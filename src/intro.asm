#importonce

#import "../lib/labels.asm"
#import "../lib/input.asm"
#import "../lib/screen.asm"
#import "state.asm"
#import "config.asm"

Intro: {

    // border flashing
    inc VIC_BORDER_COLOUR
    //nastyBorder(0, 0);
    //ldx #00
    //jsr AnimatedBorder
    jsr FullscreenBorder

    lda STATE.entered
    cmp #$01
    beq INTRO_DRAW
    jmp INTRO_INPUT

    INTRO_DRAW:

        lda #$00
        sta STATE.entered

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

    //nastyBorder(0, 0);
    jsr FullscreenBorder

    lda STATE.entered
    cmp #$01
    beq INSTRUCTION_DRAW
    jmp INSTRUCTION_INPUT

    INSTRUCTION_DRAW:

        lda #$00
        sta STATE.entered

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
        transitionState(GameStateNewLevel);
        rts

    NOOP:
        rts
}
