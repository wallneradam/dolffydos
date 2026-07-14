# Dolffy DOS regression tests

Black-box LOAD/SAVE regression for the custom KERNAL (`kernal/rom/dolffy.rom`),
driven through VICE's binary monitor. Each test pokes a known payload into C64
RAM, issues a BASIC `LOAD`/`SAVE`, runs the emulator free, and compares the
result byte-for-byte. Drive ROMs are used only as opaque test targets — no drive
or KERNAL code is read or embedded (clean-room safe).

The three per-device transfer paths that must all stay byte-exact:

| mode               | path                   | VICE drive setup                                 |
| ------------------ | ---------------------- | ------------------------------------------------ |
| `jiffy-serial`     | JiffyDOS fast serial   | external JiffyDOS ROM, no cable                  |
| `dolphin-parallel` | DolphinDOS parallel    | external Dolphin ROM, parallel cable, drive RAM  |
| `stock-serial`     | stock Commodore serial | bundled 1541 DOS, no external ROM                |

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

### Hyper build checks

The static layout check builds on the five ROM images and verifies that the
three legacy images remain byte-identical, all images are exactly 8192 bytes,
the Hyper LOAD/SAVE vectors are installed, and Hyper-only bytes stay inside the
reserved ROM holes:

```sh
python3 test/hyper_layout.py
```

VICE does not emulate the Ultimate Command Interface, so the existing matrix
only exercises the Hyper ROMs' Dolphin/Jiffy/stock fallback paths. Select a
Hyper ROM through `DOLFFY_ROM`, for example:

```sh
DOLFFY_ROM=kernal/rom/dolffy-hyper.rom \
  python3 test/regress.py jiffy-serial stock-serial
```

The `@` smoke test confirms that both Hyper ROMs retain `@$` / `@$9`, accept the
new `@$10` / `@$11` syntax, and fall back cleanly to IEC when UCI is absent:

```sh
python3 test/hyper_at_dir.py
```

The cursor runtime probe checks the five relevant phases in both Hyper ROMs:
inverse character, inverse SHIFT arrow, safe restoration, and the normal
two-phase cursor with SHIFT off.

```sh
python3 test/hyper_cursor.py
```

For real hardware, build and run the small UCI discovery probe:

```sh
acme -f cbm -o /tmp/hyper_uci_probe.prg test/hyper_uci_probe.asm
curl -X POST --data-binary @/tmp/hyper_uci_probe.prg \
  http://ULTIMATE_HOST/v1/runners:run_prg
curl 'http://ULTIMATE_HOST/v1/machine:readmem?address=0xC0F0&length=272' | xxd -g1
```

The result byte at `$C0FF` is `$A5` on success or `$EE` on timeout. `$C0F0`
contains the UCI identification byte (expected `$C9`), `$C0F1` the SoftwareIEC
bus ID, `$C100` the IDENTIFY response, and `$C180` its status (expected `$00`).

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

| file                     | purpose                                                 |
| ------------------------ | ------------------------------------------------------- |
| `harness.py`             | VICE monitor, RAM, keyboard, and disk-image helpers     |
| `regress.py`             | regression matrix runner                                |
| `hyper_at_dir.py`        | Hyper `@` parser and non-UCI IEC fallback smoke test    |
| `hyper_cursor.py`        | Hyper three-phase SHIFT cursor runtime test             |
| `hyper_cursor_probe.asm` | machine-code probe used by `hyper_cursor.py`            |
| `hyper_layout.py`        | ROM size, legacy hash, vector, and reserved-hole checks |
| `hyper_uci_probe.asm`    | real-Ultimate UCI target and SoftwareIEC bus-ID probe   |
| `.env.example`           | template for the proprietary drive-ROM paths            |
