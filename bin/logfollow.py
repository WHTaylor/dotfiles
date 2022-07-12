#!python
import sys
import re
import time
import curses

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

def get_tails(env, system, prefix=""):
    if system == "live-ingest":
        apps = [prefix + a for a in ["FileWatcher", "LiveIngest", "XMLtoICAT"]]

        if env == "local":
            log_root = "C:\\FBS\\Logs"
        elif env == "dev":
            log_root = r"\\icatdevingest\c$\FBS\Logs"
        elif env == "prod":
            log_root = r"\\icatliveingest\c$\FBS\Logs"

    elif system == "schedule":
        apps = ["SCHEDULE", "UserOffice"]

        if env == "local":
            log_root = r"C:/payara/domains/domain1/logs"
        elif env == "dev":
            print("todo, dev schedule")
            exit(1)
        elif env == "prod":
            print("todo, prod schedule")
            exit(1)
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

h_height, f_height = 3, 3

def main(stdscr, tails):
    curses.curs_set(0)
    stdscr.clear()
    stdscr.nodelay(True)
    scr_height, scr_width = stdscr.getmaxyx()

    # Setup a window for each tracked log, in vertical columns
    num_cols = len(tails)
    col_h_pad = 2
    col_width = (scr_width // num_cols - 1) - col_h_pad
    windows = []
    for i, (app, _) in enumerate(tails):
        x = i * (col_width + col_h_pad)
        stdscr.insstr(1, x, app) # Title in header
        win = curses.newwin(
            scr_height - h_height - f_height - 1,
            col_width,
            h_height,
            x)
        windows.append(win)
        win.scrollok(True)
    stdscr.insstr(scr_height - f_height + 1, 1, "q: quit")
    stdscr.refresh()

    while True:
        for i, (_, tail) in enumerate(tails):
            lines = next(tail)
            if lines:
                for line in lines:
                    chunks = list(chunk_string(strip_crap(line), col_width))
                    for chunk in chunks:
                        (height, _) = windows[i].getmaxyx()
                        windows[i].scroll()
                        windows[i].insstr(height - 1, 0, chunk)
            windows[i].refresh()
        time.sleep(0.01)
        try:
            k = stdscr.getkey()
            if k == "q": break
        except: pass # No key pressed


if __name__ == "__main__":
    env = "prod"
    apps = "live-ingest"
    if len(sys.argv) >= 2:
        env = sys.argv[1]
    if len(sys.argv) == 3:
        apps = sys.argv[2]

    tails = get_tails(env, apps)
    curses.wrapper(lambda s: main(s, tails))
