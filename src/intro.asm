#importonce

#import "../lib/labels.asm"
#import "../lib/input.asm"
#import "../lib/screen.asm"
#import "state.asm"
#import "config.asm"

Intro: {

    // border flashing
    inc VIC_BORDER_COLOUR
    nastyBorder()

    lda STATE.entered
    cmp #$01
    beq INTRO_DRAW
    jmp INTRO_INPUT

    INTRO_DRAW:

        lda #$00
        sta STATE.entered

        setTextColour(LIGHT_GREEN)
        printCenter(@"<- ! ich vermisse dich ! ->", 10);
        printCenter("intro", 12);
        printCenter("welcome to a game", 14);

    INTRO_INPUT:

        //lda STATE.divider
        //bne NOOP
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

    nastyBorder()

    lda STATE.entered
    cmp #$01
    beq INSTRUCTION_DRAW
    jmp INSTRUCTION_INPUT

    INSTRUCTION_DRAW:

        lda #$00
        sta STATE.entered

        setBorderColour(BLACK);
        setTextColour(WHITE);
        printCenter(@"<- ! ich vermisse dich ! ->", 10)
        printCenter("instructions", 12);
        printCenter("! just play it !", 14);

    INSTRUCTION_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    KEY:
        // go back to intro screen
        transitionState(GameStateIntro)
        rts

    NOOP:
        rts
}

.macro nastyBorder() {
    .for (var y = 0; y < 25; y++) {
        .if (y == 0 || y == 24) {
            // top or bottom row is full
            .for (var x = 0; x < 40; x++) {
                inc SCREEN_BASE + (y * 40) + x
                inc $d800 + (y * 40) + x
            }
        } else {
            // just left and right borders
            inc SCREEN_BASE + (y * 40)
            inc SCREEN_BASE + (y * 40) + 39
            inc $d800 + (y * 40)
            inc $d800 + (y * 40) + 39
        }
    }
}