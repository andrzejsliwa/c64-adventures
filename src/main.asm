#importonce

#import "../lib/screen.asm"
#import "../lib/input.asm"

// game specific code
#import "config.asm"
#import "music.asm"
#import "state.asm"
#import "intro.asm"
#import "game.asm"
#import "high_score.asm"

SidHandler: {

    #if HAS_MUSIC
        jsr currentSid.play
    #endif

    lda STATE.gameState
    cmp #GameStateIntro
    beq IntroJmp
    cmp #GameStateInstructions
    beq InstructionsJmp
    cmp #GameStateNewLevel
    beq NewLevelJmp
    cmp #GameStatePlaying
    beq GameJmp
    cmp #GameStateDying
    beq DyingJmp
    cmp #GameStateHighScore
    beq HighScoreJmp

    // safety net should never be hit
    rts

    // let us jump more than 255 bytes
    IntroJmp:
        jmp Intro
    InstructionsJmp:
        jmp Instructions
    NewLevelJmp:
        jmp NewLevel
    GameJmp:
        jmp Game
    DyingJmp:
        jmp Dying
    HighScoreJmp:
        jmp HighScore
}

GraphicsHandler: {
    // border flashing
    inc VIC_BORDER_COLOUR
    // top left char on the screen
    inc SCREEN_BASE
}

