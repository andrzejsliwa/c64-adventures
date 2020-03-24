#importonce

#import "config.asm"

#if HAS_MUSIC

    .const IntroMusicPath = "./assets/intro.sid"
    .var introMusic = LoadSid(IntroMusicPath)
    .pc = introMusic.location "IntroMusic"
    .fill introMusic.size, introMusic.getData(i)

    .const GameMusicPath = "./assets/game.sid"
    .var gameMusic = LoadSid(GameMusicPath)
    .pc = gameMusic.location "GameMusic"
    .fill gameMusic.size, gameMusic.getData(i)

    .var sids = List();
    .eval sids.add(introMusic)
    .eval sids.add(gameMusic) 

    {}.print "loaded sids :: " + sids

    .var currentSidIndex = round (random() * (sids.size() - 1))
    {}.print "selected sid : " + currentSidIndex
    .var currentSid = sids.get(currentSidIndex)

    #if DEBUG_VERBOSE
        .for (var x = 0; x < sids.size(); x++) {
            .var music = sids.get(x)
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
        }
    #endif

#endif
