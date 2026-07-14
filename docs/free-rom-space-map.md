# Dolffy DOS — usable free ROM space (current map)

Live map of the overwritable holes in the **current** plain/stable
`kernal/rom/dolffy.rom`, origin `$E000`, fixed 8192 bytes. These are the bytes the
DolphinDOS-2 feature removal (the "bake") freed — available for further add-ons.

`file_offset = addr - $E000`. A region counts as free only if it is `$EA`/`$00`
fill that diverges from the pristine DolphinDOS-2 base (`kernal/reference/dolphindos2-faithful-b3b0.rom`).
Regenerate this map after any bake or feature change; see the one-liner at the bottom.

**Total free: 674 bytes in 28 regions.** The ROM stays exactly 8192 bytes — you
cannot shrink the file, only fill these holes (use `jmp` glue to span them).

The JiffyDOS fast serial work (M1 LOAD + M2 SAVE + M3 detection + GEOS-safe
VIC-bank preservation + `$`-dir relocate guard) currently consumes **502 bytes**
across six holes (see "Now in use" below).

## Free regions

| Range          | Size | Fill  | What was here (removed feature) / current note                   |
| -------------- | ---- | ----- | ---------------------------------------------------------------- |
| `$E42C-$E42F`  |    4 | `$EA` | slack after the plain runtime banner-patch call                  |
| `$E5F0-$E5FD`  |   14 | `$EA` | SHIFT+RUN/STOP auto-LOAD buffer fill (removed)                   |
| `$ECE7-$ECF0`  |   10 | `$00` | SHIFT+RUN/STOP auto-LOAD string (removed)                        |
| `$F075-$F08D`  |   25 | `$EA` | ML-monitor command loop tail (JiffyDOS `JT_GATE` + `JS_PREP` + `DIRCHK` took `$F005-$F074`) |
| `$F187-$F195`  |   15 | `$EA` | helper tail after the kept Dolphin parallel `X` sender           |
| `$F1AA-$F1AC`  |    3 | `$EA` | directory char-printer thunk                                     |
| `$F1DF-$F20D`  |   47 | `$EA` | ML-monitor filename parser                                       |
| `$F227-$F234`  |   14 | `$00` | ML-monitor command-char table                                    |
| `$F26C-$F278`  |   13 | `$EA` | ML-monitor byte-store helper (was embedded in CKOUT)             |
| `$F387-$F3AB`  |   37 | `$00` | F-key macro strings, part 1                                      |
| `$F3AE-$F3D4`  |   39 | `$00` | F-key macro strings part 2 + F7/UCI-menu hook                    |
| `$F47B-$F47F`  |    5 | `$EA` | slack inside the JiffyDOS fast-SAVE core block (`JS_TX`, `$F42B-$F47A`) |
| `$F487-$F494`  |   14 | `$EA` | slack inside the JiffyDOS fast-SAVE core block (tail to `$F495`)  |
| `$F533-$F554`  |   34 | `$EA` | F-key dispatch                                                   |
| `$F662-$F675`  |   20 | `$EA` | monitor tail after device-1/2 SAVE redirect                      |
| `$F72C-$F735`  |   10 | `$EA` | ML-monitor helper                                                |
| `$F815-$F816`  |    2 | `$EA` | slack after `@$` / `@$9` directory streamer                      |
| `$F8AF-$F8CA`  |   28 | `$00` | ML-monitor handler-address table (14 pairs)                      |
| `$FA37-$FA6A`  |   52 | `$EA` | tail slack after the JiffyDOS detection probe (`JD_LOOPCHK`/`JD_CAP`, `$F9E2-$FA36`) |
| `$FAF7-$FB10`  |   26 | mixed | tail slack after the JiffyDOS fast-SAVE gate + slot tables (`JS_GATE`/`JS_T3`/`JS_T4`, `$FAC0-$FAF6`) |
| `$FB1A-$FB2D`  |   20 | `$EA` | screen->printer hardcopy body before JiffyDOS bank helpers        |
| `$FB61-$FB8D`  |   45 | `$EA` | screen->printer hardcopy body after JiffyDOS bank helpers         |
| `$FB97-$FB9D`  |    7 | `$EA` | directory line-number printer                                    |
| `$FBEA-$FBEE`  |    5 | `$EA` | slack inside the JiffyDOS fast-LOAD receive core (`JT_RX`, `$FBA6-$FC1A`) |
| `$FC1B-$FC3E`  |   36 | `$EA` | tail slack after the JiffyDOS fast-LOAD receive core             |
| `$FCAA-$FCC9`  |   32 | `$EA` | ML-monitor "W" handler                                           |
| `$FE8B-$FE8D`  |    3 | `$EA` | SPACE+RESTORE disabled NOPs (behavioural slack; reuse only deliberately) |
| `$FECB-$FF3A`  |  112 | `$EA` | `$`-dir / F-key / CTRL+V dispatch (CTRL+D tail removed)           |

## Largest contiguous blocks (for placing routines)

| Size | Range          |
| ---- | -------------- |
|  112 | `$FECB-$FF3A`  |
|   52 | `$FA37-$FA6A`  |
|   47 | `$F1DF-$F20D`  |
|   45 | `$FB61-$FB8D`  |
|   39 | `$F3AE-$F3D4`  |
|   37 | `$F387-$F3AB`  |
|   36 | `$FC1B-$FC3E`  |
|   34 | `$F533-$F554`  |
|   32 | `$FCAA-$FCC9`  |

## Now in use — JiffyDOS fast-serial code (do NOT overwrite)

Six pre-JiffyDOS holes now hold live code (gated by `JD_ENABLE`). Each is only
partly filled; the leftover bytes are the `$Fxxx` slack rows in the free table
above. Listed so the next add-on does not reclaim the used part.

| Original hole         | Used | Free | Routine                                                      |
| --------------------- | ---- | ---- | ------------------------------------------------------------ |
| `$F005-$F08D` (137)   |  112 |   25 | `JT_GATE` + `JS_PREP` + `DIRCHK` — LOAD gate + GEOS-safe send-slot prep + `$`-dir relocate guard |
| `$F42B-$F494` (106)   |   87 |   19 | `JS_TX` — fast-SAVE send core (sync + 4 slots + EOI marker)  |
| `$F9E2-$FA6A` (137)   |   85 |   52 | `JD_LOOPCHK`/`JD_DOPROBE`/`JD_CAP` — in-band detection probe |
| `$FAC0-$FB10` (81)    |   55 |   26 | `JS_GATE` + `JS_T3`/`JS_T4` slot tables — fast-SAVE byte fork |
| `$FB1A-$FB8D` (116)   |   51 |   65 | `JD_BANKSET`/`JS_BANKSET` — VIC-bank-preserving `$DD00` setup |
| `$FBA6-$FC3E` (153)   |  112 |   41 | `JT_RX` — fast-LOAD receive core (cycle-counted 4×2-bit reads) |
| **totals**            |  502 |  228 |                                                              |

Plus a 4-byte splice at `$ED8E` (`jmp JD_LOOPCHK`) and the `JD_CAP` capture at
`$ED5F` (both inside the live IEC command-send loop, not in any hole).

## Hyper variants — additional hole usage

The plain free map above remains the allocation source for future common code.
`dolffy-hyper.rom` and `dolffy-hyper-quickrun.rom` additionally use the following
parts for SoftwareIEC DMA LOAD/SAVE, automatic LOAD fallback, and direct
`@$10` / `@$11` directory streaming. Hyper Quickrun places its own 16-byte
shortcut first in `$F1DF-$F20D`; the LOAD return filter and retry selector
occupy the remaining 31 bytes, so both features still fit together.

| Range          | Bytes | Hyper use                                              |
| -------------- | ----: | ------------------------------------------------------ |
| `$E5F0-$E5F4`  |     5 | cursor draw tail (Hyper)                               |
| `$E5F8-$E5FC`  |     5 | cursor draw tail (Hyper Quickrun)                      |
| `$F075-$F08D`  |    25 | UCI directory byte source                              |
| `$F187-$F195`  |    15 | CHKIN launch plus final LOAD-error bridge              |
| `$F1AA-$F1AC`  |     3 | LOAD retry bridge                                      |
| `$F1DF-$F1FD`  |    31 | stock LOAD return filter and selector (Hyper)          |
| `$F1EF-$F20D`  |    31 | stock LOAD return filter and selector (Hyper Quickrun) |
| `$F227-$F234`  |    14 | OPEN completion and CHKIN setup                        |
| `$F26C-$F278`  |    13 | OPEN command frame and directory name                  |
| `$F387-$F3AB`  |    37 | compact `@$9` / `@$10` / `@$11` parser and retry reset |
| `$F3AE-$F3D4`  |    39 | SAVE parameters and completion                         |
| `$F487-$F494`  |    14 | UCI identity half of directory gate                    |
| `$F533-$F553`  |    33 | response handlers and Bus-ID half of gate              |
| `$F662-$F674`  |    19 | UCI directory channel close                            |
| `$F72C-$F734`  |     9 | final directory-block EOI                              |
| `$F815`        |     1 | one-byte expansion of the shared `@` wedge             |
| `$F8AF-$F8CA`  |    28 | SAVE completion and directory chunk state              |
| `$FA37-$FA69`  |    51 | LOAD_EX command and result                             |
| `$FAF7-$FB0F`  |    25 | directory chunk refill and empty-block handling        |
| `$FB1A-$FB2C`  |    19 | empty-response command and DATA_ACC helper             |
| `$FB61-$FB88`  |    40 | SAVE entry and fallback gate                           |
| `$FB97-$FB9D`  |     7 | common zero-secondary-address command prefix           |
| `$FC1B-$FC3B`  |    33 | UCI response drain, acknowledgement, and wait          |
| `$FCAA-$FCC5`  |    28 | command-state cleanup and prefix helper                |
| `$FECB-$FF39`  |   111 | LOAD command frames, completion, and filename          |

The default RAM-vector initializer also changes four live bytes at
`$FD4C-$FD4F`, pointing ILOAD/ISAVE to `$FECB`/`$FB61`. This is deliberate and
is checked separately from the hole boundaries by `test/hyper_layout.py`.

Hyper also replaces the live cursor-blink block at `$EA40-$EA60`. Most of the
first phase is inline there; its five-byte draw tail occupies `$E5F0-$E5F4` (or
`$E5F8-$E5FC` after Quickrun) in the removed SHIFT+RUN/STOP auto-LOAD buffer. The
34-byte state selector occupies `$F409-$F42A`, reclaimed by making the
Ultimate-only Hyper banner static. The cursor uses `$CF=0/1/$80` for original,
inverse, and inverse-up-arrow states; no additional RAM is reserved. The fixed
banner consumes the four-byte plain startup slack at `$E42C-$E42F`.

After the SoftwareIEC, cursor, and LOAD-fallback allocations, Hyper retains 75
bytes of the plain free map; Hyper Quickrun retains 43 bytes.

## Now in use — `@` directory wedge

The old DolphinDOS `@`/`&`/`*` wedge body at `$F775-$F816` has been replaced with
a focused non-destructive directory streamer. `$E38E` jumps to `$F775`; `$F775-$F816`
implements `@$` (drive 8) and `@$9` (drive 9) by opening `"$"` and streaming the
directory to the screen without loading it into BASIC text memory. Hyper builds
also parse `@$10` and `@$11`; if the number matches `$DF1B`, the same formatter
reads a chunked SoftwareIEC UCI OPEN/CHKIN stream and closes it through command
`$14`. Other devices retain the IEC channel path. Block counts are passed to
BASIC `$BDCD` as high byte in A, low byte in X; directory-provided spacing is
preserved with a single CHROUT space after the count. The streamer checks `$90`
after directory line-header and filename-byte reads so EOF, timeout, or a missing
drive cannot loop forever. `$E115` remains stock; the old `&`, `*`, quoted-load
helper paths, and incidental `@$8` spelling were not restored.

## Hazards — live bytes inside/adjacent to the holes (do NOT overwrite)

| Keep            | Why                                                                 |
| --------------- | ------------------------------------------------------------------- |
| `$F178-$F184`   | Dolphin parallel `X` command sender; required before parallel LOAD/SAVE enters burst mode |
| `$F676-$F68E`   | Serial command-open helper called by `$F178` and SAVE paths         |
| `$F3AC-$F3AD`   | `clc`/`rts` island between the two F-key holes; 5 OPEN/send-name branches target it |
| `$F495-$F4BB`   | LOAD (live; directly after the `JS_TX` block that ends at `$F494`)  |
| `$F196-$F1A6`   | serial-send constant table (read by the kept serial fallback); do not merge the `$F187` hole across it |
| `$FB11-$FB19`   | SCNKEY stub (`sta $028c`/`sty $c5`/`lda $028c`/`rts`); hole resumes at `$FB1A` |
| `$FECA`         | `$`-dir stub `rts` (`$60`); hole starts at `$FECB`                   |
| `$FF3B+`        | parallel-handshake serial wait (`jsr $ff3b` from `$EFE0/$EFE9/$F5A1`) and the IRQ/BRK entry `$FF48` |

The boot banner is variant-specific: `make plain` builds `kernal/rom/dolffy.rom`
with the original `BASIC V2` banner text plus the runtime UCI banner patch at
`$F409-$F42A`; on Ultimate hardware it rewrites the screen copy to `ULTIMATE`.
`make ultimate` builds `kernal/rom/dolffy-ultimate.rom` with static `ULTIMATE`
banner text.

## Regenerate

```sh
python3 - <<'PY'
ORIG=0xE000
base=open('kernal/reference/dolphindos2-faithful-b3b0.rom','rb').read()
dol =open('kernal/rom/dolffy.rom','rb').read()
keep=[(0xF196,0xF1A6)]
def is_keep(addr):
    return any(a <= addr <= b for a,b in keep)
i=0; total=0; n=0
while i<len(dol):
    if dol[i] in (0xEA,0x00) and not is_keep(ORIG+i):
        j=i
        while j<len(dol) and dol[j] in (0xEA,0x00) and not is_keep(ORIG+j): j+=1
        if any(dol[k]!=base[k] for k in range(i,j)) and j-i>=3:
            print(f"${ORIG+i:04x}-${ORIG+j-1:04x}  {j-i}"); total+=j-i; n+=1
        i=j
    else: i+=1
print(f"total free: {total} bytes in {n} regions")
PY
```
