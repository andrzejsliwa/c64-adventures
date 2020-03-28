#importonce

#import "labels.asm"

/*
self modifying code for a word value
takes the label Val and applies it to the desination label next command
*/
.macro smcWord(labelVal, destinationLabel) {
    lda labelVal
    sta destinationLabel + 1
    lda labelVal + 1
    sta destinationLabel + 2 
}

/*
negates a number
*/
.function negate(value) {
	.return value ^ $FF
}

.macro fill1kbAddressMulti(listKVP) {
    // set up the counter
    ldx #0
    loop:
    .for(var i = 0; i < listKVP.size(); i++) {
        .var ram = listKVP.get(i);
        .var address = ram.get(0);
        .var val = ram.get(1);
        lda #val
        sta address, x
        sta address + $0100, x
        sta address + $0200, x
        sta address + $0300, x
    }
    inx
    bne loop
}

.macro fill1kbAddress(address, value) {
    lda #value
    ldx #$00
    loop: // until x wraps
        sta address, x
        sta address + $0100, x
        sta address + $0200, x
        sta address + $0300, x
        inx
        bne loop
}

.macro copy1kbAddress(origin, destination) {
    ldx $00
    loop:
        lda origin, x
        sta destination, x
        lda origin + $0100, x
        sta destination + $0100, x
        lda origin + $0200, x
        sta destination + $0200, x
        lda origin + $0300, x
        sta destination + $0300, x
        inx
        bne loop
        .var destinationEnd = destination + $0300 + 255;
        {}.print "copied 1k from origin : $" + toHexString(origin) + ", to dest : $" + toHexString(destination) + " - $" + toHexString(destinationEnd);
}


/*
flips between exposing character rom and registers at $d000
*/
.macro toggleCharacterRomVisible(visible) {
    .var mask = visible ? %11111011 : %11111111;
    sei
    enableRomPaging(true);
    lda PROCESSOR_PORT
    and #mask
    sta PROCESSOR_PORT
    enableRomPaging(false);
    cli
}
/*
pages basic and kernal roms in or out
*/
.macro configureRoms(basicEnabled, kernalEnabled) {
    .var mask = %11111100;
    .if (basicEnabled) {
        .eval mask += 1
    }
    .if (kernalEnabled) {
        .eval mask += 2
    }
    sei
    enableRomPaging(true);
    lda PROCESSOR_PORT
    and #mask
    sta PROCESSOR_PORT
    enableRomPaging(false);
    cli
}
/*
set read / write permissions on the PROCESSOR_PORT register
*/
.macro enableRomPaging(bool) {
    .var maskRead = %11111000
    .var maskWrite = %00000111

    lda PROCESSOR_PORT_ACCESS
    .if (bool) {
        ora #maskWrite
    } else {
        and #maskRead
    }
    sta PROCESSOR_PORT_ACCESS
}


/*
increments a word sized memory address
*/
.macro incWord(address) {
    // inc the lsb
    inc address
    // if we've wrapped to zero then inc the msb
    bne !+
    inc address + 1
    !:
}

/*
inc a word address by x reg
*/
.macro incWordX(address) {
    inc address, x
    bne !+
    inc address + 1
    !:
}

/*
decrements a word sized memory address
*/
.macro decWord(address) {
    {}.print "decrementing : $" + toHexString(address);
    // dec the lsb, which only sets the zero and neg flags
    dec address
    // so we have to manually compare it to a roll around max value
    lda address
    cmp #$ff
    bne !+
    dec address + 1
    !:
}

/* 
zeroes out a word sized address. 
Accumulator 
*/
.macro resetWord(address) {
    lda  #00
    sta address
    sta address + 1
}
.macro addWordFromAddress(address, to) {
    .break
    clc
    lda to
    adc address
    sta to
    lda to + 1
    adc address + 1
    sta to + 1
}
/*
adds word 'val' to memory pair specified by the to address
Accumulator 
*/
.macro addWord(val, to) {
    clc
    lda to
    adc #<val
    sta to
    lda to + 1
    adc #>val
    sta to + 1
}

/*
subtracts a word 'val' from address pair specified by from address
Accumulator 
*/
.macro subWord(val, from) {
    sec
    lda from
    sbc #<val
    sta from
    lda from + 1
    sbc #>val
    sta from + 1
}


/*
    key Repeat macro.
    defaults are 00 , 04, 0a
    allowed ranges are $0-3, $0-4, $0-0f
*/
.enum {
    // default is cursor keys, delete, space bar etc
    KeyRepeatModeDefault = %00, 
    KeyRepeatModeOff = %01, 
    KeyRepeatModeAll = %11
}
.macro keyRepeat(mode, speed, initialDelay) {

    .if (speed < 0) {
        .eval speed = 0;
    } else .if (speed > 4) {
        .eval speed = 4;
    }

    .var finalMode = mode << 6
    lda #finalMode
    sta 650

    .if (speed < 0) {
        .eval speed = 0;
    } else .if (speed > 4) {
        .eval speed = 4;
    }
    lda #speed
    sta 651

    .if (initialDelay < 0) {
        .eval initialDelay = 0;
    } else .if (initialDelay > 16) {
        .eval initialDelay = 16;
    }
    lda #initialDelay
    sta 652

}