#importonce


#import "../lib/screen.asm"
#import "../lib/input.asm"
#import "../lib/score.asm"
#import "state.asm"

#import "../lib/score.asm"
scoreSetup(STATE.score, $0400 + 60);

/* sets us up for a new game */
GameInit: {
    stateTransitioned();
    lda #00
    sta STATE.level
    sta STATE.score
    lda #03
    sta STATE.lives
    transitionState(GameStateNewLevel);
    jsr resetScore
}

/* sets us up for a new level */
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
        // reset state
        stateTransitioned();
        // increment our level counter
        inc STATE.level
        jmp LEVEL_DRAW

    TRANSITION:

        transitionState(GameStatePlaying);
        //transitionState(GameStateIntro);
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

/* the main game logic will go here */
Game: {

/*
    .if (currentSidIndex != 1) {
        .eval currentSidIndex = 1
        .eval currentSid = sids.get(currentSidIndex)
        ldx #0
        ldy #0
        lda #currentSid.startSong - 1
        jsr currentSid.init
    }
*/

    ldx #0
    jsr AnimatedBorder

    // score goes up every frame for testing
    ldx #01
    jsr addToScore

    lda STATE.entered
    cmp #StateEntered
    beq DRAW
    jmp INPUT

    DRAW:

        // reset state
        stateTransitioned();

        setBorderColour(BLACK);
        setTextColour(WHITE);
        printAbs("sCORE:", 14, 1);

        centreText(@"<- ! a c=64 adventure ! ->", 11);
        centreText("playing game", 13);
        //centreText("lives remaining : 0x", 15);

        appendIntegerToText("lives remaining : ", STATE.lives);
        ldx #15
        jsr TextCenter

    INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        transitionState(GameStateDying);

    NOOP:
        rts

}

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
        // reset state
        stateTransitioned();
        // increment our level counter
        inc STATE.level
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

GameOver: {

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

        centreText("gAME oVER pLAYER 1", 11);
        incrementTextColour();
        lda STATE.level
        centreText("your ranking is", 13);
        centreText("> rank amateur <", 15);

        // shrink the border
        ldx STATE.temp1
        jsr AnimatedBorder
        rts

}