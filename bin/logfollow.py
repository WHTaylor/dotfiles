#!python
import sys
import re
import time
from collections import namedtuple
from typing import List
try:
    import curses
except:
    print("logfollow requires ncurses")
    print("On windows, use the `windows-curses` pypi package")
    exit(1)

Rect = namedtuple("Rect", ["x", "y", "w", "h"])

col_h_pad = 2
h_height, f_height = 3, 3

def calculate_columns(scr_width: int, scr_height: int, num_cols: int) -> List[Rect]:
    col_width = (scr_width // num_cols) - col_h_pad
    cols = []
    for i in range(num_cols):
        x = i * (col_width + col_h_pad)
        y = h_height
        height = scr_height - h_height - f_height - 1
        cols.append(Rect(x, y, col_width, height))
    return cols

class TailingWindow:
    def __init__(self, window, tail):
        self._window = window
        self._tail = tail
        self.height, self.width = self._window.getmaxyx()
        self._history = []
    
    def step(self):
        lines = next(self._tail)
        if lines:
            self._draw(lines)
            self._history += lines
            history_start = len(self._history) - 500 if len(self._history) > 500 else 0
            self._history = self._history[history_start:]

    def resize(self, new_width):
        self._window.resize(self.height, new_width)
        self.width = new_width

    def reposition(self, new_x):
        y, _ = self._window.getbegyx()
        self._window.mvwin(y, new_x)

    def redraw(self):
        self._window.clear()
        self._draw(self._history)

    def _draw(self, lines):
        for line in lines:
            chunks = list(chunk_string(strip_crap(line), self.width))
            for chunk in chunks:
                self._window.scroll()
                self._window.insstr(self.height - 1, 0, chunk)
        self._window.refresh()

def get_tail_lines(filename, catch_up_N=15):
    '''
    Create a generator that yields any lines written to 'filename' since last yield

    If catch_up_N is a positive number, will start by yielding that many lines 
    from the end of the existing file.
    '''
    f = open(filename, "r")
    f.seek(0, 2) # Seek to end
    if catch_up_N > 0:
        fsize = f.tell()
        f.seek(max(fsize - 2048, 0), 0) # Seek back a couple KB (hopefully enough)
        yield f.readlines()[-catch_up_N:]

    while True:
        res = []
        line = f.readline()
        while line:
            res.append(line)
            line = f.readline()
        yield res

def get_tails(env, prefix="Test"):
    apps = [prefix + a for a in ["FileWatcher", "LiveIngest", "XMLtoICAT"]]

    if env == "local":
        log_root = "C:\\FBS\\Logs"
    elif env == "dev":
        log_root = r"\\icatdevingest\c$\FBS\Logs"
    elif env == "prod":
        log_root = r"\\icatliveingest\c$\FBS\Logs"

    return [(app, get_tail_lines(f"{log_root}\\{app}.log")) for app in apps]

def chunk_string(s, w):
    """ Split a string, s, into chunks of at most w characters """
    return (s[i:w + i] for i in range(0, len(s), w))

date_patt = r"(?P<year>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})"
time_patt = r"(?P<time>\d{2}:\d{2}:\d{2}),\d{3}"
thread_patt = r"\[\d+\]"
level_patt = "(?P<level>[A-Z]+)"
logging_class_patt = r"([a-zA-Z0-9]+\.)+(?P<logging_class>[a-zA-Z0-9]+)"
pattern = f"{date_patt} {time_patt} {thread_patt} {level_patt} {logging_class_patt} - (?P<message>.+)"
def strip_crap(line):
    m = re.match(pattern, line)
    if not m:
        return line
    def v(group_name): return m.group(group_name)
    return f"{v('day')}/{v('month')} {v('time')} {v('logging_class')}.{v('level')} - {v('message')}"

def handle_input(line, windows, stdscr):
    new_line, new_windows = line, windows
    if len(line) > 2:
        new_line = ""
        new_windows = new_windows[:-1]
        scr_height, scr_width = stdscr.getmaxyx()
        stdscr.clear()
        stdscr.refresh()
        rects = calculate_columns(scr_width, scr_height, len(new_windows))
        for i, w in enumerate(new_windows):
            w.resize(rects[i].w)
            w.reposition(rects[i].x)
            w.redraw()

    return new_line, new_windows

def main(stdscr, tails):
    curses.curs_set(0)
    curses.init_pair(5, curses.COLOR_RED, curses.COLOR_WHITE)
    stdscr.clear()
    stdscr.nodelay(True)
    scr_height, scr_width = stdscr.getmaxyx()

    windows = []
    input_line = ""

    rects = calculate_columns(scr_width, scr_height, len(tails))
    # Setup a window for each tracked log, in vertical columns
    for i, (app, tail) in enumerate(tails):
        r = rects[i]
        stdscr.insstr(1, r.x, app) # Title in header
        win = curses.newwin(r.h, r.w, r.y, r.x)
        win.scrollok(True)
        windows.append(TailingWindow(win, tail))
    stdscr.insstr(scr_height - f_height + 1, 1, "q: quit")
    stdscr.refresh()

    while True:
        for window in windows:
            window.step()
        time.sleep(0.01)
        try:
            k = stdscr.getkey()
            if k == "q": break
            else:
                input_line += k
                input_line, windows = handle_input(input_line, windows, stdscr)
        except: pass # No key pressed


if __name__ == "__main__":
    env = "prod"
    if len(sys.argv) >= 2:
        env = sys.argv[1]

    tails = get_tails(env)
    curses.wrapper(lambda s: main(s, tails))
