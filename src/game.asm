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

        // reset state
        stateTransitioned();

        setBorderColour(BLACK);
        setTextColour(WHITE);
        printAbs("sCORE:", 14, 1);

        centreText(@"<- ! a c=64 adventure ! ->", 10);
        centreText("playing game", 12);
        //centreText("lives remaining : 0x", 14);

        appendIntegerToText("lives remaining : ", STATE.lives);
        ldx #14
        jsr TextCenter

    INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        transitionState(GameStateDying);

    NOOP:
        rts

}
