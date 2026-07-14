; Runtime probe for the Hyper cursor's normal/inverse/inverse-SHIFT phases.
; Results are five screen-code/colour/state/covered-character records at $C100.

!cpu 6502
!to "/tmp/hyper_cursor_probe.prg", cbm

HCURSOR = $f409
RESULT = $c100

* = $c000
    php
    sei

    lda $d1
    pha
    lda $d2
    pha
    lda $d3
    pha
    lda $f3
    pha
    lda $f4
    pha
    lda $cf
    pha
    lda $ce
    pha
    lda $0287
    pha
    lda $0286
    pha
    lda $028d
    pha
    lda $0400
    pha
    lda $d800
    pha

    lda #$00
    sta $d1
    sta $d3
    sta $f3
    sta $cf
    lda #$04
    sta $d2
    lda #$d8
    sta $f4
    lda #$0e
    sta $0286

    lda #$41
    sta $0400
    lda #$05
    sta $d800
    sta $0287
    lda #$01
    sta $028d

    jsr DRAW
    ldy #$00
    jsr SNAPSHOT
    jsr DRAW
    ldy #$04
    jsr SNAPSHOT
    jsr DRAW
    ldy #$08
    jsr SNAPSHOT

    lda #$42
    sta $0400
    lda #$06
    sta $d800
    sta $0287
    lda #$00
    sta $cf
    sta $028d

    jsr DRAW
    ldy #$0c
    jsr SNAPSHOT
    jsr DRAW
    ldy #$10
    jsr SNAPSHOT

    lda #$a5
    sta RESULT+$14

    pla
    sta $d800
    pla
    sta $0400
    pla
    sta $028d
    pla
    sta $0286
    pla
    sta $0287
    pla
    sta $ce
    pla
    sta $cf
    pla
    sta $f4
    pla
    sta $f3
    pla
    sta $d3
    pla
    sta $d2
    pla
    sta $d1
    plp
    rts

DRAW:
    ldy #$00
    ldx $0287
    jsr HCURSOR
    rts

SNAPSHOT:
    lda $0400
    sta RESULT,y
    iny
    lda $d800
    and #$0f
    sta RESULT,y
    iny
    lda $cf
    sta RESULT,y
    iny
    lda $ce
    sta RESULT,y
    rts
