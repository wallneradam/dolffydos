# Dolffy DOS — UCI "Hyperspeed" variant (Ultimate DMA LOAD/SAVE)

Design and implementation notes for the Ultimate-only, DMA-based fast LOAD/SAVE
("hyperspeed") in Dolffy's Hyper ROMs. The implementation is clean-room from the
public Ultimate documentation and official firmware source; no proprietary ROM
is copied.

> Status: **implemented on 2026-07-14** as `dolffy-hyper.rom` and
> `dolffy-hyper-quickrun.rom`. UCI LOAD, automatic 8 -> 9 -> 10 -> 11 search,
> and direct `@$11` directory streaming have been verified end to end on a real
> C64 Ultimate. The remaining SAVE/VERIFY matrix still requires end-to-end
> validation.

For ROM selection, practical setup, normal BASIC commands, trade-offs, and the
three-phase SHIFT/SHIFT LOCK cursor, see the
[root README](../README.md#which-rom-should-i-use).

---

## 1. The idea in one line

Point the Ultimate's **Software IEC** drive at a host folder, and make the
standard KERNAL LOAD/SAVE routines fetch/store files from it via a **DMA
transfer straight into C64 RAM** instead of clocking bytes over the IEC bus.
The disk mechanism and serial byte transfer disappear from that route, making
ordinary files feel effectively immediate while remaining transparent to BASIC
and programs that go through the KERNAL.

This is an **Ultimate-only** accelerator delivered in two plain-based variants:
Hyper and Hyper Quickrun. The separate border-clock build remains unchanged.

---

## 2. Two distinct things — don't conflate them

| Layer                     | What it is                                                 | Backing store                                                       | Speed path                                                                  |
| ------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| **Software IEC drive**    | A virtual IEC device the Ultimate firmware serves          | A **host folder** (USB / SD / network), shown as a C64 directory    | Normal — appears on the IEC bus at its configured device number             |
| **Hyperspeed (this doc)** | KERNAL LOAD/SAVE re-routed through UCI to that same drive   | The same host folder                                                | **DMA** — Ultimate pauses the CPU and copies the file directly into C64 RAM  |

So the **Software IEC drive is the storage**; **hyperspeed is the fast door to
it**. You enable Software IEC in the Ultimate config, give it a folder, and it
already works as a read/write C64 disk (`LOAD"$"`, `LOAD"NAME"`, `SAVE"NAME"`).
Hyperspeed just makes the KERNAL LOAD/SAVE to it instant.

Limitation (inherent, same as the official Hyperspeed): only **standard KERNAL
LOAD/SAVE** is accelerated. Programs that carry their own turbo/custom loader
(bit-banging the bus, bypassing the KERNAL) do not use — and cannot use — the
DMA path; they keep running on the real drive / Dolphin / Jiffy path.

The Command Interface is required only for the DMA shortcut. If it is disabled,
SoftwareIEC remains a normal IEC drive: explicit and automatic LOAD/SAVE plus
`@$10` / `@$11` still work through the conventional, slower KERNAL path.

---

## 3. UCI transport recap (we already have working code for this)

The border-clock RTC read (`CLK_*` GET_TIME) already drives the same register
interface, so the transport layer is proven in this codebase.

Registers ($DF1B–$DF1F, masking the top REU registers):

| Addr    | Write                          | Read                                                          |
| ------- | ------------------------------ | ------------------------------------------------------------- |
| `$DF1B` | —                              | SoftwareIEC **Bus ID** (virtual-drive device number)           |
| `$DF1C` | Control                        | Status                                                        |
| `$DF1D` | Command data (push bytes here) | Identification (`$C9` = UCI present)                           |
| `$DF1E` | —                              | Response Data queue                                           |
| `$DF1F` | —                              | Status Data queue                                             |

Control register `$DF1C` (write) bits:

```
b7 DMA | b6 TRIGGER | b5 IRQ | b4 - | b3 CLR_ERR | b2 ABORT | b1 DATA_ACC | b0 PUSH_CMD
```

Status register `$DF1C` (read) bits:

```
b7 DATA_AV | b6 STAT_AV | b5 STATE | b4 STATE | b3 ERROR | b2 ABORT_P | b1 DATA_ACC | b0 CMD_BUSY
```

Command lifecycle (identical shape to our GET_TIME code):

1. Write the command bytes in order to `$DF1D` — frame = `[target][command][params…]`.
2. Set `PUSH_CMD` (`$DF1C = $01`). The SoftwareIEC firmware performs the direct
   memory transfer and manages the C64 CPU stop/resume itself. Although the
   transport also exposes a DMA/freeze bit, the Hyper builds deliberately follow
   the Ultimate's own KERNAL sequence and leave that bit clear.
3. Poll status: while `DATA_AV` (b7) drain `$DF1E`; while `STAT_AV` (b6) drain `$DF1F`.
4. Acknowledge with `DATA_ACC` (`$DF1C = $02`) to clear the response/status queues,
   then wait for its handshake bit to clear before starting another command.

The RTC read uses **target `$01`** (Ultimate-DOS) command `$26`. Hyperspeed uses
**target `$05`** (Software IEC).

---

## 4. Software IEC target ($05) — command set

| Command           | ID    | Params                                               | Returns / Status                                                   |
| ----------------- | ----- | ---------------------------------------------------- | ------------------------------------------------------------------ |
| IDENTIFY          | `$01` | —                                                    | string `SOFTWARE IEC TARGET V1.0`; `$00` OK                        |
| **LOAD_SU**       | `$10` | sec-addr, verify, load-addr LO/HI, reserved, filename | 2-byte start address; `$00` OK / `$01` FILE NOT FOUND             |
| **LOAD_EX**       | `$11` | sec-addr, verify                                     | status +, for LOAD, 2-byte end address LE; **data via DMA**        |
| **SAVE**          | `$12` | verify, sec-addr, start LO/HI, end LO/HI, filename   | `$00` OK / `$02` SAVE ERROR                                       |
| OPEN              | `$13` | sec-addr, unused `$00`, filename                     | —                                                                  |
| CLOSE             | `$14` | sec-addr                                             | `$00` OK                                                           |
| CHKIN             | `$15` | sec-addr                                             | pre-fetches 32 bytes into the data channel                         |
| CHKOUT            | `$16` | sec-addr, data                                       | `$F0–$FF` OPEN, `$E0–$EF` CLOSE, otherwise push write data         |
| ADD_PARTITION     | `$20` | index, name`:`path                                   | `$00` / `$06` INVALID                                              |
| DEL_PARTITION     | `$21` | index                                                | `$00` / `$06`                                                      |
| GET_FATNAME       | `$22` | channel, IEC name                                    | host path; `$00`/`$06`/`$07`/`$08`/`$09`                          |
| GET_IECNAME       | `$23` | host name                                            | filetype byte + IEC name; `$00`/`$06`                              |

The OPEN/CLOSE/CHKIN/CHKOUT/GET_*NAME set is what makes it a *full* virtual
drive (directory, per-channel file I/O, long-name ↔ PETSCII translation), not
just a load/save shortcut.

---

## 5. The LOAD / SAVE byte frames

Bytes pushed to `$DF1D`, in order. `$05` = Software IEC target ID.

**LOAD, step 1 — LOAD_SU (open + get start address):**

```
$05 $10 <SEC_ADDR> <VERIFY> <ADDR_LO> <ADDR_HI> $00 $00 <NAME…>
```

- `SEC_ADDR` = secondary address (the `,1` of `LOAD"x",8,1` → load-to-own-address
  vs relocate to $0801).
- `ADDR_LO/HI` = requested load address (used when SEC_ADDR selects relocation).
- The two reserved bytes are required by the firmware implementation: LOAD_SU
  reads the filename from command offset 8, even though the shorter public
  command table omits these bytes. This was confirmed against the official
  `softiec_target.cc` source.
- `NAME…` = filename bytes; the frame ends when `PUSH_CMD` is set, so no explicit
  length byte is needed.
- Returns the file's embedded 2-byte start address; status `$00` / `$01` FILE NOT FOUND.

**LOAD, step 2 — LOAD_EX (the DMA transfer):**

```
$05 $11 <SEC_ADDR> <VERIFY>
```

- Push with `$DF1C = $01`. The Ultimate transfers the file opened by LOAD_SU
  directly into C64 RAM and handles the CPU pause internally.
- For LOAD, the status queue is `$00` followed by the 2-byte little-endian end
  address. VERIFY returns only `$00` or `$80`; the implementation preserves a
  deterministic KERNAL X/Y result without reading nonexistent end-address bytes.

**SAVE — SAVE (0x12):**

```
$05 $12 <VERIFY> <SEC_ADDR> <START_LO> <START_HI> <END_LO> <END_HI> <NAME…>
```

- Push with `$DF1C=$01`. The command creates the file, writes the 2-byte start
  address, dumps the memory range (start..end) via DMA, and closes it. Status is
  `$00` / `$02` SAVE ERROR.

**Non-destructive directory — OPEN / CHKIN / CLOSE:**

```
$05 $13 $00 $00 "$"
$05 $15 $00
$05 $14 $00
```

- OPEN attaches `"$"` to SoftwareIEC channel zero.
- CHKIN leaves the first 32-byte response block queued. DATA_ACC requests the
  next block; continued reads are automatically enlarged to 256 bytes.
- CLOSE follows an ABORT of the still-open CHKIN transaction, so the exact
  number of consumed bytes is committed before the channel is released.

---

## 6. How it coexists with "real" disks — by **device number**

Every drive on an Ultimate has its own device number, and they live on the bus
side by side:

- emulated 1541 (Drive A, a mounted D64) → e.g. device 8
- Software IEC (a host folder) → preferably device 10 or 11
- a physical 1541 → yet another number

Config: F2 → *1541 Drive A settings* → *1541 Drive Bus ID*; the Software IEC
device number is likewise configurable and readable at `$DF1B`.

The kernal dispatch for every LOAD/SAVE therefore becomes:

```
device == SoftwareIEC-BusID ($DF1B)  ->  UCI DMA hyperspeed (§5)
otherwise                            ->  existing path: Dolphin-parallel / Jiffy-serial / stock
```

So a user can run device 8 = real Dolphin 1541 (parallel), device 9 = another
emulated or physical drive, **and** device 11 = Software IEC folder (DMA
hyperspeed) at the same time, each at its own top speed. D64-image /
true-1541-emulation titles stay on their own device number, untouched. **Config
caveat:** the Software IEC device number must not collide with an emulated or
physical drive.

---

## 7. How you actually use it (BASIC and other programs) — transparently

LOAD/SAVE needs no new syntax. Hyperspeed hooks the **standard KERNAL LOAD/SAVE vectors**
(`$FFD5` / `$FFD8`, and the `$0330`/`$0332` LOAD/SAVE RAM vectors):

- **BASIC:** `LOAD"FILE",10` · `LOAD"FILE",10,1` · `SAVE"FILE",10` ·
  `LOAD"$",10` — ordinary commands using the direct-memory route when 10 is the
  configured SoftwareIEC Bus ID.
- **Any program** that calls KERNAL LOAD (`JSR $FFD5`) or goes through the load
  vector gets the DMA speed for free, unmodified.
- **Self-loading turbo code** that bypasses the KERNAL does *not* hit this path
  (and doesn't need it) — that is exactly the "standard KERNAL routines only"
  limitation.

The non-destructive wedge adds `@$10` and `@$11` in Hyper builds. When the typed
number matches the SoftwareIEC Bus ID and UCI is available, it uses direct UCI
OPEN/CHKIN/CLOSE and streams the chunked directory response to the existing
formatter. `@$`, `@$9`, a non-matching 10/11, or disabled UCI keep the normal
IEC route.

---

## 8. Integration into Dolffy

**Build variants.** `make hyper` builds `kernal/rom/dolffy-hyper.rom`, and
`make hyper-quickrun` builds `kernal/rom/dolffy-hyper-quickrun.rom`. Both are
plain-based and keep the complete Dolphin parallel and Jiffy serial engines.

**Hook points.**
- LOAD: the default RAM ILOAD vector points to `HLOAD`, which checks UCI identity
  and `device == $DF1B`, then runs LOAD_SU → LOAD_EX and returns the end address.
  `FILE NOT FOUND` and `DEVICE NOT PRESENT` advance 8 → 9 → 10 → 11,
  re-entering the same loader after restoring its secondary address. The active
  SoftwareIEC number automatically takes the UCI path when available; otherwise
  10 and 11 remain conventional IEC attempts. This also lets Hyper Quickrun find
  a program in a SoftwareIEC folder with Command Interface disabled. Before
  advancing after `FILE NOT FOUND`, the current IEC drive's command channel is
  read to EOI, clearing its error LED. `DEVICE NOT PRESENT` advances without
  contacting that device again. Other errors retain the stock return unchanged.
- SAVE: the default RAM ISAVE vector points to `HSAVE`, which performs one DMA
  SAVE command for the SoftwareIEC device.
- Directory: `LOAD"$"` uses the DMA LOAD path. The non-destructive Hyper wedge
  accepts `@$10` / `@$11` and uses OPEN (`$13`), CHKIN (`$15`), chunked
  DATA_ACC refills, and CLOSE (`$14`) when the number matches SoftwareIEC.

**Transport.** Every command first aborts any stale UCI state. `HREPLY` drains
the response-data and status queues independently, acknowledges them with
DATA_ACC, and waits for the acknowledgement handshake to finish. The small
routines are split across ROM holes.

**Size.** The SoftwareIEC implementation fits the plain build's fragmented
674-byte free map. The cursor's first phase is mostly inline in the live IRQ
block, with its five-byte draw tail in the removed SHIFT+RUN/STOP auto-LOAD
buffer. A 13-byte stock LOAD return filter and an 18-byte device selector share
the former `$F1DF-$F20D` monitor-parser hole after Quickrun where applicable.
Both Hyper variants are exactly 8192 bytes, and a static layout test verifies
that differences from their base ROMs stay inside the declared ranges.

**Why separate from the clock build.** This is a product decision, not a technical
impossibility: Dolffy's Hyper variants are specifically the three disk
accelerators together. The already-satisfactory clock ROM remains an independent
personal/experimental Ultimate variant.

---

## 9. Real-hardware validation status

1. **Confirmed on C64 Ultimate.** SoftwareIEC ordinary directory access works;
   Hyper `LOAD"$"` and a game LOAD completed through the UCI path.
2. **Fast non-destructive directory.** The first real `@$11` attempt returned
   immediately without output. Hardware traces found two protocol bugs. `HWAIT`
   ignored `CMD_BUSY` bit 0, and `HNAME` left Y=1 after appending the one-byte
   `"$"` filename, so CHKIN selected unopened channel 1 instead of OPEN's channel
   0. The corrected transition restores Y=0 before constructing CHKIN. Later ROM
   packing exposed another hidden contract: `HAT_OPEN_2` clears KERNAL status from
   X, so the shared filename copier must also exit with X=0. That contract now has
   a static regression check. The final rebuilt ROM listed the real SoftwareIEC
   folder on bus ID 11 end to end, including multi-block refill and the 10/11
   device-number parser.
3. **Remaining end-to-end matrix.** Exercise relocated LOAD, `LOAD,1`, `VERIFY`,
   SAVE, missing-file error, and empty/large files against SoftwareIEC.
4. **Fallback behavior.** Disable Command Interface and SoftwareIEC separately
   and confirm the normal IEC path remains usable.
5. **VICE limitation.** UCI is not emulated in VICE (same as the clock), so VICE
   covers only parser/fallback and legacy Dolphin/Jiffy/stock behavior.

---

## Sources

- Software IEC Target — https://1541u-documentation.readthedocs.io/en/master/uci/software_iec_target.html
- Core UCI Architecture — https://1541u-documentation.readthedocs.io/en/latest/uci/core_uci_architecture.html
- UCI Programming Guide (index) — https://1541u-documentation.readthedocs.io/en/latest/uci/index.html
- Command Interface — https://1541u-documentation.readthedocs.io/en/latest/command%20interface.html
- Drive Bus ID config — https://1541u-documentation.readthedocs.io/en/latest/quick_guide.html
- Official SoftwareIEC target source — https://github.com/GideonZ/1541ultimate/blob/master/software/io/command_interface/softiec_target.cc
