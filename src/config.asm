/*
Compile level config flags for libs
*/
#importonce

{}.print "config loading"

#define HAS_KERNAL_ROM
#undef HAS_BASIC_ROM
#define HAS_MUSIC
#define DEBUG_VERBOSE

#import "state.asm"
#import "../lib/screen.asm"
#import "../lib/charset.asm"

.pc = * "Config"

.const RASTER_LINE = $00

.enum {
    GameStateIntro = 0, 
    GameStateInstructions = 1,
    GameStatePlaying = 2,
    GameStateDying = 3,
    GameStateHighScore = 4
}

/*
    flip to the new state
    and set the entered flag
*/
.macro transitionState(newState) {
    lda #newState
    sta STATE.gameState
    lda #$01
    sta STATE.entered
    jsr SCREEN.Clear
}

{}.print "config loaded"
