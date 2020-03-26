#importonce

#import "labels.asm"
#import "functions.asm"
#import "vic.asm"

/*
    c64 colour codes
    https://sta.c64.org/cbm64col.html
*/

* = $2200 "Screen Code"

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

    // calculate 1st row and last row and column
    txa
    sta start // first row && column
    sta counter

    // flip it negative
    //eor #$7F
    // add 25
    //adc #25

    lda #24
    sta lastRow // last row
    //adc #15
    lda #40
    sta lastColumn // last column

    ldx #0//(lastRow * 40) + (start)

LoopXHigh:
    // paint full rows with an inc of what's there

    inc SCREEN_BASE, x
    inc $d800, x
    inc counter
    inx
    // compare last column with counter
    cmp counter
    bne LoopXHigh


    // set up for bottom row
    lda start
    sta counter
    lda lastColumn
    ldx #0

LoopXLow:

    inc $07c0, x
    inc $d800 + 960, x
    inc counter
    inx
    // compare last column with counter
    cmp counter
    bne LoopXLow

    // walk in between rows paintig first and last column with an inc

    rts

    // local vars
    start: .byte $ff
    lastColumn: .byte $ff
    lastRow: .byte $ff
    counter: .byte $ff

    .label screenFirst = $0400
    .label colourFirst = $d800
    .label screenLast =  1984//$07c0   // $0400 + (40 * 24)
    colourLast: .word $d800 + (40 * 24)

}

/* utility unerapping the macro because it's re used ll ove rhe place in this format
*/
FullscreenBorder:
    nastyBorder(0, 0);
    rts

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
