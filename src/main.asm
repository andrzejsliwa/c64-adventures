#importonce

#import "../lib/screen.asm"
#import "../lib/input.asm"

// game specific code
#import "config.asm"
#import "music.asm"
#import "state.asm"
#import "intro.asm"
#import "game.asm"
#import "game_init.asm"
#import "game_new_level.asm"
#import "game_dying.asm"
#import "game_over.asm"
#import "high_score.asm"

* = * "Main"

Main: {

    #if HAS_MUSIC
        jsr music.play
    #endif

    lda STATE.gameState
    cmp #GameStateIntro
    beq IntroJmp
    cmp #GameStateInstructions
    beq InstructionsJmp
    cmp #GameStateNewGame
    beq NewGameJmp
    cmp #GameStateNewLevel
    beq NewLevelJmp
    cmp #GameStatePlaying
    beq GamePlayingJmp
    cmp #GameStateDying
    beq GameDyingJmp
    cmp #GameStateGameOver
    beq GameOverJmp
    cmp #GameStateHighScore
    beq HighScoreJmp

    // safety net should never be hit
    rts

    // let us jump more than 255 bytes
    IntroJmp:
        jmp Intro
    InstructionsJmp:
        jmp Instructions
    NewGameJmp:
        jmp GameInit
    NewLevelJmp:
        jmp NewLevel
    GamePlayingJmp:
        jmp Game
    GameDyingJmp:
        jmp Dying
    GameOverJmp:
        jmp GameOver
    HighScoreJmp:
        jmp HighScore
}

GraphicsHandler: {
    // border flashing
    inc VIC_BORDER_COLOUR
    // top left char on the screen
    inc SCREEN_BASE
}

