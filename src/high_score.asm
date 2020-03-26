#importonce

#import "../lib/screen.asm"

HighScore: {
    //nastyBorder()
    printCenter(@"<- ! a c=64 adventure ! ->", 11);
    printCenter("high scores", 13);
    rts
}
