#importonce

#import "../lib/score.asm"
#import "state.asm"

scoreSetup(STATE.score, $0400 + 60);

/* sets us up for a new game */
* = $2500 "GameInit"
GameInit: {
    lda #00
    sta STATE.level
    lda #03
    sta STATE.lives
    // reset the score
    jsr resetScore
    // set up the in game music
    #if HAS_MUSIC
        ldx #0
        ldy #0
        lda #MUSIC_IN_GAME
        jsr music.init
    #endif
    stateTransitioned(GameStateNewGame);
    transitionState(GameStateNewLevel);
}
