#importonce

#import "../lib/screen.asm"
#import "../lib/score.asm"
#import "state.asm"

* = * "Dying"
Dying: {

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
        beq KEY
        cmp #$09
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
            ldx #0
            ldy #0
            lda #MUSIC_DYING
            jsr music.init
        #endif
        // reset state
        stateTransitioned(GameStateDying);

        jmp LEVEL_DRAW

    KEY:

        dec STATE.lives
        beq GameOver
        transitionState(GameStateNewLevel);
        rts

    GameOver:
        transitionState(GameStateGameOver);
        rts

    LEVEL_DRAW:

        jsr SCREEN.Clear
        incrementTextColour();
        centreText("damn, we're dying :(", 11);
        //centreText("lives remaining : x", 13);
        appendIntegerToText("lives remaining : ", STATE.lives);
        ldx #13
        jsr TextCenter

        // shrink the border
        ldx STATE.temp1
        jsr AnimatedBorder
        rts
}

