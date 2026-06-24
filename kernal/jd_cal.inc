; JiffyDOS fast-LOAD receiver calibration (sourced from kernal.asm when JD_ENABLE=1).
; The tight LOAD-body core JT_RX issues one DATA-release sync edge per byte and reads
; $DD00 four times; the drive edge-locks to the release and bursts 4 bit-pairs.
; Inter-read fills are in BYTES ($ea = 2 cyc each). Reads target ~+4/+14/+25/+36.
JT_TERM = $0334  ; scratch: terminal P (b6=CLK-in, b7=DATA-in) handed JT_RX -> caller
JT_USESTAB = 1   ; 1 = CLK-in stability confirm loop (anti-jitter), 0 = single CLK check
JT_STAB = 4      ; CLK-in stability confirm count (kills sync-phase jitter)
JT_R0 = 5        ; edge->read0 ~+16 (only working steady-state offset; window is razor-thin)
JT_R1 = 1        ; read0->read1 extra gap (on top of lsr lsr)
JT_R2 = 0        ; read1->read2 extra gap (on top of lsr lsr + eor#$07)
JT_R3 = 0        ; read2->read3 extra gap
JT_TG = 1        ; read3->terminal sample pad
JT_BLANK = 0     ; 0 = screen ON + raster guard (final), 1 = blank scaffold (debug)
; --- fast SAVE (send, JS_*) calibration ---
; The send core JS_TX issues one CLK-release sync edge per byte, then writes $DD00
; four times presenting bit-pairs (slot1=+11/slot2=+24/slot3=+35/slot4=+48 from the
; edge). slot1/slot2 land naturally; slot3/slot4/park are padded (BYTES of $ea, 2cyc).
JS_S2 = $0335    ; scratch: slot2 value precomputed before the burst (avoids lsr drift)
JS_P2 = 2        ; slot1->slot2 pad (slot2 from scratch -> ~+23)
JS_P3 = 2        ; slot2->slot3 pad (~+35)
JS_P4 = 2        ; slot3->slot4 pad (~+47)
JS_PE = 5        ; EOI marker hold ($07 both-released) before re-park; LAST byte only
                 ; (measured: real JD inserts $07 at ~+60 on the last byte of a
                 ; transmission so the drive finalizes the filename/file; non-EOI
                 ; bytes go slot4 -> re-park directly)
