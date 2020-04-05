#importonce

#import "../lib/labels.asm"
#import "../lib/input.asm"
#import "../lib/screen.asm"
#import "state.asm"
#import "config.asm"

mytext: 
    .text "zERO pAGE pOWER ! "
    .byte 'h', 'e', 'l', 'l', 'o', ' ', 'z', 'p', 0


Intro: {

    // border flashing
    inc VIC_BORDER_COLOUR

    ldx #00
    jsr AnimatedBorder

    lda STATE.entered
    cmp #StateEntered
    beq INTRO_DRAW
    jmp INTRO_INPUT

    INTRO_DRAW:

        // reset state
        stateTransitioned();

        setTextColour(LIGHT_GREEN)
        centreText(@"<- ! a c=64 adventure ! ->", 10);
        centreText("introduction", 12);
        centreText("welcome to a game", 14);

    INTRO_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        // goto instructions screen
        transitionState(GameStateInstructions);
        //transitionState(GameStateHighScore)

    NOOP:
        rts
}

Instructions: {

    ldx #00
    jsr AnimatedBorder

    lda STATE.entered
    cmp #StateEntered
    beq INSTRUCTION_DRAW
    jmp INSTRUCTION_INPUT

    INSTRUCTION_DRAW:

        // reset state
        stateTransitioned();

        setBorderColour(BLACK);
        setTextColour(WHITE);
        centreText(@"<- ! a c=64 adventure ! ->", 10)
        centreText("instructions", 12);
        centreText("! just play it !", 14);

    INSTRUCTION_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        transitionState(GameStateNewGame);

    NOOP:
        rts
}

