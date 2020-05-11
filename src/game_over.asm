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

        // increment our level counter
        inc STATE.level
        jsr SCREEN.Clear
        incrementTextColour();
        centreText("gAME oVER pLAYER 1", 10);
        incrementTextColour();
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

        // reset state
        stateTransitioned(GameStateGameOver);

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
