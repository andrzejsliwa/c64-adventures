#importonce

* = * "Labels"

/*
Processor port data direction register. Bits:
Default: $2F, %00101111.

Bit #x: 0 = Bit #x in processor port can only be read; 1 = Bit #x in processor port can be read and written.
*/
.label PROCESSOR_PORT_ACCESS = $00

/*
Processor port. $01, Bits:
Default: $37, %00110111.

Bits #0-#2: Configuration for memory areas $A000-$BFFF, $D000-$DFFF and $E000-$FFFF. Values:

%x00: RAM visible in all three areas.
%x01: RAM visible at $A000-$BFFF and $E000-$FFFF.
%x10: RAM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
%x11: BASIC ROM visible at $A000-$BFFF; KERNAL ROM visible at $E000-$FFFF.
%0xx: Character ROM visible at $D000-$DFFF. (Except for the value %000, see above.)
%1xx: I/O area visible at $D000-$DFFF. (Except for the value %100, see above.)

Bit #3: Datasette output signal level.
Bit #4: Datasette button status; 0 = One or more of PLAY, RECORD, F.FWD or REW pressed; 1 = No button is pressed.
Bit #5: Datasette motor control; 0 = On; 1 = Off.
*/
.label PROCESSOR_PORT = $01

/*
    High byte of pointer to screen memory for screen input/output.
    Default: $04 = address $0400, 1024, pointing to SCREEN_BASE
    Calculate by SCREEN_BASE / 256 = 4
*/
.label SCREEN_MEMORY_PAGE = $0288

// charset colour
.label CHARSET_COLOUR = $d800

// border register
.label VIC_BORDER_COLOUR = $d020
// background register
.label VIC_BACKGROUND_COLOUR = $d021
// text colour
.label VIC_TEXT_COLOUR = $0286

// start of sprites
//.label SPRITE_PTRS = SCREEN_BASE + $03f8
// sprite enabled control
.label VIC_SPRITE_ENABLE = $d015

/*
Screen control register #2. Bits:
$d016

Bits #0-#2: Horizontal raster scroll.
Bit #3: Screen width; 0 = 38 columns; 1 = 40 columns.
Bit #4: 1 = Multicolor mode on.

Default: $c8, %11001000.
*/
.label VIC_SCREEN_CONTROL_2 = $d016



/*
Memory setup register. $d018 
Default Value: $14/20 (%0001 010 0).

Bit 0: Unused

Bits #1-#3: In text mode, pointer to character memory (bits #11-#13), relative to VIC bank, memory address $DD00. Values:
%000, 0: $0000-$07FF, 0-2047.
%001, 1: $0800-$0FFF, 2048-4095.
%010, 2: $1000-$17FF, 4096-6143.
%011, 3: $1800-$1FFF, 6144-8191.
%100, 4: $2000-$27FF, 8192-10239.
%101, 5: $2800-$2FFF, 10240-12287.
%110, 6: $3000-$37FF, 12288-14335.
%111, 7: $3800-$3FFF, 14336-16383.

Values %010 and %011 in VIC bank #0 and #2 select Character ROM instead.
In bitmap mode, pointer to bitmap memory (bit #13), relative to VIC bank, memory address $DD00. Values:

%0xx, 0: $0000-$1FFF, 0-8191.
%1xx, 4: $2000-$3FFF, 8192-16383.

Bits #4-#7: Pointer to screen memory (bits #10-#13), relative to VIC bank, memory address $DD00. Values:

%0000, 0: $0000-$03FF, 0-1023.
%0001, 1: $0400-$07FF, 1024-2047.
%0010, 2: $0800-$0BFF, 2048-071.
%0011, 3: $0C00-$0FFF, 3072-4095.
%0100, 4: $1000-$13FF, 4096-5119.
%0101, 5: $1400-$17FF, 5120-6143.
%0110, 6: $1800-$1BFF, 6144-7167.
%0111, 7: $1C00-$1FFF, 7168-8191.
%1000, 8: $2000-$23FF, 8192-9215.
%1001, 9: $2400-$27FF, 9216-10239.
%1010, 10: $2800-$2BFF, 10240-11263.
%1011, 11: $2C00-$2FFF, 11264-12287.
%1100, 12: $3000-$33FF, 12288-13311.
%1101, 13: $3400-$37FF, 13312-14335.
%1110, 14: $3800-$3BFF, 14336-15359.
%1111, 15: $3C00-$3FFF, 15360-16383.
*/
.label VIC_MEMORY_CONTROL = $d018
.enum {
    VIC_SCREEN_OFFSET_0 = $0000, 
    VIC_SCREEN_OFFSET_1 = $0400, 
    VIC_SCREEN_OFFSET_2 = $0800, 
    VIC_SCREEN_OFFSET_3 = $0c00, 
    VIC_SCREEN_OFFSET_4 = $1000, 
    VIC_SCREEN_OFFSET_5 = $1400, 
    VIC_SCREEN_OFFSET_6 = $1800, 
    VIC_SCREEN_OFFSET_7 = $1c00, 
    VIC_SCREEN_OFFSET_8 = $2000, 
    VIC_SCREEN_OFFSET_9 = $2400, 
    VIC_SCREEN_OFFSET_10 = $2800, 
    VIC_SCREEN_OFFSET_11 = $2c00, 
    VIC_SCREEN_OFFSET_12 = $3000, 
    VIC_SCREEN_OFFSET_13 = $3400, 
    VIC_SCREEN_OFFSET_14 = $3800, 
    VIC_SCREEN_OFFSET_15 = $3c00
}
.enum {
    VIC_BITMAP_OFFSET_0 = $0000, 
    VIC_BITMAP_OFFSET_1 = $2000
}
.enum {
    VIC_CHARSET_OFFSET_0 = $0000, 
    VIC_CHARSET_OFFSET_1 = $0800, 
    VIC_CHARSET_OFFSET_2 = $1000, 
    VIC_CHARSET_OFFSET_3 = $1800, 
    VIC_CHARSET_OFFSET_4 = $2000, 
    VIC_CHARSET_OFFSET_5 = $2800, 
    VIC_CHARSET_OFFSET_6 = $3000, 
    VIC_CHARSET_OFFSET_7 = $3800
}

/*
Vic Bank. $dd00
Default Value: $17/23 (%00010111)

Port A, serial bus access.
the c64  charset is unavailable in banks 1 & 3

Bits #0-#1: VIC bank. (Low is active)
%00, 0: Bank #3, $C000-$FFFF, 49152-65535.
%01, 1: Bank #2, $8000-$BFFF, 32768-49151.
%10, 2: Bank #1, $4000-$7FFF, 16384-32767.
%11, 3: Bank #0, $0000-$3FFF, 0-16383.

Bit #2: RS232 TXD line, output bit.
Bit #3: Serial bus ATN OUT; 0 = High; 1 = Low.
Bit #4: Serial bus CLOCK OUT; 0 = High; 1 = Low.
Bit #5: Serial bus DATA OUT; 0 = High; 1 = Low.
Bit #6: Serial bus CLOCK IN; 0 = Low; 1 = High.
Bit #7: Serial bus DATA IN; 0 = Low; 1 = High.
*/
.label VIC_BANK = $dd00
.enum {
    VIC_BANK_0 = $0000, 
    VIC_BANK_1 = $4000, 
    VIC_BANK_2 = $8000, 
    VIC_BANK_3 = $c000
}

/*
Port A data direction register.
Bit #x: 0 = Bit #x in port A can only be read; 1 = Bit #x in port A can be read and written.
*/
.label VIC_PORT_A_DATA_DIRECTION = $dd02

.label CIA_PRA = $dc00

/*  rom functions    */

#if HAS_KERNAL_ROM
    KROUTINES: {
        // kernal rom
        .label PLOT = $fff0 // e50a
        .label PRINT_ACC = $ffd2 // 0326
    }
#endif

#if HAS_BASIC_ROM
    BROUTINES: {
        // basic rom
        .label PRINT = $aa9d
        .label CHKCOM = $aefd
        .label FCERR = $b248
        .label GETBYT = $b79b
    }
#endif
