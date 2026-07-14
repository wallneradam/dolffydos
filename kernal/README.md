# Dolffy DOS — C64 KERNAL

**Dolffy DOS** (Dolphin + Jiffy) is a custom Commodore 64 KERNAL ROM that aims to
combine:

- **DolphinDOS** parallel disk speed on the cabled drive (drive 8),
- the **JiffyDOS** serial fast protocol on any compatible drive (including as a
  fallback for drive 8 when no parallel cable is present) — per-device autodetect
  (parallel > JiffyDOS-serial > stock serial),
- optional **Ultimate** add-ons: SoftwareIEC DMA LOAD/SAVE and a three-phase
  cursor SHIFT/SHIFT LOCK indicator in the Hyper builds, including direct
  `@$10` / `@$11` directory streaming, or the RTC border clock and sprite-based
  shift-lock indicator in the separate Ultimate build.

This directory holds the editable ACME assembler source. It is built on a
reverse-engineered **DolphinDOS 2** disassembly, mechanically relabeled to the true
`$E000` runtime origin; the JiffyDOS side is being reimplemented clean-room from
protocol documentation (see *Provenance and licensing*).

| Output ROM                    | Base support              | Variant-specific addition                  |
| ----------------------------- | ------------------------- | ------------------------------------------ |
| `dolffy.rom`                  | Dolphin + Jiffy + stock   | Portable plain build                       |
| `dolffy-quickrun.rom`         | Dolphin + Jiffy + stock   | C=+RUN/STOP Quickrun                       |
| `dolffy-hyper.rom`            | Dolphin + Jiffy + stock   | SoftwareIEC DMA + three-phase SHIFT cursor |
| `dolffy-hyper-quickrun.rom`   | Dolphin + Jiffy + stock   | Hyper plus Quickrun                        |
| `dolffy-ultimate.rom`         | Dolphin + Jiffy + stock   | RTC clock + border SHIFT indicator         |

The user-facing comparison, Hyper explanation, limitations, and exact Ultimate
settings are in the [root README](../README.md#which-rom-should-i-use).

## Build

```
make            # assembles all five raw, headerless 8192-byte images
make plain      # assembles rom/dolffy.rom (stable base)
make ultimate   # assembles rom/dolffy-ultimate.rom
make quickrun   # assembles rom/dolffy-quickrun.rom
make hyper      # assembles rom/dolffy-hyper.rom
make hyper-quickrun  # assembles rom/dolffy-hyper-quickrun.rom
make verify     # checks the build still equals the upstream faithful base
                # (MD5 b3b0fa84…)
```

Requires the [ACME](https://sourceforge.net/projects/acme-crossass/) cross-assembler
(`brew install acme` on macOS; tested with 0.97). The stable `plain` build is
`rom/dolffy.rom`; the Ultimate-specific builds add either SoftwareIEC DMA
(`dolffy-hyper*.rom`) or the border clock (`dolffy-ultimate.rom`). Each raw ROM
is usable directly as a C64 KERNAL ROM (e.g. the Ultimate / C64U "Kernal
ROM" config slot, or VICE `-kernal`).

`make verify` proves the `$E000` relabel is faithful; it passes only on the pristine
relabeled base. Now that the Dolffy bake (DolphinDOS feature removal, the Ultimate
boot-banner patch, more to come) has diverged from upstream, it no longer matches the
live build (currently MD5 `25cd89d3…`) — the pristine base is preserved verbatim in
`reference/`, and what the bake removed is documented under the project-root `docs/`.

## The $E000 relabel

The upstream `kernal.asm` is a flat disassembly assembled at the artifact origin
`* = $5684`. This copy is mechanically relabeled to the **true runtime origin
`* = $E000`** so the listing addresses match where the code actually runs, which is
the foundation for editing it. The relabel is **byte-exact** (assembling produces the
identical 8192-byte ROM, MD5 `b3b0fa8410edef1a42dbccf87e798f6e`): only
relative-branch operands (577) and the `; $xxxx` PC-annotation comments (3665) were
shifted by `+$897C`; absolute operands and data are untouched. Transform:
`tools/relabel.py`.

## Layout

```
kernal.asm          the $E000 DolphinDOS 2 source — being turned into Dolffy DOS
rom/                build output (plain, quickrun, hyper, hyper-quickrun, Ultimate)
tools/relabel.py    the $5684 -> $E000 byte-exact relabel transform
reference/          pristine upstream base, preserved verbatim:
                      dolphindos2-faithful-b3b0.rom, kernal.orig.asm, transform.py
Makefile            build + faithful-base verify
```

Licensing lives at the project root (`../LICENSE`, `../NOTICE`); design documents and
plans live under the project-root `docs/`.

## Provenance and licensing

This source is a reverse-engineered disassembly. It is **not** original DolphinDOS
source and is not affiliated with the original DolphinDOS authors; the original
DolphinDOS firmware is third-party.

- DolphinDOS disassembly base:
  [`donnchawp/DolphinDOS2`](https://github.com/donnchawp/DolphinDOS2), released into
  the public domain (Unlicense). Faithful upstream binaries and the DolphinDOS 2
  preservation project: silverdr,
  <http://e4aws.silverdr.com/projects/dolphindos2/>.
- JiffyDOS support is being **reimplemented clean-room** from the protocol
  documentation in [`MEGA65/open-roms`](https://github.com/MEGA65/open-roms)
  (`doc/Protocol-JiffyDOS.md`) and public reverse-engineering references — no copyleft
  source is copied. The JiffyDOS *wire protocol* is not copyrightable; the *drive-side*
  JiffyDOS ROM is a separate, proprietary component (RETRO Innovations, © Mark Fellows)
  that must be licensed independently.

**License:** Wallner Ádám's own contributions to Dolffy DOS are released under the
**MIT License** — see `../LICENSE` and the scope note in `../NOTICE`. The MIT grant
covers only those contributions, not the upstream Commodore C64 KERNAL or the
DolphinDOS code beneath them.

## Acknowledgements

With thanks to:

- The original **DolphinDOS** authors — the Frankfurt C64 enthusiast group around
  **Günther Jilg** (hardware and concept) and **Jan Bubela** (board development, later
  the business side), with **Michael Priske** and **Ralf Köhler**. DolphinDOS first
  shipped in January 1986 and was distributed in the UK by Evesham Micros.
- **silverdr** — the DolphinDOS 2 preservation project and faithful binaries.
- **donnchawp** — the ACME disassembly this source is built on.
- The **MEGA65 / open-roms** project — for the openly documented JiffyDOS protocol.
