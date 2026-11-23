#!/usr/bin/env python3
"""Fail if line coverage falls below a floor.

Reads an `lcov.info` produced by `flutter test --coverage` and ignores
generated localization sources.
"""

from __future__ import annotations

import argparse
import sys

# Generated files excluded from the denominator.
IGNORED_SUBSTRINGS = (
    "/l10n/",
    ".g.dart",
)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lcov", default="coverage/lcov.info")
    parser.add_argument("--min", type=float, default=80.0)
    args = parser.parse_args()

    current: str | None = None
    per_file: dict[str, list[int]] = {}

    try:
        handle = open(args.lcov, encoding="utf-8")
    except FileNotFoundError:
        print(f"error: {args.lcov} not found; run `flutter test --coverage` first")
        return 2

    with handle:
        for raw in handle:
            line = raw.strip()
            if line.startswith("SF:"):
                current = line[3:]
                per_file.setdefault(current, [0, 0])
            elif line.startswith("LF:") and current:
                per_file[current][0] = int(line[3:])
            elif line.startswith("LH:") and current:
                per_file[current][1] = int(line[3:])

    covered = total = 0
    for path, (lines_found, lines_hit) in per_file.items():
        if any(snippet in path for snippet in IGNORED_SUBSTRINGS):
            continue
        total += lines_found
        covered += lines_hit

    if total == 0:
        print("error: no measurable lines found in lcov report")
        return 2

    percent = 100.0 * covered / total
    print(f"line coverage: {percent:.2f}% ({covered}/{total}), floor {args.min:.0f}%")
    if percent + 1e-9 < args.min:
        print(f"FAIL: coverage {percent:.2f}% is below the {args.min:.0f}% floor")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
