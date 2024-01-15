GCOBOL*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-29/15:08-0500
      *>
      *> Tectonics:
      *>   cobc -x goloop.cob
      *>   ./goloop
      *>+<*
      *>
      *> goloop.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. goloop.

       data division.
       working-storage section.
       01 counter              pic 9   value 1.

       procedure division.

       loop-here.

           display counter
           add 1 to counter
           if counter < 4 then GO TO loop-here end-if
       .

       goback.
       end program goloop.
