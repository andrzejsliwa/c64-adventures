#importonce

#import "../lib/screen.asm"
#import "../lib/input.asm"
#import "../lib/score.asm"
#import "state.asm"

/* the main game logic will go here */
* = * "Game"
Game: {

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

        // set up the in game music
        #if HAS_MUSIC
            ldx #0
            ldy #0
            lda #MUSIC_IN_GAME
            jsr music.init
        #endif

        setBorderColour(BLACK);
        setTextColour(WHITE);
        printAbs("sCORE:", 14, 1);

        centreText(@"<- ! a c=64 adventure ! ->", 10);
        centreText("playing game", 12);
        //centreText("lives remaining : 0x", 14);

        appendIntegerToText("lives remaining : ", STATE.lives);
        ldx #14
        jsr TextCenter

        // reset state
        stateTransitioned(GameStatePlaying);

    INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        transitionState(GameStateDying);

    NOOP:
        rts

}
