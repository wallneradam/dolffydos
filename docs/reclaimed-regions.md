# Dolffy DOS — reclaimed regions & removed DolphinDOS-2 features

What the Dolffy "bake" removed from the DolphinDOS-2 base, what each piece
originally did, its current state, and how to restore it. This is the
restoration-grade record so the knowledge is not lost as more space is reclaimed.

## Where the originals live (nothing is lost)

The complete, pristine DolphinDOS-2 source and ROM are preserved in the repo:

| File                                                | What                                                   |
| --------------------------------------------------- | ------------------------------------------------------ |
| `kernal/reference/kernal.orig.asm`                  | full pre-bake source; assembles byte-exact to the base |
| `kernal/reference/dolphindos2-faithful-b3b0.rom`    | the base ROM, MD5 `b3b0fa84…` (origin `$E000`)         |
| `kernal/reference/transform.py`                     | the `$5684 -> $E000` relabel transform                 |

To recover any original bytes: `file_offset = addr - $E000` into the base ROM, or
`da65`/`dis.py` it. `da65 … dolphindos2-faithful-b3b0.rom` gives full disassembly.

The current `kernal/rom/dolffy.rom` is MD5 `25cd89d3`. Free holes the bake opened
are mapped in `docs/free-rom-space-map.md`. The original removal plan (historical,
written pre-application, partly superseded) is `docs/free-rom-space-plan.md`.

## Editor CTRL-key features

DolphinDOS adds editor CTRL-key functions. The output control-code keys are
dispatched at `$FA6B` (reached from the editor output path `$E7D1 jmp $fa6b`,
falling through to stock `$EC44`); the action keys were dispatched from the
F-key/special handler (`$F533` → `$FECA` chain), now neutralised.

### Kept (still work)

| Key    | Code  | Handler       | Action                          |
| ------ | ----- | ------------- | ------------------------------- |
| CTRL+B | `$02` | `$FA88-$FA96` | cursor to bottom of screen      |
| CTRL+G | `$07` | `$FA6B-$FA7E` | cursor 20 columns forward       |
| CTRL+K | `$0B` | `$FA97-$FAAD` | clear right side of line        |
| CTRL+L | `$0C` | `$FA83-$FA87` | clear left side of line         |

These are byte-identical to the base and verified in VICE (CTRL+G → column 20,
CTRL+B → row 24).

### Removed

| Key       | Original function                  | Original site(s)                 | Current state                                              |
| --------- | ---------------------------------- | -------------------------------- | --------------------------------------------------------- |
| CTRL+A    | key-repeat flag toggle (`$028A`)   | `$FAAE-$FAB9` handler            | **removed this session**: `$FA99` miss-branch retargeted `$13`→`$22` (→`$FABD jmp $ec44`), `$FAAE-$FAB9` → `$EA`. Verified: `$028A` no longer toggles |
| CTRL+D    | disk directory (`LOAD"$"`)         | `$FECA cmp #$04` → `$FBA6` engine | `$FECA` stubbed `rts`; engine `$FBA6-$FC3E` blanked; residual tail `$FECC-$FEDE` blanked this session |
| CTRL+@    | drive status                       | `$E591 jmp $fba9`               | `$E591` stubbed (`clc`/`rts`/`nop`); status body `$FBA9-$FC3E` blanked. Already removed |
| CTRL+\*   | screen hardcopy to printer         | `$FB11` SCNKEY detect → `$FB2E`  | `$FB11` stubbed (detector gone); body `$FB2E-$FB8D` blanked. Already removed |
| CTRL+V    | VIC-II re-init to defaults         | `$FF2E cpy #$16` → `$E5A0`       | dispatch chain orphaned then blanked `$FEDF-$FF3A` this session (shared `$E5A0` VIC-init kept) |
| CTRL+&    | function-keys ON                   | `$FECA` chain `$FEDF-$FF0F`      | F-key subsystem already bypassed; orphan chain blanked `$FEDF-$FF3A` this session |
| CTRL+X    | function-keys OFF                  | `$FECA` chain `$FEE2 eor #$18`   | same orphan chain, blanked this session                   |

`$F533-$F554` (F-key dispatch) was already NOPed and `$E5E7` rewritten to
`jsr $e5b4`, so the whole `$FECA-$FF3A` action chain had no live caller before the
blanking — removal is byte-confirmed safe and does not touch the kept keys.

### Never existed in DolphinDOS 2 (nothing to remove)

`CTRL+DEL` ("read line into buffer + erase from screen") and `C= +DEL` ("restore
buffer to screen") are **not implemented** in this ROM. Byte-verified across base,
stock and current: the only DEL (`$14`) code is the stock INST/DEL editor
(`$E74C`, `$E7EE`); `$FD9C` (called from `$E621`) is just a stock line-scroll
wrapper. No cut/paste buffer code is present.

## Other reclaimed DolphinDOS-2 features

| Feature                         | Original range(s)                                   | What it did                                          | Current state          |
| ------------------------------- | --------------------------------------------------- | ---------------------------------------------------- | ---------------------- |
| Built-in ML monitor             | `$F005-$F08D`, `$F1DF-$F20D`, `$F227-$F234`, `$F26C-$F278`, `$F409-$F494`†, `$F72C-$F735`, `$F8AF-$F8CA`, `$FCAA-$FCC9` | machine-language monitor (R/;/L/V/S/@/W, hex parse, dump) | blanked `$EA`/`$00`    |
| F-key macros + dispatch         | `$F387-$F3D4`, `$F533-$F554`, `$E5E7` (rewritten)   | programmable function-key strings + dispatch         | blanked; editor hook rewritten to `jsr $e5b4` |
| Fast directory display          | `$F1AA-$F1AC`, `$F9E2-$FA6A`, `$FAC0-$FB01`, `$FB97-$FB9D`, `$FBA6-$FC3E` | `LOAD"$"` read + on-screen list renderer             | blanked `$EA`          |
| Screen → printer hardcopy       | `$FB11` (stub), `$FB2E-$FB8D`, `$FB02-$FB10`        | dump screen to printer (OPEN 4)                      | detector stubbed, body blanked |
| BASIC `@`/`&`/`*` wedge         | `$E115` & `$E38E` (hooks), `$F775`-`$F7FC` (body)   | `@`/`&`/`*` commands at the READY prompt             | hooks restored to stock; `@`/`&`/`*` now `?SYNTAX ERROR` |

† `$F409-$F42A` of the monitor-handler hole has since been re-used for the
Ultimate UCI boot-banner patch: `$E429` calls `$F409`, which prints the original
`$E473` startup banner, reads UCI ident `$DF1D`, and only when it returns `$C9`
writes `!scr "ultimate"` over the on-screen `BASIC V2` at `$043E-$0445`.
Only `$F42B-$F494` is free.

## Restoring a feature

1. Find the range above; read the original bytes from
   `kernal/reference/dolphindos2-faithful-b3b0.rom` (`offset = addr - $E000`), or
   copy the original lines from `kernal/reference/kernal.orig.asm`.
2. Paste them back over the `!fill`/stub in `kernal/kernal.asm` at the same address
   (the bake never moved anything — addresses are unchanged).
3. Re-instate the entry hook (e.g. un-stub `$FECA`, restore `$E5E7 jsr $f533`, or
   the `$E115`/`$E38E` wedge hooks) — see the per-feature "site" column.
4. `make` and diff against the base to confirm only the intended bytes changed.
