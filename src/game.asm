#importonce

#import "../lib/screen.asm"
#import "../lib/input.asm"
#import "state.asm"

/* sets us up for a new game */
GameInit: {
    stateTransitioned();
    lda #00
    sta STATE.level
    sta STATE.score
    lda #03
    sta STATE.lives
    transitionState(GameStateNewLevel);
}

/* sets us up for a new level */
NewLevel: {

    nastyBorder($09, $09);

    // check this is first time here
    lda STATE.entered
    cmp #StateEntered
    beq LEVEL_SETUP

    // do nothing for 30 frames
    inc STATE.divider
    lda STATE.divider
    cmp #$1d
    beq FRAME
    rts

    // every 30 frames we hit here
    FRAME:
        // reset divider
        lda #$00
        sta STATE.divider
        // increment offset
        inc STATE.temp1
        // check if we're finished animating
        lda STATE.temp1
        cmp #$0a
        beq START_GAME
        jmp LEVEL_DRAW

    LEVEL_SETUP:
        // reset state
        stateTransitioned();
        // increment our level counter
        inc STATE.level
        jmp LEVEL_DRAW

    START_GAME:

        transitionState(GameStatePlaying);
        rts

    LEVEL_DRAW:

        jsr SCREEN.Clear
        setTextColour(WHITE);
        printCenter(@"gET rEADY pLAYER 1", 11);
        .var level = -1
        lda STATE.level
        sta level
        printCenter("lEVEL " + toIntString(level), 13);
        //nastyBorder(STATE.temp1, STATE.temp1);
        rts

}

Game: {
/*
    .if (currentSidIndex != 1) {
        .eval currentSidIndex = 1
        .eval currentSid = sids.get(currentSidIndex)
        jsr currentSid.init
    }
*/

    inc VIC_BORDER_COLOUR

    printCenter(@"<- ! a c=64 adventure ! ->", 11);
    printCenter("playing game", 13);

    rts
}

Dying: {
    printCenter(@"<- ! a c=64 adventure ! ->", 11);
    printCenter("dying", 13);
    rts
}