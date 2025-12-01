#!/usr/bin/env python3

'''Given a list of arguments, expands abbreviations into an fba-compose command'''

import sys
from enum import Enum
from typing import List, Optional

class MatchResultType(Enum):
    SUCCESS = 1
    NO_MATCH = 2
    NON_UNIQUE = 3

class MatchResult:
    def __init__(
            self,
            type: MatchResultType,
            word: Optional[str],
            suggestions: List[str]):
        self.type = type
        self.word = word
        self.suggestions = suggestions

    @staticmethod
    def success(word: str):
        return MatchResult(MatchResultType.SUCCESS, word, [])

    @staticmethod
    def no_match():
        return MatchResult(MatchResultType.NO_MATCH, None, [])

    @staticmethod
    def non_unique(suggestions: List[str]):
        return MatchResult(MatchResultType.NON_UNIQUE, None, suggestions)


class PrefixMatcher:
    def __init__(self, word_or_words):
        self._trails = {}
        if type(word_or_words) is str:
            self._leaf = word_or_words
        else:
            self._leaf = None
            for word in word_or_words:
                self._insert(word)

    def _insert(self, word, char_num = 0):
        if not word: return

        if char_num == len(word):
            self._leaf = word
            return

        letter = word[char_num]
        if letter in self._trails:
            self._trails[letter]._insert(word, char_num + 1)
        else:
            if not self._leaf or self._leaf == word[:char_num]:
                asdf = PrefixMatcher(word)
                self._trails[letter] = asdf
            else:
                self._trails[self._leaf[char_num]] = PrefixMatcher(self._leaf)
                self._leaf = None
                self._insert(word, char_num)

    def search(self, prefix: str, char_num = 0):
        if self._leaf == prefix:
            return MatchResult.success(self._leaf)

        if not self._trails:
            if self._leaf.startswith(prefix):
                return MatchResult.success(self._leaf)
            else:
                return MatchResult.no_match()

        if char_num == len(prefix):
            return MatchResult.non_unique([])

        letter = prefix[char_num]
        if letter in self._trails:
            return self._trails[letter].search(prefix, char_num + 1)
        return MatchResult.no_match()

command_matcher = PrefixMatcher([
    "logs",
    "up",
    "down",
    "build",
    "stop",
    "pull"
])

no_abbrev_services = [
    "schedule-service",
    "settings-tool-service",
    "visits-service",
    "cron-service"
]
services = {
    "uows": "user-office-web-service",
    "wifi": "user-wifi-login-service",
    "allocations": "proposal-allocations",
    "lookup": "proposal-lookup-service",
    "db": "bisapps-db",
    **{s: s for s in no_abbrev_services}
}

service_matcher = PrefixMatcher(services.keys())

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("fba-compose")
    else:
        def expand(w):
            match = service_matcher.search(w)
            if match.type == MatchResultType.SUCCESS:
                return services[match.word]
            return w

        cmd_match = command_matcher.search(sys.argv[1])
        cmd = cmd_match.word if cmd_match.type == MatchResultType.SUCCESS else sys.argv[1]
        args = [expand(a) for a in sys.argv[2:]]

        # Always want to run containers in detached mode
        if cmd == "up" and args[0] != '-d':
            args.insert(0, '-d')

        if cmd == "build":
            args.insert(0, "--build-arg SKIP_TESTS=true")

        print(f"fba-compose {' '.join([cmd] + args)}")
