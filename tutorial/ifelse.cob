*>GCOB >>SOURCE FORMAT IS FREE
      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-29/17:27-0500
      *>
      *> Tectonics:
      *>   cobc -xj ifelse.cob
      *>+<*
      *>
      *> ifelse.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. ifelse.

       data division.
       working-storage section.
       01 result               pic 99.

       procedure division.

       multiply 6 by 7 giving result

       if result equals 42 then
           display "The ultimate answer is still " result
       else
           display "There is something wrong with the universe: " result
       end-if

       goback.
       end program ifelse.
