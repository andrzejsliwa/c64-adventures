#importonce

#import "functions.asm"

.macro scoreSetup(scoreRegister, displayAddress) {

@resetScore:

    lda #$ff
    sta cache
    sta cache + 1
    sta value

    lda #00
    sta scoreRegister
    sta scoreRegister + 1

    // reset the result bytes
    ldx #05
    !:
        sta result, x
        dex
        bmi !-

    rts

printScore:
    ldx #05
    ldy #00
l1:
    lda result, x
/*
    // skip leading zeroes...
    bne l2
    dex
    bne l1
*/
l2:
    lda result, x
    // petscii the value
    ora #$30
    // print it
    sta displayAddress, y
    iny
    dex
    bpl l2
    rts

@addToScore:
    // add the new points to existing score
    stx value
    clc
    lda scoreRegister
    adc value
    sta scoreRegister
    bcc Done
        // rollover
        inc scoreRegister + 1
    Done:

    // cache the new score
    lda scoreRegister
    sta cache
    lda scoreRegister + 1
    sta cache + 1

    // reset x
    ldx #01
l3:
    jsr div10
    sta result, x
    inx
    cpx #10
    bne l3

    // and print it
    jsr printScore
    rts

div10:
    ldy #16
    lda #00
    clc
l4:
    rol
    cmp #10
    bcc skip
    sbc #10
skip:
    rol cache
    rol cache + 1
    dey
    bpl l4
    rts

value:  .byte $ff
result: .byte 0, 0, 0, 0, 0, 0
cache:  .word $ffff

}