#importonce
// zero page addresses, when i page out the kernal

//* = $02 "Zeropage" virtual

STATE: {

    // if we're in the intro, playing, dying etc
    gameState: .byte $00;
    // remaining lives
    lives: .byte $00;
    // score
    score: .word $0000;
    // frequency divider
    divider: .byte $00
    // entered new section
    entered: .byte $00
    // temp1 stasher
    temp1: .byte $00
    // temp2 stasher
    temp2: .byte $00
}
