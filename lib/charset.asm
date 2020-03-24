#importonce

#import "labels.asm"
#import "functions.asm"

    .macro loadCharset(file, location) {
        loadCharsetWithHeader(file, location, 0);
    }

    .macro loadCharsetWithHeader(file, location, header) {
        * = location "Charset data"
        // get the charset, label it
        .var data = LoadBinary(file);
        .var headerLength = 2;
        @charset: .fill data.getSize() - headerLength, data.get(i + headerLength);
    }

    /*
    deploy 2k charset to targetAddress, 
    switch banks etc etc
    */
    .macro deployCharset(targetAddress) {

        .label tempAddress = $0a
        // block interrupts
        // since we turn ROMs off this would result in crashes if we did not
        sei

        // save the configuration
        lda PROCESSOR_PORT
        sta tempAddress

        // set us to only RAM, to copy under the IO rom, expose the rom at D000
        lda #%00110000
        sta PROCESSOR_PORT
        copyCharset(charset, targetAddress);
        // restore ROMs
        lda tempAddress
        sta PROCESSOR_PORT
        // restore interrupt
        cli

    }

    /*
        Copies a 2kb charset to a new location 
    */
    .macro copyCharset(from, to) {
        {}.print "copying charset from " +  toHexString(from) + " to : " +  toHexString(to);
        copy1kbAddress(from, to);
        copy1kbAddress(from + $400, to + $400);
        {}.print "copied charset";
    }
