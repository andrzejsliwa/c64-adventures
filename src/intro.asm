#importonce

#import "../lib/labels.asm"
#import "../lib/input.asm"
#import "../lib/screen.asm"
#import "state.asm"
#import "config.asm"

Intro: {

    // border flashing
    inc VIC_BORDER_COLOUR

    //ldx #00
    //jsr AnimatedBorder
    jsr FullscreenBorder

    lda STATE.entered
    cmp #StateEntered
    beq INTRO_DRAW
    jmp INTRO_INPUT

    INTRO_DRAW:

        // reset state
        stateTransitioned();

        setTextColour(LIGHT_GREEN)
        printCenter(@"<- ! a c=64 adventure ! ->", 11);
        printCenter("intro", 13);
        printCenter("welcome to a game", 15);

    INTRO_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        // goto instructions screen
        transitionState(GameStateInstructions)
        rts

    NOOP:
        rts
}

Instructions: {

    jsr FullscreenBorder

    lda STATE.entered
    cmp #StateEntered
    beq INSTRUCTION_DRAW
    jmp INSTRUCTION_INPUT

    INSTRUCTION_DRAW:

        // reset state
        stateTransitioned();

        setBorderColour(BLACK);
        setTextColour(WHITE);
        printCenter(@"<- ! a c=64 adventure ! ->", 11)
        printCenter("instructions", 13);
        printCenter("! just play it !", 15);

    INSTRUCTION_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        // go back to intro screen
        //transitionState(GameStateIntro)
        transitionState(GameStateNewGame);
        rts

    NOOP:
        rts
}
