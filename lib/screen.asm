#importonce

#import "labels.asm"
#import "functions.asm"
#import "vic.asm"

/*
    c64 colour codes
    https://sta.c64.org/cbm64col.html
*/

* = $2200 "Screen Code"

// lookup for calculating screen row offset
table40:.fillword 24, i * 40

SCREEN: {
    BackgroundColour: 
        .byte BLACK
    BorderColour: 
        .byte LIGHT_BLUE

    Clear: {
        // clear the screen
        fill1kbAddress(SCREEN_BASE, $20);
        rts
    }
}

// size is in X
AnimatedBorder: {

    // store the x register
    stx startPosition
    stx rowCounter

    // set up our initial screen memory base
    resetWord(screenRowBase);
    addWord(SCREEN_BASE, screenRowBase);
    resetWord(colourRowBase);
    addWord(CHARSET_COLOUR, colourRowBase);

    /* 
        first we multiply x by 2 to get the correct table index
        
        then calulate the row memory offset, based on [rowCounter * 40]
        get the address from our table based on start
        store it in the offset mem address.
        row counter is in x at this point
    */
    txa
    asl
    tax

    lda table40, x
    sta offset
    inx

    lda table40, x
    sta offset + 1
    addWordFromAddress(offset, screenRowBase);
    addWordFromAddress(offset, colourRowBase);
    // initial screen memory and colour bases are set
 
    // calc last row and last column
    lda #25
    sbc startPosition
    sta lastRow

    lda #39
    sbc startPosition
    sta lastColumn

    // set up the initial row
    ldy rowCounter

    NewRow:

        // reset counters for a new row
        ldx startPosition
        stx columnCounter

        // check which row we'e on
        cpy startPosition
        beq FullRow
        cpy lastRow
        bne PartialRow
        jmp FullRow

    PartialRow:
            // paint the first char by incrementing the address
            smcWord(screenRowBase, smc1);
            smcWord(colourRowBase, smc2);
        smc1:
            inc $dead, x
        smc2:
            inc $beef, x

            smcWord(screenRowBase, smc3);
            smcWord(colourRowBase, smc4);
            ldx lastColumn
        smc3:
            inc $dead, x
        smc4:
            inc $beef, x
            jmp EndOfRow

    FullRow:
            // self modifying code
            smcWord(screenRowBase, smc5);
            smcWord(colourRowBase, smc6);

    FullRowLoop:
        smc5:
            inc $dead, x
        smc6:
            inc $beef, x

        cpx lastColumn
        beq EndOfRow
        inx
        jmp FullRowLoop

    EndOfRow:
        // calculate the next screen row base (SCREEN_BASE + offset)
        addWord(40, screenRowBase);
        addWord(40, colourRowBase);

        // compare rowCounter w/ lastRow
        cpy lastRow
        beq Done
        inc rowCounter
        ldy rowCounter
        jmp NewRow

    Done:

        rts

    // local vars
    rowCounter: .byte $ff
    columnCounter: .byte $ff

    startPosition: .byte $ff
    lastRow: .byte $ff
    lastColumn: .byte $ff

    offset: .word $ffff
    screenRowBase: .word $ffff
    colourRowBase: .word $ffff
}

/* 
    utility unwrapping the macro because it's re-used all over the place in this fullscreen format
*/
/*
FullscreenBorder:
    nastyBorder(0, 0);
    rts
*/
/*
    simple border scroll, with offset
*/
.macro nastyBorder(startX, startY) {

    .var endX = 40 - startX
    .var sizeX = 40 - startX
    .var endY = 25 - startY
    .var sizeY = endY - startY

    .for (var y = startY; y < endY; y++) {
        .if (y == startY || y == endY - 1) {
            // top or bottom row is full
            .for (var x = startX; x < sizeX; x++) {
                inc SCREEN_BASE + (y * 40) + x
                inc $d800 + (y * 40) + x
            }
        } else {
            // just left and right borders
            inc SCREEN_BASE + (y * 40) + startY
            inc SCREEN_BASE + (y * 40) + 39 - startY
            inc $d800 + (y * 40) + startY
            inc $d800 + (y * 40) + 39 - startY
        }
    }
}

.macro printCenter(text, y) {

    // start position
    .var charOffset = ((y * 40) + (text.size() / 2 + 20 - text.size()));
    .var screenStart = SCREEN_BASE + charOffset;
    .var colourStart = CHARSET_COLOUR + charOffset;
    // offset counter
    ldy #00
    // text colour
    ldx VIC_TEXT_COLOUR

    LOOP:
        // load next chat based on y offset
        lda Data, y
        // null terminate means end
        beq End
        // draw the next character
        sta screenStart, y
        // set the colour
        txa
        sta colourStart, y
        // increment the counter
        iny
        jmp LOOP

    Data:
        // null terminate the original message
        .text text
        .byte 0

    End:

}
.macro printAbs(text, x, y) {

    // start position
    .var start = SCREEN_BASE + ((y * 40) + x)
    ldx #00
    // clear y
    ldy #00
    LOOP:
        lda Data, y
        beq End
        // draw the next character
        sta start, x
        iny
        inx
        jmp LOOP

    Data:
        // null terminate the original message
        .text text
        .byte 0

    End:

}

.macro setBorderColour(colour) {
    ldx #colour;
    stx VIC_BORDER_COLOUR;
}
.macro setBackgroundColour(colour) {
    ldx #colour;
    stx VIC_BACKGROUND_COLOUR;
}
// takes a direct mode value
.macro setTextColour(colour) {
    ldx #colour;
    stx VIC_TEXT_COLOUR;
}

#if HAS_KERNAL_ROM
.macro DrawText( msg ) {
    DrawTextPos(msg, 0, 0)
}
.macro DrawTextPos(msg, x, y) {

    // positional code first, x & y coords, in reverse registers
    ldy #x
    ldx #y

    //bounds check and go to error handler if out of range
    clc
    cpy #$28
    cpx #$19
    bcs Illegal
    clc

    // call the plot routine to move to x/y
    jsr KROUTINES.PLOT

    // load zero in to y
    ldy #$00
    Start:
        // load string into accumulator, offset by y
        lda Data, y
        // end of string test
        beq End
        // print the char in the acc
        jsr $ffd2
        // inc y
        iny
        // go round again
        jmp Start

    Data:
        // null terminate the original message
        .text msg
        .byte 0
    
    Illegal:
        // something

    End:

}
#endif
