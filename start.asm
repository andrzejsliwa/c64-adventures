// entry point for compiling etc
#importonce

#import "lib/labels.asm"
#import "lib/functions.asm"

#import "src/config.asm"
#import "src/music.asm"
#import "lib/screen.asm"
#import "lib/irq.asm"
#import "lib/charset.asm"
#import "lib/vic.asm"

//loadCharsetWithHeader("assets/charset_llamaish.64c", $3800, 2);
loadCharsetWithHeader("assets/charset_cpu.64c", $3800, 2);

* = $0801 "Basic"
BasicUpstart2(Entry)

// set the program counter to just after game music
* = $1754 "Entry"
Entry: {

    .var hasKernalRom = false;
    .var hasBasicRom = false;
    #if HAS_KERNAL_ROM
        .eval hasKernalRom = true;
    #endif
    #if HAS_BASIC_ROM
        .eval hasBasicRom = true;
    #endif
    configureRoms(hasBasicRom, hasKernalRom);

    // init sprite registers with no visible sprites
    lda #0
    sta VIC_SPRITE_ENABLE
    setVicColourMode(false);
    initialiseVicCharacterMode(VIC_BANK_0, VIC_SCREEN_OFFSET_1, VIC_CHARSET_OFFSET_7);

    // set up the music, IRQ's and or game specific stuff
    #if HAS_MUSIC
        ldx #0
        ldy #0
        lda #currentSid.startSong - 1
        jsr currentSid.init
    #endif

    setBackgroundColour(BLACK);
    setBorderColour(LIGHT_GREEN);
    setTextColour(LIGHT_GRAY);

    // set the initial game state up
    transitionState(GameStateIntro);

    // register the interrupt handler
    initIRQ(Main, RASTER_LINE)

    // and kick off infinite main loop
    jmp *
}

#import "src/main.asm"

// TODO ::
//* = $8000 "Level data"
//* = $c800 "Font data"
