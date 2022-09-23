# microbee_1-bit_music. About 25 music players with tunes from different authors.
Majority are by Shiru and UTZ. Tim Follin and others are also included.
1-bit music engine players for the Microbee computer ported from the ZX Spectrum. 

-ZX Speccy typically plays through bit 4 on port ($FE)

-Microbee's speaker hangs off bit 6 on port ($2)

-VZ200/300 speaker hangs off a software latch at $6800, and uses bit 0 (speaker +) and bit 5 (speaker -)


Assembled to 100h as .COM files, these files are intended to run straight from off a real floppy disk (Microbee's CP/M) or disk image within an emulator.
Within MESS/MAME, fire up the Microbee emulator. (Microbee 32 will run these).
Then : Devices --> Quickload --> Mount --> *.COM      (And the music plays)
No idea with these emulators : NANOWASP (no sound), UBEE512 and MBEE32.

All sources can be re-assembed using ORG $900, named as '.BEE', and loaded into UBEE512. 
Though I still couldnt get this to work at the time of writing.
Assemble with PASMO and SJASMPLUS.
Most of Shiru's engines are assembled with SJASMPLUS. All source code that has ' OUTPUT "FILENAME.COM" ' as the first statement after comments will be this.
All other source code without a "OUTPUT" will be PASMO.
Pasmo Assembler can be found somewhere deep within a ZX website; simply google it and you'll find the windows and/or Linux executable. Same with SJASMPLUS.


All credit go to the originators of the related source code.
Huge thanks to Utz and Shiru; masters of 1-bit Z80 music coding.

Some of these tunes are far superior than most of todays current top-40 commerical crap (noise) music.

For more info, check out the 1-bit music forum over at : http://randomflux.info/1bit/

...once you get into these, it so much fun fiddling around with these music players.
Find and download/install Shiru's '1tracker' 1-bit music tracking software for Win/Linux. Create your own 1-bit music that also can be played on the ZX/ VZ / Microbee.
