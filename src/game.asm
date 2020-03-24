#importonce

#import "../lib/screen.asm"

Game: {
/*
    .if (currentSidIndex != 1) {
        .eval currentSidIndex = 1
        .eval currentSid = sids.get(currentSidIndex)
        jsr currentSid.init
    }
*/
    // border flashing
    inc VIC_BORDER_COLOUR

    printCenter(@"<- ! ich vermisse dich ! ->", 10);
    printCenter("game", 12);

    rts
}
Dying: {
    printCenter(@"<- ! ich vermisse dich ! ->", 10);
    printCenter("dying", 12);
    rts
}