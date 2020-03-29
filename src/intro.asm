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
        
        centreText("zERO pAGE pOWER", 9);
        centreText(@"<- ! a c=64 adventure ! ->", 11);
        centreText("intro", 13);
        centreText("welcome to a game", 15);

    INTRO_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        // goto instructions screen
        //transitionState(GameStateInstructions);
        transitionState(GameStateHighScore)

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
        centreText(@"<- ! a c=64 adventure ! ->", 11)
        centreText("instructions", 13);
        centreText("! just play it !", 15);

    INSTRUCTION_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        // go back to intro screen
        //transitionState(GameStateIntro)
        transitionState(GameStateNewGame);

    NOOP:
        rts
}

