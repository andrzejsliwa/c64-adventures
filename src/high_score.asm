#importonce

#import "../lib/screen.asm"

HighScore: {
    //nastyBorder()
    printCenter(@"<- ! ich vermisse dich ! ->", 10);
    printCenter("high scores", 12);
    rts
}
