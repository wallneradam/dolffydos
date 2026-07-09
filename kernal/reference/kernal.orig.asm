; =============================================
; Dolffy DOS - C64 Kernal ROM   (builds to rom/dolffy.rom)
; =============================================
; Project "Dolffy DOS" (Dolphin + Jiffy): DolphinDOS parallel disk speed +
; JiffyDOS serial (per-device) + Ultimate add-ons. This file is the editable
; base; it currently still assembles to the faithful upstream DolphinDOS 2 ROM
; (the Dolffy bake, i.e. feature removal, JiffyDOS, rebrand, is applied on top).
; =============================================
;
; ACME assembler format.
;
; Source provenance:
;   Reverse-engineered ACME disassembly from donnchawp/DolphinDOS2
;   (https://github.com/donnchawp/DolphinDOS2), released into the public
;   domain (Unlicense). Upstream binaries/credit: silverdr,
;   http://e4aws.silverdr.com/projects/dolphindos2/ . Not affiliated with the
;   original DolphinDOS developers; the original DolphinDOS firmware is
;   third-party. See README.md and LICENSE.
;
; This copy is RELABELED to the true runtime origin $E000 (the upstream
; disassembly used the artifact origin $5684). The relabel is byte-exact:
; assembling this file produces the identical 8192-byte ROM as upstream
; (MD5 b3b0fa8410edef1a42dbccf87e798f6e). Only relative-branch operands and
; the "; $xxxx" PC-annotation comments were shifted by +$897C; absolute
; operands and data are unchanged. See tools/relabel.py for the transform.
;
; Build:   acme -o rom/dolffy.rom kernal.asm   (or: make)
; =============================================

!cpu 6502
* = $e000

    sta $56                                  ; $e000

    jsr $bc0f                                ; $e002
    lda $61                                  ; $e005
    cmp #$88                                 ; $e007
    bcc $e00e                                ; $e009
    jsr $bad4                                ; $e00b
    jsr $bccc                                ; $e00e
    lda $07                                  ; $e011
    clc                                      ; $e013
    adc #$81                                 ; $e014
    beq $e00b                                ; $e016
    sec                                      ; $e018
    sbc #$01                                 ; $e019
    pha                                      ; $e01b
    ldx #$05                                 ; $e01c
    lda $69,x                                ; $e01e
    ldy $61,x                                ; $e020
    sta $61,x                                ; $e022
    sty $69,x                                ; $e024
    dex                                      ; $e026
    bpl $e01e                                ; $e027
    lda $56                                  ; $e029
    sta $70                                  ; $e02b
    jsr $b853                                ; $e02d
    jsr $bfb4                                ; $e030
    lda #$c4                                 ; $e033
    ldy #$bf                                 ; $e035
    jsr $e059                                ; $e037
    lda #$00                                 ; $e03a
    sta $6f                                  ; $e03c
    pla                                      ; $e03e
    jsr $bab9                                ; $e03f
    rts                                      ; $e042
    sta $71                                  ; $e043
    sty $72                                  ; $e045
    jsr $bbca                                ; $e047
    lda #$57                                 ; $e04a
    jsr $ba28                                ; $e04c
    jsr $e05d                                ; $e04f
    lda #$57                                 ; $e052
    ldy #$00                                 ; $e054
    jmp $ba28                                ; $e056
    sta $71                                  ; $e059
    sty $72                                  ; $e05b
    jsr $bbc7                                ; $e05d
    lda ($71),y                              ; $e060
    sta $67                                  ; $e062
    ldy $71                                  ; $e064
    iny                                      ; $e066
    tya                                      ; $e067
    bne $e06c                                ; $e068
    inc $72                                  ; $e06a
    sta $71                                  ; $e06c
    ldy $72                                  ; $e06e
    jsr $ba28                                ; $e070
    lda $71                                  ; $e073
    ldy $72                                  ; $e075
    clc                                      ; $e077
    adc #$05                                 ; $e078
    bcc $e07d                                ; $e07a
    iny                                      ; $e07c
    sta $71                                  ; $e07d
    sty $72                                  ; $e07f
    jsr $b867                                ; $e081
    lda #$5c                                 ; $e084
    ldy #$00                                 ; $e086
    dec $67                                  ; $e088
    bne $e070                                ; $e08a
    rts                                      ; $e08c
    tya                                      ; $e08d
    and $44,x                                ; $e08e
    !byte $7a                                ; $5714 (undefined opcode)
    brk                                      ; $e091
    pla                                      ; $e092
    plp                                      ; $e093
    lda ($46),y                              ; $e094
    brk                                      ; $e096
    jsr $bc2b                                ; $e097
    bmi $e0d3                                ; $e09a
    bne $e0be                                ; $e09c
    jsr $fff3                                ; $e09e
    stx $22                                  ; $e0a1
    sty $23                                  ; $e0a3
    ldy #$04                                 ; $e0a5
    lda ($22),y                              ; $e0a7
    sta $62                                  ; $e0a9
    iny                                      ; $e0ab
    lda ($22),y                              ; $e0ac
    sta $64                                  ; $e0ae
    ldy #$08                                 ; $e0b0
    lda ($22),y                              ; $e0b2
    sta $63                                  ; $e0b4
    iny                                      ; $e0b6
    lda ($22),y                              ; $e0b7
    sta $65                                  ; $e0b9
    jmp $e0e3                                ; $e0bb
    lda #$8b                                 ; $e0be
    ldy #$00                                 ; $e0c0
    jsr $bba2                                ; $e0c2
    lda #$8d                                 ; $e0c5
    ldy #$e0                                 ; $e0c7
    jsr $ba28                                ; $e0c9
    lda #$92                                 ; $e0cc
    ldy #$e0                                 ; $e0ce
    jsr $b867                                ; $e0d0
    ldx $65                                  ; $e0d3
    lda $62                                  ; $e0d5
    sta $65                                  ; $e0d7
    stx $62                                  ; $e0d9
    ldx $63                                  ; $e0db
    lda $64                                  ; $e0dd
    sta $63                                  ; $e0df
    stx $64                                  ; $e0e1
    lda #$00                                 ; $e0e3
    sta $66                                  ; $e0e5
    lda $61                                  ; $e0e7
    sta $70                                  ; $e0e9
    lda #$80                                 ; $e0eb
    sta $61                                  ; $e0ed
    jsr $b8d7                                ; $e0ef
    ldx #$8b                                 ; $e0f2
    ldy #$00                                 ; $e0f4
    jmp $bbd4                                ; $e0f6
    tax                                      ; $e0f9
    bne $e0fe                                ; $e0fa
    ldx #$1e                                 ; $e0fc
    jmp $a437                                ; $e0fe
    pha                                      ; $e101
    lda $0294                                ; $e102
    beq $e108                                ; $e105
    tax                                      ; $e107
    pla                                      ; $e108
    jmp $ffba                                ; $e109
    jsr $ffd2                                ; $e10c
    bcs $e0f9                                ; $e10f
    rts                                      ; $e111
    jsr $ffcf                                ; $e112
    jmp $f775                                ; $e115
    jsr $e4ad                                ; $e118
    bcs $e0f9                                ; $e11b
    rts                                      ; $e11d
    jsr $ffc6                                ; $e11e
    bcs $e0f9                                ; $e121
    rts                                      ; $e123
    jsr $ffe4                                ; $e124
    bcs $e0f9                                ; $e127
    rts                                      ; $e129
    jmp $f2be                                ; $e12a
    jsr $b7f7                                ; $e12d
    lda #$e1                                 ; $e130
    pha                                      ; $e132
    lda #$46                                 ; $e133
    pha                                      ; $e135
    lda $030f                                ; $e136
    pha                                      ; $e139
    lda $030c                                ; $e13a
    ldx $030d                                ; $e13d
    ldy $030e                                ; $e140
    plp                                      ; $e143
    jmp ($0014)                              ; $e144
    php                                      ; $e147
    sta $030c                                ; $e148
    stx $030d                                ; $e14b
    sty $030e                                ; $e14e
    pla                                      ; $e151
    sta $030f                                ; $e152
    rts                                      ; $e155
    jsr $e1d4                                ; $e156
    ldx $2d                                  ; $e159
    ldy $2e                                  ; $e15b
    lda #$2b                                 ; $e15d
    jsr $ffd8                                ; $e15f
    bcs $e0f9                                ; $e162
    rts                                      ; $e164
    lda #$01                                 ; $e165
    bit $00a9                                ; $e167
    sta $0a                                  ; $e16a
    jsr $e1d4                                ; $e16c
    lda $0a                                  ; $e16f
    ldx $2b                                  ; $e171
    ldy $2c                                  ; $e173
    jsr $ffd5                                ; $e175
    bcs $e1d1                                ; $e178
    lda $0a                                  ; $e17a
    beq $e195                                ; $e17c
    ldx #$1c                                 ; $e17e
    jsr $ffb7                                ; $e180
    and #$10                                 ; $e183
    bne $e19e                                ; $e185
    lda $7a                                  ; $e187
    cmp #$02                                 ; $e189
    beq $e194                                ; $e18b
    lda #$64                                 ; $e18d
    ldy #$a3                                 ; $e18f
    jmp $ab1e                                ; $e191
    rts                                      ; $e194
    jsr $ffb7                                ; $e195
    and #$bf                                 ; $e198
    beq $e1a1                                ; $e19a
    ldx #$1d                                 ; $e19c
    jmp $a437                                ; $e19e
    lda $7b                                  ; $e1a1
    cmp #$02                                 ; $e1a3
    bne $e1b5                                ; $e1a5
    jmp $f58e                                ; $e1a7
    rol $76a9                                ; $e1aa
    ldy #$a3                                 ; $e1ad
    jsr $ab1e                                ; $e1af
    jmp $a52a                                ; $e1b2
    jsr $a68e                                ; $e1b5
    jsr $a533                                ; $e1b8
    jmp $a677                                ; $e1bb
    jsr $e219                                ; $e1be
    jsr $ffc0                                ; $e1c1
    bcs $e1d1                                ; $e1c4
    rts                                      ; $e1c6
    jsr $e219                                ; $e1c7
    lda $49                                  ; $e1ca
    jsr $ffc3                                ; $e1cc
    bcc $e194                                ; $e1cf
    jmp $e0f9                                ; $e1d1
    lda #$00                                 ; $e1d4
    jsr $ffbd                                ; $e1d6
    ldx #$08                                 ; $e1d9
    ldy #$01                                 ; $e1db
    jsr $e101                                ; $e1dd
    jsr $e206                                ; $e1e0
    jsr $e257                                ; $e1e3
    jsr $f14a                                ; $e1e6
    jsr $e200                                ; $e1e9
    ldy #$00                                 ; $e1ec
    stx $49                                  ; $e1ee
    jsr $ffba                                ; $e1f0
    jsr $f14a                                ; $e1f3
    jsr $e200                                ; $e1f6
    txa                                      ; $e1f9
    tay                                      ; $e1fa
    ldx $49                                  ; $e1fb
    jmp $ffba                                ; $e1fd
    jsr $e20e                                ; $e200
    jmp $b79e                                ; $e203
    jsr $0079                                ; $e206
    bne $e20d                                ; $e209
    pla                                      ; $e20b
    pla                                      ; $e20c
    rts                                      ; $e20d
    jsr $aefd                                ; $e20e
    jsr $0079                                ; $e211
    bne $e20d                                ; $e214
    jmp $af08                                ; $e216
    lda #$00                                 ; $e219
    jsr $ffbd                                ; $e21b
    jsr $e211                                ; $e21e
    jsr $b79e                                ; $e221
    stx $49                                  ; $e224
    txa                                      ; $e226
    ldx #$08                                 ; $e227
    ldy #$0f                                 ; $e229
    jsr $e101                                ; $e22b
    jsr $e206                                ; $e22e
    jsr $e200                                ; $e231
    stx $4a                                  ; $e234
    ldy #$00                                 ; $e236
    lda $49                                  ; $e238
    cpx #$03                                 ; $e23a
    bne $e23f                                ; $e23c
    dey                                      ; $e23e
    jsr $ffba                                ; $e23f
    jsr $e206                                ; $e242
    jsr $e200                                ; $e245
    txa                                      ; $e248
    tay                                      ; $e249
    ldx $4a                                  ; $e24a
    lda $49                                  ; $e24c
    jsr $ffba                                ; $e24e
    jsr $e206                                ; $e251
    jsr $e20e                                ; $e254
    jsr $ad9e                                ; $e257
    jsr $b6a3                                ; $e25a
    ldx $22                                  ; $e25d
    ldy $23                                  ; $e25f
    jmp $ffbd                                ; $e261
    lda #$e0                                 ; $e264
    ldy #$e2                                 ; $e266
    jsr $b867                                ; $e268
    jsr $bc0c                                ; $e26b
    lda #$e5                                 ; $e26e
    ldy #$e2                                 ; $e270
    ldx $6e                                  ; $e272
    jsr $bb07                                ; $e274
    jsr $bc0c                                ; $e277
    jsr $bccc                                ; $e27a
    lda #$00                                 ; $e27d
    sta $6f                                  ; $e27f
    jsr $b853                                ; $e281
    lda #$ea                                 ; $e284
    ldy #$e2                                 ; $e286
    jsr $b850                                ; $e288
    lda $66                                  ; $e28b
    pha                                      ; $e28d
    bpl $e29d                                ; $e28e
    jsr $b849                                ; $e290
    lda $66                                  ; $e293
    bmi $e2a0                                ; $e295
    lda $12                                  ; $e297
    eor #$ff                                 ; $e299
    sta $12                                  ; $e29b
    jsr $bfb4                                ; $e29d
    lda #$ea                                 ; $e2a0
    ldy #$e2                                 ; $e2a2
    jsr $b867                                ; $e2a4
    pla                                      ; $e2a7
    bpl $e2ad                                ; $e2a8
    jsr $bfb4                                ; $e2aa
    lda #$ef                                 ; $e2ad
    ldy #$e2                                 ; $e2af
    jmp $e043                                ; $e2b1
    jsr $bbca                                ; $e2b4
    lda #$00                                 ; $e2b7
    sta $12                                  ; $e2b9
    jsr $e26b                                ; $e2bb
    ldx #$4e                                 ; $e2be
    ldy #$00                                 ; $e2c0
    jsr $e0f6                                ; $e2c2
    lda #$57                                 ; $e2c5
    ldy #$00                                 ; $e2c7
    jsr $bba2                                ; $e2c9
    lda #$00                                 ; $e2cc
    sta $66                                  ; $e2ce
    lda $12                                  ; $e2d0
    jsr $e2dc                                ; $e2d2
    lda #$4e                                 ; $e2d5
    ldy #$00                                 ; $e2d7
    jmp $bb0f                                ; $e2d9
    pha                                      ; $e2dc
    jmp $e29d                                ; $e2dd
    sta ($49,x)                              ; $e2e0
    !byte $0f                                ; $5966 (undefined opcode)
    !byte $da                                ; $5967 (undefined opcode)
    ldx #$83                                 ; $e2e4
    eor #$0f                                 ; $e2e6
    !byte $da                                ; $596c (undefined opcode)
    ldx #$7f                                 ; $e2e9
    brk                                      ; $e2eb
    brk                                      ; $e2ec
    brk                                      ; $e2ed
    brk                                      ; $e2ee
    ora $84                                  ; $e2ef
    inc $1a                                  ; $e2f1
    and $861b                                ; $e2f3
    plp                                      ; $e2f6
    !byte $07                                ; $597b (undefined opcode)
    !byte $fb                                ; $597c (undefined opcode)
    sed                                      ; $e2f9
    !byte $87                                ; $597e (undefined opcode)
    sta $8968,y                              ; $e2fb
    ora ($87,x)                              ; $e2fe
    !byte $23                                ; $5984 (undefined opcode)
    and $df,x                                ; $e301
    sbc ($86,x)                              ; $e303
    lda $5d                                  ; $e305
    !byte $e7                                ; $598b (undefined opcode)
    plp                                      ; $e308
    !byte $83                                ; $598d (undefined opcode)
    eor #$0f                                 ; $e30a
    !byte $da                                ; $5990 (undefined opcode)
    ldx #$a5                                 ; $e30d
    ror $48                                  ; $e30f
    bpl $e316                                ; $e311
    jsr $bfb4                                ; $e313
    lda $61                                  ; $e316
    pha                                      ; $e318
    cmp #$81                                 ; $e319
    bcc $e324                                ; $e31b
    lda #$bc                                 ; $e31d
    ldy #$b9                                 ; $e31f
    jsr $bb0f                                ; $e321
    lda #$3e                                 ; $e324
    ldy #$e3                                 ; $e326
    jsr $e043                                ; $e328
    pla                                      ; $e32b
    cmp #$81                                 ; $e32c
    bcc $e337                                ; $e32e
    lda #$e0                                 ; $e330
    ldy #$e2                                 ; $e332
    jsr $b850                                ; $e334
    pla                                      ; $e337
    bpl $e33d                                ; $e338
    jmp $bfb4                                ; $e33a
    rts                                      ; $e33d
    !byte $0b                                ; $59c2 (undefined opcode)
    ror $b3,x                                ; $e33f
    !byte $83                                ; $59c5 (undefined opcode)
    lda $79d3,x                              ; $e342
    asl $a6f4,x                              ; $e345
    sbc $7b,x                                ; $e348
    !byte $83                                ; $59ce (undefined opcode)
    !byte $fc                                ; $59cf (undefined opcode)
    bcs $e35e                                ; $e34c
    !byte $7c                                ; $59d2 (undefined opcode)
    !byte $0c                                ; $59d3 (undefined opcode)
    !byte $1f                                ; $59d4 (undefined opcode)
    !byte $67                                ; $59d5 (undefined opcode)
    dex                                      ; $e352
    !byte $7c                                ; $59d7 (undefined opcode)
    dec $cb53,x                              ; $e354
    cmp ($7d,x)                              ; $e357
    !byte $14                                ; $59dd (undefined opcode)
    !byte $64                                ; $59de (undefined opcode)
    bvs $e3a9                                ; $e35b
    adc $eab7,x                              ; $e35d
    eor ($7a),y                              ; $e360
    adc $3063,x                              ; $e362
    dey                                      ; $e365
    ror $927e,x                              ; $e366
    !byte $44                                ; $59ed (undefined opcode)
    sta $7e3a,y                              ; $e36a
    jmp $91cc                                ; $e36d
    !byte $c7                                ; $59f4 (undefined opcode)
    !byte $7f                                ; $59f5 (undefined opcode)
    tax                                      ; $e372
    tax                                      ; $e373
    tax                                      ; $e374
    !byte $13                                ; $59f9 (undefined opcode)
    sta ($00,x)                              ; $e376
    brk                                      ; $e378
    brk                                      ; $e379
    brk                                      ; $e37a
    jsr $ffcc                                ; $e37b
    lda #$00                                 ; $e37e
    sta $13                                  ; $e380
    jsr $a67a                                ; $e382
    cli                                      ; $e385
    ldx #$80                                 ; $e386
    jmp ($0300)                              ; $e388
    txa                                      ; $e38b
    bmi $e391                                ; $e38c
    jmp $f79c                                ; $e38e
    jmp $a474                                ; $e391
    jsr $e453                                ; $e394
    jsr $e3bf                                ; $e397
    jsr $e422                                ; $e39a
    ldx #$fb                                 ; $e39d
    txs                                      ; $e39f
    bne $e386                                ; $e3a0
    inc $7a                                  ; $e3a2
    bne $e3a8                                ; $e3a4
    inc $7b                                  ; $e3a6
    lda $ea60                                ; $e3a8
    cmp #$3a                                 ; $e3ab
    bcs $e3b9                                ; $e3ad
    cmp #$20                                 ; $e3af
    beq $e3a2                                ; $e3b1
    sec                                      ; $e3b3
    sbc #$30                                 ; $e3b4
    sec                                      ; $e3b6
    sbc #$d0                                 ; $e3b7
    rts                                      ; $e3b9
    !byte $80                                ; $5a3e (undefined opcode)
    !byte $4f                                ; $5a3f (undefined opcode)
    !byte $c7                                ; $5a40 (undefined opcode)
    !byte $52                                ; $5a41 (undefined opcode)
    cli                                      ; $e3be
    lda #$4c                                 ; $e3bf
    sta $54                                  ; $e3c1
    sta $0310                                ; $e3c3
    lda #$48                                 ; $e3c6
    ldy #$b2                                 ; $e3c8
    sta $0311                                ; $e3ca
    sty $0312                                ; $e3cd
    lda #$91                                 ; $e3d0
    ldy #$b3                                 ; $e3d2
    sta $05                                  ; $e3d4
    sty $06                                  ; $e3d6
    lda #$aa                                 ; $e3d8
    ldy #$b1                                 ; $e3da
    sta $03                                  ; $e3dc
    sty $04                                  ; $e3de
    ldx #$1c                                 ; $e3e0
    lda $e3a2,x                              ; $e3e2
    sta $73,x                                ; $e3e5
    dex                                      ; $e3e7
    bpl $e3e2                                ; $e3e8
    lda #$03                                 ; $e3ea
    sta $53                                  ; $e3ec
    lda #$00                                 ; $e3ee
    sta $68                                  ; $e3f0
    sta $13                                  ; $e3f2
    sta $18                                  ; $e3f4
    ldx #$01                                 ; $e3f6
    stx $01fd                                ; $e3f8
    stx $01fc                                ; $e3fb
    ldx #$19                                 ; $e3fe
    stx $16                                  ; $e400
    sec                                      ; $e402
    jsr $ff9c                                ; $e403
    stx $2b                                  ; $e406
    sty $2c                                  ; $e408
    sec                                      ; $e40a
    jsr $ff99                                ; $e40b
    stx $37                                  ; $e40e
    sty $38                                  ; $e410
    stx $33                                  ; $e412
    sty $34                                  ; $e414
    ldy #$00                                 ; $e416
    tya                                      ; $e418
    sta ($2b),y                              ; $e419
    inc $2b                                  ; $e41b
    bne $e421                                ; $e41d
    inc $2c                                  ; $e41f
    rts                                      ; $e421
    lda $2b                                  ; $e422
    ldy $2c                                  ; $e424
    jsr $a408                                ; $e426
    lda #$73                                 ; $e429
    ldy #$e4                                 ; $e42b
    jsr $ab1e                                ; $e42d
    lda $37                                  ; $e430
    sec                                      ; $e432
    sbc $2b                                  ; $e433
    tax                                      ; $e435
    lda $38                                  ; $e436
    sbc $2c                                  ; $e438
    jsr $bdcd                                ; $e43a
    lda #$60                                 ; $e43d
    ldy #$e4                                 ; $e43f
    jsr $ab1e                                ; $e441
    jmp $a644                                ; $e444
    !byte $8b                                ; $5acb (undefined opcode)
    !byte $e3                                ; $5acc (undefined opcode)
    !byte $83                                ; $5acd (undefined opcode)
    ldy $7c                                  ; $e44a
    lda $1a                                  ; $e44c
    !byte $a7                                ; $5ad2 (undefined opcode)
    cpx $a7                                  ; $e44f
    stx $ae                                  ; $e451
    ldx #$0b                                 ; $e453
    lda $e447,x                              ; $e455
    sta $0300,x                              ; $e458
    dex                                      ; $e45b
    bpl $e455                                ; $e45c
    bmi $e4b7                                ; $e45e
    jsr $4142                                ; $e460
    !byte $53                                ; $5ae7 (undefined opcode)
    eor #$43                                 ; $e464
    !byte $20,$42,$59                        ; $5aea (data: " BY")
    !byte $54                                ; $5aed (undefined opcode)
    eor $53                                  ; $e46a
    jsr $5246                                ; $e46c
    eor $45                                  ; $e46f
    ora $9300                                ; $e471
    ora $2020                                ; $e474
    jsr $2a20                                ; $e477
    rol                                    ; $e47a
    rol                                    ; $e47b
    rol                                    ; $e47c
    jsr $4f43                                ; $e47d
    eor $4f4d                                ; $e480
    !byte $44                                ; $5b07 (undefined opcode)
    !byte $4f                                ; $5b08 (undefined opcode)
    !byte $52                                ; $5b09 (undefined opcode)
    eor $20                                  ; $e486
    rol $34,x                                ; $e488
    jsr $4142                                ; $e48a
    !byte $53                                ; $5b11 (undefined opcode)
    eor #$43                                 ; $e48e
    jsr $3256                                ; $e490
    jsr $2a2a                                ; $e493
    rol                                    ; $e496
    rol                                    ; $e497
    ora $200d                                ; $e498
    !byte $44                                ; $5b1f (undefined opcode)
    !byte $4f                                ; $5b20 (undefined opcode)
    jmp $4850                                ; $e49d
    eor #$4e                                 ; $e4a0
    !byte $44                                ; $5b26 (undefined opcode)
    !byte $4f                                ; $5b27 (undefined opcode)
    !byte $53                                ; $5b28 (undefined opcode)
    jsr $2e32                                ; $e4a5
    bmi $e4ca                                ; $e4a8
    jsr $8100                                ; $e4aa
    pha                                      ; $e4ad
    jsr $ffc9                                ; $e4ae
    tax                                      ; $e4b1
    pla                                      ; $e4b2
    bcc $e4b6                                ; $e4b3
    txa                                      ; $e4b5
    rts                                      ; $e4b6
    lda #$87                                 ; $e4b7
    ldx #$f3                                 ; $e4b9
    sta $0297                                ; $e4bb
    stx $0298                                ; $e4be
    rts                                      ; $e4c1
    sei                                      ; $e4c2
    cld                                      ; $e4c3
    txs                                      ; $e4c4
    inx                                      ; $e4c5
    txa                                      ; $e4c6
    sta $01                                  ; $e4c7
    sta $0100,x                              ; $e4c9
    inx                                      ; $e4cc
    bne $e4c9                                ; $e4cd
    inc $f1                                  ; $e4cf
    bne $e4c9                                ; $e4d1
    lda #$37                                 ; $e4d3
    sta $01                                  ; $e4d5
    jmp $fcef                                ; $e4d7
    lda $0286                                ; $e4da
    sta ($f3),y                              ; $e4dd
    rts                                      ; $e4df
    adc #$02                                 ; $e4e0
    ldy $91                                  ; $e4e2
    iny                                      ; $e4e4
    bne $e4eb                                ; $e4e5
    cmp $a1                                  ; $e4e7
    bne $e4e2                                ; $e4e9
    rts                                      ; $e4eb
; =============================================================================
; PARALLEL_SEND_BYTE - Send one byte via parallel port
; Entry: A = byte to send
; Uses: $DD01 (parallel data), $DD00 (handshake via CLK line bit 2)
; =============================================================================
    sta $dd01      ; Write byte to parallel data port (directly to 1541) ; $5b70
    lda $dd0d      ; Read CIA#2 ICR to clear any pending FLAG interrupt ; $5b73
    lda $dd00      ; Read current port A state ; $5b76
    and #$fb       ; Clear bit 2 (CLK OUT low = "data ready") ; $5b79
    sta $dd00      ; Signal to drive: byte is ready on port ; $5b7b
    ora #$04       ; Set bit 2 (CLK OUT high = "idle/done") ; $5b7e
    sta $dd00      ; Complete handshake cycle ; $5b80
    rts                                      ; $e4ff
    ldx #$00                                 ; $e500
    ldy #$dc                                 ; $e502
    rts                                      ; $e504
    ldx #$28                                 ; $e505
    ldy #$19                                 ; $e507
    rts                                      ; $e509
    bcs $e513                                ; $e50a
    stx $d6                                  ; $e50c
    sty $d3                                  ; $e50e
    jsr $e56c                                ; $e510
    ldx $d6                                  ; $e513
    ldy $d3                                  ; $e515
    rts                                      ; $e517
    jsr $e5a0                                ; $e518
    lda #$00                                 ; $e51b
    sta $0291                                ; $e51d
    sta $cf                                  ; $e520
    lda #$48                                 ; $e522
    sta $028f                                ; $e524
    lda #$eb                                 ; $e527
    sta $0290                                ; $e529
    lda #$04                                 ; $e52c
    sta $028b                                ; $e52e
    sta $0288                                ; $e531
    lda #$01                                 ; $e534
    sta $0286                                ; $e536
    lda #$0a                                 ; $e539
    sta $0289                                ; $e53b
    lda #$0c                                 ; $e53e
    sta $cd                                  ; $e540
    sta $cc                                  ; $e542
    lda $0288                                ; $e544
    ora #$80                                 ; $e547
    tay                                      ; $e549
    lda #$00                                 ; $e54a
    tax                                      ; $e54c
    sty $d9,x                                ; $e54d
    clc                                      ; $e54f
    adc #$28                                 ; $e550
    bcc $e555                                ; $e552
    iny                                      ; $e554
    inx                                      ; $e555
    cpx #$1a                                 ; $e556
    bne $e54d                                ; $e558
    lda #$ff                                 ; $e55a
    sta $d9,x                                ; $e55c
    ldx #$18                                 ; $e55e
    jsr $e9ff                                ; $e560
    dex                                      ; $e563
    bpl $e560                                ; $e564
    ldy #$00                                 ; $e566
    sty $d3                                  ; $e568
    sty $d6                                  ; $e56a
    ldx $d6                                  ; $e56c
    lda $d3                                  ; $e56e
    ldy $d9,x                                ; $e570
    bmi $e57c                                ; $e572
    clc                                      ; $e574
    adc #$28                                 ; $e575
    sta $d3                                  ; $e577
    dex                                      ; $e579
    bpl $e570                                ; $e57a
    jsr $e9f0                                ; $e57c
    lda #$27                                 ; $e57f
    inx                                      ; $e581
    ldy $d9,x                                ; $e582
    bmi $e58c                                ; $e584
    clc                                      ; $e586
    adc #$28                                 ; $e587
    inx                                      ; $e589
    bpl $e582                                ; $e58a
    sta $d5                                  ; $e58c
    jmp $ea24                                ; $e58e
    jmp $fba9                                ; $e591
    jmp $e101                                ; $e594
    jmp $f894                                ; $e597
    jsr $e5a0                                ; $e59a
    jmp $e566                                ; $e59d
    lda #$03                                 ; $e5a0
    sta $9a                                  ; $e5a2
    lda #$00                                 ; $e5a4
    sta $99                                  ; $e5a6
    ldx #$2f                                 ; $e5a8
    lda $ecb8,x                              ; $e5aa
    sta $cfff,x                              ; $e5ad
    dex                                      ; $e5b0
    bne $e5aa                                ; $e5b1
    rts                                      ; $e5b3
    ldy $0277                                ; $e5b4
    ldx #$00                                 ; $e5b7
    lda $0278,x                              ; $e5b9
    sta $0277,x                              ; $e5bc
    inx                                      ; $e5bf
    cpx $c6                                  ; $e5c0
    bne $e5b9                                ; $e5c2
    dec $c6                                  ; $e5c4
    tya                                      ; $e5c6
    cli                                      ; $e5c7
    clc                                      ; $e5c8
    rts                                      ; $e5c9
    jsr $e716                                ; $e5ca
    lda $c6                                  ; $e5cd
    sta $cc                                  ; $e5cf
    sta $0292                                ; $e5d1
    beq $e5cd                                ; $e5d4
    sei                                      ; $e5d6
    lda $cf                                  ; $e5d7
    beq $e5e7                                ; $e5d9
    lda $ce                                  ; $e5db
    ldx $0287                                ; $e5dd
    ldy #$00                                 ; $e5e0
    sty $cf                                  ; $e5e2
    jsr $ea13                                ; $e5e4
    jsr $f533                                ; $e5e7
    cmp #$83                                 ; $e5ea
    bne $e5fe                                ; $e5ec
    ldx #$09                                 ; $e5ee
    sei                                      ; $e5f0
    stx $c6                                  ; $e5f1
    lda $ece6,x                              ; $e5f3
    sta $0276,x                              ; $e5f6
    dex                                      ; $e5f9
    bne $e5f3                                ; $e5fa
    beq $e5cd                                ; $e5fc
    cmp #$0d                                 ; $e5fe
    bne $e5ca                                ; $e600
    ldy $d5                                  ; $e602
    sty $d0                                  ; $e604
    lda ($d1),y                              ; $e606
    cmp #$20                                 ; $e608
    bne $e60f                                ; $e60a
    dey                                      ; $e60c
    bne $e606                                ; $e60d
    iny                                      ; $e60f
    sty $c8                                  ; $e610
    ldy #$00                                 ; $e612
    sty $0292                                ; $e614
    sty $d3                                  ; $e617
    sty $d4                                  ; $e619
    lda $c9                                  ; $e61b
    bmi $e63a                                ; $e61d
    ldx $d6                                  ; $e61f
    jsr $fd9c                                ; $e621
    cpx $c9                                  ; $e624
    bne $e63a                                ; $e626
    lda $ca                                  ; $e628
    sta $d3                                  ; $e62a
    cmp $c8                                  ; $e62c
    bcc $e63a                                ; $e62e
    bcs $e65d                                ; $e630
    tya                                      ; $e632
    pha                                      ; $e633
    txa                                      ; $e634
    pha                                      ; $e635
    lda $d0                                  ; $e636
    beq $e5cd                                ; $e638
    ldy $d3                                  ; $e63a
    lda ($d1),y                              ; $e63c
    sta $d7                                  ; $e63e
    and #$3f                                 ; $e640
    asl $d7                                  ; $e642
    bit $d7                                  ; $e644
    bpl $e64a                                ; $e646
    ora #$80                                 ; $e648
    bcc $e650                                ; $e64a
    ldx $d4                                  ; $e64c
    bne $e654                                ; $e64e
    bvs $e654                                ; $e650
    ora #$40                                 ; $e652
    inc $d3                                  ; $e654
    jsr $e684                                ; $e656
    cpy $c8                                  ; $e659
    bne $e674                                ; $e65b
    lda #$00                                 ; $e65d
    sta $d0                                  ; $e65f
    lda #$0d                                 ; $e661
    ldx $99                                  ; $e663
    cpx #$03                                 ; $e665
    beq $e66f                                ; $e667
    ldx $9a                                  ; $e669
    cpx #$03                                 ; $e66b
    beq $e672                                ; $e66d
    jsr $e716                                ; $e66f
    lda #$0d                                 ; $e672
    sta $d7                                  ; $e674
    pla                                      ; $e676
    tax                                      ; $e677
    pla                                      ; $e678
    tay                                      ; $e679
    lda $d7                                  ; $e67a
    cmp #$de                                 ; $e67c
    bne $e682                                ; $e67e
    lda #$ff                                 ; $e680
    clc                                      ; $e682
    rts                                      ; $e683
    cmp #$22                                 ; $e684
    bne $e690                                ; $e686
    lda $d4                                  ; $e688
    eor #$01                                 ; $e68a
    sta $d4                                  ; $e68c
    lda #$22                                 ; $e68e
    rts                                      ; $e690
    ora #$40                                 ; $e691
    ldx $c7                                  ; $e693
    beq $e699                                ; $e695
    ora #$80                                 ; $e697
    ldx $d8                                  ; $e699
    beq $e69f                                ; $e69b
    lsr $d4                                  ; $e69d
    ldx $0286                                ; $e69f
    jsr $ea13                                ; $e6a2
    jsr $e6b6                                ; $e6a5
    lda $d8                                  ; $e6a8
    beq $e6ae                                ; $e6aa
    dec $d8                                  ; $e6ac
    pla                                      ; $e6ae
    tay                                      ; $e6af
    pla                                      ; $e6b0
    tax                                      ; $e6b1
    pla                                      ; $e6b2
    clc                                      ; $e6b3
    cli                                      ; $e6b4
    rts                                      ; $e6b5
    jsr $e8b3                                ; $e6b6
    inc $d3                                  ; $e6b9
    lda $d5                                  ; $e6bb
    cmp $d3                                  ; $e6bd
    bcs $e700                                ; $e6bf
    cmp #$4f                                 ; $e6c1
    beq $e6f7                                ; $e6c3
    lda $0292                                ; $e6c5
    beq $e6cd                                ; $e6c8
    jmp $e967                                ; $e6ca
    ldx $d6                                  ; $e6cd
    cpx #$19                                 ; $e6cf
    bcc $e6da                                ; $e6d1
    jsr $e8ea                                ; $e6d3
    dec $d6                                  ; $e6d6
    ldx $d6                                  ; $e6d8
    asl $d9,x                                ; $e6da
    lsr $d9,x                                ; $e6dc
    inx                                      ; $e6de
    lda $d9,x                                ; $e6df
    ora #$80                                 ; $e6e1
    sta $d9,x                                ; $e6e3
    dex                                      ; $e6e5
    lda $d5                                  ; $e6e6
    clc                                      ; $e6e8
    adc #$28                                 ; $e6e9
    sta $d5                                  ; $e6eb
    lda $d9,x                                ; $e6ed
    bmi $e6f4                                ; $e6ef
    dex                                      ; $e6f1
    bne $e6ed                                ; $e6f2
    jmp $e9f0                                ; $e6f4
    dec $d6                                  ; $e6f7
    jsr $e87c                                ; $e6f9
    lda #$00                                 ; $e6fc
    sta $d3                                  ; $e6fe
    rts                                      ; $e700
    ldx $d6                                  ; $e701
    bne $e70b                                ; $e703
    stx $d3                                  ; $e705
    pla                                      ; $e707
    pla                                      ; $e708
    bne $e6a8                                ; $e709
    dex                                      ; $e70b
    stx $d6                                  ; $e70c
    jsr $e56c                                ; $e70e
    ldy $d5                                  ; $e711
    sty $d3                                  ; $e713
    rts                                      ; $e715
    pha                                      ; $e716
    sta $d7                                  ; $e717
    txa                                      ; $e719
    pha                                      ; $e71a
    tya                                      ; $e71b
    pha                                      ; $e71c
    lda #$00                                 ; $e71d
    sta $d0                                  ; $e71f
    ldy $d3                                  ; $e721
    lda $d7                                  ; $e723
    bpl $e72a                                ; $e725
    jmp $e7d4                                ; $e727
    cmp #$0d                                 ; $e72a
    bne $e731                                ; $e72c
    jmp $e891                                ; $e72e
    cmp #$20                                 ; $e731
    bcc $e745                                ; $e733
    cmp #$60                                 ; $e735
    bcc $e73d                                ; $e737
    and #$df                                 ; $e739
    bne $e73f                                ; $e73b
    and #$3f                                 ; $e73d
    jsr $e684                                ; $e73f
    jmp $e693                                ; $e742
    ldx $d8                                  ; $e745
    beq $e74c                                ; $e747
    jmp $e697                                ; $e749
    cmp #$14                                 ; $e74c
    bne $e77e                                ; $e74e
    tya                                      ; $e750
    bne $e759                                ; $e751
    jsr $e701                                ; $e753
    jmp $e773                                ; $e756
    jsr $e8a1                                ; $e759
    dey                                      ; $e75c
    sty $d3                                  ; $e75d
    jsr $ea24                                ; $e75f
    iny                                      ; $e762
    lda ($d1),y                              ; $e763
    dey                                      ; $e765
    sta ($d1),y                              ; $e766
    iny                                      ; $e768
    lda ($f3),y                              ; $e769
    dey                                      ; $e76b
    sta ($f3),y                              ; $e76c
    iny                                      ; $e76e
    cpy $d5                                  ; $e76f
    bne $e762                                ; $e771
    lda #$20                                 ; $e773
    sta ($d1),y                              ; $e775
    lda $0286                                ; $e777
    sta ($f3),y                              ; $e77a
    bpl $e7cb                                ; $e77c
    ldx $d4                                  ; $e77e
    beq $e785                                ; $e780
    jmp $e697                                ; $e782
    cmp #$12                                 ; $e785
    bne $e78b                                ; $e787
    sta $c7                                  ; $e789
    cmp #$13                                 ; $e78b
    bne $e792                                ; $e78d
    jsr $e566                                ; $e78f
    cmp #$1d                                 ; $e792
    bne $e7ad                                ; $e794
    iny                                      ; $e796
    jsr $e8b3                                ; $e797
    sty $d3                                  ; $e79a
    dey                                      ; $e79c
    cpy $d5                                  ; $e79d
    bcc $e7aa                                ; $e79f
    dec $d6                                  ; $e7a1
    jsr $e87c                                ; $e7a3
    ldy #$00                                 ; $e7a6
    sty $d3                                  ; $e7a8
    jmp $e6ae                                ; $e7aa
    cmp #$11                                 ; $e7ad
    bne $e7ce                                ; $e7af
    clc                                      ; $e7b1
    tya                                      ; $e7b2
    adc #$28                                 ; $e7b3
    tay                                      ; $e7b5
    inc $d6                                  ; $e7b6
    cmp $d5                                  ; $e7b8
    bcc $e7a8                                ; $e7ba
    beq $e7a8                                ; $e7bc
    dec $d6                                  ; $e7be
    sbc #$28                                 ; $e7c0
    bcc $e7c8                                ; $e7c2
    sta $d3                                  ; $e7c4
    bne $e7c0                                ; $e7c6
    jsr $e87c                                ; $e7c8
    jmp $e6ae                                ; $e7cb
    jsr $e8cb                                ; $e7ce
    jmp $fa6b                                ; $e7d1
    and #$7f                                 ; $e7d4
    cmp #$7f                                 ; $e7d6
    bne $e7dc                                ; $e7d8
    lda #$5e                                 ; $e7da
    cmp #$20                                 ; $e7dc
    bcc $e7e3                                ; $e7de
    jmp $e691                                ; $e7e0
    cmp #$0d                                 ; $e7e3
    bne $e7ea                                ; $e7e5
    jmp $e891                                ; $e7e7
    ldx $d4                                  ; $e7ea
    bne $e82d                                ; $e7ec
    cmp #$14                                 ; $e7ee
    bne $e829                                ; $e7f0
    ldy $d5                                  ; $e7f2
    lda ($d1),y                              ; $e7f4
    cmp #$20                                 ; $e7f6
    bne $e7fe                                ; $e7f8
    cpy $d3                                  ; $e7fa
    bne $e805                                ; $e7fc
    cpy #$4f                                 ; $e7fe
    beq $e826                                ; $e800
    jsr $e965                                ; $e802
    ldy $d5                                  ; $e805
    jsr $ea24                                ; $e807
    dey                                      ; $e80a
    lda ($d1),y                              ; $e80b
    iny                                      ; $e80d
    sta ($d1),y                              ; $e80e
    dey                                      ; $e810
    lda ($f3),y                              ; $e811
    iny                                      ; $e813
    sta ($f3),y                              ; $e814
    dey                                      ; $e816
    cpy $d3                                  ; $e817
    bne $e80a                                ; $e819
    lda #$20                                 ; $e81b
    sta ($d1),y                              ; $e81d
    lda $0286                                ; $e81f
    sta ($f3),y                              ; $e822
    inc $d8                                  ; $e824
    jmp $e6ae                                ; $e826
    ldx $d8                                  ; $e829
    beq $e832                                ; $e82b
    ora #$40                                 ; $e82d
    jmp $e697                                ; $e82f
    cmp #$11                                 ; $e832
    bne $e84c                                ; $e834
    ldx $d6                                  ; $e836
    beq $e871                                ; $e838
    dec $d6                                  ; $e83a
    lda $d3                                  ; $e83c
    sec                                      ; $e83e
    sbc #$28                                 ; $e83f
    bcc $e847                                ; $e841
    sta $d3                                  ; $e843
    bpl $e871                                ; $e845
    jsr $e56c                                ; $e847
    bne $e871                                ; $e84a
    cmp #$12                                 ; $e84c
    bne $e854                                ; $e84e
    lda #$00                                 ; $e850
    sta $c7                                  ; $e852
    cmp #$1d                                 ; $e854
    bne $e86a                                ; $e856
    tya                                      ; $e858
    beq $e864                                ; $e859
    jsr $e8a1                                ; $e85b
    dey                                      ; $e85e
    sty $d3                                  ; $e85f
    jmp $e6ae                                ; $e861
    jsr $e701                                ; $e864
    jmp $e6ae                                ; $e867
    cmp #$13                                 ; $e86a
    bne $e874                                ; $e86c
    jsr $e544                                ; $e86e
    jmp $e6ae                                ; $e871
    ora #$80                                 ; $e874
    jsr $e8cb                                ; $e876
    jmp $ec4f                                ; $e879
    lsr $c9                                  ; $e87c
    ldx $d6                                  ; $e87e
    inx                                      ; $e880
    cpx #$19                                 ; $e881
    bne $e888                                ; $e883
    jsr $e8ea                                ; $e885
    lda $d9,x                                ; $e888
    bpl $e880                                ; $e88a
    stx $d6                                  ; $e88c
    jmp $e56c                                ; $e88e
    ldx #$00                                 ; $e891
    stx $d8                                  ; $e893
    stx $c7                                  ; $e895
    stx $d4                                  ; $e897
    stx $d3                                  ; $e899
    jsr $e87c                                ; $e89b
    jmp $e6ae                                ; $e89e
    ldx #$02                                 ; $e8a1
    lda #$00                                 ; $e8a3
    cmp $d3                                  ; $e8a5
    beq $e8b0                                ; $e8a7
    clc                                      ; $e8a9
    adc #$28                                 ; $e8aa
    dex                                      ; $e8ac
    bne $e8a5                                ; $e8ad
    rts                                      ; $e8af
    dec $d6                                  ; $e8b0
    rts                                      ; $e8b2
    ldx #$02                                 ; $e8b3
    lda #$27                                 ; $e8b5
    cmp $d3                                  ; $e8b7
    beq $e8c2                                ; $e8b9
    clc                                      ; $e8bb
    adc #$28                                 ; $e8bc
    dex                                      ; $e8be
    bne $e8b7                                ; $e8bf
    rts                                      ; $e8c1
    ldx $d6                                  ; $e8c2
    cpx #$19                                 ; $e8c4
    beq $e8ca                                ; $e8c6
    inc $d6                                  ; $e8c8
    rts                                      ; $e8ca
    ldx #$0f                                 ; $e8cb
    cmp $e8da,x                              ; $e8cd
    beq $e8d6                                ; $e8d0
    dex                                      ; $e8d2
    bpl $e8cd                                ; $e8d3
    rts                                      ; $e8d5
    stx $0286                                ; $e8d6
    rts                                      ; $e8d9
    bcc $e8e1                                ; $e8da
    !byte $1c                                ; $5f60 (undefined opcode)
    !byte $9f                                ; $5f61 (undefined opcode)
    !byte $9c                                ; $5f62 (undefined opcode)
    asl $9e1f,x                              ; $e8df
    sta ($95,x)                              ; $e8e2
    stx $97,y                                ; $e8e4
    tya                                      ; $e8e6
    sta $9b9a,y                              ; $e8e7
    lda $ac                                  ; $e8ea
    pha                                      ; $e8ec
    lda $ad                                  ; $e8ed
    pha                                      ; $e8ef
    lda $ae                                  ; $e8f0
    pha                                      ; $e8f2
    lda $af                                  ; $e8f3
    pha                                      ; $e8f5
    ldx #$ff                                 ; $e8f6
    dec $d6                                  ; $e8f8
    dec $c9                                  ; $e8fa
    lda #$7f                                 ; $e8fc
    sta $dc00                                ; $e8fe
    lda $dc01                                ; $e901
    and #$24                                 ; $e904
    eor #$24                                 ; $e906
    beq $e91e                                ; $e908
    eor #$04                                 ; $e90a
    beq $e901                                ; $e90c
    lda $dc01                                ; $e90e
    and #$24                                 ; $e911
    eor #$04                                 ; $e913
    bne $e90e                                ; $e915
    sta $c6                                  ; $e917
    lda $aabd                                ; $e919
    cmp ($cf,x)                              ; $e91c
    inx                                      ; $e91e
    jsr $e9f0                                ; $e91f
    cpx #$18                                 ; $e922
    bcs $e932                                ; $e924
    lda $ecf1,x                              ; $e926
    sta $ac                                  ; $e929
    lda $da,x                                ; $e92b
    jsr $e9c8                                ; $e92d
    bmi $e91e                                ; $e930
    jsr $e9ff                                ; $e932
    ldx #$00                                 ; $e935
    lda $d9,x                                ; $e937
    and #$7f                                 ; $e939
    ldy $da,x                                ; $e93b
    bpl $e941                                ; $e93d
    ora #$80                                 ; $e93f
    sta $d9,x                                ; $e941
    inx                                      ; $e943
    cpx #$18                                 ; $e944
    bne $e937                                ; $e946
    lda $f1                                  ; $e948
    ora #$80                                 ; $e94a
    sta $f1                                  ; $e94c
    lda $d9                                  ; $e94e
    ora #$80                                 ; $e950
    sta $d9                                  ; $e952
    inc $d6                                  ; $e954
    ldx $d6                                  ; $e956
    pla                                      ; $e958
    sta $af                                  ; $e959
    pla                                      ; $e95b
    sta $ae                                  ; $e95c
    pla                                      ; $e95e
    sta $ad                                  ; $e95f
    pla                                      ; $e961
    sta $ac                                  ; $e962
    rts                                      ; $e964
    ldx $d6                                  ; $e965
    inx                                      ; $e967
    lda $d9,x                                ; $e968
    bpl $e967                                ; $e96a
    stx $02a5                                ; $e96c
    cpx #$18                                 ; $e96f
    beq $e981                                ; $e971
    bcc $e981                                ; $e973
    jsr $e8ea                                ; $e975
    ldx $02a5                                ; $e978
    dex                                      ; $e97b
    dec $d6                                  ; $e97c
    jmp $e6da                                ; $e97e
    lda $ac                                  ; $e981
    pha                                      ; $e983
    lda $ad                                  ; $e984
    pha                                      ; $e986
    lda $ae                                  ; $e987
    pha                                      ; $e989
    lda $af                                  ; $e98a
    pha                                      ; $e98c
    ldx #$19                                 ; $e98d
    dex                                      ; $e98f
    jsr $e9f0                                ; $e990
    cpx $02a5                                ; $e993
    bcc $e9a6                                ; $e996
    beq $e9a6                                ; $e998
    lda $ecef,x                              ; $e99a
    sta $ac                                  ; $e99d
    lda $d8,x                                ; $e99f
    jsr $e9c8                                ; $e9a1
    bmi $e98f                                ; $e9a4
    jsr $e9ff                                ; $e9a6
    ldx #$17                                 ; $e9a9
    cpx $02a5                                ; $e9ab
    bcc $e9bf                                ; $e9ae
    lda $da,x                                ; $e9b0
    and #$7f                                 ; $e9b2
    ldy $d9,x                                ; $e9b4
    bpl $e9ba                                ; $e9b6
    ora #$80                                 ; $e9b8
    sta $da,x                                ; $e9ba
    dex                                      ; $e9bc
    bne $e9ab                                ; $e9bd
    ldx $02a5                                ; $e9bf
    jsr $e6da                                ; $e9c2
    jmp $e958                                ; $e9c5
    and #$03                                 ; $e9c8
    ora $0288                                ; $e9ca
    sta $ad                                  ; $e9cd
    jsr $e9e0                                ; $e9cf
    ldy #$27                                 ; $e9d2
    lda ($ac),y                              ; $e9d4
    sta ($d1),y                              ; $e9d6
    lda ($ae),y                              ; $e9d8
    sta ($f3),y                              ; $e9da
    dey                                      ; $e9dc
    bpl $e9d4                                ; $e9dd
    rts                                      ; $e9df
    jsr $ea24                                ; $e9e0
    lda $ac                                  ; $e9e3
    sta $ae                                  ; $e9e5
    lda $ad                                  ; $e9e7
    and #$03                                 ; $e9e9
    ora #$d8                                 ; $e9eb
    sta $af                                  ; $e9ed
    rts                                      ; $e9ef
    lda $ecf0,x                              ; $e9f0
    sta $d1                                  ; $e9f3
    lda $d9,x                                ; $e9f5
    and #$03                                 ; $e9f7
    ora $0288                                ; $e9f9
    sta $d2                                  ; $e9fc
    rts                                      ; $e9fe
    ldy #$27                                 ; $e9ff
    jsr $e9f0                                ; $ea01
    jsr $ea24                                ; $ea04
    jsr $e4da                                ; $ea07
    lda #$20                                 ; $ea0a
    sta ($d1),y                              ; $ea0c
    dey                                      ; $ea0e
    bpl $ea07                                ; $ea0f
    rts                                      ; $ea11
    nop                                      ; $ea12
    tay                                      ; $ea13
    lda #$02                                 ; $ea14
    sta $cd                                  ; $ea16
    jsr $ea24                                ; $ea18
    tya                                      ; $ea1b
    ldy $d3                                  ; $ea1c
    sta ($d1),y                              ; $ea1e
    txa                                      ; $ea20
    sta ($f3),y                              ; $ea21
    rts                                      ; $ea23
    lda $d1                                  ; $ea24
    sta $f3                                  ; $ea26
    lda $d2                                  ; $ea28
    and #$03                                 ; $ea2a
    ora #$d8                                 ; $ea2c
    sta $f4                                  ; $ea2e
    rts                                      ; $ea30
    jsr $ffea                                ; $ea31
    lda $cc                                  ; $ea34
    bne $ea61                                ; $ea36
    dec $cd                                  ; $ea38
    bne $ea61                                ; $ea3a
    lda #$14                                 ; $ea3c
    sta $cd                                  ; $ea3e
    ldy $d3                                  ; $ea40
    lsr $cf                                  ; $ea42
    ldx $0287                                ; $ea44
    lda ($d1),y                              ; $ea47
    bcs $ea5c                                ; $ea49
    inc $cf                                  ; $ea4b
    sta $ce                                  ; $ea4d
    jsr $ea24                                ; $ea4f
    lda ($f3),y                              ; $ea52
    sta $0287                                ; $ea54
    ldx $0286                                ; $ea57
    lda $ce                                  ; $ea5a
    eor #$80                                 ; $ea5c
    jsr $ea1c                                ; $ea5e
    lda $01                                  ; $ea61
    and #$10                                 ; $ea63
    beq $ea71                                ; $ea65
    ldy #$00                                 ; $ea67
    sty $c0                                  ; $ea69
    lda $01                                  ; $ea6b
    ora #$20                                 ; $ea6d
    bne $ea79                                ; $ea6f
    lda $c0                                  ; $ea71
    bne $ea7b                                ; $ea73
    lda $01                                  ; $ea75
    and #$1f                                 ; $ea77
    sta $01                                  ; $ea79
    jsr $ea87                                ; $ea7b
    lda $dc0d                                ; $ea7e
    pla                                      ; $ea81
    tay                                      ; $ea82
    pla                                      ; $ea83
    tax                                      ; $ea84
    pla                                      ; $ea85
    rti                                      ; $ea86
    lda #$00                                 ; $ea87
    sta $028d                                ; $ea89
    ldy #$40                                 ; $ea8c
    sty $cb                                  ; $ea8e
    sta $dc00                                ; $ea90
    ldx $dc01                                ; $ea93
    cpx #$ff                                 ; $ea96
    beq $eafb                                ; $ea98
    tay                                      ; $ea9a
    lda #$81                                 ; $ea9b
    sta $f5                                  ; $ea9d
    lda #$eb                                 ; $ea9f
    sta $f6                                  ; $eaa1
    lda #$fe                                 ; $eaa3
    sta $dc00                                ; $eaa5
    ldx #$08                                 ; $eaa8
    pha                                      ; $eaaa
    lda $dc01                                ; $eaab
    cmp $dc01                                ; $eaae
    bne $eaab                                ; $eab1
    lsr                                    ; $eab3
    bcs $eacc                                ; $eab4
    pha                                      ; $eab6
    lda ($f5),y                              ; $eab7
    cmp #$05                                 ; $eab9
    bcs $eac9                                ; $eabb
    cmp #$03                                 ; $eabd
    beq $eac9                                ; $eabf
    ora $028d                                ; $eac1
    sta $028d                                ; $eac4
    bpl $eacb                                ; $eac7
    sty $cb                                  ; $eac9
    pla                                      ; $eacb
    iny                                      ; $eacc
    cpy #$41                                 ; $eacd
    bcs $eadc                                ; $eacf
    dex                                      ; $ead1
    bne $eab3                                ; $ead2
    sec                                      ; $ead4
    pla                                      ; $ead5
    rol                                    ; $ead6
    sta $dc00                                ; $ead7
    bne $eaa8                                ; $eada
    pla                                      ; $eadc
    jmp ($028f)                              ; $eadd
    ldy $cb                                  ; $eae0
    lda ($f5),y                              ; $eae2
    tax                                      ; $eae4
    cpy $c5                                  ; $eae5
    beq $eaf0                                ; $eae7
    lda #$10                                 ; $eae9
    jsr $fb11                                ; $eaeb
    bne $eb26                                ; $eaee
    and #$7f                                 ; $eaf0
    bit $028a                                ; $eaf2
    bmi $eb0d                                ; $eaf5
    bvs $eb42                                ; $eaf7
    cmp #$7f                                 ; $eaf9
    beq $eb26                                ; $eafb
    cmp #$0f                                 ; $eafd
    bcc $eb05                                ; $eaff
    cmp #$15                                 ; $eb01
    bcc $eb0d                                ; $eb03
    cmp #$1d                                 ; $eb05
    beq $eb0d                                ; $eb07
    cmp #$20                                 ; $eb09
    bne $eb42                                ; $eb0b
    ldy $028c                                ; $eb0d
    beq $eb17                                ; $eb10
    dec $028c                                ; $eb12
    bne $eb42                                ; $eb15
    dec $028b                                ; $eb17
    bne $eb42                                ; $eb1a
    ldy #$04                                 ; $eb1c
    sty $028b                                ; $eb1e
    ldy $c6                                  ; $eb21
    dey                                      ; $eb23
    bpl $eb42                                ; $eb24
    ldy $cb                                  ; $eb26
    sty $c5                                  ; $eb28
    ldy $028d                                ; $eb2a
    sty $028e                                ; $eb2d
    cpx #$fd                                 ; $eb30
    bcs $eb42                                ; $eb32
    txa                                      ; $eb34
    ldx $c6                                  ; $eb35
    cpx $0289                                ; $eb37
    bcs $eb42                                ; $eb3a
    sta $0277,x                              ; $eb3c
    inx                                      ; $eb3f
    stx $c6                                  ; $eb40
    lda #$7f                                 ; $eb42
    sta $dc00                                ; $eb44
    rts                                      ; $eb47
    lda $028d                                ; $eb48
    cmp #$03                                 ; $eb4b
    bne $eb64                                ; $eb4d
    cmp $028e                                ; $eb4f
    beq $eb42                                ; $eb52
    lda $0291                                ; $eb54
    bmi $eb76                                ; $eb57
    lda $d018                                ; $eb59
    eor #$02                                 ; $eb5c
    sta $d018                                ; $eb5e
    jmp $eb76                                ; $eb61
    asl                                    ; $eb64
    cmp #$08                                 ; $eb65
    bcc $eb6b                                ; $eb67
    lda #$06                                 ; $eb69
    tax                                      ; $eb6b
    lda $eb79,x                              ; $eb6c
    sta $f5                                  ; $eb6f
    lda $eb7a,x                              ; $eb71
    sta $f6                                  ; $eb74
    jmp $eae0                                ; $eb76
    sta ($eb,x)                              ; $eb79
    !byte $c2                                ; $61ff (undefined opcode)
    !byte $eb                                ; $6200 (undefined opcode)
    !byte $03                                ; $6201 (undefined opcode)
    cpx $ec78                                ; $eb7e
    !byte $14                                ; $6205 (undefined opcode)
    ora $881d                                ; $eb82
    sta $86                                  ; $eb85
    !byte $87                                ; $620b (undefined opcode)
    ora ($33),y                              ; $eb88
    !byte $57                                ; $620e (undefined opcode)
    eor ($34,x)                              ; $eb8b
    !byte $5a                                ; $6211 (undefined opcode)
    !byte $53                                ; $6212 (undefined opcode)
    eor $01                                  ; $eb8f
    and $52,x                                ; $eb91
    !byte $44                                ; $6217 (undefined opcode)
    rol $43,x                                ; $eb94
    lsr $54                                  ; $eb96
    cli                                      ; $eb98
    !byte $37                                ; $621d (undefined opcode)
    eor $3847,y                              ; $eb9a
    !byte $42                                ; $6221 (undefined opcode)
    pha                                      ; $eb9e
    eor $56,x                                ; $eb9f
    and $4a49,y                              ; $eba1
    bmi $ebf3                                ; $eba4
    !byte $4b                                ; $622a (undefined opcode)
    !byte $4f                                ; $622b (undefined opcode)
    lsr $502b                                ; $eba8
    jmp $2e2d                                ; $ebab
    !byte $3a                                ; $6232 (undefined opcode)
    rti                                      ; $ebaf
    bit $2a5c                                ; $ebb0
    !byte $3b                                ; $6237 (undefined opcode)
    !byte $13                                ; $6238 (undefined opcode)
    ora ($3d,x)                              ; $ebb5
    lsr $312f,x                              ; $ebb7
    !byte $5f                                ; $623e (undefined opcode)
    !byte $04                                ; $623f (undefined opcode)
    !byte $32                                ; $6240 (undefined opcode)
    jsr $5102                                ; $ebbd
    !byte $03                                ; $6244 (undefined opcode)
    !byte $ff                                ; $6245 (undefined opcode)
    sty $8d,x                                ; $ebc2
    sta $898c,x                              ; $ebc4
    txa                                      ; $ebc7
    !byte $8b                                ; $624c (undefined opcode)
    sta ($23),y                              ; $ebc9
    !byte $d7                                ; $624f (undefined opcode)
    cmp ($24,x)                              ; $ebcc
    !byte $da                                ; $6252 (undefined opcode)
    !byte $d3                                ; $6253 (undefined opcode)
    cmp $01                                  ; $ebd0
    and $d2                                  ; $ebd2
    cpy $26                                  ; $ebd4
    !byte $c3                                ; $625a (undefined opcode)
    dec $d4                                  ; $ebd7
    cld                                      ; $ebd9
    !byte $27                                ; $625e (undefined opcode)
    cmp $28c7,y                              ; $ebdb
    !byte $c2                                ; $6262 (undefined opcode)
    iny                                      ; $ebdf
    cmp $d6,x                                ; $ebe0
    and #$c9                                 ; $ebe2
    dex                                      ; $ebe4
    bmi $ebb4                                ; $ebe5
    !byte $cb                                ; $626b (undefined opcode)
    !byte $cf                                ; $626c (undefined opcode)
    dec $d0db                                ; $ebe9
    cpy $3edd                                ; $ebec
    !byte $5b                                ; $6273 (undefined opcode)
    tsx                                      ; $ebf0
    !byte $3c                                ; $6275 (undefined opcode)
    lda #$c0                                 ; $ebf2
    eor $0193,x                              ; $ebf4
    and $3fde,x                              ; $ebf7
    and ($5f,x)                              ; $ebfa
    !byte $04                                ; $6280 (undefined opcode)
    !byte $22                                ; $6281 (undefined opcode)
    ldy #$02                                 ; $ebfe
    cmp ($83),y                              ; $ec00
    !byte $ff                                ; $6286 (undefined opcode)
    !byte $10,$8d                            ; $6287 (bpl $6215)
    sta $808f,x                              ; $ec05
    !byte $82                                ; $628c (undefined opcode)
    sty $91                                  ; $ec09
    stx $b3,y                                ; $ec0b
    bcs $eba6                                ; $ec0d
    lda $b1ae                                ; $ec0f
    ora ($98,x)                              ; $ec12
    !byte $b2                                ; $6298 (undefined opcode)
    ldy $bc99                                ; $ec15
    !byte $bb                                ; $629c (undefined opcode)
    !byte $a3                                ; $629d (undefined opcode)
    lda $b79a,x                              ; $ec1a
    lda $9b                                  ; $ec1d
    !byte $bf                                ; $62a3 (undefined opcode)
    ldy $b8,x                                ; $ec20
    ldx $a229,y                              ; $ec22
    lda $30,x                                ; $ec25
    !byte $a7                                ; $62ab (undefined opcode)
    lda ($b9,x)                              ; $ec28
    tax                                      ; $ec2a
    ldx $af                                  ; $ec2b
    ldx $dc,y                                ; $ec2d
    rol $a45b,x                              ; $ec2f
    !byte $3c                                ; $62b6 (undefined opcode)
    tay                                      ; $ec33
    !byte $df                                ; $62b8 (undefined opcode)
    eor $0193,x                              ; $ec35
    and $3fde,x                              ; $ec38
    sta ($5f,x)                              ; $ec3b
    !byte $04                                ; $62c1 (undefined opcode)
    sta $a0,x                                ; $ec3e
    !byte $02                                ; $62c4 (undefined opcode)
    !byte $ab                                ; $62c5 (undefined opcode)
    !byte $83                                ; $62c6 (undefined opcode)
    !byte $ff                                ; $62c7 (undefined opcode)
    cmp #$0e                                 ; $ec44
    bne $ec4f                                ; $ec46
    lda $d018                                ; $ec48
    ora #$02                                 ; $ec4b
    bne $ec58                                ; $ec4d
    cmp #$8e                                 ; $ec4f
    bne $ec5e                                ; $ec51
    lda $d018                                ; $ec53
    and #$fd                                 ; $ec56
    sta $d018                                ; $ec58
    jmp $e6ae                                ; $ec5b
    cmp #$08                                 ; $ec5e
    bne $ec69                                ; $ec60
    lda #$80                                 ; $ec62
    ora $0291                                ; $ec64
    bmi $ec72                                ; $ec67
    cmp #$09                                 ; $ec69
    bne $ec5b                                ; $ec6b
    lda #$7f                                 ; $ec6d
    and $0291                                ; $ec6f
    sta $0291                                ; $ec72
    jmp $e6ae                                ; $ec75
    !byte $0f                                ; $62fc (undefined opcode)
    inc $ffff,x                              ; $ec79
    !byte $ff                                ; $6300 (undefined opcode)
    !byte $ff                                ; $6301 (undefined opcode)
    !byte $ff                                ; $6302 (undefined opcode)
    !byte $ff                                ; $6303 (undefined opcode)
    !byte $1c                                ; $6304 (undefined opcode)
    !byte $17                                ; $6305 (undefined opcode)
    ora ($9f,x)                              ; $ec82
    !byte $1a                                ; $6308 (undefined opcode)
    !byte $13                                ; $6309 (undefined opcode)
    ora $ff                                  ; $ec86
    !byte $9c                                ; $630c (undefined opcode)
    !byte $12                                ; $630d (undefined opcode)
    !byte $04                                ; $630e (undefined opcode)
    asl $0603,x                              ; $ec8b
    !byte $14                                ; $6312 (undefined opcode)
    clc                                      ; $ec8f
    !byte $1f                                ; $6314 (undefined opcode)
    ora $9e07,y                              ; $ec91
    !byte $02                                ; $6318 (undefined opcode)
    php                                      ; $ec95
    ora $16,x                                ; $ec96
    !byte $12                                ; $631c (undefined opcode)
    ora #$0a                                 ; $ec99
    !byte $92                                ; $631f (undefined opcode)
    ora $0f0b                                ; $ec9c
    asl $10ff                                ; $ec9f
    !byte $0c                                ; $6326 (undefined opcode)
    !byte $ff                                ; $6327 (undefined opcode)
    !byte $ff                                ; $6328 (undefined opcode)
    !byte $1b                                ; $6329 (undefined opcode)
    brk                                      ; $eca6
    !byte $ff                                ; $632b (undefined opcode)
    !byte $1c                                ; $632c (undefined opcode)
    sbc $021d,x                              ; $eca9
    !byte $ff                                ; $6330 (undefined opcode)
    !byte $1f                                ; $6331 (undefined opcode)
    asl $90ff,x                              ; $ecae
    asl $ff                                  ; $ecb1
    ora $ff                                  ; $ecb3
    !byte $ff                                ; $6339 (undefined opcode)
    !byte $11,$ff                            ; $633a (ora ($ff),y - zeropage wrap)
    !byte $ff                                ; $633c (undefined opcode)
    brk                                      ; $ecb9
    brk                                      ; $ecba
    brk                                      ; $ecbb
    brk                                      ; $ecbc
    brk                                      ; $ecbd
    brk                                      ; $ecbe
    brk                                      ; $ecbf
    brk                                      ; $ecc0
    brk                                      ; $ecc1
    brk                                      ; $ecc2
    brk                                      ; $ecc3
    brk                                      ; $ecc4
    brk                                      ; $ecc5
    brk                                      ; $ecc6
    brk                                      ; $ecc7
    brk                                      ; $ecc8
    brk                                      ; $ecc9
    !byte $9b                                ; $634e (undefined opcode)
    !byte $37                                ; $634f (undefined opcode)
    brk                                      ; $eccc
    brk                                      ; $eccd
    brk                                      ; $ecce
    php                                      ; $eccf
    brk                                      ; $ecd0
    !byte $14                                ; $6355 (undefined opcode)
    !byte $0f                                ; $6356 (undefined opcode)
    brk                                      ; $ecd3
    brk                                      ; $ecd4
    brk                                      ; $ecd5
    brk                                      ; $ecd6
    brk                                      ; $ecd7
    brk                                      ; $ecd8
    asl $0106                                ; $ecd9
    !byte $02                                ; $6360 (undefined opcode)
    !byte $03                                ; $6361 (undefined opcode)
    !byte $04                                ; $6362 (undefined opcode)
    brk                                      ; $ecdf
    ora ($02,x)                              ; $ece0
    !byte $03                                ; $6366 (undefined opcode)
    !byte $04                                ; $6367 (undefined opcode)
    ora $06                                  ; $ece4
    !byte $07                                ; $636a (undefined opcode)
    !byte $4c,$4f,$61                        ; $636b (data: "LOa")
    ora $5393                                ; $ecea
    eor $0d53,y                              ; $eced
    brk                                      ; $ecf0
    plp                                      ; $ecf1
    bvc $ed6c                                ; $ecf2
    ldy #$c8                                 ; $ecf4
    beq $ed10                                ; $ecf6
    rti                                      ; $ecf8
    pla                                      ; $ecf9
    bcc $ecb4                                ; $ecfa
    cpx #$08                                 ; $ecfc
    bmi $ed58                                ; $ecfe
    !byte $80                                ; $6384 (undefined opcode)
    tay                                      ; $ed01
    bne $ecfc                                ; $ed02
    !byte $20,$48,$70                        ; $6388 (data: " Hp")
    tya                                      ; $ed07
    cpy #$09                                 ; $ed08
    rti                                      ; $ed0a
    bit $2009                                ; $ed0b
    bit $24a9                                ; $ed0e
    pha                                      ; $ed11
    bit $94                                  ; $ed12
    bpl $ed20                                ; $ed14
    sec                                      ; $ed16
    ror $a3                                  ; $ed17
    jsr $ed40                                ; $ed19
    lsr $94                                  ; $ed1c
    lsr $a3                                  ; $ed1e
    pla                                      ; $ed20
    sta $95                                  ; $ed21
    sei                                      ; $ed23
    jsr $f951                                ; $ed24
    cmp #$24                                 ; $ed27
    bne $ed2e                                ; $ed29
    jmp $f91a                                ; $ed2b
; =============================================================================
; PARALLEL_MODE_ENTRY - Initialize parallel transfer mode for fast load
; Sets DATA OUT high to signal parallel mode to drive
; =============================================================================
    lda $dd00      ; Read CIA#2 port A       ; $63b2
    ora #$08       ; Set bit 3 (DATA OUT high) ; $63b5
    sta $dd00      ; Signal: "C64 ready for parallel mode" ; $63b7
    sei ; Disable interrupts for timing-critical code ; $63ba
    jsr $ee8e      ; IEC bus timing setup    ; $63bb
    jsr $ee97      ; Release CLK line        ; $63be
    jsr $eeb3      ; Additional IEC setup    ; $63c1
    sei ; Ensure interrupts still off        ; $63c4
    jmp $f96f      ; Continue to standard load routine ; $63c5
; =============================================================================
; SERIAL_BIT_RECEIVE - Fallback bit-by-bit receive (when parallel unavailable)
; Receives 8 bits via IEC bus CLK/DATA lines, stores in $95
; =============================================================================
    jsr $eea9      ; Wait for CLK edge       ; $63c8
    bcs $edad      ; Error: timeout          ; $63cb
    jsr $ee85      ; Release DATA line       ; $63cd
    bit $a3        ; Check handshake state   ; $63d0
    bpl $ed5a      ; Skip sync if not needed ; $63d2
    jsr $eea9      ; Wait for sync pulse high ; $63d4
    bcc $ed50                                ; $ed53
    jsr $eea9      ; Wait for sync pulse low ; $63d9
    bcs $ed55                                ; $ed58
    jsr $eea9      ; Wait for data ready signal ; $63de
    bcc $ed5a                                ; $ed5d
    jsr $ee8e      ; Prepare for bit reception ; $63e3
    lda #$08       ; 8 bits to receive       ; $63e6
    sta $a5        ; Store bit counter       ; $63e8
; --- Receive loop: get 8 bits from $DD00 bit 7 ---
    lda $dd00      ; Read port (bit 7 = data from drive) ; $63ea
    cmp $dd00      ; Wait for stable read    ; $63ed
    bne $ed66      ; Loop until two reads match ; $63f0
    asl          ; Shift bit 7 into carry  ; $63f2
    bcc $edb0      ; Carry clear (bit 7 was 0): EOI/last-byte condition ; $63f3
    ror $95        ; Rotate carry into result byte ; $63f5
    bcs $ed7a      ; Branch based on bit value ; $63f7
    jsr $eea0      ; Acknowledge: pull DATA low ; $63f9
    bne $ed7d                                ; $ed78
    jsr $ee97      ; Or: release CLK         ; $63fe
    jsr $ee85      ; Release DATA line       ; $6401
    nop ; Timing delay (4 cycles)            ; $6404
    nop                                      ; $ed81
    nop                                      ; $ed82
    nop                                      ; $ed83
    lda $dd00      ; Read port for next handshake ; $6408
    and #$df       ; Clear bit 5             ; $640b
    ora #$10       ; Set bit 4 (acknowledge received) ; $640d
    sta $dd00                                ; $ed8b
    dec $a5        ; Decrement bit counter   ; $6412
    bne $ed66      ; Loop until 8 bits received ; $6414
    lda #$04                                 ; $ed92
    sta $dc07                                ; $ed94
    lda #$19                                 ; $ed97
    sta $dc0f                                ; $ed99
    lda $dc0d                                ; $ed9c
    lda $dc0d                                ; $ed9f
    and #$02                                 ; $eda2
    bne $edb0                                ; $eda4
    jsr $eea9                                ; $eda6
    bcs $ed9f                                ; $eda9
    cli                                      ; $edab
    rts                                      ; $edac
    lda #$80                                 ; $edad
    bit $03a9                                ; $edaf
    jsr $fe1c                                ; $edb2
    cli                                      ; $edb5
    clc                                      ; $edb6
    bcc $ee03                                ; $edb7
    sta $95                                  ; $edb9
    jsr $f8dd                                ; $edbb
    lda $dd00                                ; $edbe
    and #$f7                                 ; $edc1
    sta $dd00                                ; $edc3
    rts                                      ; $edc6
    sta $95                                  ; $edc7
    jsr $f8dd                                ; $edc9
    sei                                      ; $edcc
    jsr $f76a                                ; $edcd
    jsr $edbe                                ; $edd0
    jsr $ee85                                ; $edd3
    jsr $eea9                                ; $edd6
    bmi $edd6                                ; $edd9
    cli                                      ; $eddb
    rts                                      ; $eddc
    bit $94                                  ; $eddd
    bmi $ede6                                ; $eddf
    sec                                      ; $ede1
    ror $94                                  ; $ede2
    bne $edeb                                ; $ede4
    pha                                      ; $ede6
    jsr $ed40                                ; $ede7
    pla                                      ; $edea
    sta $95                                  ; $edeb
    clc                                      ; $eded
    rts                                      ; $edee
    sei                                      ; $edef
    jsr $ee8e                                ; $edf0
    lda $dd00                                ; $edf3
    ora #$08                                 ; $edf6
    sta $dd00                                ; $edf8
    lda #$5f                                 ; $edfb
    bit $3fa9                                ; $edfd
    jsr $ed11                                ; $ee00
    jsr $edbe                                ; $ee03
    txa                                      ; $ee06
    ldx #$0a                                 ; $ee07
    dex                                      ; $ee09
    bne $ee09                                ; $ee0a
    tax                                      ; $ee0c
    jsr $ee85                                ; $ee0d
    jmp $ee97                                ; $ee10
    sei                                      ; $ee13
    lda #$00                                 ; $ee14
    sta $a5                                  ; $ee16
    jmp $f841                                ; $ee18
    jsr $eea9                                ; $ee1b
    bpl $ee1b                                ; $ee1e
    lda #$01                                 ; $ee20
    sta $dc07                                ; $ee22
    lda #$19                                 ; $ee25
    sta $dc0f                                ; $ee27
    jsr $ee97                                ; $ee2a
    lda $dc0d                                ; $ee2d
    lda $dc0d                                ; $ee30
    and #$02                                 ; $ee33
    bne $ee3e                                ; $ee35
    jsr $eea9                                ; $ee37
    bmi $ee30                                ; $ee3a
    bpl $ee56                                ; $ee3c
    lda $a5                                  ; $ee3e
    beq $ee47                                ; $ee40
    lda #$02                                 ; $ee42
    jmp $edb2                                ; $ee44
    jsr $eea0                                ; $ee47
    jsr $ee85                                ; $ee4a
    lda #$40                                 ; $ee4d
    jsr $fe1c                                ; $ee4f
    inc $a5                                  ; $ee52
    bne $ee20                                ; $ee54
; =============================================================================
; PARALLEL_FAST_RECEIVE - Receive byte via parallel port bit 7 handshake
; Uses two-phase clocking: wait for bit7 high (data), then wait for bit7 low
; Result stored in $A4, returned in A
; =============================================================================
    lda #$08       ; 8 bits to receive       ; $64da
    sta $a5        ; Store in bit counter    ; $64dc
; --- Receive bit loop ---
    lda $dd00      ; Read CIA#2 port A       ; $64de
    cmp $dd00      ; Double-read for stability (debounce) ; $64e1
    bne $ee5a      ; Retry if reads don't match ; $64e4
    asl          ; Shift bit 7 into carry  ; $64e6
    bpl $ee5a      ; Wait until bit 7 is HIGH (data ready) ; $64e7
    ror $a4        ; Rotate carry (the data bit) into result ; $64e9
; --- Wait for clock phase 2 (bit 7 goes low) ---
    lda $dd00      ; Read port again         ; $64eb
    cmp $dd00      ; Stability check         ; $64ee
    bne $ee67      ; Retry if unstable       ; $64f1
    asl          ; Shift bit 7 into carry  ; $64f3
    bmi $ee67      ; Wait until bit 7 is LOW (next bit ready) ; $64f4
    dec $a5        ; Decrement bit counter   ; $64f6
    bne $ee5a      ; Loop until 8 bits received ; $64f8
    jsr $eea0      ; Pull DATA low (acknowledge byte) ; $64fa
    bit $90        ; Check status flags      ; $64fd
    bvc $ee80      ; Skip if no overflow     ; $64ff
    jsr $ee06      ; Handle EOI condition    ; $6501
    lda $a4        ; Return received byte in A ; $6504
    cli ; Re-enable interrupts               ; $6506
    clc ; Clear carry (success)              ; $6507
    rts                                      ; $ee84
; =============================================================================
; HANDSHAKE HELPER ROUTINES - Manipulate $DD00 bits for IEC/parallel signaling
; =============================================================================
; CLR_ATN - Clear bit 4 (ATN OUT low)
    lda $dd00                                ; $ee85
    and #$ef       ; Clear bit 4             ; $650c
    sta $dd00                                ; $ee8a
    rts                                      ; $ee8d
; SET_ATN - Set bit 4 (ATN OUT high)
    lda $dd00                                ; $ee8e
    ora #$10       ; Set bit 4               ; $6515
    sta $dd00                                ; $ee93
    rts                                      ; $ee96
; CLR_BIT5 - Clear bit 5 (directly mapped to user port)
    lda $dd00                                ; $ee97
    and #$df       ; Clear bit 5             ; $651e
    sta $dd00                                ; $ee9c
    rts                                      ; $ee9f
; SET_BIT5 - Set bit 5 (directly mapped to user port)
    lda $dd00                                ; $eea0
    ora #$20       ; Set bit 5               ; $6527
    sta $dd00                                ; $eea5
    rts                                      ; $eea8
; WAIT_STABLE_READ - Read $DD00 until stable, return bit 7 in carry
    lda $dd00      ; Read port               ; $652d
    cmp $dd00      ; Compare with second read ; $6530
    bne $eea9      ; Loop until stable       ; $6533
    asl          ; Shift bit 7 into carry  ; $6535
    rts                                      ; $eeb2
; SHORT_DELAY - ~500 cycle delay loop
    txa ; Save X                             ; $6537
    ldx #$64       ; 100 iterations          ; $6538
    dex                                      ; $eeb6
    bne $eeb6      ; Loop (5 cycles * 100 = 500 cycles) ; $653b
    tax ; Restore X                          ; $653d
    rts                                      ; $eeba
    jsr $f5d2                                ; $eebb
    cpx #$02                                 ; $eebe
    beq $eeca                                ; $eec0
    ldy #$00                                 ; $eec2
    lda ($bb),y                              ; $eec4
    cmp #$24                                 ; $eec6
    bne $eecd                                ; $eec8
    jmp $f4f3                                ; $eeca
    ldx $dc0c                                ; $eecd
    bpl $eeca                                ; $eed0
    ldy #$51                                 ; $eed2
    jsr $f0eb                                ; $eed4
    jsr $f76f                                ; $eed7
    jsr $efef                                ; $eeda
    beq $eeca                                ; $eedd
    lda $9d                                  ; $eedf
    bpl $eeee                                ; $eee1
    ldy #$2a                                 ; $eee3
    jsr $f12f                                ; $eee5
    jsr $f890                                ; $eee8
    jsr $f12f                                ; $eeeb
    lda $ae                                  ; $eeee
    sta $c3                                  ; $eef0
    lda $af                                  ; $eef2
    sta $c4                                  ; $eef4
    jsr $f5a1                                ; $eef6
    tax                                      ; $eef9
    bit $dd00                                ; $eefa
    bvs $ef49                                ; $eefd
    bit $dd0d                                ; $eeff
    beq $eefa                                ; $ef02
    bit $dd01                                ; $ef04
    bit $91                                  ; $ef07
    bpl $ef2b                                ; $ef09
    ldy #$00                                 ; $ef0b
    lda $93                                  ; $ef0d
    bne $ef31                                ; $ef0f
    txa                                      ; $ef11
    bit $dd00                                ; $ef12
    bvs $ef49                                ; $ef15
    bit $dd0d                                ; $ef17
    beq $ef12                                ; $ef1a
    lda $dd01                                ; $ef1c
    sta ($ae),y                              ; $ef1f
    inc $ae                                  ; $ef21
    bne $ef11                                ; $ef23
    inc $af                                  ; $ef25
    bit $91                                  ; $ef27
    bmi $ef0d                                ; $ef29
    jsr $f736                                ; $ef2b
    jmp $f636                                ; $ef2e
    txa                                      ; $ef31
    bit $dd00                                ; $ef32
    bvs $ef49                                ; $ef35
    bit $dd0d                                ; $ef37
    beq $ef32                                ; $ef3a
    lda $dd01                                ; $ef3c
    cmp ($ae),y                              ; $ef3f
    bne $ef66                                ; $ef41
    inc $ae                                  ; $ef43
    bne $ef31                                ; $ef45
    beq $ef25                                ; $ef47
    jsr $ee97                                ; $ef49
    ldy #$40                                 ; $ef4c
    txa                                      ; $ef4e
    bit $dd0d                                ; $ef4f
    bne $ef5e                                ; $ef52
    inx                                      ; $ef54
    bne $ef4f                                ; $ef55
    ldy #$42                                 ; $ef57
    jsr $ef5e                                ; $ef59
    bcc $ef2e                                ; $ef5c
    sty $90                                  ; $ef5e
    jsr $f740                                ; $ef60
    jmp $f5a9                                ; $ef63
    jsr $f736                                ; $ef66
    lda #$50                                 ; $ef69
    sta $90                                  ; $ef6b
    bne $ef63                                ; $ef6d
    jsr $eddd                                ; $ef6f
    lda $90                                  ; $ef72
    beq $ef7b                                ; $ef74
    ldy #$00                                 ; $ef76
    jmp $f624                                ; $ef78
    ldx $dc0c                                ; $ef7b
    bpl $ef76                                ; $ef7e
    ldy #$5a                                 ; $ef80
    jsr $f0eb                                ; $ef82
    jsr $ee8e                                ; $ef85
    jsr $efef                                ; $ef88
    beq $ef76                                ; $ef8b
    ldy $ac                                  ; $ef8d
    sty $dd01                                ; $ef8f
    jsr $fcd1                                ; $ef92
    ldx $ad                                  ; $ef95
    bcs $efe0                                ; $ef97
    jsr $f5a1                                ; $ef99
    lda #$00                                 ; $ef9c
    sta $ac                                  ; $ef9e
    lda $ad                                  ; $efa0
    cmp $af                                  ; $efa2
    beq $efd8                                ; $efa4
    bne $efab                                ; $efa6
    stx $dd01                                ; $efa8
    lda ($ac),y                              ; $efab
    tax                                      ; $efad
    iny                                      ; $efae
    bne $efc3                                ; $efaf
    inc $ad                                  ; $efb1
    bit $91                                  ; $efb3
    bmi $efbd                                ; $efb5
    jsr $efe0                                ; $efb7
    jmp $f636                                ; $efba
    lda $ad                                  ; $efbd
    cmp $af                                  ; $efbf
    beq $efdc                                ; $efc1
    lda #$10                                 ; $efc3
    bit $dd0d                                ; $efc5
    bne $efa8                                ; $efc8
    bit $dd00                                ; $efca
    bpl $efc5                                ; $efcd
    jsr $f958                                ; $efcf
    jmp $f63f                                ; $efd2
    jsr $f5a1                                ; $efd5
    lda ($ac),y                              ; $efd8
    tax                                      ; $efda
    iny                                      ; $efdb
    cpy $ae                                  ; $efdc
    bne $efd5                                ; $efde
    jsr $ff3b                                ; $efe0
    jsr $ee85                                ; $efe3
    stx $dd01                                ; $efe6
    jsr $ff3b                                ; $efe9
    jmp $efcf                                ; $efec
    stx $dc0c                                ; $efef
    lda #$10                                 ; $eff2
    tax                                      ; $eff4
    bit $dd0d                                ; $eff5
    bne $effd                                ; $eff8
    inx                                      ; $effa
    bne $eff5                                ; $effb
    rts                                      ; $effd
    lda #$cb                                 ; $effe
    php                                      ; $f000
    pha                                      ; $f001
    txa                                      ; $f002
    pha                                      ; $f003
    tya                                      ; $f004
    pha                                      ; $f005
    sei                                      ; $f006
    cld                                      ; $f007
    ldx #$05                                 ; $f008
    pla                                      ; $f00a
    sta $0229,x                              ; $f00b
    dex                                      ; $f00e
    bpl $f00a                                ; $f00f
    tsx                                      ; $f011
    stx $022f                                ; $f012
    lda #$c0                                 ; $f015
    sta $9d                                  ; $f017
    lda #$52                                 ; $f019
    bne $f048                                ; $f01b
    lda $0316                                ; $f01d
    cmp #$66                                 ; $f020
    bne $f02b                                ; $f022
    lda $0317                                ; $f024
    cmp #$fe                                 ; $f027
    beq $f006                                ; $f029
    lda #$10                                 ; $f02b
    jmp ($0316)                              ; $f02d
    lda #$3f                                 ; $f030
    jsr $ffd2                                ; $f032
    ldx $022f                                ; $f035
    txs                                      ; $f038
    cli                                      ; $f039
    jsr $fec2                                ; $f03a
    jsr $ffcf                                ; $f03d
    cmp #$2e                                 ; $f040
    beq $f03d                                ; $f042
    cmp #$20                                 ; $f044
    beq $f03d                                ; $f046
    ldx #$0e                                 ; $f048
    dex                                      ; $f04a
    bmi $f030                                ; $f04b
    cmp $f227,x                              ; $f04d
    bne $f04a                                ; $f050
    txa                                      ; $f052
    asl                                    ; $f053
    tax                                      ; $f054
    lda $f8b0,x                              ; $f055
    pha                                      ; $f058
    lda $f8af,x                              ; $f059
    pha                                      ; $f05c
    rts                                      ; $f05d
    jsr $f063                                ; $f05e
    sta $fa                                  ; $f061
    lda #$10                                 ; $f063
    sta $f9                                  ; $f065
    jsr $f06e                                ; $f067
    asl $f9                                  ; $f06a
    bcc $f06a                                ; $f06c
    jsr $ffcf                                ; $f06e
    cmp #$20                                 ; $f071
    beq $f06e                                ; $f073
    cmp #$30                                 ; $f075
    bcc $f030                                ; $f077
    cmp #$47                                 ; $f079
    bcs $f030                                ; $f07b
    cmp #$3a                                 ; $f07d
    bcc $f087                                ; $f07f
    cmp #$41                                 ; $f081
    bcc $f030                                ; $f083
    sbc #$08                                 ; $f085
    sbc #$2f                                 ; $f087
    ora $f9                                  ; $f089
    sta $f9                                  ; $f08b
    rts                                      ; $f08d
    jsr $2e3b                                ; $f08e
    !byte $0d,$43,$5a                        ; $6715 (data: CR "CZ")
    eor #$44                                 ; $f094
    !byte $42                                ; $671a (undefined opcode)
    and $4e56                                ; $f097
    jsr $4320                                ; $f09a
    bvc $f0bf                                ; $f09d
    jsr $5350                                ; $f09f
    !byte $20,$52,$59                        ; $6726 (data: " RY")
    !byte $20,$52,$58                        ; $6729 (data: " RX")
    jsr $4143                                ; $f0a8
    jsr $5352                                ; $f0ab
    jsr $2020                                ; $f0ae
    jsr $000d                                ; $f0b1
    eor ($5f,x)                              ; $f0b4
    adc ($7f,x)                              ; $f0b6
    cpy #$c1                                 ; $f0b8
    !byte $db                                ; $673e (undefined opcode)
    cpx #$ff                                 ; $f0bb
    ora $2f49                                ; $f0bd
    !byte $4f                                ; $6744 (undefined opcode)
    jsr $5245                                ; $f0c1
    !byte $52                                ; $6748 (undefined opcode)
    !byte $4f                                ; $6749 (undefined opcode)
    !byte $52                                ; $674a (undefined opcode)
    jsr $0da3                                ; $f0c7
    !byte $53                                ; $674e (undefined opcode)
    eor $41                                  ; $f0cb
    !byte $52                                ; $6751 (undefined opcode)
    !byte $43                                ; $6752 (undefined opcode)
    pha                                      ; $f0cf
    eor #$4e                                 ; $f0d0
    !byte $47                                ; $6756 (undefined opcode)
    ldy #$46                                 ; $f0d3
    !byte $4f                                ; $6759 (undefined opcode)
    !byte $52                                ; $675a (undefined opcode)
    ldy #$0d                                 ; $f0d7
    bvc $f127                                ; $f0d9
    eor ($59,x)                              ; $f0db
    !byte $bf                                ; $6761 (undefined opcode)
    !byte $52                                ; $6762 (undefined opcode)
    eor $43                                  ; $f0df
    rol $50                                  ; $f0e1
    !byte $4c,$41,$59                        ; $6767 (data: "LAY")
    !byte $bf                                ; $676a (undefined opcode)
    jsr $2da4                                ; $f0e7
    ldy $20                                  ; $f0ea
    sei                                      ; $f0ec
    sbc ($20),y                              ; $f0ed
    clv                                      ; $f0ef
    sbc ($2c),y                              ; $f0f0
    !byte $0d,$dd,$60                        ; $6776 (data)
    ldx #$35                                 ; $f0f5
    ldy #$f2                                 ; $f0f7
    lda $93                                  ; $f0f9
    beq $f101                                ; $f0fb
    inx                                      ; $f0fd
    lda #$01                                 ; $f0fe
    bit $02a9                                ; $f100
    jmp $ffbd                                ; $f103
    ora $4f4c                                ; $f106
    eor ($44,x)                              ; $f109
    eor #$4e                                 ; $f10b
    !byte $c7                                ; $6791 (undefined opcode)
    ora $4153                                ; $f10e
    lsr $49,x                                ; $f111
    lsr $a047                                ; $f113
    ora $4556                                ; $f116
    !byte $52                                ; $679d (undefined opcode)
    eor #$46                                 ; $f11a
    eor $4e49,y                              ; $f11c
    !byte $c7                                ; $67a3 (undefined opcode)
    ora $4f46                                ; $f120
    eor $4e,x                                ; $f123
    !byte $44                                ; $67a9 (undefined opcode)
    ldy #$0d                                 ; $f126
    !byte $4f                                ; $67ac (undefined opcode)
    !byte $4b                                ; $67ad (undefined opcode)
    sta $9d24                                ; $f12a
    bpl $f13c                                ; $f12d
    lda $f0bd,y                              ; $f12f
    php                                      ; $f132
    and #$7f                                 ; $f133
    jsr $ffd2                                ; $f135
    iny                                      ; $f138
    plp                                      ; $f139
    bpl $f12f                                ; $f13a
    clc                                      ; $f13c
    rts                                      ; $f13d
    lda $99                                  ; $f13e
    bne $f166                                ; $f140
    lda $c6                                  ; $f142
    beq $f13c                                ; $f144
    sei                                      ; $f146
    jmp $e5b4                                ; $f147
    jsr $0079                                ; $f14a
    cmp #$2c                                 ; $f14d
    beq $f156                                ; $f14f
    pla                                      ; $f151
    pla                                      ; $f152
    jmp $a8f8                                ; $f153
    rts                                      ; $f156
    lda $99                                  ; $f157
    bne $f166                                ; $f159
    lda $d3                                  ; $f15b
    sta $ca                                  ; $f15d
    lda $d6                                  ; $f15f
    sta $c9                                  ; $f161
    jmp $e632                                ; $f163
    cmp #$03                                 ; $f166
    bne $f173                                ; $f168
    sta $d0                                  ; $f16a
    lda $d5                                  ; $f16c
    sta $c8                                  ; $f16e
    jmp $e632                                ; $f170
    bcs $f1ad                                ; $f173
    jmp $f713                                ; $f175
    jsr $f676                                ; $f178
    lda #$58                                 ; $f17b
    jsr $eddd                                ; $f17d
    tya                                      ; $f180
    jsr $eddd                                ; $f181
    jmp $edfe                                ; $f184
    ldy #$00                                 ; $f187
    jsr $fb9e                                ; $f189
    lda ($f9),y                              ; $f18c
    jsr $f898                                ; $f18e
    iny                                      ; $f191
    dex                                      ; $f192
    bne $f189                                ; $f193
    rts                                      ; $f195
    brk                                      ; $f196
    brk                                      ; $f197
    brk                                      ; $f198
    !byte $03                                ; $681d (undefined opcode)
    !byte $27                                ; $681e (undefined opcode)
    brk                                      ; $f19b
    cpx #$00                                 ; $f19c
    !byte $20,$00,$60                        ; $6822 (data)
    !byte $80                                ; $6825 (undefined opcode)
    rts                                      ; $f1a2
    rti                                      ; $f1a3
    sta ($85,x)                              ; $f1a4
    ldx $4c                                  ; $f1a6
    !byte $4b                                ; $682c (undefined opcode)
    !byte $fc                                ; $682d (undefined opcode)
    jmp $f2a9                                ; $f1aa
    lda $90                                  ; $f1ad
    beq $f1b5                                ; $f1af
    lda #$0d                                 ; $f1b1
    clc                                      ; $f1b3
    rts                                      ; $f1b4
    jmp $ee13                                ; $f1b5
    lda $dd03                                ; $f1b8
    sta $0296                                ; $f1bb
    lda #$ff                                 ; $f1be
    sta $dd03                                ; $f1c0
    lda $dd01                                ; $f1c3
    sta $0295                                ; $f1c6
    rts                                      ; $f1c9
    pha                                      ; $f1ca
    lda $9a                                  ; $f1cb
    cmp #$03                                 ; $f1cd
    bne $f1d5                                ; $f1cf
    pla                                      ; $f1d1
    jmp $e716                                ; $f1d2
    bcc $f1db                                ; $f1d5
    pla                                      ; $f1d7
    jmp $eddd                                ; $f1d8
    pla                                      ; $f1db
    jmp $f713                                ; $f1dc
    ldx #$08                                 ; $f1df
    ldy #$00                                 ; $f1e1
    jsr $e101                                ; $f1e3
    jsr $ffcf                                ; $f1e6
    cmp #$22                                 ; $f1e9
    beq $f1fd                                ; $f1eb
    cmp #$20                                 ; $f1ed
    beq $f1e6                                ; $f1ef
    cmp #$0d                                 ; $f1f1
    beq $f204                                ; $f1f3
    cmp #$22                                 ; $f1f5
    beq $f206                                ; $f1f7
    sta $0200,y                              ; $f1f9
    iny                                      ; $f1fc
    jsr $ffcf                                ; $f1fd
    cpy #$29                                 ; $f200
    bne $f1f1                                ; $f202
    stx $b9                                  ; $f204
    tya                                      ; $f206
    ldx #$00                                 ; $f207
    ldy #$02                                 ; $f209
    jmp $ffbd                                ; $f20b
    jsr $f30f                                ; $f20e
    beq $f216                                ; $f211
    jmp $f701                                ; $f213
    jsr $f31f                                ; $f216
    lda $ba                                  ; $f219
    beq $f223                                ; $f21b
    cmp #$03                                 ; $f21d
    bcc $f1dc                                ; $f21f
    bne $f237                                ; $f221
    sta $99                                  ; $f223
    clc                                      ; $f225
    rts                                      ; $f226
    !byte $52                                ; $68ab (undefined opcode)
    eor $3a58                                ; $f228
    !byte $3b                                ; $68af (undefined opcode)
    !byte $47                                ; $68b0 (undefined opcode)
    !byte $53                                ; $68b1 (undefined opcode)
    jmp $4056                                ; $f22e
    eor ($57,x)                              ; $f231
    ldy #$0d                                 ; $f233
    !byte $3a                                ; $68b9 (undefined opcode)
    rol                                    ; $f236
    tax                                      ; $f237
    jsr $ed09                                ; $f238
    lda $b9                                  ; $f23b
    bpl $f245                                ; $f23d
    jsr $edcc                                ; $f23f
    jmp $f248                                ; $f242
    jsr $edc7                                ; $f245
    txa                                      ; $f248
    bit $90                                  ; $f249
    bpl $f223                                ; $f24b
    jmp $f707                                ; $f24d
    jsr $f30f                                ; $f250
    beq $f258                                ; $f253
    jmp $f701                                ; $f255
    jsr $f31f                                ; $f258
    lda $ba                                  ; $f25b
    bne $f262                                ; $f25d
    jmp $f70d                                ; $f25f
    cmp #$03                                 ; $f262
    bcc $f21f                                ; $f264
    bne $f279                                ; $f266
    sta $9a                                  ; $f268
    clc                                      ; $f26a
    rts                                      ; $f26b
    ldy #$00                                 ; $f26c
    jsr $f063                                ; $f26e
    sei                                      ; $f271
    sta ($f7),y                              ; $f272
    iny                                      ; $f274
    dex                                      ; $f275
    bne $f26e                                ; $f276
    rts                                      ; $f278
    tax                                      ; $f279
    jsr $ed0c                                ; $f27a
    lda $b9                                  ; $f27d
    bpl $f286                                ; $f27f
    jsr $edbe                                ; $f281
    bne $f289                                ; $f284
    jsr $edb9                                ; $f286
    txa                                      ; $f289
    bit $90                                  ; $f28a
    bpl $f268                                ; $f28c
    jmp $f707                                ; $f28e
    jsr $f314                                ; $f291
    beq $f298                                ; $f294
    clc                                      ; $f296
    rts                                      ; $f297
    jsr $f31f                                ; $f298
    txa                                      ; $f29b
    pha                                      ; $f29c
    lda $ba                                  ; $f29d
    beq $f2f1                                ; $f29f
    cmp #$03                                 ; $f2a1
    beq $f2f1                                ; $f2a3
    bcs $f2ee                                ; $f2a5
    bcc $f2f1                                ; $f2a7
    pha                                      ; $f2a9
    and #$60                                 ; $f2aa
    bne $f2b5                                ; $f2ac
    inc $c7                                  ; $f2ae
    pla                                      ; $f2b0
    clc                                      ; $f2b1
    adc #$40                                 ; $f2b2
    bit $68                                  ; $f2b4
    jsr $ffd2                                ; $f2b6
    lda #$00                                 ; $f2b9
    sta $c7                                  ; $f2bb
    rts                                      ; $f2bd
    bne $f2d4                                ; $f2be
    lda $c3                                  ; $f2c0
    sta $14                                  ; $f2c2
    sbc $2b                                  ; $f2c4
    ldx $c4                                  ; $f2c6
    stx $15                                  ; $f2c8
    cpx $2c                                  ; $f2ca
    bne $f2d7                                ; $f2cc
    tax                                      ; $f2ce
    bne $f2d7                                ; $f2cf
    jmp $a871                                ; $f2d1
    jsr $f1a7                                ; $f2d4
    ldy $15                                  ; $f2d7
    bne $f2eb                                ; $f2d9
    lda $14                                  ; $f2db
    cmp #$10                                 ; $f2dd
    bcs $f2eb                                ; $f2df
    sty $14                                  ; $f2e1
    asl                                    ; $f2e3
    asl                                    ; $f2e4
    asl                                    ; $f2e5
    asl                                    ; $f2e6
    sta $15                                  ; $f2e7
    beq $f2ba                                ; $f2e9
    jmp $e130                                ; $f2eb
    jsr $f642                                ; $f2ee
    pla                                      ; $f2f1
    tax                                      ; $f2f2
    dec $98                                  ; $f2f3
    cpx $98                                  ; $f2f5
    beq $f30d                                ; $f2f7
    ldy $98                                  ; $f2f9
    lda $0259,y                              ; $f2fb
    sta $0259,x                              ; $f2fe
    lda $0263,y                              ; $f301
    sta $0263,x                              ; $f304
    lda $026d,y                              ; $f307
    sta $026d,x                              ; $f30a
    clc                                      ; $f30d
    rts                                      ; $f30e
    lda #$00                                 ; $f30f
    sta $90                                  ; $f311
    txa                                      ; $f313
    ldx $98                                  ; $f314
    dex                                      ; $f316
    bmi $f32e                                ; $f317
    cmp $0259,x                              ; $f319
    bne $f316                                ; $f31c
    rts                                      ; $f31e
    lda $0259,x                              ; $f31f
    sta $b8                                  ; $f322
    lda $0263,x                              ; $f324
    sta $ba                                  ; $f327
    lda $026d,x                              ; $f329
    sta $b9                                  ; $f32c
    rts                                      ; $f32e
    lda #$00                                 ; $f32f
    sta $98                                  ; $f331
    ldx #$03                                 ; $f333
    cpx $9a                                  ; $f335
    bcs $f33c                                ; $f337
    jsr $edfe                                ; $f339
    cpx $99                                  ; $f33c
    bcs $f343                                ; $f33e
    jsr $edef                                ; $f340
    stx $9a                                  ; $f343
    lda #$00                                 ; $f345
    sta $99                                  ; $f347
    rts                                      ; $f349
    ldx $b8                                  ; $f34a
    bne $f351                                ; $f34c
    jmp $f70a                                ; $f34e
    jsr $f30f                                ; $f351
    bne $f359                                ; $f354
    jmp $f6fe                                ; $f356
    ldx $98                                  ; $f359
    cpx #$0a                                 ; $f35b
    bcc $f362                                ; $f35d
    jmp $f6fb                                ; $f35f
    inc $98                                  ; $f362
    lda $b8                                  ; $f364
    sta $0259,x                              ; $f366
    lda $b9                                  ; $f369
    ora #$60                                 ; $f36b
    sta $b9                                  ; $f36d
    sta $026d,x                              ; $f36f
    lda $ba                                  ; $f372
    sta $0263,x                              ; $f374
    beq $f3ac                                ; $f377
    cmp #$03                                 ; $f379
    beq $f3ac                                ; $f37b
    bcc $f384                                ; $f37d
    jsr $f3d5                                ; $f37f
    bcc $f3ac                                ; $f382
    jmp $f713                                ; $f384
; F-key string table
; F1: LOa CR Ru: CR (LOAD then RUN with colon separator)
    !byte $4c,$4f,$61                        ; $f387
    !byte $0d,$52,$75                        ; $f38a
    !byte $3a,$0d                            ; $f38d
    !byte $00                                ; $f38f
; F2: Sy$0 LEFT (SYS$0 - monitor)
    !byte $53,$79,$24                        ; $f390
    !byte $30,$9d                            ; $f393
    !byte $00                                ; $f395
; F3: CLR @$ CR (display directory)
    !byte $93,$40,$24                        ; $f396
    !byte $0d                                ; $f399
    !byte $00                                ; $f39a
; F4: Ve CR (VERIFY)
    !byte $56,$65                            ; $f39b
    !byte $0d                                ; $f39d
    !byte $00                                ; $f39e
; F5: Ru: CR (RUN:)
    !byte $52,$75,$3a                        ; $f39f
    !byte $0d                                ; $f3a2
    !byte $00                                ; $f3a3
; F6: SAv"@: (SAVE)
    !byte $53,$41,$76                        ; $f3a4
    !byte $22,$40,$3a                        ; $f3a7
    !byte $00                                ; $f3aa
; F7: (intercepted at $6bd5 - opens UCI menu instead)
    !byte $93                                ; $f3ab
    clc                                      ; $6a30 (relocated branch target for clc+rts)
    rts                                      ; $f3ad
    !byte $0d                                ; $f3ae
    !byte $00                                ; $f3af
; F8: @X CR
    !byte $40,$58                            ; $f3b0
    !byte $0d                                ; $f3b2
    !byte $00                                ; $f3b3
; =============================================================================
; UCI Menu: F7 handler - opens Ultimate menu via UCI freeze command
; Hooked from F-key dispatch at $6bd5 (jmp $6a38)
; Uses Control Target ($04) with Freeze command ($05)
; =============================================================================
    cpx #$07           ; F7 key?              ; $6a38
    beq $f3be          ; Yes: UCI freeze      ; $6a3a
; --- Not F5: restore original dispatch flow ---
    lda $0298          ; Original instruction from $6bd5 ; $6a3c
    jmp $F554          ; Back to beq $6c10 at $6bd8 (tests Z flag) ; $6a3f
; --- UCI freeze: accept previous state, send Control Target + Freeze ---
    lda #$02                                  ; $f3be
    sta $DF1C          ; Accept: reset Data Last → Idle ; $6a44
    lsr                ; A=$01 (reused for push later) ; $6a47
    sta $DC00          ; Deselect keyboard row 0 (hides F7 from menu) ; $6a48
    ldx #$04           ; Control Target       ; $6a4b
    stx $DF1D          ; Send target byte     ; $6a4d
    inx                ; X=$05 (Freeze cmd)   ; $6a50
    stx $DF1D          ; Send command byte    ; $6a51
    sta $DF1C          ; Push command, A=$01 (CPU freezes after this) ; $6a54
    pla                ; Balance stack (from F-key dispatch) ; $6a57
    rts                                       ; $f3d4
    lda $b9                                  ; $f3d5
    bmi $f3ac                                ; $f3d7
    ldy $b7                                  ; $f3d9
    beq $f3ac                                ; $f3db
    lda #$00                                 ; $f3dd
    sta $90                                  ; $f3df
    lda $ba                                  ; $f3e1
    jsr $ed0c                                ; $f3e3
    lda $b9                                  ; $f3e6
    ora #$f0                                 ; $f3e8
    jsr $edb9                                ; $f3ea
    lda $90                                  ; $f3ed
    bpl $f3f6                                ; $f3ef
    pla                                      ; $f3f1
    pla                                      ; $f3f2
    jmp $f707                                ; $f3f3
    lda $b7                                  ; $f3f6
    beq $f406                                ; $f3f8
    ldy #$00                                 ; $f3fa
    lda ($bb),y                              ; $f3fc
    jsr $eddd                                ; $f3fe
    iny                                      ; $f401
    cpy $b7                                  ; $f402
    bne $f3fc                                ; $f404
    jmp $f654                                ; $f406
    ldx #$25                                 ; $f409
    lda $f08d,x                              ; $f40b
    jsr $ffd2                                ; $f40e
    dex                                      ; $f411
    bne $f40b                                ; $f412
    lda #$2b                                 ; $f414
    sta $f9                                  ; $f416
    lda #$02                                 ; $f418
    sta $fa                                  ; $f41a
    ldx #$05                                 ; $f41c
    jsr $f187                                ; $f41e
    jsr $fb9e                                ; $f421
    lda $0229                                ; $f424
    ldx $022a                                ; $f427
    jsr $f894                                ; $f42a
    jsr $fb9e                                ; $f42d
    ldx #$08                                 ; $f430
    ldy $022b                                ; $f432
    tya                                      ; $f435
    asl                                    ; $f436
    tay                                      ; $f437
    lda #$30                                 ; $f438
    adc #$00                                 ; $f43a
    jsr $ffd2                                ; $f43c
    dex                                      ; $f43f
    bne $f435                                ; $f440
    beq $f489                                ; $f442
    lda #$2b                                 ; $f444
    sta $f7                                  ; $f446
    lda #$02                                 ; $f448
    sta $f8                                  ; $f44a
    ldx #$05                                 ; $f44c
    jsr $f26c                                ; $f44e
    beq $f421                                ; $f451
    lda #$00                                 ; $f453
    bit $01a9                                ; $f455
    pha                                      ; $f458
    jsr $f1df                                ; $f459
    lda $d3                                  ; $f45c
    cmp $c8                                  ; $f45e
    bcs $f469                                ; $f460
    jsr $f05e                                ; $f462
    tax                                      ; $f465
    ldy $fa                                  ; $f466
    bit $b9e6                                ; $f468
    pla                                      ; $f46b
    jsr $ffd5                                ; $f46c
    lda $90                                  ; $f46f
    and #$10                                 ; $f471
    beq $f489                                ; $f473
    jmp $f030                                ; $f475
    jsr $f1df                                ; $f478
    jsr $f72c                                ; $f47b
    jsr $f05e                                ; $f47e
    tax                                      ; $f481
    ldy $fa                                  ; $f482
    lda #$f7                                 ; $f484
    jsr $ffd8                                ; $f486
    jmp $f035                                ; $f489
    jsr $f1df                                ; $f48c
    jsr $fba6                                ; $f48f
    jmp $f035                                ; $f492
    lsr                                    ; $f495
    bne $f4af                                ; $f496
    lda #$08                                 ; $f498
    sta $ba                                  ; $f49a
    bne $f4b8                                ; $f49c
    stx $c3                                  ; $f49e
    sty $c4                                  ; $f4a0
    jmp ($0330)                              ; $f4a2
    sta $93                                  ; $f4a5
    lda #$00                                 ; $f4a7
    sta $90                                  ; $f4a9
    lda $ba                                  ; $f4ab
    bne $f4b2                                ; $f4ad
    jmp $f713                                ; $f4af
    cmp #$03                                 ; $f4b2
    beq $f4af                                ; $f4b4
    bcc $f495                                ; $f4b6
    ldy $b7                                  ; $f4b8
    bne $f4bf                                ; $f4ba
    jsr $f0f5                                ; $f4bc
    ldx $b9                                  ; $f4bf
    jsr $f5af                                ; $f4c1
    lda #$60                                 ; $f4c4
    sta $b9                                  ; $f4c6
    jsr $f3d5                                ; $f4c8
    lda $ba                                  ; $f4cb
    jsr $ed09                                ; $f4cd
    lda $b9                                  ; $f4d0
    jsr $edc7                                ; $f4d2
    jsr $ee13                                ; $f4d5
    sta $ae                                  ; $f4d8
    lda $90                                  ; $f4da
    lsr                                    ; $f4dc
    lsr                                    ; $f4dd
    bcs $f530                                ; $f4de
    jsr $ee13                                ; $f4e0
    sta $af                                  ; $f4e3
    txa                                      ; $f4e5
    bne $f4f0                                ; $f4e6
    lda $c3                                  ; $f4e8
    sta $ae                                  ; $f4ea
    lda $c4                                  ; $f4ec
    sta $af                                  ; $f4ee
    jmp $eebb                                ; $f4f0
    lda #$fd                                 ; $f4f3
    and $90                                  ; $f4f5
    sta $90                                  ; $f4f7
    jsr $ffe1                                ; $f4f9
    bne $f501                                ; $f4fc
    jmp $f633                                ; $f4fe
    jsr $ee13                                ; $f501
    tax                                      ; $f504
    lda $90                                  ; $f505
    lsr                                    ; $f507
    lsr                                    ; $f508
    bcs $f4f3                                ; $f509
    txa                                      ; $f50b
    ldy $93                                  ; $f50c
    beq $f51c                                ; $f50e
    ldy #$00                                 ; $f510
    cmp ($ae),y                              ; $f512
    beq $f51e                                ; $f514
    lda #$50                                 ; $f516
    jsr $fe1c                                ; $f518
    bit $ae91                                ; $f51b
    inc $ae                                  ; $f51e
    bne $f524                                ; $f520
    inc $af                                  ; $f522
    bit $90                                  ; $f524
    bvc $f4f3                                ; $f526
    jsr $edef                                ; $f528
    jsr $f642                                ; $f52b
    bcc $f5a9                                ; $f52e
    jmp $f704                                ; $f530
    jsr $e5b4                                ; $f533
    pha                                      ; $f536
    cmp #$03                                 ; $f537
    beq $f584                                ; $f539
    lda $d4                                  ; $f53b
    ora $d8                                  ; $f53d
    bne $f58c                                ; $f53f
    tya                                      ; $f541
    ldx #$0c                                 ; $f542
    cmp $fc3e,x                              ; $f544
    beq $f551                                ; $f547
    dex                                      ; $f549
    bne $f544                                ; $f54a
    jsr $feca                                ; $f54c
    pla                                      ; $f54f
    rts                                      ; $f550
    jmp $F3B4      ; Hook: check for F7 (UCI menu) ; $6bd5
    beq $f58c                                ; $f554
    sta $f8                                  ; $f556
    lda $0297                                ; $f558
    sta $f7                                  ; $f55b
    ldy #$ff                                 ; $f55d
    dex                                      ; $f55f
    beq $f56c                                ; $f560
    iny                                      ; $f562
    lda ($f7),y                              ; $f563
    beq $f55f                                ; $f565
    bne $f562                                ; $f567
    jsr $e716                                ; $f569
    iny                                      ; $f56c
    lda ($f7),y                              ; $f56d
    beq $f582                                ; $f56f
    cmp #$0d                                 ; $f571
    beq $f579                                ; $f573
    cpx #$00                                 ; $f575
    beq $f569                                ; $f577
    sei                                      ; $f579
    sta $0277,x                              ; $f57a
    inx                                      ; $f57d
    cpx #$0a                                 ; $f57e
    bne $f56c                                ; $f580
    stx $c6                                  ; $f582
    ldx #$00                                 ; $f584
    stx $c7                                  ; $f586
    stx $d4                                  ; $f588
    stx $d8                                  ; $f58a
    pla                                      ; $f58c
    rts                                      ; $f58d
    lda $2b                                  ; $f58e
    cmp $c3                                  ; $f590
    bne $f59e                                ; $f592
    lda $2c                                  ; $f594
    cmp $c4                                  ; $f596
    bne $f59e                                ; $f598
    stx $2d                                  ; $f59a
    sty $2e                                  ; $f59c
    jmp $e1ab                                ; $f59e
    jsr $ff3b                                ; $f5a1
    stx $dd01                                ; $f5a4
    rts                                      ; $f5a7
    bit $18                                  ; $f5a8
    ldx $ae                                  ; $f5aa
    ldy $af                                  ; $f5ac
    rts                                      ; $f5ae
    lda $9d                                  ; $f5af
    bpl $f5d1                                ; $f5b1
    ldy #$0c                                 ; $f5b3
    jsr $f12f                                ; $f5b5
    lda $b7                                  ; $f5b8
    beq $f5d1                                ; $f5ba
    ldy #$17                                 ; $f5bc
    jsr $f12f                                ; $f5be
    ldy $b7                                  ; $f5c1
    beq $f5d1                                ; $f5c3
    ldy #$00                                 ; $f5c5
    lda ($bb),y                              ; $f5c7
    jsr $ffd2                                ; $f5c9
    iny                                      ; $f5cc
    cpy $b7                                  ; $f5cd
    bne $f5c7                                ; $f5cf
    rts                                      ; $f5d1
    ldy #$49                                 ; $f5d2
    lda $93                                  ; $f5d4
    beq $f5da                                ; $f5d6
    ldy #$59                                 ; $f5d8
    jmp $f12b                                ; $f5da
    stx $ae                                  ; $f5dd
    sty $af                                  ; $f5df
    tax                                      ; $f5e1
    lda $00,x                                ; $f5e2
    sta $c1                                  ; $f5e4
    lda $01,x                                ; $f5e6
    sta $c2                                  ; $f5e8
    jmp ($0332)                              ; $f5ea
    lda $ba                                  ; $f5ed
    bne $f5f4                                ; $f5ef
    jmp $f713                                ; $f5f1
    cmp #$03                                 ; $f5f4
    beq $f5f1                                ; $f5f6
    bcc $f659                                ; $f5f8
    lda #$61                                 ; $f5fa
    sta $b9                                  ; $f5fc
    ldy $b7                                  ; $f5fe
    bne $f605                                ; $f600
    jmp $f710                                ; $f602
    jsr $f3d5                                ; $f605
    jsr $f68f                                ; $f608
    lda $ba                                  ; $f60b
    jsr $ed0c                                ; $f60d
    lda $b9                                  ; $f610
    jsr $edb9                                ; $f612
    ldy #$00                                 ; $f615
    jsr $fb8e                                ; $f617
    lda $ac                                  ; $f61a
    jsr $eddd                                ; $f61c
    lda $ad                                  ; $f61f
    jmp $ef6f                                ; $f621
    jsr $fcd1                                ; $f624
    bcs $f63f                                ; $f627
    lda ($ac),y                              ; $f629
    jsr $eddd                                ; $f62b
    jsr $ffe1                                ; $f62e
    bne $f63a                                ; $f631
    jsr $f642                                ; $f633
    lda #$00                                 ; $f636
    sec                                      ; $f638
    rts                                      ; $f639
    jsr $fcdb                                ; $f63a
    bne $f624                                ; $f63d
    jsr $edfe                                ; $f63f
    bit $b9                                  ; $f642
    bmi $f657                                ; $f644
    lda $ba                                  ; $f646
    jsr $ed0c                                ; $f648
    lda $b9                                  ; $f64b
    and #$ef                                 ; $f64d
    ora #$e0                                 ; $f64f
    jsr $edb9                                ; $f651
    jsr $edfe                                ; $f654
    clc                                      ; $f657
    rts                                      ; $f658
    lsr                                    ; $f659
    !byte $90,$95                            ; $6cde (bcc $6c74)
    lda #$08                                 ; $f65c
    sta $ba                                  ; $f65e
    !byte $d0,$98                            ; $6ce4 (bne $6c7d)
    jsr $f05e                                ; $f662
    ldy $022e                                ; $f665
    ldx $022d                                ; $f668
    lda $022b                                ; $f66b
    pha                                      ; $f66e
    lda $022c                                ; $f66f
    plp                                      ; $f672
    jmp ($00f9)                              ; $f673
    lda #$00                                 ; $f676
    sta $90                                  ; $f678
    lda $ba                                  ; $f67a
    jsr $ed0c                                ; $f67c
    lda #$6f                                 ; $f67f
    jsr $edb9                                ; $f681
    lda $90                                  ; $f684
    bpl $f68d                                ; $f686
    pla                                      ; $f688
    pla                                      ; $f689
    jmp $f707                                ; $f68a
    clc                                      ; $f68d
    rts                                      ; $f68e
    lda $9d                                  ; $f68f
    bpl $f68e                                ; $f691
    ldy #$51                                 ; $f693
    jsr $f12f                                ; $f695
    jmp $f5c1                                ; $f698
    ldx #$00                                 ; $f69b
    inc $a2                                  ; $f69d
    bne $f6a7                                ; $f69f
    inc $a1                                  ; $f6a1
    bne $f6a7                                ; $f6a3
    inc $a0                                  ; $f6a5
    sec                                      ; $f6a7
    lda $a2                                  ; $f6a8
    sbc #$01                                 ; $f6aa
    lda $a1                                  ; $f6ac
    sbc #$1a                                 ; $f6ae
    lda $a0                                  ; $f6b0
    sbc #$4f                                 ; $f6b2
    bcc $f6bc                                ; $f6b4
    stx $a0                                  ; $f6b6
    stx $a1                                  ; $f6b8
    stx $a2                                  ; $f6ba
    lda $dc01                                ; $f6bc
    cmp $dc01                                ; $f6bf
    bne $f6bc                                ; $f6c2
    tax                                      ; $f6c4
    bmi $f6da                                ; $f6c5
    ldx #$bd                                 ; $f6c7
    stx $dc00                                ; $f6c9
    ldx $dc01                                ; $f6cc
    cpx $dc01                                ; $f6cf
    bne $f6cc                                ; $f6d2
    sta $dc00                                ; $f6d4
    inx                                      ; $f6d7
    bne $f6dc                                ; $f6d8
    sta $91                                  ; $f6da
    rts                                      ; $f6dc
    sei                                      ; $f6dd
    lda $a2                                  ; $f6de
    ldx $a1                                  ; $f6e0
    ldy $a0                                  ; $f6e2
    sei                                      ; $f6e4
    sta $a2                                  ; $f6e5
    stx $a1                                  ; $f6e7
    sty $a0                                  ; $f6e9
    cli                                      ; $f6eb
    rts                                      ; $f6ec
    lda $91                                  ; $f6ed
    cmp #$7f                                 ; $f6ef
    bne $f6fa                                ; $f6f1
    php                                      ; $f6f3
    jsr $ffcc                                ; $f6f4
    sta $c6                                  ; $f6f7
    plp                                      ; $f6f9
    rts                                      ; $f6fa
    lda #$01                                 ; $f6fb
    bit $02a9                                ; $f6fd
    bit $03a9                                ; $f700
    bit $04a9                                ; $f703
    bit $05a9                                ; $f706
    bit $06a9                                ; $f709
    bit $07a9                                ; $f70c
    bit $08a9                                ; $f70f
    bit $09a9                                ; $f712
    pha                                      ; $f715
    jsr $ffcc                                ; $f716
    ldy #$00                                 ; $f719
    bit $9d                                  ; $f71b
    bvc $f729                                ; $f71d
    jsr $f12f                                ; $f71f
    pla                                      ; $f722
    pha                                      ; $f723
    ora #$30                                 ; $f724
    jsr $ffd2                                ; $f726
    pla                                      ; $f729
    sec                                      ; $f72a
    rts                                      ; $f72b
    jsr $f05e                                ; $f72c
    sta $f7                                  ; $f72f
    lda $fa                                  ; $f731
    sta $f8                                  ; $f733
    rts                                      ; $f735
    jsr $ee97                                ; $f736
    bit $dd01                                ; $f739
    and #$40                                 ; $f73c
    beq $f736                                ; $f73e
    lda $c4                                  ; $f740
    cmp #$08                                 ; $f742
    bcc $f74d                                ; $f744
    lda $9d                                  ; $f746
    bpl $f74d                                ; $f748
    jsr $f890                                ; $f74a
    jmp $f958                                ; $f74d
    ldy #$63                                 ; $f750
    jsr $f12f                                ; $f752
    ldy #$05                                 ; $f755
    lda ($b2),y                              ; $f757
    jsr $ffd2                                ; $f759
    iny                                      ; $f75c
    cpy #$15                                 ; $f75d
    bne $f757                                ; $f75f
    lda $a1                                  ; $f761
    jsr $e4e0                                ; $f763
    nop                                      ; $f766
    clc                                      ; $f767
    dey                                      ; $f768
    rts                                      ; $f769
    bit $dc0c                                ; $f76a
    bpl $f772                                ; $f76d
    inc $dd03                                ; $f76f
    jmp $eea0                                ; $f772
    bcs $f7c0                                ; $f775
    cmp #$0d                                 ; $f777
    bne $f7bf                                ; $f779
    lda #$00                                 ; $f77b
    sta $0200,x                              ; $f77d
    bit $9d                                  ; $f780
    bpl $f797                                ; $f782
    ldx #$ff                                 ; $f784
    inx                                      ; $f786
    lda $0200,x                              ; $f787
    cmp #$20                                 ; $f78a
    beq $f786                                ; $f78c
    cmp #$40                                 ; $f78e
    bne $f797                                ; $f790
    lda #$22                                 ; $f792
    sta $0200,x                              ; $f794
    pla                                      ; $f797
    pla                                      ; $f798
    jmp $aacf                                ; $f799
    eor #$0b                                 ; $f79c
    beq $f7a3                                ; $f79e
    jmp $a43a                                ; $f7a0
    tay                                      ; $f7a3
    pla                                      ; $f7a4
    cmp #$a7                                 ; $f7a5
    bne $f7a0                                ; $f7a7
    pla                                      ; $f7a9
    lda ($7a),y                              ; $f7aa
    cmp #$22                                 ; $f7ac
    beq $f7b7                                ; $f7ae
    cmp #$40                                 ; $f7b0
    bne $f7c3                                ; $f7b2
    jsr $0073                                ; $f7b4
    jsr $e1d4                                ; $f7b7
    jsr $e591                                ; $f7ba
    bcs $f7c0                                ; $f7bd
    rts                                      ; $f7bf
    jmp $e0f9                                ; $f7c0
    cmp #$26                                 ; $f7c3
    bne $f7a0                                ; $f7c5
    jsr $0073                                ; $f7c7
    bne $f7cf                                ; $f7ca
    jmp $e4b7                                ; $f7cc
    cmp #$22                                 ; $f7cf
    bne $f7e4                                ; $f7d1
    jsr $e1d4                                ; $f7d3
    lda #$00                                 ; $f7d6
    jsr $ffd5                                ; $f7d8
    bcs $f7c0                                ; $f7db
    lda $c3                                  ; $f7dd
    ldx $c4                                  ; $f7df
    jmp $e4bb                                ; $f7e1
    cmp #$ac                                 ; $f7e4
    bne $f7fd                                ; $f7e6
    iny                                      ; $f7e8
    sta ($2b),y                              ; $f7e9
    jsr $a533                                ; $f7eb
    lda $22                                  ; $f7ee
    adc #$02                                 ; $f7f0
    sta $2d                                  ; $f7f2
    lda $23                                  ; $f7f4
    adc #$00                                 ; $f7f6
    sta $2e                                  ; $f7f8
    jmp $e1ab                                ; $f7fa
    jsr $f1a7                                ; $f7fd
    ldy #$2a                                 ; $f800
    jsr $f12f                                ; $f802
    lda $15                                  ; $f805
    tay                                      ; $f807
    ldx $14                                  ; $f808
    jsr $f894                                ; $f80a
    lda #$3d                                 ; $f80d
    jsr $ffd2                                ; $f80f
    tya                                      ; $f812
    jmp $bdcd                                ; $f813
    rts                                      ; $f816
    jsr $f82e                                ; $f817
    beq $f836                                ; $f81a
    ldy #$1b                                 ; $f81c
    jsr $f12f                                ; $f81e
    jsr $f8d0                                ; $f821
    jsr $f82e                                ; $f824
    bne $f821                                ; $f827
    ldy #$6a                                 ; $f829
    jmp $f12f                                ; $f82b
    lda #$10                                 ; $f82e
    bit $01                                  ; $f830
    bne $f836                                ; $f832
    bit $01                                  ; $f834
    clc                                      ; $f836
    rts                                      ; $f837
    jsr $f82e                                ; $f838
    beq $f836                                ; $f83b
    ldy #$21                                 ; $f83d
    bne $f81e                                ; $f83f
    bit $dc0c                                ; $f841
    bpl $f88a                                ; $f844
    stx $a5                                  ; $f846
    bit $dd00                                ; $f848
    bvc $f848                                ; $f84b
    lda $dd00                                ; $f84d
    and #$df                                 ; $f850
    sta $dd00                                ; $f852
    ldx #$05                                 ; $f855
    bit $dd00                                ; $f857
    bvc $f879                                ; $f85a
    dex                                      ; $f85c
    bne $f857                                ; $f85d
    jsr $eea0                                ; $f85f
    lda #$40                                 ; $f862
    jsr $fe1c                                ; $f864
    jsr $ee97                                ; $f867
    ldx #$05                                 ; $f86a
    bit $dd00                                ; $f86c
    bvc $f879                                ; $f86f
    dex                                      ; $f871
    bne $f86c                                ; $f872
    lda #$02                                 ; $f874
    jmp $f9b7                                ; $f876
    ldx $dd01                                ; $f879
    ora #$20                                 ; $f87c
    sta $dd00                                ; $f87e
    stx $a4                                  ; $f881
    ldx $a5                                  ; $f883
    lda $a4                                  ; $f885
    clc                                      ; $f887
    cli                                      ; $f888
    rts                                      ; $f889
    jsr $ee85                                ; $f88a
    jmp $ee1b                                ; $f88d
    ldx $ae                                  ; $f890
    lda $af                                  ; $f892
    jsr $f898                                ; $f894
    txa                                      ; $f897
    pha                                      ; $f898
    lsr                                    ; $f899
    lsr                                    ; $f89a
    lsr                                    ; $f89b
    lsr                                    ; $f89c
    jsr $f8a3                                ; $f89d
    pla                                      ; $f8a0
    and #$0f                                 ; $f8a1
    clc                                      ; $f8a3
    adc #$30                                 ; $f8a4
    cmp #$3a                                 ; $f8a6
    bcc $f8ac                                ; $f8a8
    adc #$06                                 ; $f8aa
    jmp $ffd2                                ; $f8ac
    php                                      ; $f8af
    !byte $f4                                ; $6f34 (undefined opcode)
    !byte $e3                                ; $6f35 (undefined opcode)
    sbc $a473,y                              ; $f8b2
    !byte $53                                ; $6f39 (undefined opcode)
    !byte $fa                                ; $6f3a (undefined opcode)
    !byte $43                                ; $6f3b (undefined opcode)
    !byte $f4                                ; $6f3c (undefined opcode)
    adc ($f6,x)                              ; $f8b9
    !byte $77                                ; $6f3f (undefined opcode)
    !byte $f4                                ; $6f40 (undefined opcode)
    !byte $52                                ; $6f41 (undefined opcode)
    !byte $f4                                ; $6f42 (undefined opcode)
    eor $f4,x                                ; $f8bf
    !byte $8b                                ; $6f45 (undefined opcode)
    !byte $f4                                ; $6f46 (undefined opcode)
    sbc ($f9,x)                              ; $f8c3
    lda #$fc                                 ; $f8c5
    !byte $f3                                ; $6f4b (undefined opcode)
    sbc $fa02,y                              ; $f8c8
    ora ($0a,x)                              ; $f8cb
    !byte $64                                ; $6f51 (undefined opcode)
    inx                                      ; $f8ce
    bpl $f8f1                                ; $f8cf
    sbc ($ff,x)                              ; $f8d1
    clc                                      ; $f8d3
    bne $f8dc                                ; $f8d4
    jsr $fc93                                ; $f8d6
    sec                                      ; $f8d9
    pla                                      ; $f8da
    pla                                      ; $f8db
    rts                                      ; $f8dc
    bit $dc0c                                ; $f8dd
    bvs $f910                                ; $f8e0
    pha                                      ; $f8e2
    jsr $ed36                                ; $f8e3
    sei                                      ; $f8e6
    pla                                      ; $f8e7
    and #$f0                                 ; $f8e8
    cmp #$e0                                 ; $f8ea
    beq $f90e                                ; $f8ec
    stx $a5                                  ; $f8ee
    ldx #$19                                 ; $f8f0
    lda #$10                                 ; $f8f2
    bit $dd0d                                ; $f8f4
    dex                                      ; $f8f7
    beq $f90c                                ; $f8f8
    bit $dd01                                ; $f8fa
    bit $dd0d                                ; $f8fd
    beq $f8f7                                ; $f900
    asl $dc0c                                ; $f902
    sec                                      ; $f905
    ror $dc0c                                ; $f906
    jsr $f1b8                                ; $f909
    ldx $a5                                  ; $f90c
    cli                                      ; $f90e
    rts                                      ; $f90f
    and #$0f                                 ; $f910
    cmp #$07                                 ; $f912
    bne $f94f                                ; $f914
    lda #$43                                 ; $f916
    bne $f94c                                ; $f918
    jsr $f1b8                                ; $f91a
    txa                                      ; $f91d
    pha                                      ; $f91e
    lda $dc0c                                ; $f91f
    and #$02                                 ; $f922
    bne $f948                                ; $f924
    lda $dd0d                                ; $f926
    lda #$16                                 ; $f929
    jsr $e4ec                                ; $f92b
    ldx #$13                                 ; $f92e
    stx $a5                                  ; $f930
    lda $dd0d                                ; $f932
    and #$10                                 ; $f935
    bne $f948                                ; $f937
    dex                                      ; $f939
    bne $f932                                ; $f93a
    dec $a5                                  ; $f93c
    bne $f932                                ; $f93e
    pla                                      ; $f940
    tax                                      ; $f941
    jsr $f958                                ; $f942
    jmp $ed2e                                ; $f945
    pla                                      ; $f948
    tax                                      ; $f949
    lda #$42                                 ; $f94a
    sta $dc0c                                ; $f94c
    bne $f9b2                                ; $f94f
    bit $dc0c                                ; $f951
    bvs $f958                                ; $f954
    bpl $f96e                                ; $f956
    pha                                      ; $f958
    lda $dc0c                                ; $f959
    and #$02                                 ; $f95c
    sta $dc0c                                ; $f95e
    lda $0296                                ; $f961
    sta $dd03                                ; $f964
    lda $0295                                ; $f967
    sta $dd01                                ; $f96a
    pla                                      ; $f96d
    rts                                      ; $f96e
; =============================================================================
; PARALLEL_TRANSFER_CORE - Core parallel byte send routine
; Entry: $95 = byte to send, X = saved across call
; Exit: C=0 success, C=1 error, A=$80 on timeout
; Uses $DD00 bit 4 for handshake, $DD01 for data
; =============================================================================
    stx $a5        ; Save X register         ; $6ff3
    lda $dc0c      ; Read CIA#1 serial port register ; $6ff5
    bpl $f9bf      ; Branch if bit 7 clear (not in parallel mode) ; $6ff8
    lda $dd00      ; Read CIA#2 port A       ; $6ffa
    bmi $f9b5      ; Abort if DATA IN high (bit 7 set): unexpected bus state ; $6ffd
    and #$ef       ; Clear bit 4 (signal "ready to send") ; $6fff
    sta $dd00                                ; $f97d
    bit $a3        ; Check handshake mode flag ; $7004
    bpl $f995      ; Skip sync wait if not needed ; $7006
; --- Wait for drive acknowledgment (bit 7 high) ---
    bit $dd00      ; Test bit 7              ; $7008
    bpl $f984      ; Loop until drive signals ready ; $700b
    ldx #$1e       ; Timeout counter (30)    ; $700d
    lda $dd00      ; Read port               ; $700f
    bpl $f995      ; Continue if bit 7 went low ; $7012
    dex ; Decrement timeout                  ; $7014
    bne $f98b      ; Loop until timeout      ; $7015
    beq $f9a1      ; Timeout: skip data write ; $7017
; --- Wait for drive ready signal (bit 7 high) ---
    lda $dd00      ; Read port               ; $7019
    bpl $f995      ; Wait for bit 7 high     ; $701c
; --- Send byte via parallel port ---
    ldx $95        ; Get byte to send        ; $701e
    stx $dd01      ; WRITE BYTE TO PARALLEL PORT ; $7020
    ldx #$1e       ; Timeout counter (30)    ; $7023
; --- Signal data ready and wait for acknowledge ---
    ora #$10       ; Set bit 4 (signal "data valid") ; $7025
    sta $dd00                                ; $f9a3
    lda #$03       ; Error code if timeout   ; $702a
    dex ; Decrement timeout counter          ; $702c
    bmi $f9b7      ; Timeout expired: error  ; $702d
    bit $dd00      ; Test bit 7              ; $702f
    bmi $f9a8      ; Wait for bit 7 low (drive acknowledged) ; $7032
; --- Success exit ---
    ldx $a5        ; Restore X register      ; $7034
    clc ; Clear carry (success)              ; $7036
    cli ; Re-enable interrupts               ; $7037
    rts                                      ; $f9b4
; --- Error exit ---
    lda #$80       ; Device not present error ; $7039
    ldx $a5        ; Restore X               ; $703b
    jsr $f951      ; IEC bus cleanup         ; $703d
    jmp $edb2      ; Return with error status ; $7040
    lsr                                    ; $f9bf
    and #$20                                 ; $f9c0
    beq $f9df                                ; $f9c2
    lda $95                                  ; $f9c4
    bcc $f9d3                                ; $f9c6
    ldx #$0a                                 ; $f9c8
    dex                                      ; $f9ca
    cmp $f0b3,x                              ; $f9cb
    bcc $f9ca                                ; $f9ce
    sbc $f19b,x                              ; $f9d0
    jsr $e4ec                                ; $f9d3
    lda #$10                                 ; $f9d6
    bit $dd0d                                ; $f9d8
    beq $f9d8                                ; $f9db
    bne $f9b0                                ; $f9dd
    jmp $ed44                                ; $f9df
    lda #$20                                 ; $f9e2
    sta $0299                                ; $f9e4
    lda $d3                                  ; $f9e7
    cmp $c8                                  ; $f9e9
    beq $fa03                                ; $f9eb
    jsr $f05e                                ; $f9ed
    lda #$01                                 ; $f9f0
    bne $fa0d                                ; $f9f2
    ldx $fa                                  ; $f9f4
    dex                                      ; $f9f6
    lda $0299                                ; $f9f7
    cmp #$20                                 ; $f9fa
    bne $fa01                                ; $f9fc
    dex                                      ; $f9fe
    dex                                      ; $f9ff
    dex                                      ; $fa00
    stx $fa                                  ; $fa01
    jsr $e566                                ; $fa03
    lda #$0b                                 ; $fa06
    jsr $ffd2                                ; $fa08
    lda #$11                                 ; $fa0b
    sta $f7                                  ; $fa0d
    ldx $0299                                ; $fa0f
    cpx #$20                                 ; $fa12
    php                                      ; $fa14
    beq $fa19                                ; $fa15
    ldx #$3a                                 ; $fa17
    jsr $fb97                                ; $fa19
    ldx $f9                                  ; $fa1c
    lda $fa                                  ; $fa1e
    jsr $f894                                ; $fa20
    plp                                      ; $fa23
    beq $fa2e                                ; $fa24
    ldx #$08                                 ; $fa26
    stx $0299                                ; $fa28
    jsr $f187                                ; $fa2b
    ldy #$00                                 ; $fa2e
    jsr $fb9e                                ; $fa30
    lda ($f9),y                              ; $fa33
    jsr $f2a9                                ; $fa35
    iny                                      ; $fa38
    cpy $0299                                ; $fa39
    bne $fa33                                ; $fa3c
    dec $f7                                  ; $fa3e
    beq $fa51                                ; $fa40
    tya                                      ; $fa42
    clc                                      ; $fa43
    adc $f9                                  ; $fa44
    sta $f9                                  ; $fa46
    bcc $fa4c                                ; $fa48
    inc $fa                                  ; $fa4a
    jsr $ffe1                                ; $fa4c
    bne $fa0f                                ; $fa4f
    jmp $f035                                ; $fa51
    jsr $f72c                                ; $fa54
    ldx #$08                                 ; $fa57
    jsr $f26c                                ; $fa59
    lda $f7                                  ; $fa5c
    sta $f9                                  ; $fa5e
    lda #$01                                 ; $fa60
    sta $f7                                  ; $fa62
    lda #$02                                 ; $fa64
    sta $d3                                  ; $fa66
    php                                      ; $fa68
    !byte $d0,$b1                            ; $70ed (bne $709f)
    cmp #$07                                 ; $fa6b
    bne $fa7f                                ; $fa6d
    tya                                      ; $fa6f
    adc #$13                                 ; $fa70
    tay                                      ; $fa72
    cmp $d5                                  ; $fa73
    bcc $fa7c                                ; $fa75
    beq $fa7c                                ; $fa77
    jmp $e7b6                                ; $fa79
    jmp $e797                                ; $fa7c
    cmp #$0c                                 ; $fa7f
    bne $fa88                                ; $fa81
    jsr $ea04                                ; $fa83
    bmi $faba                                ; $fa86
    cmp #$02                                 ; $fa88
    bne $fa97                                ; $fa8a
    lda #$00                                 ; $fa8c
    sta $d3                                  ; $fa8e
    ldy #$18                                 ; $fa90
    jsr $e56a                                ; $fa92
    bmi $faba                                ; $fa95
    cmp #$0b                                 ; $fa97
    bne $faae                                ; $fa99
    jsr $ea24                                ; $fa9b
    lda #$20                                 ; $fa9e
    sta ($d1),y                              ; $faa0
    jsr $e4da                                ; $faa2
    iny                                      ; $faa5
    cpy $d5                                  ; $faa6
    bcc $fa9e                                ; $faa8
    beq $fa9e                                ; $faaa
    bcs $faba                                ; $faac
    cmp #$01                                 ; $faae
    bne $fabd                                ; $fab0
    lda $028a                                ; $fab2
    eor #$80                                 ; $fab5
    sta $028a                                ; $fab7
    jmp $e6ae                                ; $faba
    jmp $ec44                                ; $fabd
    sta $f7                                  ; $fac0
    stx $f8                                  ; $fac2
    lda #$31                                 ; $fac4
    sta $f9                                  ; $fac6
    ldx #$04                                 ; $fac8
    dec $f9                                  ; $faca
    lda #$2f                                 ; $facc
    sta $fa                                  ; $face
    sec                                      ; $fad0
    lda $f8                                  ; $fad1
    sbc $f8cb,x                              ; $fad3
    sta $f8                                  ; $fad6
    lda $f7                                  ; $fad8
    sbc $f196,x                              ; $fada
    sta $f7                                  ; $fadd
    inc $fa                                  ; $fadf
    bcs $fad1                                ; $fae1
    lda $f8                                  ; $fae3
    adc $f8cb,x                              ; $fae5
    sta $f8                                  ; $fae8
    lda $f7                                  ; $faea
    adc $f196,x                              ; $faec
    sta $f7                                  ; $faef
    lda $fa                                  ; $faf1
    cmp $f9                                  ; $faf3
    beq $fafc                                ; $faf5
    jsr $ffd2                                ; $faf7
    dec $f9                                  ; $fafa
    dex                                      ; $fafc
    beq $faca                                ; $fafd
    bpl $facc                                ; $faff
    rts                                      ; $fb01
    adc #$10                                 ; $fb02
    tax                                      ; $fb04
    txs                                      ; $fb05
    lsr $dc00                                ; $fb06
    ldx $dc01                                ; $fb09
    inx                                      ; $fb0c
    bne $fb09                                ; $fb0d
    dex                                      ; $fb0f
    rts                                      ; $fb10
    sta $028c                                ; $fb11
    sty $c5                                  ; $fb14
    cpx #$fd                                 ; $fb16
    beq $fb2e                                ; $fb18
    cpx #$fe                                 ; $fb1a
    bne $fb2d                                ; $fb1c
    ldy #$0e                                 ; $fb1e
    lda $fb02,y                              ; $fb20
    pha                                      ; $fb23
    dey                                      ; $fb24
    bpl $fb20                                ; $fb25
    tsx                                      ; $fb27
    lda #$01                                 ; $fb28
    pha                                      ; $fb2a
    txa                                      ; $fb2b
    pha                                      ; $fb2c
    rts                                      ; $fb2d
    jsr $ed0f                                ; $fb2e
    lda $d018                                ; $fb31
    and #$02                                 ; $fb34
    beq $fb3a                                ; $fb36
    lda #$07                                 ; $fb38
    ora #$60                                 ; $fb3a
    jsr $edb9                                ; $fb3c
    lda $0288                                ; $fb3f
    sta $f8                                  ; $fb42
    lda #$00                                 ; $fb44
    sta $f7                                  ; $fb46
    sta $dc00                                ; $fb48
    ldx #$19                                 ; $fb4b
    ldy #$00                                 ; $fb4d
    lda #$0d                                 ; $fb4f
    jsr $eddd                                ; $fb51
    dex                                      ; $fb54
    bmi $fb5e                                ; $fb55
    bit $dc01                                ; $fb57
    bmi $fb61                                ; $fb5a
    ldx #$ff                                 ; $fb5c
    jmp $edfe                                ; $fb5e
    lda ($f7),y                              ; $fb61
    sta $f9                                  ; $fb63
    and #$3f                                 ; $fb65
    asl $f9                                  ; $fb67
    bit $f9                                  ; $fb69
    bpl $fb6f                                ; $fb6b
    ora #$80                                 ; $fb6d
    bvs $fb73                                ; $fb6f
    ora #$40                                 ; $fb71
    jsr $eddd                                ; $fb73
    iny                                      ; $fb76
    cpy #$28                                 ; $fb77
    bne $fb61                                ; $fb79
    tya                                      ; $fb7b
    clc                                      ; $fb7c
    adc $f7                                  ; $fb7d
    sta $f7                                  ; $fb7f
    bcc $fb4d                                ; $fb81
    inc $f8                                  ; $fb83
    bne $fb4d                                ; $fb85
    jsr $1c20                                ; $fb87
    inc $bc4c,x                              ; $fb8a
    inc $c2a5,x                              ; $fb8d
    sta $ad                                  ; $fb90
    lda $c1                                  ; $fb92
    sta $ac                                  ; $fb94
    rts                                      ; $fb96
    jsr $fec2                                ; $fb97
    txa                                      ; $fb9a
    jmp $ffd2                                ; $fb9b
    lda #$20                                 ; $fb9e
    bit $0da9                                ; $fba0
    jmp $ffd2                                ; $fba3
    jsr $fba1                                ; $fba6
    ldy $b7                                  ; $fba9
    beq $fbca                                ; $fbab
    ldy #$00                                 ; $fbad
    lda ($bb),y                              ; $fbaf
    cmp #$30                                 ; $fbb1
    bcc $fbc0                                ; $fbb3
    cmp #$3a                                 ; $fbb5
    bcs $fbc4                                ; $fbb7
    sbc #$2f                                 ; $fbb9
    sta $0294                                ; $fbbb
    clc                                      ; $fbbe
    rts                                      ; $fbbf
    cmp #$24                                 ; $fbc0
    beq $fbe8                                ; $fbc2
    jsr $f676                                ; $fbc4
    jsr $f3fa                                ; $fbc7
    lda $b9                                  ; $fbca
    beq $fbbe                                ; $fbcc
    jsr $f676                                ; $fbce
    lda $ba                                  ; $fbd1
    jsr $ed09                                ; $fbd3
    lda #$6f                                 ; $fbd6
    jsr $edc7                                ; $fbd8
    jsr $ee13                                ; $fbdb
    jsr $ffd2                                ; $fbde
    bit $90                                  ; $fbe1
    bvc $fbdb                                ; $fbe3
    jmp $edef                                ; $fbe5
    sty $90                                  ; $fbe8
    ldx $b9                                  ; $fbea
    sty $b9                                  ; $fbec
    jsr $f3d5                                ; $fbee
    lda $ba                                  ; $fbf1
    jsr $ed09                                ; $fbf3
    lda #$60                                 ; $fbf6
    jsr $edc7                                ; $fbf8
    txa                                      ; $fbfb
    tay                                      ; $fbfc
    ldx #$04                                 ; $fbfd
    bit $02a2                                ; $fbff
    jsr $ee13                                ; $fc02
    lda $90                                  ; $fc05
    bne $fc24                                ; $fc07
    dex                                      ; $fc09
    bne $fc02                                ; $fc0a
    jsr $ee13                                ; $fc0c
    tax                                      ; $fc0f
    jsr $ee13                                ; $fc10
    jsr $fac0                                ; $fc13
    lda #$20                                 ; $fc16
    jsr $ffd2                                ; $fc18
    jsr $ee13                                ; $fc1b
    beq $fc34                                ; $fc1e
    ldx $90                                  ; $fc20
    beq $fc18                                ; $fc22
    jsr $f642                                ; $fc24
    sty $b9                                  ; $fc27
    lda $90                                  ; $fc29
    and #$bf                                 ; $fc2b
    !byte $f0,$8f                            ; $72b1 (beq $7241)
    jsr $fba1                                ; $fc2f
    !byte $d0,$96                            ; $72b6 (bne $724d)
    jsr $fba1                                ; $fc34
    jsr $ffe1                                ; $fc37
    bne $fc00                                ; $fc3a
    jmp $f633                                ; $fc3c
    sta $89                                  ; $fc3f
    stx $8a                                  ; $fc41
    !byte $87                                ; $72c7 (undefined opcode)
    !byte $8b                                ; $72c8 (undefined opcode)
    dey                                      ; $fc45
    sty $8280                                ; $fc46
    sty $8f                                  ; $fc49
    eor #$24                                 ; $fc4b
    beq $fc55                                ; $fc4d
    jsr $ad8a                                ; $fc4f
    jmp $b7f7                                ; $fc52
    sta $15                                  ; $fc55
    sta $14                                  ; $fc57
    jsr $0073                                ; $fc59
    beq $fc8f                                ; $fc5c
    bcc $fc66                                ; $fc5e
    cmp #$41                                 ; $fc60
    bcc $fc8f                                ; $fc62
    sbc #$08                                 ; $fc64
    sbc #$2f                                 ; $fc66
    cmp #$10                                 ; $fc68
    bcs $fc71                                ; $fc6a
    jsr $fc80                                ; $fc6c
    bcc $fc59                                ; $fc6f
    cmp #$5f                                 ; $fc71
    bne $fc8f                                ; $fc73
    lda #$0d                                 ; $fc75
    jsr $fc80                                ; $fc77
    sta $15                                  ; $fc7a
    lda #$ef                                 ; $fc7c
    bne $fc57                                ; $fc7e
    ldx #$03                                 ; $fc80
    asl $14                                  ; $fc82
    rol $15                                  ; $fc84
    bcs $fc90                                ; $fc86
    dex                                      ; $fc88
    bpl $fc82                                ; $fc89
    ora $14                                  ; $fc8b
    sta $14                                  ; $fc8d
    rts                                      ; $fc8f
    jmp $b248                                ; $fc90
    php                                      ; $fc93
    sei                                      ; $fc94
    lda $d011                                ; $fc95
    ora #$10                                 ; $fc98
    sta $d011                                ; $fc9a
    jsr $fcca                                ; $fc9d
    lda #$7f                                 ; $fca0
    sta $dc0d                                ; $fca2
    jsr $fddd                                ; $fca5
    plp                                      ; $fca8
    rts                                      ; $fca9
    jsr $f05e                                ; $fcaa
    jsr $f1df                                ; $fcad
    clc                                      ; $fcb0
    tay                                      ; $fcb1
    dey                                      ; $fcb2
    bmi $fcbb                                ; $fcb3
    lda ($bb),y                              ; $fcb5
    sta ($f9),y                              ; $fcb7
    bcc $fcb2                                ; $fcb9
    lda $f9                                  ; $fcbb
    adc $b7                                  ; $fcbd
    tax                                      ; $fcbf
    lda $fa                                  ; $fcc0
    adc #$00                                 ; $fcc2
    jsr $f894                                ; $fcc4
    jmp $f035                                ; $fcc7
    lda $01                                  ; $fcca
    ora #$20                                 ; $fccc
    sta $01                                  ; $fcce
    rts                                      ; $fcd0
    sec                                      ; $fcd1
    lda $ac                                  ; $fcd2
    sbc $ae                                  ; $fcd4
    lda $ad                                  ; $fcd6
    sbc $af                                  ; $fcd8
    rts                                      ; $fcda
    inc $ac                                  ; $fcdb
    bne $fce1                                ; $fcdd
    inc $ad                                  ; $fcdf
    rts                                      ; $fce1
    ldx #$ff                                 ; $fce2
    sei                                      ; $fce4
    txs                                      ; $fce5
    cld                                      ; $fce6
    jsr $fe72                                ; $fce7
    bne $fcef                                ; $fcea
    jmp ($8000)                              ; $fcec
    stx $d016                                ; $fcef
    jsr $fda3                                ; $fcf2
    jsr $fd50                                ; $fcf5
    jsr $fd15                                ; $fcf8
    jsr $ff5b                                ; $fcfb
    cli                                      ; $fcfe
    jmp ($a000)                              ; $fcff
    ldx #$05                                 ; $fd02
    lda $fd0f,x                              ; $fd04
    cmp $8003,x                              ; $fd07
    bne $fd0f                                ; $fd0a
    dex                                      ; $fd0c
    bne $fd04                                ; $fd0d
    rts                                      ; $fd0f
    !byte $c3                                ; $7394 (undefined opcode)
    !byte $c2                                ; $7395 (undefined opcode)
    cmp $3038                                ; $fd12
    ldx #$30                                 ; $fd15
    ldy #$fd                                 ; $fd17
    clc                                      ; $fd19
    stx $c3                                  ; $fd1a
    sty $c4                                  ; $fd1c
    ldy #$1f                                 ; $fd1e
    lda ($c3),y                              ; $fd20
    bcc $fd29                                ; $fd22
    lda $0314,y                              ; $fd24
    sta ($c3),y                              ; $fd27
    sta $0314,y                              ; $fd29
    dey                                      ; $fd2c
    bpl $fd20                                ; $fd2d
    rts                                      ; $fd2f
    and ($ea),y                              ; $fd30
    ror $fe                                  ; $fd32
    !byte $47                                ; $73b8 (undefined opcode)
    inc $f34a,x                              ; $fd35
    sta ($f2),y                              ; $fd38
    asl $50f2                                ; $fd3a
    !byte $f2                                ; $73c1 (undefined opcode)
    !byte $33                                ; $73c2 (undefined opcode)
    !byte $f3                                ; $73c3 (undefined opcode)
    !byte $57                                ; $73c4 (undefined opcode)
    sbc ($ca),y                              ; $fd41
    sbc ($ed),y                              ; $fd43
    inc $3e,x                                ; $fd45
    sbc ($2f),y                              ; $fd47
    !byte $f3                                ; $73cd (undefined opcode)
    ror $fe                                  ; $fd4a
    lda $f4                                  ; $fd4c
    sbc $a9f5                                ; $fd4e
    brk                                      ; $fd51
    tay                                      ; $fd52
    sta $0002,y                              ; $fd53
    sta $0200,y                              ; $fd56
    sta $023c,y                              ; $fd59
    iny                                      ; $fd5c
    bne $fd53                                ; $fd5d
    ldx #$3c                                 ; $fd5f
    ldy #$03                                 ; $fd61
    stx $b2                                  ; $fd63
    sty $b3                                  ; $fd65
    tay                                      ; $fd67
    sta $dc0c                                ; $fd68
    lda #$80                                 ; $fd6b
    ldx #$20                                 ; $fd6d
    sta $c2                                  ; $fd6f
    lda ($c1),y                              ; $fd71
    eor #$ff                                 ; $fd73
    sta ($c1),y                              ; $fd75
    cmp ($c1),y                              ; $fd77
    php                                      ; $fd79
    eor #$ff                                 ; $fd7a
    sta ($c1),y                              ; $fd7c
    plp                                      ; $fd7e
    bne $fd89                                ; $fd7f
    iny                                      ; $fd81
    bne $fd71                                ; $fd82
    inc $c2                                  ; $fd84
    dex                                      ; $fd86
    bne $fd71                                ; $fd87
    tya                                      ; $fd89
    tax                                      ; $fd8a
    ldy $c2                                  ; $fd8b
    clc                                      ; $fd8d
    jsr $fe2d                                ; $fd8e
    lda #$08                                 ; $fd91
    sta $0282                                ; $fd93
    lda #$04                                 ; $fd96
    sta $0288                                ; $fd98
    rts                                      ; $fd9b
    cpx $c9                                  ; $fd9c
    beq $fd9b                                ; $fd9e
    jmp $e6ed                                ; $fda0
    lda #$7f                                 ; $fda3
    sta $dc0d                                ; $fda5
    sta $dd0d                                ; $fda8
    sta $dc00                                ; $fdab
    lda #$08                                 ; $fdae
    sta $dc0e                                ; $fdb0
    sta $dd0e                                ; $fdb3
    sta $dc0f                                ; $fdb6
    sta $dd0f                                ; $fdb9
    ldx #$00                                 ; $fdbc
    stx $dc03                                ; $fdbe
    stx $dd03                                ; $fdc1
    stx $d418                                ; $fdc4
    dex                                      ; $fdc7
    stx $dc02                                ; $fdc8
    lda #$07                                 ; $fdcb
    sta $dd00                                ; $fdcd
    lda #$3f                                 ; $fdd0
    sta $dd02                                ; $fdd2
    lda #$e7                                 ; $fdd5
    sta $01                                  ; $fdd7
    lda #$2f                                 ; $fdd9
    sta $00                                  ; $fddb
    lda $02a6                                ; $fddd
    beq $fdec                                ; $fde0
    lda #$25                                 ; $fde2
    sta $dc04                                ; $fde4
    lda #$40                                 ; $fde7
    jmp $fdf3                                ; $fde9
    lda #$95                                 ; $fdec
    sta $dc04                                ; $fdee
    lda #$42                                 ; $fdf1
    sta $dc05                                ; $fdf3
    jmp $ff6e                                ; $fdf6
    sta $b7                                  ; $fdf9
    stx $bb                                  ; $fdfb
    sty $bc                                  ; $fdfd
    rts                                      ; $fdff
    sta $b8                                  ; $fe00
    stx $ba                                  ; $fe02
    sty $b9                                  ; $fe04
    rts                                      ; $fe06
    lda $ba                                  ; $fe07
    cmp #$02                                 ; $fe09
    bne $fe1a                                ; $fe0b
    lda $0297                                ; $fe0d
    pha                                      ; $fe10
    lda #$00                                 ; $fe11
    sta $0297                                ; $fe13
    pla                                      ; $fe16
    rts                                      ; $fe17
    sta $9d                                  ; $fe18
    lda $90                                  ; $fe1a
    ora $90                                  ; $fe1c
    sta $90                                  ; $fe1e
    rts                                      ; $fe20
    sta $0285                                ; $fe21
    rts                                      ; $fe24
    bcc $fe2d                                ; $fe25
    ldx $0283                                ; $fe27
    ldy $0284                                ; $fe2a
    stx $0283                                ; $fe2d
    sty $0284                                ; $fe30
    rts                                      ; $fe33
    bcc $fe3c                                ; $fe34
    ldx $0281                                ; $fe36
    ldy $0282                                ; $fe39
    stx $0281                                ; $fe3c
    sty $0282                                ; $fe3f
    rts                                      ; $fe42
    sei                                      ; $fe43
    jmp ($0318)                              ; $fe44
    pha                                      ; $fe47
    txa                                      ; $fe48
    pha                                      ; $fe49
    tya                                      ; $fe4a
    pha                                      ; $fe4b
    lda #$7f                                 ; $fe4c
    sta $dd0d                                ; $fe4e
    ldy $dd0d                                ; $fe51
    bmi $feb6                                ; $fe54
    jsr $fd02                                ; $fe56
    bne $fe5e                                ; $fe59
    jmp ($8002)                              ; $fe5b
    jsr $f6bc                                ; $fe5e
    jsr $fe7e                                ; $fe61
    bne $feb6                                ; $fe64
    jsr $fd15                                ; $fe66
    jsr $fda3                                ; $fe69
    jsr $e518                                ; $fe6c
    jmp ($a002)                              ; $fe6f
    jsr $fda3                                ; $fe72
    lda $dc01                                ; $fe75
    jsr $fe81                                ; $fe78
    jmp $fd02                                ; $fe7b
    jsr $ffe1                                ; $fe7e
    rol                                    ; $fe81
    bcc $fe66                                ; $fe82
    rol                                    ; $fe84
    bcc $fe69                                ; $fe85
    rol                                    ; $fe87
    rol                                    ; $fe88
    bcs $fe8e                                ; $fe89
    jmp $fcef                                ; $fe8b
    rol                                    ; $fe8e
    rol                                    ; $fe8f
    bcs $fea3                                ; $fe90
    jsr $fda3                                ; $fe92
    jsr $e518                                ; $fe95
    tsx                                      ; $fe98
    inx                                      ; $fe99
    inx                                      ; $fe9a
    txs                                      ; $fe9b
    cpx #$fa                                 ; $fe9c
    bcs $feb4                                ; $fe9e
    jmp $f01d                                ; $fea0
    rol                                    ; $fea3
    bcs $feb5                                ; $fea4
    bmi $feb5                                ; $fea6
    ldx #$17                                 ; $fea8
    lda $e4c2,x                              ; $feaa
    sta $e8,x                                ; $fead
    dex                                      ; $feaf
    bpl $feaa                                ; $feb0
    jmp $00e8                                ; $feb2
    rts                                      ; $feb5
    lda $02a1                                ; $feb6
    sta $dd0d                                ; $feb9
    pla                                      ; $febc
    tay                                      ; $febd
    pla                                      ; $febe
    tax                                      ; $febf
    pla                                      ; $fec0
    rti                                      ; $fec1
    jsr $fba1                                ; $fec2
    lda #$2e                                 ; $fec5
    jmp $ffd2                                ; $fec7
    cmp #$04                                 ; $feca
    bne $fedf                                ; $fecc
    lda #$01                                 ; $fece
    ldx #$cd                                 ; $fed0
    ldy #$eb                                 ; $fed2
    jsr $ffbd                                ; $fed4
    ldx #$08                                 ; $fed7
    jsr $e101                                ; $fed9
    jmp $fba6                                ; $fedc
    tya                                      ; $fedf
    beq $fed2                                ; $fee0
    eor #$18                                 ; $fee2
    bne $fef7                                ; $fee4
    ldy #$06                                 ; $fee6
    sta $0293,y                              ; $fee8
    dey                                      ; $feeb
    bpl $fee8                                ; $feec
    ldy #$cc                                 ; $feee
    sta $0333,y                              ; $fef0
    dey                                      ; $fef3
    bne $fef0                                ; $fef4
    rts                                      ; $fef6
    cpy #$0f                                 ; $fef7
    bne $ff12                                ; $fef9
    ldx $0293                                ; $fefb
    bmi $fef6                                ; $fefe
    ldy $d3                                  ; $ff00
    dey                                      ; $ff02
    bmi $fef6                                ; $ff03
    lda ($d1),y                              ; $ff05
    sta $0380,x                              ; $ff07
    inc $0293                                ; $ff0a
    lda #$14                                 ; $ff0d
    jmp $e716                                ; $ff0f
    cpy #$10                                 ; $ff12
    bne $ff2e                                ; $ff14
    ldx $0293                                ; $ff16
    beq $fef6                                ; $ff19
    lda #$94                                 ; $ff1b
    jsr $e716                                ; $ff1d
    lda $d8                                  ; $ff20
    beq $fef6                                ; $ff22
    dex                                      ; $ff24
    stx $0293                                ; $ff25
    lda $0380,x                              ; $ff28
    jmp $e69f                                ; $ff2b
    cpy #$16                                 ; $ff2e
    !byte $d0,$c4                            ; $75b4 (bne $7579)
    lda $e535                                ; $ff32
    sta $0286                                ; $ff35
    jmp $e5a0                                ; $ff38
; =============================================================================
; WAIT_PARALLEL_HANDSHAKE - Wait for drive to signal via FLAG or bit 4
; Exit: Returns when either FLAG interrupt or $DD00 bit 4 goes high
; =============================================================================
    lda #$10       ; Bit mask for FLAG (bit 4 of ICR) ; $75bf
    bit $dd0d      ; Check CIA#2 interrupt control register ; $75c1
    bne $ff47      ; Exit if FLAG interrupt occurred ; $75c4
    bit $dd00      ; Check bit 4 of port A   ; $75c6
    bpl $ff3d      ; Loop until bit 7 high (drive signaled) ; $75c9
    rts                                      ; $ff47
    pha                                      ; $ff48
    txa                                      ; $ff49
    pha                                      ; $ff4a
    tya                                      ; $ff4b
    pha                                      ; $ff4c
    tsx                                      ; $ff4d
    lda $0104,x                              ; $ff4e
    and #$10                                 ; $ff51
    beq $ff58                                ; $ff53
    jmp $f01d                                ; $ff55
    jmp ($0314)                              ; $ff58
    jsr $e518                                ; $ff5b
    lda $d012                                ; $ff5e
    bne $ff5e                                ; $ff61
    lda $d019                                ; $ff63
    and #$01                                 ; $ff66
    sta $02a6                                ; $ff68
    jmp $fddd                                ; $ff6b
    lda #$81                                 ; $ff6e
    sta $dc0d                                ; $ff70
    lda $dc0e                                ; $ff73
    and #$80                                 ; $ff76
    ora #$11                                 ; $ff78
    sta $dc0e                                ; $ff7a
    jmp $ee8e                                ; $ff7d
    !byte $03                                ; $7604 (undefined opcode)
    jmp $ff5b                                ; $ff81
    jmp $fda3                                ; $ff84
    jmp $fd50                                ; $ff87
    jmp $fd15                                ; $ff8a
    jmp $fd1a                                ; $ff8d
    jmp $fe18                                ; $ff90
    jmp $edb9                                ; $ff93
    jmp $edc7                                ; $ff96
    jmp $fe25                                ; $ff99
    jmp $fe34                                ; $ff9c
    jmp $ea87                                ; $ff9f
    jmp $fe21                                ; $ffa2
    jmp $ee13                                ; $ffa5
    jmp $eddd                                ; $ffa8
    jmp $edef                                ; $ffab
    jmp $edfe                                ; $ffae
    jmp $ed0c                                ; $ffb1
    jmp $ed09                                ; $ffb4
    jmp $fe07                                ; $ffb7
    jmp $fe00                                ; $ffba
    jmp $fdf9                                ; $ffbd
    jmp ($031a)                              ; $ffc0
    jmp ($031c)                              ; $ffc3
    jmp ($031e)                              ; $ffc6
    jmp ($0320)                              ; $ffc9
    jmp ($0322)                              ; $ffcc
    jmp ($0324)                              ; $ffcf
    jmp ($0326)                              ; $ffd2
    jmp $f49e                                ; $ffd5
    jmp $f5dd                                ; $ffd8
    jmp $f6e4                                ; $ffdb
    jmp $f6dd                                ; $ffde
    jmp ($0328)                              ; $ffe1
    jmp ($032a)                              ; $ffe4
    jmp ($032c)                              ; $ffe7
    jmp $f69b                                ; $ffea
    jmp $e505                                ; $ffed
    jmp $e50a                                ; $fff0
    jmp $e500                                ; $fff3
    !byte $52                                ; $767a (undefined opcode)
    !byte $52                                ; $767b (undefined opcode)
    !byte $42                                ; $767c (undefined opcode)
    eor $fe43,y                              ; $fff9
    !byte $e2                                ; $7680 (undefined opcode)
    !byte $fc                                ; $7681 (undefined opcode)
    pha                                      ; $fffe
    !byte $ff                                ; $7683 (undefined opcode)
