#importonce

#import "../lib/screen.asm"

// zero page addresses, when i page out the kernal

* = $02 "Zeropage" virtual

.enum {
    GameStateIntro = 0, 
    GameStateInstructions = 1,
    GameStateNewLevel = 2,
    GameStatePlaying = 3,
    GameStateDying = 4,
    GameStateHighScore = 5
}

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
    // temp2 stasher
    temp2: .byte $00;
    // temp3 stasher
    temp3: .byte $00;
    // temp4 stasher
    temp4: .byte $00;
}

/*
    flip to the new state
    and set the entered flag
*/
.macro transitionState(newState) {
    lda #$00
    sta STATE.divider
    sta STATE.temp1
    sta STATE.temp2
    lda #newState
    sta STATE.gameState
    lda #$01
    sta STATE.entered
    jsr SCREEN.Clear
}
