#importonce

#import "../lib/screen.asm"
#import "../lib/input.asm"
#import "../lib/score.asm"
#import "state.asm"

* = * "GameOver"

GameOver: {

    // check this is first time here
    lda STATE.entered
    cmp #StateEntered
    beq LEVEL_SETUP

    !:
        jsr LEVEL_DRAW
        jmp INPUT

    LEVEL_SETUP:
        // reset state
        stateTransitioned();
        // increment our level counter
        inc STATE.level
        jsr SCREEN.Clear
        incrementTextColour();
        centreText("gAME oVER pLAYER 1", 10);
        incrementTextColour();
        lda STATE.level
        centreText("your ranking is", 12);
        incrementTextColour();
        centreText("> rank amateur <", 14);

        #if HAS_MUSIC
            // fix the sid up
            ldx #0
            ldy #0
            lda #MUSIC_GAME_OVER
            jsr music.init
        #endif

        jmp !-

    LEVEL_DRAW:

        ldx #06
        jsr AnimatedBorder
        rts

    INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        transitionState(GameStateHighScore);

    NOOP:
        rts

}

GameOver2: {

    ldx STATE.temp1
    jsr AnimatedBorder

    // check this is first time here
    lda STATE.entered
    cmp #StateEntered
    beq LEVEL_SETUP

    // do nothing for 16 frames
    inc STATE.divider
    lda STATE.divider
    cmp #$0f
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
        centreText(" ...............", 12);
        rts

    LEVEL_SETUP:
        // reset state
        stateTransitioned();
        // increment our level counter
        inc STATE.level
        jmp LEVEL_DRAW

    TRANSITION:

        transitionState(GameStateHighScore);
        rts

    LEVEL_DRAW:

        jsr SCREEN.Clear
        incrementTextColour();

        centreText("gAME oVER pLAYER 1", 10);
        incrementTextColour();
        lda STATE.level
        centreText("your ranking is", 12);
        incrementTextColour();
        centreText("> rank amateur <", 14);

        // shrink the border
        ldx STATE.temp1
        jsr AnimatedBorder
        rts

}
