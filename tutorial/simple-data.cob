GCOBOL*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-29/12:34-0500
      *>
      *> Tectonics:
      *>   cobc -x simple-data.cob
      *>   ./simple-data
      *>+<*
      *>
      *> simple-data.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. simple-data.

       data division.
       working-storage section.
       01 program-message      PIC X(64).
       01 answer               PIC 99.

       procedure division.

       move "simple-data.cob example" to program-message
       display program-message

       move "compute 6 times 7" to program-message
       display program-message

       move "answer is:" to program-message
       display program-message

       compute answer = 6 * 7.
       display answer

       goback.
       end program simple-data.
