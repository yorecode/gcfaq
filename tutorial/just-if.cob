*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-02-02/12:22-0500 btiffin
      *>
      *> Tectonics:
      *>   cobc -x just-if.cob
      *>   ./just-if
      *>+<*
      *>
      *> just-if.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. just-if.

       data division.
       working-storage section.
       01 result               pic 999.

       procedure division.

       multiply 6 by 7 giving result

       if result is less than 100 then
           display "The ultimate answer seems reasonable: " result
       end-if

       if result is greater than or equal to 100 then
           display "There is something wrong with the universe: " result
       end-if

       goback.
       end program just-if.
