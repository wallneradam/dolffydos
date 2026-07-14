!cpu 6502

* = $0801
    !word basic_end
    !word 10
    !byte $9e
    !text "2061"
    !byte 0
basic_end:
    !word 0

* = $080d
    sei
    lda #$00
    sta $c0ff
    lda $df1d
    sta $c0f0
    lda $df1b
    sta $c0f1

    lda $df1c
    and #$30
    beq send_identify
    lda #$04
    sta $df1c
wait_abort:
    lda $df1c
    and #$04
    bne wait_abort

send_identify:
    lda #$05
    sta $df1d
    lda #$01
    sta $df1d
    sta $df1c

    ldy #$ff
wait_outer:
    ldx #$ff
wait_reply:
    lda $df1c
    and #$c0
    bne reply_ready
    dex
    bne wait_reply
    dey
    bne wait_outer
    lda #$ee
    sta $c0ff
    cli
    rts

reply_ready:
    ldx #$00
read_data:
    lda $df1c
    bpl read_status
    lda $df1e
    sta $c100,x
    inx
    bne read_data

read_status:
    ldy #$00
status_loop:
    lda $df1c
    and #$40
    beq accept
    lda $df1f
    sta $c180,y
    iny
    bne status_loop

accept:
    lda #$02
    sta $df1c
wait_accept:
    bit $df1c
    bne wait_accept
    stx $c0f2
    sty $c0f3
    lda #$a5
    sta $c0ff
    cli
    rts
