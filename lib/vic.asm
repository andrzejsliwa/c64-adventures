#importonce

#import "labels.asm"
#import "functions.asm"

/*
Power up settings are
initialiseVicCharacterMode(VIC_BANK_0, VIC_SCREEN_OFFSET_1, VIC_CHARSET_OFFSET_2);
*/
.namespace VIC {

    .var @BANK_START = $0000;
    .var @SCREEN_BASE = $0400;
    .var @SCREEN_BITMAP_BASE = $00;
    .var @SCREEN_CHARSET_BASE = $1000;

    .var @SPRITE_0_BASE = $00;
    .var @SPRITE_1_BASE = $00;
    .var @SPRITE_2_BASE = $00;
    .var @SPRITE_3_BASE = $00;
    .var @SPRITE_4_BASE = $00;
    .var @SPRITE_5_BASE = $00;
    .var @SPRITE_6_BASE = $00;
    .var @SPRITE_7_BASE = $00;

    .macro @setVicColourMode(bool) {
        lda VIC_SCREEN_CONTROL_2
        .if (bool) {
            // bit 4 on
            ora $ef
        } else {
            // bit 4 off
            and #$ef
        }
        sta VIC_SCREEN_CONTROL_2
    }

    /*
        @inputs
            VIC_BANK enum value
            VIC_SCREEN_OFFSET enum value
            and (
                VIC_BITMAP_OFFSET enum value
                or
                VIC_CHARSET_OFFSET enum value
            )

        @outputs

            @SCREEN_BASE
            @SCREEN_BITMAP_BASE
            @SCREEN_CHARSET_BASE
            @SPRITE_0_BASE
            @SPRITE_1_BASE
            @SPRITE_2_BASE
            @SPRITE_3_BASE
            @SPRITE_4_BASE
            @SPRITE_5_BASE
            @SPRITE_6_BASE
            @SPRITE_7_BASE
    */
    .macro @initialiseVicBitmapMode(bank, screenOffset, bitmapOffset) {

        initialiseBank(bank);
        {}.print "bankStart : $" + toHexString(BANK_START);
        .var screenMask = getVicScreenMask(screenOffset);
        {}.print "got screen mask : " + toBinaryString(screenMask);

        .var bitmapMask = (bitmapOffset == VIC_BITMAP_OFFSET_0 ? 0 : 1) << 3;
        {}.print "got bitmap mask : " + toBinaryString(bitmapMask);

        .var finalValue = screenMask + bitmapMask;
        {}.print "final mask : " + toBinaryString(finalValue);

        finalise(finalValue, screenOffset);

    }

    .macro @initialiseVicCharacterMode(bank, screenOffset, characterOffset) {

        // do some basic validation
        //.assert "Must be bank 0 or 2 required for character rom", bank == VIC_BANK_0 || bank == VIC_BANK_2, true;
        initialiseBank(bank);
        {}.print "bankStart : $" + toHexString(BANK_START);
        .var screenMask = getVicScreenMask(screenOffset);
        {}.print "got screen mask : " + toBinaryString(screenMask);
        .var charsetMask = getVicCharsetMask(characterOffset);
        {}.print "got charset mask : " + toBinaryString(charsetMask);

        .var finalValue = screenMask + charsetMask;
        {}.print "final mask : " + toBinaryString(finalValue);

        finalise(finalValue, screenOffset);

    }

    .macro finalise(finalValue, screenOffset) {

        {}.print "finalising value : $" + toHexString(finalValue);
        lda #finalValue
        sta VIC_MEMORY_CONTROL

        .var screenMemoryPage = screenOffset / 256;
        {}.print "notifying the kernal we're using screen memory page : $" + screenMemoryPage
        lda #screenMemoryPage
        sta SCREEN_MEMORY_PAGE

        .eval SPRITE_0_BASE = SCREEN_BASE + $03f8;
        .eval SPRITE_1_BASE = SCREEN_BASE + $03f9;
        .eval SPRITE_2_BASE = SCREEN_BASE + $03fa;
        .eval SPRITE_3_BASE = SCREEN_BASE + $03fb;
        .eval SPRITE_4_BASE = SCREEN_BASE + $03fc;
        .eval SPRITE_5_BASE = SCREEN_BASE + $03fd;
        .eval SPRITE_6_BASE = SCREEN_BASE + $04fe;
        .eval SPRITE_7_BASE = SCREEN_BASE + $03ff;

        .var x = 0 + BANK_START;
        .var charsetAbsoluteAddress = (0 + BANK_START + SCREEN_CHARSET_BASE);

        {}.print @"------------------------------------";
        {}.print @"            VIC LAYOUT";
        {}.print @"------------------------------------";
        {}.print @"SCREEN_BASE :         $" + toHexString(SCREEN_BASE) + " (" + toIntString(SCREEN_BASE) + ")";
        {}.print @"SCREEN_BITMAP_BASE :  $" + toHexString(SCREEN_BITMAP_BASE) + " (" + toIntString(SCREEN_BITMAP_BASE) + ")";
        {}.print @"SCREEN_CHARSET_BASE : $" + toHexString(SCREEN_CHARSET_BASE) + " (" + toIntString(SCREEN_CHARSET_BASE) + ")";
        {}.print @"";
        {}.print @"Charset Absolute    : $" + toHexString(charsetAbsoluteAddress) + " (" + toIntString(charsetAbsoluteAddress) + ")";
        {}.print @"";
        {}.print @"SPRITE_0_BASE :       $" + toHexString(SPRITE_0_BASE) + " (" + toIntString(SPRITE_0_BASE) + ")";
        {}.print @"SPRITE_1_BASE :       $" + toHexString(SPRITE_1_BASE) + " (" + toIntString(SPRITE_1_BASE) + ")";
        {}.print @"SPRITE_2_BASE :       $" + toHexString(SPRITE_2_BASE) + " (" + toIntString(SPRITE_2_BASE) + ")";
        {}.print @"SPRITE_3_BASE :       $" + toHexString(SPRITE_3_BASE) + " (" + toIntString(SPRITE_3_BASE) + ")";
        {}.print @"SPRITE_4_BASE :       $" + toHexString(SPRITE_4_BASE) + " (" + toIntString(SPRITE_4_BASE) + ")";
        {}.print @"SPRITE_5_BASE :       $" + toHexString(SPRITE_5_BASE) + " (" + toIntString(SPRITE_5_BASE) + ")";
        {}.print @"SPRITE_6_BASE :       $" + toHexString(SPRITE_6_BASE) + " (" + toIntString(SPRITE_6_BASE) + ")";
        {}.print @"SPRITE_7_BASE :       $" + toHexString(SPRITE_7_BASE) + " (" + toIntString(SPRITE_7_BASE) + ")";
        {}.print @"------------------------------------";
    }

    .macro initialiseBank(bank) {

        .eval SCREEN_CHARSET_BASE = $00;
        .eval SCREEN_BITMAP_BASE = $00;

        {}.print "Deploying charset to bank : $" + toHexString(bank);

        // start working out the real address
        .eval BANK_START = bank;

        // get our bank mask
        /*
            %xxxxxx11 -> bank0: $0000-$3fff
            %xxxxxx10 -> bank1: $4000-$7fff
            %xxxxxx01 -> bank2: $8000-$bfff
            %xxxxxx00 -> bank3: $c000-$ffff
        */

        .var bankMask = getBankMask(bank);
        {}.print "got bank mask : " + toBinaryString(bankMask);

        // enable write mode
        lda VIC_PORT_A_DATA_DIRECTION
        ora #3
        sta VIC_PORT_A_DATA_DIRECTION

        // get the current value
        lda VIC_BANK
        // flatten 2 least significant bits
        and #%11111100
        // the set our desired mask value
        ora #bankMask
        // set it back again
        sta VIC_BANK

    }
    
        /*
            VIC_MEMORY_CONTROL
            Character mem is made up of 256 x 8 byte chars: 256*8 = 2048 -> $0800
            Bitmap is (40 x 8) x 25 = 8000, rounded up to 8192 -> $2000

            +----------+---------------------------------------------------+
            | Bits 7-4 |   Video Matrix Base Address (inside VIC)          |
            | Bit  3   |   Bitmap-Mode: Select Base Address (inside VIC)   |
            | Bits 3-1 |   Character Dot-Data Base Address (inside VIC)    |
            | Bit  0   |   Unused                                          |
            +----------+---------------------------------------------------+

            Screen masks
            %0000xxxx -> screenmem is at $0000
            %0001xxxx -> screenmem is at $0400
            %0010xxxx -> screenmem is at $0800
            %0011xxxx -> screenmem is at $0c00
            %0100xxxx -> screenmem is at $1000
            %0101xxxx -> screenmem is at $1400
            %0110xxxx -> screenmem is at $1800
            %0111xxxx -> screenmem is at $1c00
            %1000xxxx -> screenmem is at $2000
            %1001xxxx -> screenmem is at $2400
            %1010xxxx -> screenmem is at $2800
            %1011xxxx -> screenmem is at $2c00
            %1100xxxx -> screenmem is at $3000
            %1101xxxx -> screenmem is at $3400
            %1110xxxx -> screenmem is at $3800
            %1111xxxx -> screenmem is at $3c00
        
            bitmap masks
            %xxxx0xxx -> bitmap is at $0000
            %xxxx1xxx -> bitmap is at $2000

            charset masks
            %xxxx000x -> charmem is at $0000
            %xxxx001x -> charmem is at $0800
            %xxxx010x -> charmem is at $1000
            %xxxx011x -> charmem is at $1800
            %xxxx100x -> charmem is at $2000
            %xxxx101x -> charmem is at $2800
            %xxxx110x -> charmem is at $3000
            %xxxx111x -> charmem is at $3800
        */

    .function getBankMask(enum) {
        .return negate((enum / $4000) + %11111100);
    }
    //.assert "VIC_BANK_2 = %xxxxxxx1 ($01)", getBankMask(VIC_BANK_2), $01;
    //.assert "VIC_BANK_3 = %xxxxxxx1 ($00)", getBankMask(VIC_BANK_3), $00;

    .function getVicScreenMask(enum) {
        .eval SCREEN_BASE = enum;
        .return (enum / $0400) << 4;
    }
    //.assert "VIC_SCREEN_OFFSET_12 = %1100xxxx ($c0)", getVicScreenMask(VIC_SCREEN_OFFSET_12), $c0;

    .function getBitmapMask(enum) {
        .eval SCREEN_BITMAP_BASE = enum;
        .return (enum == VIC_BITMAP_OFFSET_0 ? 0 : 1) << 3;
    }
    //.assert "VIC_BITMAP_OFFSET_1 = %00001000 ($08)", getBitmapMask(VIC_BITMAP_OFFSET_1), $08;

    .function getVicCharsetMask(enum) {
        .eval SCREEN_CHARSET_BASE = enum;
        .return (enum / $0800) << 1;
    }
    //.assert "VIC_CHARSET_OFFSET_5 = %xxxx011x ($0a)", getVicCharsetMask(VIC_CHARSET_OFFSET_5), $0a;

}