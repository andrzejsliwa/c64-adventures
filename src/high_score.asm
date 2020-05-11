#importonce

#import "../lib/labels.asm"
#import "../lib/input.asm"
#import "../lib/screen.asm"
#import "state.asm"
#import "config.asm"
#import "music.asm"

HighScore: {

    ldx #00
    jsr AnimatedBorder

    // check this is first time here
    lda STATE.entered
    cmp #StateEntered
    beq SETUP

    INSTRUCTION_INPUT:

        checkKey(KeySpace, true);
        beq NOOP

    TRANSITION:
        // go back to intro screen
        transitionState(GameStateIntro);
        rts

    NOOP:

        // do nothing for 10 frames
        inc STATE.divider
        lda STATE.divider
        cmp #$0a
        beq DRAW
        rts

    SETUP:

        setBorderColour(BLACK);
        setTextColour(WHITE);
        #if HAS_MUSIC
            // fix the sid up
            ldx #0
            ldy #0
            lda #MUSIC_HI_SCORE
            jsr music.init
        #endif
        // reset state
        stateTransitioned(GameStateHighScore);

    DRAW:
        // reset the divider flag
        lda #00
        sta STATE.divider

        //jsr SCREEN.Clear
        incrementTextColour();
        centreText("<- ! a c=64 adventure ! ->", 5);
        incrementTextColour();
        centreText("tOP 10 hIGH sCORES", 8);
        .for (var x = 0; x < 10; x++) {
            .var intScore = (10 - x) * 100;
            .var textScore = toIntString(intScore, 4);
            incrementTextColour();
            centreText("player "  + toIntString([x + 1], 2) + " ..... " + textScore, [11 + x]);
        }

        rts

}
