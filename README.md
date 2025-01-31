# AoC-2024-COBOL
Learning COBOL with the 2024 Advent of Code. It's probably neither very efficient nor very idiomatic, but some important COBOL features and quirks are highlighted. I thank my employer [LV1871](https://www.lv1871.de/) for supporting this learning challenge.

Each day is a full COBOL program, the first and second part of the daily challenge can be toggled in the comments.

## COBOL Compilation with GNU Cobol (Windows MinGW64)

This project provides a `Makefile` to compile COBOL programs using **GNU Cobol** (`cobc`) in an **MSYS2 MinGW64** environment on **Windows**. It should also work on **Linux** or **Mac** with minor adjustments.
Other COBOL environments such as MicroFocus should also work.

## Installation (Windows)

1. **Install MSYS2**: [https://www.msys2.org/](https://www.msys2.org/)
2. **Install dependencies** (in the **MSYS2 MinGW64** shell):
   ```sh
   pacman Syu && pacman -S --needed mingw-w64-x86_64-gnucobol mingw-w64-x86_64-make mingw-w64-x86_64-gcc
   ```

## Usage

**Compile a COBOL file:**
```sh
make Day1.exe
```
(Outputs to `bin/Day1.exe`.)

**Run an executable:**
```sh
make run FILE=Day1.exe
```

**Clean compiled files:**
```sh
make clean
```

## Notes

- Use **MSYS2 MinGW64 shell**, not the default MSYS shell.
- For **Linux/macOS**, install `gnucobol` and `make` via `apt`, `brew`, or `dnf`.

