# Dolffy DOS regression tests

Black-box LOAD/SAVE regression for the custom KERNAL (`kernal/rom/dolffy.rom`),
driven through VICE's binary monitor. Each test pokes a known payload into C64
RAM, issues a BASIC `LOAD`/`SAVE`, runs the emulator free, and compares the
result byte-for-byte. Drive ROMs are used only as opaque test targets — no drive
or KERNAL code is read or embedded (clean-room safe).

The three per-device transfer paths that must all stay byte-exact:

| mode               | path                  | VICE drive setup                                          |
| ------------------ | --------------------- | --------------------------------------------------------- |
| `jiffy-serial`     | JiffyDOS fast serial  | `-dos1541 <jiffy>` (no cable)                             |
| `dolphin-parallel` | DolphinDOS parallel   | `-dos1541 <dolphin> -parallel8 1 -userportdevice 21` + drive RAM `$2000/$4000/$6000` |
| `stock-serial`     | stock Commodore serial| VICE's bundled 1541 DOS (no external ROM)                 |

## Requirements

- `x64sc` and `c1541` from VICE 3.x on `PATH` (or set `X64SC` / `C1541`).
- VICE's bundled C64 ROMs (`basic-901226-01.bin`, `chargen-901225-01.bin`);
  found automatically under `/opt/homebrew/share/vice/C64` or set `VICE_C64_DIR`.
- A built `kernal/rom/dolffy.rom` (`cd kernal && touch kernal.asm && make`).
- For the `jiffy-serial` and `dolphin-parallel` modes: the respective **drive
  ROMs**, which are proprietary and **not** included here. Point the env vars at
  your own copies. Without them those modes are skipped (not failed).

## Setup

```sh
cp test/.env.example test/.env      # then edit the two drive-ROM paths
```

`test/.env` is gitignored and auto-loaded by the harness. Alternatively export
`JIFFY_DRIVE_ROM` / `DOLPHIN_DRIVE_ROM` directly.

## Running

```sh
python3 test/regress.py                 # full matrix
python3 test/regress.py stock-serial    # one or more named modes
python3 test/regress.py --load          # only the LOAD checks
python3 test/regress.py --save          # only the SAVE checks
```

Exit code is non-zero if any executed check fails. Runtime artifacts (d64 images,
extracted files) go to a system temp dir; nothing is written into the repo.

## What each check proves

- **LOAD** — `LOAD"*",8,1` of a PRG saved at `$4001` must land byte-exact at
  `$4001`. Because the secondary address `,1` means "load to the file's own
  address", a mis-handled `,1` relocates to BASIC start `$0801` and leaves
  `$4001` unwritten → fail. This is the check that caught the X-register clobber
  in the JiffyDOS detection probe (the probe used X as its window counter, but
  the stock LOAD carries the `,1` flag in X across the `TALK`/`TKSA` calls).
- **SAVE** — `SAVE"T",8` of a known payload, extracted with `c1541`, must be
  byte-exact (atom-stable).

## Files

| file              | purpose                                                       |
| ----------------- | ------------------------------------------------------------- |
| `harness.py`      | VICE binary-monitor glue: launch, mem peek/poke, key inject, free-run, disk build/extract |
| `regress.py`      | the regression matrix runner (main entry)                     |
| `.env.example`    | template for the proprietary drive-ROM paths                  |
