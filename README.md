# microbee_1-bit_music. Music players ported to the Microbee from the ZX Spectrum computer.
Majority are by Shiru and UTZ. Tim Follin and others are also included.
1-bit music engine players for the Microbee computer ported from the ZX Spectrum. 

-ZX Speccy typically plays through bit 4 on port ($FE)

-Microbee's speaker hangs off bit 6 on port ($2)

-VZ200/300 speaker hangs off a software latch at $6800, and uses bit 0 (speaker +) and bit 5 (speaker -)


Assembled with origin at 100h as CP/M .COM files, these files are intended to run straight from off a real floppy disk (Microbee's CP/M) or disk image within an emulator.

Within MESS/MAME, fire up the Microbee emulator. (Microbee 32 will run all of these).
Then : Devices --> Quickload --> Mount --> and select any .COM file.      (And the music will auto play)

UBEE512 emulator : create a disc image, copy these files on to the disc image, and then load.

All sources can be re-assembed using the origin of  'ORG $900' and renaming the resulting object code to a '.BEE' extension.
These can then also be loaded into UBEE512 emulator.

Most of Shiru's engines are assembled with SJASMPLUS, whilst the others were intended for assembling with PASMO assembler. ( All source code that does not have ' OUTPUT "FILENAME.COM" ' as the first statement will be for PASMO). 

Pasmo Assembler can be found somewhere deep within a ZX website; simply google it and you'll find the windows and/or Linux executable. Same with SJASMPLUS.


All credit go to the originators of the related source code.
Huge thanks to Utz and Shiru; masters of 1-bit Z80 music coding.


For more info, check out the 1-bit music forum over at : http://randomflux.info/1bit/

Find and download/install Shiru's '1tracker' 1-bit music tracking software for Win/Linux. Create your own 1-bit music that also can be played on the ZX/ VZ / Microbee.
See this thread:  http://randomflux.info/1bit/viewtopic.php?id=24

1tracker x32   : http://shiru.untergrund.net/files/1tracker.zip   

1tracker x64   : http://shiru.untergrund.net/files/1tracker_x64.zip  

1tracker build for linux : http://shiru.untergrund.net/files/1tracker_src.zip  

Beepola tracker  : http://freestuff.grok.co.uk/beepola/

Bin Tracker      : https://bintracker.org


'Lets Go' by Shiru has got to be the best 1-bit music tune released yet.

https://youtu.be/HLj5PDpigEw								  A real VZ-300 playing 'Lets Go'

https://www.youtube.com/watch?v=Jil6W1oLxzo   Microbee emulator playing 'Lets Go'

https://www.youtube.com/watch?v=JU2Qv_bwOPg	  Microbee emulator playing 'Standing Wave'

https://www.youtube.com/watch?v=wF3dtUdJbnc		Microbee emulator playing 'Catching Up'



