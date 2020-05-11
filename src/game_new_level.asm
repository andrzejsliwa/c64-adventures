#importonce

#import "../lib/screen.asm"
#import "state.asm"

/* sets us up for a new level */
* = * "NewLevel"
NewLevel: {

    ldx STATE.temp1
    jsr AnimatedBorder

    // check this is first time here
    lda STATE.entered
    cmp #StateEntered
    beq LEVEL_SETUP

    // do nothing for 10 frames
    inc STATE.divider
    lda STATE.divider
    cmp #$0a
    beq FRAME
    rts

    // every 10 frames we hit here
    FRAME:
        // reset divider
        lda #$00
        sta STATE.divider
        // increment offset
        inc STATE.temp1
        // check if we're finished animating
        lda STATE.temp1
        cmp #$0d
        beq TRANSITION
        cmp #$0a
        bmi LEVEL_DRAW
        jsr SCREEN.Clear
        incrementTextColour();
        centreText("::::::::::::::::", 12);
        rts

    LEVEL_SETUP:

        // increment our level counter
        inc STATE.level
        // set up the in game music
        #if HAS_MUSIC
            lda STATE.lastState
            cmp #GameStateDying
            //beq !+
            ldx #0
            ldy #0
            lda #MUSIC_INTERSTITIAL
            jsr music.init
            !:
        #endif
        // reset state
        stateTransitioned(GameStateNewLevel);
        jmp LEVEL_DRAW

    TRANSITION:

        transitionState(GameStatePlaying);
        rts

    LEVEL_DRAW:

        jsr SCREEN.Clear
        incrementTextColour();

        centreText("gET rEADY pLAYER 1", 11);
        incrementTextColour();
        lda STATE.level
        centreText(">> lEVEL 01 <<", 13);

        // shrink the border
        ldx STATE.temp1
        jsr AnimatedBorder
        rts
}
