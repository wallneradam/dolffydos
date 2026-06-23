# Dolffy DOS — usable free ROM space (current map)

Live map of the overwritable holes in the **current** `kernal/rom/dolffy.rom`
(MD5 `25cd89d3`), origin `$E000`, fixed 8192 bytes. These are the bytes the
DolphinDOS-2 feature removal (the "bake") freed — available for JiffyDOS, the
border clock, the shift-lock indicator, and other Ultimate add-ons.

`file_offset = addr - $E000`. A region counts as free only if it is `$EA`/`$00`
fill that diverges from the pristine DolphinDOS-2 base (`kernal/reference/dolphindos2-faithful-b3b0.rom`).
Regenerate this map after any bake change; see the one-liner at the bottom.

**Total free: 1122 bytes in 20 regions.** The ROM stays exactly 8192 bytes — you
cannot shrink the file, only fill these holes (use `jmp` glue to span them).

## Free regions

| Range          | Size | Fill  | What was here (removed feature)                                   |
| -------------- | ---- | ----- | ---------------------------------------------------------------- |
| `$E42C-$E42F`  |    4 | `$EA` | boot-init slack (misc)                                            |
| `$F005-$F08D`  |  137 | `$EA` | ML-monitor prologue + command loop                               |
| `$F1AA-$F1AC`  |    3 | `$EA` | directory char-printer thunk                                     |
| `$F1DF-$F20D`  |   47 | `$EA` | ML-monitor filename parser                                       |
| `$F227-$F234`  |   14 | `$00` | ML-monitor command-char table                                    |
| `$F26C-$F278`  |   13 | `$EA` | ML-monitor byte-store helper (was embedded in CKOUT)             |
| `$F387-$F3AB`  |   37 | `$00` | F-key macro strings, part 1                                      |
| `$F3AE-$F3D4`  |   39 | mixed | F-key macro strings part 2 + F7/UCI-menu hook                    |
| `$F42B-$F494`  |  106 | `$EA` | ML-monitor handlers tail (`$F409-$F42A` = Ultimate UCI screen patch, IN USE) |
| `$F533-$F554`  |   34 | `$EA` | F-key dispatch                                                   |
| `$F72C-$F735`  |   10 | `$EA` | ML-monitor helper                                                |
| `$F8AF-$F8CA`  |   28 | `$00` | ML-monitor handler-address table (14 pairs)                      |
| `$F9E2-$FA6A`  |  137 | `$EA` | directory display renderer + continue-dump                       |
| `$FAAE-$FAB9`  |   12 | `$EA` | CTRL+A key-repeat toggle (removed)                               |
| `$FAC0-$FB10`  |   81 | mixed | directory block-count printer + hardcopy data table              |
| `$FB1A-$FB8D`  |  116 | `$EA` | screen->printer hardcopy body                                    |
| `$FB97-$FB9D`  |    7 | `$EA` | directory line-number printer                                    |
| `$FBA6-$FC3E`  |  153 | `$EA` | `LOAD"$"` / directory read+list engine                           |
| `$FCAA-$FCC9`  |   32 | `$EA` | ML-monitor "W" handler                                           |
| `$FECB-$FF3A`  |  112 | `$EA` | `$`-dir / F-key / CTRL+V dispatch (CTRL+D tail removed)           |

## Largest contiguous blocks (for placing routines)

| Size | Range          |
| ---- | -------------- |
|  153 | `$FBA6-$FC3E`  |
|  137 | `$F005-$F08D`  |
|  137 | `$F9E2-$FA6A`  |
|  116 | `$FB1A-$FB8D`  |
|  112 | `$FECB-$FF3A`  |
|  106 | `$F42B-$F494`  |
|   81 | `$FAC0-$FB10`  |
|   47 | `$F1DF-$F20D`  |

## Hazards — live bytes inside/adjacent to the holes (do NOT overwrite)

| Keep            | Why                                                                 |
| --------------- | ------------------------------------------------------------------- |
| `$F3AC-$F3AD`   | `clc`/`rts` island between the two F-key holes; 5 OPEN/send-name branches target it |
| `$F409-$F42A`   | Ultimate UCI ident + on-screen `BASIC V2` -> `ULTIMATE` patch (live add-on) |
| `$F495-$F4BB`   | LOAD (live; directly after the `$F42B-$F494` hole)                  |
| `$F196-$F1A6`   | serial-send constant table (read by the kept serial fallback)       |
| `$FB11-$FB19`   | SCNKEY stub (`sta $028c`/`sty $c5`/`lda $028c`/`rts`); hole starts at `$FB1A` |
| `$FECA`         | `$`-dir stub `rts` (`$60`); hole starts at `$FECB`                   |
| `$FF3B+`        | parallel-handshake serial wait (`jsr $ff3b` from `$EFE0/$EFE9/$F5A1`) and the IRQ/BRK entry `$FF48` |

`$F409-$F42A` does not contain a duplicate startup banner. It prints the original
`$E473` banner, then on UCI ident `$DF1D == $C9` writes `!scr "ultimate"` to
screen RAM `$043E-$0445`.

## Regenerate

```sh
python3 - <<'PY'
ORIG=0xE000
base=open('kernal/reference/dolphindos2-faithful-b3b0.rom','rb').read()
dol =open('kernal/rom/dolffy.rom','rb').read()
i=0
while i<len(dol):
    if dol[i] in (0xEA,0x00):
        j=i
        while j<len(dol) and dol[j] in (0xEA,0x00): j+=1
        if any(dol[k]!=base[k] for k in range(i,j)) and j-i>=3:
            print(f"${ORIG+i:04x}-${ORIG+j-1:04x}  {j-i}")
        i=j
    else: i+=1
PY
```
