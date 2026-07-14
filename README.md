# Dolffy DOS

**A fast, modern KERNAL ROM for the Commodore 64 — DolphinDOS parallel speed and
a clean-room JiffyDOS serial fast loader in one ROM, with optional Ultimate
SoftwareIEC DMA speed or clock/SHIFT LOCK extras.**

<p align="center">
  <img src="docs/images/boot-screen.png" width="420"
       alt="Dolffy DOS boot screen on a Commodore 64 Ultimate: the COMMODORE 64 ULTIMATE banner, a DOLFFY DOS 1.0 line, and a clock in the bottom-right border">
</p>

The stock C64 KERNAL is wonderfully **safe**: hit a random key and nothing much
happens. DolphinDOS and JiffyDOS, by contrast, are packed with extras — a
built-in machine-language monitor, function-key macros, a wedge of CTRL commands —
most of which most people never use. And kids love to just *mash keys* (who knows
why), so on a loaded KERNAL one stray combination can fire off a command and wipe
out the program you were about to show them. A built-in monitor was a treasure in
the 1980s, too; today you reach for the one in your emulator, or the Ultimate's
own tooling over its REST API, so baking one into the KERNAL is just space you
could spend better.

What you *do* still want is simple: disk access that is genuinely fast — and fast
on **whatever drive you happen to have**. When you sit down to load a game or fire
up a tool, it matters a great deal whether it comes up in five seconds or in a
minute and a half.

So Dolffy DOS drops the parts that no longer earn their keep and spends every
reclaimed byte on speed instead, getting the fastest protocol each of your drives
can manage out of the system — the full DolphinDOS parallel loader and a
clean-room JiffyDOS serial loader. The Ultimate-specific variants go further in
two different directions: Hyper adds direct SoftwareIEC folder speed and an
ingenious three-phase SHIFT/SHIFT LOCK cursor, while the separate Ultimate build
adds the real-time clock and its border indicator.

Dolffy DOS (**Dolph**in + Ji**ffy**) is a drop-in replacement for the C64 KERNAL
ROM. It stays highly compatible with stock software — as compatible as DolphinDOS
and JiffyDOS themselves, which is to say very — while transparently speeding up
disk access on whatever drive you have:

- **DolphinDOS parallel** speed on the cabled drive (drive 8) — the fastest path
  by a wide margin;
- **JiffyDOS-compatible serial fast LOAD/SAVE** on serial drives — a from-scratch,
  clean-room reimplementation of the wire protocol (see *Clean-room
  implementation* below);
- **stock serial** as the universal fallback, so every drive still works.

Nothing is locked to one scheme. The KERNAL probes **each device independently**
and picks the fastest protocol it can speak with *that* drive:
**parallel > JiffyDOS serial > stock**. The parallel path is drive 8 only, but
drive 8 is not tied to it — put a JiffyDOS or a plain serial drive on 8 and it
just uses that instead. So you can mix freely: a physical JiffyDOS drive, a
virtual DolphinDOS parallel drive, and a stock drive can all sit on the bus at
once, each running as fast as it can, and you can switch between them whenever you
like. There is nothing to configure per program — `LOAD` and `SAVE` just get
faster.

> Heads up: Dolffy DOS replaces the **C64 KERNAL** only. The matching **drive-side
> ROMs** (DolphinDOS 1541 ROM for the parallel path, a genuine JiffyDOS drive ROM
> for the serial fast path) are separate third-party components you must supply
> yourself. See *Drives and ROMs* and *Licensing*.

## Features

- **DolphinDOS parallel fast LOAD/SAVE** on the cabled drive (drive 8) — the
  fastest path.
- **JiffyDOS-compatible serial fast LOAD/SAVE** — a clean-room reimplementation of
  the C64 side of the protocol (no JiffyDOS source used).
- **Ultimate SoftwareIEC DMA LOAD/SAVE** — optional Hyper builds bypass IEC for
  the Ultimate's SoftwareIEC device while retaining the complete Dolphin and
  JiffyDOS paths for every other device.
- **Per-device autodetect** — picks the best protocol per drive automatically:
  parallel > JiffyDOS serial > stock. No per-program setup.
- **Universal fallback** — any non-fast drive still works at stock serial speed.
- **PAL and NTSC** — the fast paths are calibrated for both.
- **Correct directory loads** — `LOAD"$"` (with or without a device number)
  relocates properly on every path.
- **Non-destructive directory wedge** — `@$` (drive 8) and `@$9` (drive 9) list a
  directory without wiping the BASIC program in memory. Hyper also accepts
  `@$10` and `@$11`, using UCI speed when that number is the SoftwareIEC Bus ID.
- **DolphinDOS editor comfort keys** — CTRL+A/B/G/K/L plus RESTORE combinations
  (see *Keyboard shortcuts*).
- **Auto Ultimate detection** — shows a `COMMODORE 64 ULTIMATE` banner when a
  Command Interface is present, `COMMODORE 64 BASIC V2` otherwise.
- **Quickrun build** — a separate ROM where C=+RUN/STOP enters `LOa`, then `SYS`
  starts the loaded program.
- **Ultimate build extras** — a real-time clock and a SHIFT LOCK indicator (see
  *The Ultimate extras*).
- **Five ready-to-use builds** — Plain, Quickrun, Hyper, Hyper+Quickrun, and
  Ultimate ROMs.
- **Stock-compatible** — a drop-in 8 KB KERNAL; normal software keeps working.

## Why it is fast — up to three accelerators in one ROM

Dolffy does not rely on one universal fast loader. Every ROM combines the
DolphinDOS parallel and JiffyDOS-compatible serial paths; the Hyper variants add
Ultimate DMA as a third. The ROM chooses the right path for each device:

| Fast path                  | Used for                              | What it needs                          |
| -------------------------- | ------------------------------------- | -------------------------------------- |
| **DolphinDOS parallel**    | A parallel-cabled drive 8             | DolphinDOS drive ROM, cable, drive RAM |
| **JiffyDOS serial**        | Any JiffyDOS-compatible serial drive  | Licensed JiffyDOS drive ROM            |
| **Ultimate Hyper DMA**     | The Ultimate SoftwareIEC host folder  | Hyper ROM, SoftwareIEC, UCI enabled    |

Everything else remains usable through stock Commodore serial. A single session
can therefore use a DolphinDOS drive on 8, a JiffyDOS drive on 9, and a
SoftwareIEC folder on 10 or 11 without changing KERNAL ROMs.

### Measured drive example

Loading [**SlotShot**](https://github.com/PyCoLang/slotshot), a real C64 game:

| Setup                                              | Load time    |
| -------------------------------------------------- | ------------ |
| Stock KERNAL + stock 1541                          | ~90 s        |
| Original JiffyDOS KERNAL + JiffyDOS drive          | ~20 s        |
| **Dolffy DOS + JiffyDOS drive** (serial fast path) | ~23 s        |
| **Dolffy DOS + DolphinDOS parallel** (drive 8)     | **~5 s (!)** |

These are the author's own measurements and are indicative. Dolffy's parallel
path is the unchanged DolphinDOS path and remains the fastest measured drive
route. Its clean-room JiffyDOS-compatible serial path is a few seconds behind the
original JiffyDOS KERNAL in this test.

Hyper is not assigned a made-up number in the table: no comparable SlotShot
timing has been recorded yet. It is also a different kind of route — the Ultimate
copies the file directly between the SoftwareIEC host folder and C64 RAM instead
of transferring it through an emulated drive and the IEC bus. For ordinary BASIC
programs, PRG files, tools, and data storage, that direct folder workflow is often
the most convenient option even before considering its speed.

The important result is not one winning benchmark. It is that Dolffy keeps every
route available at once, automatically uses the best one that a device supports,
and still retains stock serial as the compatibility fallback.

## Which ROM should I use?

Dolffy now builds **five** ROM images. All five include DolphinDOS parallel,
JiffyDOS-compatible serial, stock serial fallback, and the non-destructive `@$`
directory command. The variants only change the convenience and Ultimate-specific
extras around that common disk core.

| Build              | File                        | Hardware        | Quickrun | SoftwareIEC DMA | SHIFT feedback        | Clock |
| ------------------ | --------------------------- | --------------- | -------- | --------------- | --------------------- | ----- |
| **Plain**          | `dolffy.rom`                | Any C64 or VICE | No       | No              | No                    | No    |
| **Quickrun**       | `dolffy-quickrun.rom`       | Any C64 or VICE | Yes      | No              | No                    | No    |
| **Hyper**          | `dolffy-hyper.rom`          | Ultimate family | No       | Yes             | Three-phase cursor    | No    |
| **Hyper Quickrun** | `dolffy-hyper-quickrun.rom` | Ultimate family | Yes      | Yes             | Three-phase cursor    | No    |
| **Ultimate**       | `dolffy-ultimate.rom`       | Ultimate family | No       | No              | Border/sprite display | Yes   |

The short version:

- Choose **Plain** for the safest, most portable Dolffy ROM.
- Choose **Quickrun** if you also want C=+RUN/STOP to load and start a program.
- Choose **Hyper** on an Ultimate when a normal folder full of programs and data
  should behave like a very fast, writable C64 drive.
- Choose **Hyper Quickrun** for the same folder speed plus the one-key start
  workflow. This is the most feature-rich disk-oriented variant.
- Choose **Ultimate** when the on-screen clock is more important than
  SoftwareIEC DMA. The clock build and the Hyper builds are intentionally
  separate; Hyper does **not** include the clock.

> Compatibility note: **Plain** and **Quickrun** have the smallest hardware
> compatibility surface. Hyper uses the Ultimate Command Interface during
> SoftwareIEC operations. Ultimate adds a continuously running raster clock and
> therefore has the widest compatibility surface. If a cartridge or demo uses
> NMI or IO1/IO2 (`$DE00` / `$DF00`), start with Plain.

The **Plain** and **Quickrun** builds auto-detect an Ultimate at boot: they show
`COMMODORE 64 BASIC V2` on a plain C64 and rewrite the screen copy to
`COMMODORE 64 ULTIMATE` when a Command Interface is present. The Ultimate-only
**Hyper**, **Hyper Quickrun**, and **Ultimate** builds always show
`COMMODORE 64 ULTIMATE`. Every build prints a `DOLFFY DOS 1.0` line.

### What does Hyper mean?

Hyper is not a CPU turbo and it is not another drive ROM. It is a third disk
accelerator added beside DolphinDOS and JiffyDOS. The Ultimate's **SoftwareIEC**
drive exposes a normal host folder as a writable C64 device. Hyper recognizes
that device and asks the Ultimate firmware to copy a file directly between the
folder and C64 RAM instead of sending every byte over the serial IEC bus.

That gives one ROM three different fast routes at the same time:

| Device or storage                         | Route selected by Hyper                            |
| ----------------------------------------- | -------------------------------------------------- |
| DolphinDOS drive 8 with parallel cable    | DolphinDOS parallel LOAD/SAVE                      |
| JiffyDOS-capable drive                    | JiffyDOS-compatible serial LOAD/SAVE               |
| Ultimate SoftwareIEC host folder          | UCI direct-memory LOAD/SAVE                        |
| Anything else                             | Stock Commodore serial fallback                    |

Nothing has to be sacrificed to gain the SoftwareIEC route. A mounted D64 can
stay on drive 8, another emulated or physical drive can stay on 9, and the host
folder can be device 10 or 11. Each device uses the best protocol it supports.

The direct folder is especially useful for:

- BASIC programs saved as ordinary PRG files;
- single-file games, tools, utilities, and development builds;
- quickly moving files between a modern computer and the C64;
- writable program and data storage that is easy to copy or back up on the host.

Standard `LOAD` and `SAVE` syntax does not change. With SoftwareIEC configured
as device 11, for example:

```basic
LOAD"PROGRAM",11
LOAD"PROGRAM",11,1
SAVE"PROGRAM",11
```

`LOAD` and `SAVE` of PRG or memory-image files use the direct-memory Hyper path.
BASIC `OPEN`, `PRINT#`, `INPUT#`, relative files, and other channel-oriented data
operations still go through the normal SoftwareIEC drive interface; they remain
useful, but Hyper does not turn every individual channel byte into a DMA transfer.

For a fast directory that does **not** overwrite the BASIC program in memory,
type `@$10` or `@$11`, matching the configured SoftwareIEC Bus ID. With UCI
available Hyper uses its direct directory stream; otherwise the same command
falls back to normal IEC. `LOAD"$",11` also works, but like a normal C64
directory load it replaces the BASIC program area.

### Automatic LOAD search

Hyper also makes device-less loading practical with several drive types. On
`FILE NOT FOUND` or `DEVICE NOT PRESENT`, a KERNAL LOAD tries every supported
disk number in order:

```text
8 -> 9 -> 10 -> 11
```

Starting at device 9 begins at the second step. The first successful load wins;
other errors stop normally. Before leaving a present IEC drive after `FILE NOT
FOUND`, Hyper drains its command channel so the drive error LED stops blinking.
A missing device is skipped without a second IEC transaction. Hyper Quickrun
uses the same search, so its one-key `LOAD` can find a program in the SoftwareIEC
folder without an explicit device number.

### Three-phase SHIFT / SHIFT LOCK cursor

The C64 Ultimate's latching SHIFT LOCK has no obvious persistent hardware
indicator. Hyper solves that inside the ordinary BASIC cursor instead of taking
over a sprite, opening the border, or reserving a screen position.

- With SHIFT off, the cursor remains the normal two-phase blink: **original
  character -> inverse character**.
- While either SHIFT or SHIFT LOCK is active, it becomes a three-phase cycle:
  **original character -> inverse character -> inverse up-arrow**.
- The up-arrow phase appears at the current cursor position, so it never covers
  an unrelated character elsewhere on the screen.
- Before BASIC accepts a key, the editor restores the original character under
  the cursor. The arrow is only an indicator and can never become part of the
  program line.

The result is deliberately subtle: the editor behaves normally, but a latched
SHIFT LOCK becomes visible as soon as the cursor blinks through its third phase.
The indicator also reacts to a physically held SHIFT key; it reports the active
SHIFT state, not which of the two ways activated it. Because it uses neither a
raster IRQ nor a sprite, it has a much smaller compatibility footprint than the
clocked Ultimate build. It is specifically a KERNAL/BASIC-editor indicator: a
game or custom editor that replaces the normal cursor also replaces this visual
feedback.

### Hyper limitations and trade-offs

- Hyper requires Ultimate-family hardware and firmware that provide both the
  Command Interface and the SoftwareIEC UCI target **for DMA speed**. With the
  Command Interface disabled, the ROM, cursor, directory commands, and ordinary
  SoftwareIEC access still work; LOAD/SAVE simply use the slower IEC path. VICE
  does not emulate the UCI target, so its DMA path cannot be used there either.
- SoftwareIEC is a host-folder drive, not cycle-exact 1541 emulation. Programs
  that depend on disk tracks, copy protection, exact drive timing, or a custom
  fast loader belong on a D64/real-drive route instead.
- Only software using the standard KERNAL LOAD/SAVE vectors receives DMA speed.
  A program that talks to IEC directly or installs its own loader bypasses Hyper.
- The Command Interface occupies Ultimate I/O space and can conflict with some
  cartridges or demos that use `$DF00-$DFFF` directly.
- SoftwareIEC must have a unique device number. A collision with Drive A, Drive
  B, or a physical IEC device makes both devices unreliable.
- Automatic search checks 8, 9, 10, and 11 in that order. This can add a short
  delay when the desired file exists only on a later device, and an earlier
  device wins if it contains a file with the same name.
- Hyper deliberately has no clock. Choose `dolffy-ultimate.rom` for the clock,
  or a Hyper ROM for the third disk accelerator and three-phase cursor.

See [Hyper setup on the Ultimate family](#hyper-setup-on-the-ultimate-family)
for the exact settings. The underlying command protocol and implementation are
documented in [`docs/uci-hyperspeed-plan.md`](docs/uci-hyperspeed-plan.md).

### The Ultimate extras

**SHIFT LOCK indicator.** The SHIFT LOCK key on the new Commodore 64 Ultimate has
been a recurring source of community complaints: it latches but gives no clear,
persistent feedback about its state, so it is easy to leave engaged by accident
and then wonder why everything types in the "wrong" case. The Ultimate build
answers that directly — it shows an indicator that reflects whether
SHIFT / SHIFT LOCK is currently active, so the key's state is visible at a glance.

**Real-time clock.** The Ultimate has a built-in real-time clock, so the Ultimate
build reads it over the Command Interface and shows a clock on screen.

> The clock follows the Ultimate's **Command Interface** setting. Enable Command
> Interface to show the clock; disable it if you prefer a clean border. When the
> Command Interface is off, the clock blanks itself while the SHIFT LOCK indicator
> continues to work.

## Download

Pre-built ROM images are published on the
[**Releases**](https://github.com/wallneradam/dolffydos/releases/latest) page.
The links below always select that file from the **latest** release:

- [`dolffy.rom`](https://github.com/wallneradam/dolffydos/releases/latest/download/dolffy.rom) — the **Plain** build
- [`dolffy-quickrun.rom`](https://github.com/wallneradam/dolffydos/releases/latest/download/dolffy-quickrun.rom) — the **Quickrun** build
- [`dolffy-hyper.rom`](https://github.com/wallneradam/dolffydos/releases/latest/download/dolffy-hyper.rom) — the **Hyper** build
- [`dolffy-hyper-quickrun.rom`](https://github.com/wallneradam/dolffydos/releases/latest/download/dolffy-hyper-quickrun.rom) — the **Hyper Quickrun** build
- [`dolffy-ultimate.rom`](https://github.com/wallneradam/dolffydos/releases/latest/download/dolffy-ultimate.rom) — the **Ultimate** build

Each is a raw, headerless **8192-byte** image, usable directly anywhere a C64
KERNAL ROM goes (the Ultimate's "Kernal ROM" slot, VICE's `-kernal`, an EPROM,
etc.). You can also build them yourself — see *Building from source*.

## Installation

Pick the build you want, copy it to your device, and point the machine's **Kernal
ROM** slot at it. For the fast-disk paths you also configure the drive (cable +
drive ROM) as described under *Drives and ROMs*.

### Commodore 64 Ultimate (the new C64U)

1. Copy your chosen Dolffy ROM onto the machine.
2. In the **file browser**, navigate to the Dolffy ROM, press **ENTER** on it, and
   choose **Set as Kernal ROM**.
3. For DolphinDOS **parallel** speed on Drive A: in the file browser, press
   **ENTER** on your DolphinDOS 1541 drive ROM and choose **Set as 1541 ROM**,
   and **enable Extra RAM** for the drive.
4. Enable the **Parallel Cable** to the drive. On the C64U some of these toggles
   live in the advanced "Machine Tweaks" page reachable by tapping **SHIFT+F1**.
5. For the **clock** (Ultimate build): enable **Command Interface** in the
   Cartridge / ROM settings. Leave it disabled if you want the SHIFT LOCK
   indicator without the clock.
6. Reboot.

### Hyper setup on the Ultimate family

The labels below are the names used by current Ultimate firmware. Their menu
location can differ slightly between the C64 Ultimate, Ultimate 64, and
1541 Ultimate-II+, but the setting names are the same.

1. Install `dolffy-hyper.rom` or `dolffy-hyper-quickrun.rom` as the **Kernal
   ROM**.
2. Under **C64 and Cartridge Settings**, set **Command Interface** to
   **Enabled**.
3. Under **SoftIEC Drive Settings**, set **IEC Drive** to **Enabled**.
4. Set **Soft Drive Bus ID** to a free device number. Device **11** is a good
   default when Drive A and Drive B use 8 and 9; device 10 works equally well.
5. Set **Default Path** to the USB, SD, or flash folder that should appear as the
   C64 drive. Alternatively, browse to that folder and choose **Software IEC ->
   Set dir. here**.
6. Check the bus IDs of Drive A, Drive B, and any physical IEC drives. None may
   use the same number as SoftwareIEC.
7. Reboot or reselect the KERNAL ROM, then test the setup. For bus ID 11:

```text
@$11
LOAD"PROGRAM",11
```

If `@$11` shows the folder contents, SoftwareIEC is reachable. With Command
Interface enabled, a subsequent KERNAL `LOAD` or `SAVE` to device 11 uses Hyper
DMA; with it disabled, the same commands remain functional through normal IEC
and are simply slower. The SoftwareIEC folder does not need a
DolphinDOS or JiffyDOS drive ROM; those ROMs remain relevant only to the separate
emulated or physical drives.

> Do not confuse **Soft Drive Bus ID** with **DMA Load Mimics ID**. Hyper reads
> the SoftwareIEC device number from the former. Normally there is no reason to
> change DMA Load Mimics ID for Dolffy.

### Ultimate 64 and 1541 Ultimate-II+

1. Copy the Dolffy ROM (and your DolphinDOS 1541 drive ROM) to the USB stick.
2. Select the Dolffy ROM and **Set as Kernal ROM**.
3. For **parallel** speed: select your DolphinDOS 1541 ROM and **Set as 1541 ROM**,
   then in **Settings (F2)**:
   - **System Setup -> Machine Tweaks -> Parallel Cable to Drive A: Enabled**
   - **1541 Drive A Settings -> Extra RAM: Enabled**
4. For the **clock** (Ultimate build): set
   **Cartridge and ROM Settings -> Command Interface** to **Enabled**. Leave it
   disabled if you want to hide the clock.
5. For a **Hyper** build, configure Command Interface and SoftwareIEC as described
   in [Hyper setup on the Ultimate family](#hyper-setup-on-the-ultimate-family).
6. Reboot.

> Note: cartridges that use the `$DF00-$DFFF` I/O range (Action Replay and
> similar) conflict with the Command Interface. Disable them if you rely on the
> Command Interface (the menu hotkey, and the Ultimate build's clock).

### VICE (emulator)

Set **Machine -> ROM -> Kernal** to the Dolffy ROM. The serial fast path needs a
JiffyDOS drive ROM on the drive; the parallel path needs the DolphinDOS 1541 drive
ROM, the **Standard** parallel cable, the userport parallel drive cable, and the
drive RAM expansions enabled. The exact VICE switches for the parallel path are
documented in [`kernal/README.md`](kernal/README.md) and in the upstream
DolphinDOS 2 project.

Use `dolffy.rom` or `dolffy-quickrun.rom` in VICE unless you specifically want
to test the Hyper cursor or its normal IEC fallbacks. VICE does not emulate the
SoftwareIEC UCI target, so selecting a Hyper ROM does not provide DMA folder
loading there.

## Drives and ROMs

Fast disk access is a conversation between the **KERNAL** (this project) and the
**drive ROM**. Dolffy provides the C64 side; the drive side is yours to provide.

- **Parallel (DolphinDOS):** needs the DolphinDOS 1541 drive ROM, the parallel
  cable, and the drive's Extra RAM. On the Ultimate family all of this is built
  in once you select the drive ROM and flip the toggles above. DolphinDOS is
  **abandonware** and the 1541 drive ROM is freely available from the
  [donnchawp/DolphinDOS2](https://github.com/donnchawp/DolphinDOS2) repository —
  its latest version also includes a drive-ROM patch that fixes a rare glitch seen
  on Ultimate machines, so prefer that one.
- **Serial fast (JiffyDOS):** needs a **genuine JiffyDOS drive ROM** installed in
  the drive. Dolffy implements the **C64 side only**; it does not contain, and
  cannot substitute for, the proprietary drive ROM. If a serial drive does not
  speak JiffyDOS, Dolffy automatically falls back to stock serial speed for that
  device.

The **JiffyDOS drive ROM is a commercial product** (RETRO Innovations,
copyright Mark Fellows). To use the JiffyDOS serial fast path **legally you must
own a licensed JiffyDOS drive ROM**. Please buy it — do not pirate it.

## Clean-room implementation

The JiffyDOS-compatible serial fast path in Dolffy is a **clean-room
reimplementation** written from scratch for the C64 side. It was built from:

- the **publicly documented** JiffyDOS wire protocol (the prose description in the
  MEGA65 / open-roms project), and
- the author's **own black-box measurements** — logic-level bus captures of a real
  JiffyDOS pair — and experiments to match the timing.

It contains **no JiffyDOS source code** and copies nothing from the JiffyDOS
firmware. The on-the-wire *protocol* (the bit timing two devices agree on) is not
copyrightable; the *drive-side ROM* that implements it is a separate, proprietary
product you supply yourself (above). The same holds for the DolphinDOS side: the
C64 source here descends from a public-domain disassembly, not from original
DolphinDOS source — see *Licensing*.

## Other niceties

- **Non-destructive directory wedge.** Type `@$` to list drive 8's directory, or
  `@$9` for drive 9, **without** wiping the BASIC program currently in memory.
  Hyper builds also accept `@$10` and `@$11`; the configured SoftwareIEC device
  uses the direct UCI directory stream when available and normal IEC otherwise.

## Keyboard shortcuts

Dolffy keeps the DolphinDOS screen-editor "comfort" keys, plus two RESTORE
combinations:

| Key                | Action                                           |
| ------------------ | ------------------------------------------------ |
| CTRL+A             | Toggle key repeat for all keys on/off            |
| CTRL+B             | Move the cursor to the bottom of the screen      |
| CTRL+G             | Move the cursor ~20 columns forward              |
| CTRL+K             | Delete the line to the right of the cursor       |
| CTRL+L             | Delete the line to the left of the cursor        |
| C=+RUN/STOP        | Quickrun build: `LOa`, then `SYS` starts it      |
| RUN/STOP + RESTORE | BASIC warm start (the program in memory is kept) |
| CTRL + RESTORE     | Full KERNAL reset                                |

Coming from DolphinDOS? To make room for the fast-disk and Ultimate code, the
F1–F8 macros, the other CTRL commands (CTRL+D, CTRL+@, CTRL+X, CTRL+&, CTRL+V,
CTRL+\*, CTRL+DEL, C=+DEL) and SPACE+RESTORE were removed. The directory listing
lives on as the `@$` / `@$9` command instead (plus `@$10` / `@$11` in Hyper;
see above). C=+RUN/STOP is restored only in Quickrun and Hyper Quickrun; Plain,
Hyper, and Ultimate keep it disabled.

## Troubleshooting

### `@$10` or `@$11` returns only `READY.`

First check that the number in the command exactly matches **Soft Drive Bus ID**.
Then verify the SoftwareIEC settings:

- a Hyper ROM is selected as the active KERNAL;
- **IEC Drive** is enabled under **SoftIEC Drive Settings**;
- **Default Path** points to an accessible folder.

**Command Interface** is required for Hyper DMA speed, but not for slow,
conventional IEC directory and file access.

Also make sure no emulated or physical drive uses the same bus ID. After replacing
a ROM file under the same filename, reselect the KERNAL ROM or temporarily select
another one before switching back; this forces the Ultimate to reload the image.

The plain `@$` command always means device 8, and `@$9` always means device 9.
On an enabled drive with no mounted disk, the non-destructive wedge can simply
return to `READY.` without printing a command-channel error. That is different
from a correctly configured `@$10` / `@$11` SoftwareIEC folder, which should show
its directory.

### A cartridge freezes before its own loader starts

Try the **Plain** build first. Hyper uses the Ultimate Command Interface during
SoftwareIEC operations, while the Ultimate build additionally installs a raster
clock. Some cartridges use NMI or IO1/IO2 during their own boot process.

If a cartridge stops before its own loader or menu appears, switch back to
`dolffy.rom` and disable Command Interface for that setup.

### The Command Interface gets stuck after running a demo

The Ultimate build's clock needs the **Command Interface** enabled — it reads the
real-time clock over it. Some software pokes the same `$DF00-$DFFF` I/O area
directly; in the author's experience a handful of **demos** do this. The
Ultimate's firmware does not fully guard the Command Interface against stray
writes, so such a program can leave it in a wedged internal state. The clock and
most things keep working, so nothing looks wrong at first — but from that point on
**other demos refuse to start**, and — the nasty part — neither **reloading your
configuration** nor **power-cycling the machine** clears it. The bad internal
state survives both.

What *does* clear it is a **factory reset followed by reloading your own saved
configuration**: that reinitializes the internal state as well, not just the
settings.

To avoid the problem in the first place, switch the Command Interface off *before*
running such demos. Save this minimal configuration as `demo.cfg`:

```
[C64 and Cartridge Settings]
Command Interface=Disabled

[U64 Specific Settings]
Turbo Control=Off
```

Load `demo.cfg`, run the demos, and when you are done restore your normal
configuration — Command Interface and the clock included — from flash with
**F1 -> Configuration -> Reset from Flash**.

## Building from source

The editable KERNAL source lives in [`kernal/`](kernal/) as ACME assembler. It is
built on a reverse-engineered DolphinDOS 2 disassembly, mechanically relabeled to
the true `$E000` runtime origin; the JiffyDOS side is the clean-room code
described above.

```
cd kernal
make            # build all five ROM variants
make plain      # build only the plain base, rom/dolffy.rom
make ultimate   # build only the Ultimate build, rom/dolffy-ultimate.rom
make hyper      # build rom/dolffy-hyper.rom
make hyper-quickrun  # build rom/dolffy-hyper-quickrun.rom
```

Requires the [ACME](https://sourceforge.net/projects/acme-crossass/) cross-assembler
(`brew install acme` on macOS; tested with 0.97). Each output is a raw 8192-byte
KERNAL image. The variants use the ACME defines `ULTIMATE_BUILD`,
`QUICKRUN_BUILD`, and `HYPER_BUILD`. More detail — including the reclaimed
ROM-space map that made the extras fit in 8 KB — is under
[`kernal/README.md`](kernal/README.md)
and [`docs/free-rom-space-map.md`](docs/free-rom-space-map.md). A regression harness for
LOAD/SAVE across the parallel, JiffyDOS-serial and stock paths lives in
[`test/`](test/).

## Licensing

Dolffy DOS combines material from several rights holders. **Adam Wallner's own
contributions** — the Dolffy DOS modifications, the build tooling, and the
documentation — are released under the **MIT License** (see
[`LICENSE`](LICENSE)). That grant covers **only** those contributions.

It does **not** license the pre-existing components the project builds upon, which
remain under their own rights holders (see [`NOTICE`](NOTICE) for the full scope):

- the **Commodore C64 KERNAL** — copyright Commodore / CBM and its successors;
- the original **DolphinDOS 2** — copyright its original authors;
- the **JiffyDOS drive ROM** — a separate, proprietary product (RETRO Innovations,
  copyright Mark Fellows) that you must license independently.

A complete built ROM image therefore combines material from several rights
holders; redistributing a complete image is subject to the upstream rights and is
at your own risk. This project is **not affiliated** with the original DolphinDOS
or JiffyDOS authors, and no support is implied. Use at your own risk.

## Acknowledgements

- The original **DolphinDOS** authors — the Frankfurt C64 group around
  **Günther Jilg** and **Jan Bubela**, with **Michael Priske** and **Ralf Köhler**.
- **silverdr** — the DolphinDOS 2 preservation project and faithful binaries.
- **donnchawp** — the public-domain ACME DolphinDOS 2 disassembly this source
  builds on, and a clear install guide for the Ultimate family.
- The **MEGA65 / open-roms** project — for openly documenting the JiffyDOS wire
  protocol.
