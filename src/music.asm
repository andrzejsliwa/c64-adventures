#importonce

#import "config.asm"

#if HAS_MUSIC

    .const musicPath = "./assets/c64-adventures.sid"
    .var music = LoadSid(musicPath)
    .pc = music.location "Music"
    .fill music.size, music.getData(i)

    .const MUSIC_INTRO = music.startSong - 1
    .const MUSIC_IN_GAME = music.startSong
    .const MUSIC_GAME_OVER = music.startSong + 3
    .const MUSIC_HI_SCORE = music.startSong + 1
    .const MUSIC_NONE = music.startSong + 2
    .const MUSIC_INTERSTITIAL = music.startSong + 4
    .const MUSIC_DYING = music.startSong + 5

    #if DEBUG_VERBOSE

        {}.print "~~ " + music.name + " ~~"
        {}.print "location=$"+toHexString(music.location)
        {}.print "init=$" + toHexString(music.init)
        {}.print "play=$" + toHexString(music.play)
        {}.print "songs=" + music.songs
        {}.print "startSong=" + music.startSong
        {}.print "size=$" + toHexString(music.size)
        {}.print "author=" + music.author
        {}.print "copyright=" + music.copyright
        {}.print ""
        {}.print "Additional tech data"
        {}.print "--------------------"
        {}.print "header=" + music.header
        {}.print "header version=" + music.version
        {}.print "flags=" + toBinaryString(music.flags)
        {}.print "speed="+toBinaryString(music.speed)
        {}.print "startpage=" + music.startpage
        {}.print "pagelength=" + music.pagelength

    #endif

#endif
