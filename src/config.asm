/*
Compile level config flags for libs
*/
#importonce

{}.print "config loading"

#undef HAS_KERNAL_ROM
#undef HAS_BASIC_ROM
#define HAS_MUSIC
#define DEBUG_VERBOSE

#import "state.asm"
#import "../lib/screen.asm"
#import "../lib/charset.asm"

.pc = * "Config"

.const RASTER_LINE = $00

{}.print "config loaded"
