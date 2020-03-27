#importonce

#import "../lib/screen.asm"

// zero page addresses, when i page out the kernal

* = $02 "Zeropage" virtual

.enum {
    GameStateIntro = 0, 
    GameStateInstructions = 1,
    GameStateNewGame = 2, 
    GameStateNewLevel = 3,
    GameStatePlaying = 4,
    GameStateDying = 5,
    GameStateHighScore = 6
}

.zp {
    STATE: {
        // if we're in the intro, playing, dying etc
        gameState: .byte $00;
        // remaining lives
        lives: .byte $00;
        // score
        score: .word $0000;
        // level
        level: .byte $00;
        // frequency divider
        divider: .byte $00;
        // entered new section
        entered: .byte $00;
        // temp1 stasher
        temp1: .byte $00;
        // word holder. 
        vector1: .word $0000;
    }
}

.enum {
    StateExisting = 0, 
    StateEntered = 1
}

/*
    flip to the new state
    and set the entered flag
*/
.macro transitionState(newState) {
    // reset state variable values
    lda #$00
    sta STATE.divider
    sta STATE.temp1
    // store the desired state
    lda #newState
    sta STATE.gameState
    // mark that we're new in state
    lda #StateEntered
    sta STATE.entered
    // and wipe the screen
    jsr SCREEN.Clear
}
/*
    simple wrapper around marking that we're not new in a state
*/
.macro stateTransitioned() {
    lda #StateExisting
    sta STATE.entered
}