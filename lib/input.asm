#importonce

.label LAST_KEY = $00c5

.enum { 
    JoystickUp = 1, 
    JoystickDown = 2,
    JoystickLeft = 4, 
    JoystickRight = 8, 
    JoystickFire = 16
}

InitJoystick2: {
    
    lda #$e0 // 1110 0000
    // Port A data direction register
    // set all joystick 2 bits @ dc00 to read only
    sta $dc02
    rts

}

/*
    Reads the joystick 2 register and puts the result into the accumulator
*/
ReadJoystick2: {
    /*
    Port A, keyboard matrix columns and joystick #2. Read bits:

    Bit #0: 0 = Port 2 joystick up pressed.
    Bit #1: 0 = Port 2 joystick down pressed.
    Bit #2: 0 = Port 2 joystick left pressed.
    Bit #3: 0 = Port 2 joystick right pressed.
    Bit #4: 0 = Port 2 joystick fire pressed.

    Write bits:
    Bit #x: 0 = Select keyboard matrix column #x.
    Bits #6-#7: Paddle selection; %01 = Paddle #1; %10 = Paddle #2.
    */
    lda $dc00 // 56320

}

/* a not quite petscii keycode list */
.enum {
    KeyZero = $30, 
    KeyOne = $31, 
    KeyTwo = $32, 
    KeyThree = $33, 
    KeyFour = $34, 
    KeyFive = $35, 
    KeySix = $36, 
    KeySeven = $37,
    KeyEight = $38, 
    KeyNine = $39, 

    KeyA = $41, 
    KeyB = $42, 
    KeyC = $43, 
    KeyD = $44, 
    KeyE = $45, 
    KeyF = $46, 
    KeyG = $47, 
    KeyH = $48, 
    KeyI = $49, 
    KeyJ = $4a, 
    KeyK = $4b, 
    KeyL = $4c, 
    KeyM = $4d, 
    KeyN = $4e, 
    KeyO = $4f, 
    KeyP = $50, 
    KeyQ = $51, 
    KeyR = $52, 
    KeyS = $53, 
    KeyT = $54, 
    KeyU = $55, 
    KeyV = $56, 
    KeyW = $57, 
    KeyX = $58, 
    KeyY = $59, 
    KeyZ = $5a, 

    KeyF1 = $85, 
    KeyF2 = $89, 
    KeyF3 = $86, 
    KeyF4 = $8a, 
    KeyF5 = $87, 
    KeyF6 = $8b, 
    KeyF7 = $88, 
    KeyF8 = $8c, 

    KeyStar = $2a, 
    KeyPlus = $2b, 
    KeyComma = $2c,
    KeyMinus = $2d, 
    KeyPeriod = $2e, 
    KeySlash = $2f, 
    KeyColon = $3a, 
    KeySemiColon = $3b, 
    KeyEquals = $3d, 
    KeyAt = $40, 
    KeyPound = $5c, 
    KeyUpArrow = $5e, 

    KeySpace = $20, 
    KeyRunStop = $83, 
    KeyReturn = $0d,

    KeyHome = $13, 
    KeyDelete = $14, 
    KeyLeftArrow = $5f, 

    KeyCursorUpDown = $11, 
    KeyCursorLeftRight = $1d, 

    KeyCommodore = $00, 
    KeyLeftShift = $01, 
    KeyRightShift = $02,
    KeyRestore = $03,
    KeyCtrl = $04

}

.define keyboardMap {

    /*
    WRITE TO PORT A               READ PORT B (56321, $DC01)
    56320/$DC00
            Bit 7   Bit 6   Bit 5   Bit 4   Bit 3   Bit 2   Bit 1   Bit 0

    Bit 7    STOP    Q       C=      SPACE   2       CTRL    <-      1
    Bit 6    /       ^       =       RSHIFT  HOME    ;       *       £
    Bit 5    ,       @       :       .       -       L       P       +
    Bit 4    N       O       K       M       0       J       I       9
    Bit 3    V       U       H       B       8       G       Y       7
    Bit 2    X       T       F       C       6       D       R       5
    Bit 1    LSHIFT  E       S       Z       4       A       W       3
    Bit 0    CRSR DN F5      F3      F1      F7      CRSR RT RETURN  DELETE
    */

    .var keyboardMap = Hashtable();

    .eval keyboardMap.put(0, List().add(KeyDelete, KeyReturn, KeyCursorLeftRight, KeyF7, KeyF1, KeyF3, KeyF5, KeyCursorUpDown));
    .eval keyboardMap.put(1, List().add(KeyThree, KeyW, KeyA, KeyFour, KeyZ, KeyS, KeyE, KeyLeftShift));
    .eval keyboardMap.put(2, List().add(KeyFive, KeyR, KeyD, KeySix, KeyC, KeyF, KeyT, KeyX));
    .eval keyboardMap.put(3, List().add(KeySeven, KeyY, KeyG, KeyEight, KeyB, KeyH, KeyU, KeyV));
    .eval keyboardMap.put(4, List().add(KeyNine, KeyI, KeyJ, KeyZero, KeyM, KeyK, KeyO, KeyN));
    .eval keyboardMap.put(5, List().add(KeyPlus, KeyP, KeyL, KeyMinus, KeyPeriod, KeyColon, KeyAt, KeyComma));
    .eval keyboardMap.put(6, List().add(KeyPound, KeyStar, KeySemiColon, KeyHome, KeyRightShift, KeyEquals, KeyUpArrow, KeySlash));
    .eval keyboardMap.put(7, List().add(KeyOne, KeyLeftArrow, KeyCtrl, KeyTwo, KeySpace, KeyCommodore, KeyQ, KeyRunStop));

}

/*
    Checks for a key code, zero flag means not pressed
*/
.macro checkKey(keyCode, noRepeat) {

    /*
    PORT A (56320, $DC00)
    PORT B (56321, $DC01)

    In order to read the individual keys in the matrix, you must first set
    - Port A for all outputs (255, $FF)
    - Port B for all inputs (0),
    using the Data Direction Registers.  
    Note that this is the default condition.
    */
    /*
    We don't need to do this as we are being explicit later on
    for exact column and row
    lda #$ff
    sta $dc00
    lda #$00
    sta $dc01
    */

    .var matched = false;
    .for (var c = 0; c < keyboardMap.keys().size() && !matched; c++) {
        .var key = keyboardMap.keys().get(c)
        .var column = keyboardMap.get(key);

        .for (var r = 0; r < column.size() && !matched; r++) {
            .var cell = column.get(r);

            .if (keyCode == cell) {

                {}.print @"/nmatched keyCode : '" + keyCode + "', column : " + key + ", row : " + r + " '" + column + "'"
                .eval matched = true;

                /*
                Next, you must write a 0 in the bit of Data Port A that
                corresponds to the column that you wish to read...

                and then a 1 to the bits that correspond to columns you wish to ignore.  

                */
                .var columnMask = 255 - pow($02, c);
                {}.print "columnMask : " + columnMask

                lda #columnMask
                sta $dc00

                /*
                You will then be able
                to read Data Port B to see which keys in that column are being pushed.
                */
                
                // start with nothing pressed
                // x is the final result of our tests
                ldx #0


                // load the register
                ldy $dc01
                // compare acc w/ $ff, aka nothing pressed
                cpy #$ff
                // clear everything if no key is down
                beq CLEAR

                // debounce it
                .if (noRepeat) {
                    cpy LAST_KEY
                    beq BOUNCER
                    jmp DEBOUNCED

                    BOUNCER:
                        jmp DONE
                }

            DEBOUNCED:

                // 'and' it with the column and if it's low it's set
                .var rowMask = pow($02, r);
                {}.print "rowMask : " + rowMask
                // bounce register val to acc
                tya
                // apply the mask
                and #rowMask
                // and compare to zero
                beq SET
                jmp DONE

                SET:
                    // store code into the debounce reg
                    sty LAST_KEY
                    // set the pressed flag true
                    ldx #1
                    jmp DONE

                CLEAR:
                    // clear the debounce register
                    ldy #00
                    sty LAST_KEY

                DONE:
                    // put the result flag in the accumulator
                    txa
            }
        }
    }
}
