*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-29/17:28-0500
      *>
      *> Tectonics:
      *>   cobc -x just-if-symbols.cob
      *>   ./just-if-symbols
      *>+<*
      *>
      *> just-if-symbols.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. just-if-symbols.

       data division.
       working-storage section.
       01 result               pic 999.

       procedure division.

       compute result = 6 * 7

       if result < 100 then
           display "The ultimate answer seems reasonable: " result
       end-if

       if result > 100 then
           display "There is something wrong with the universe: " result
       end-if

       goback.
       end program just-if-symbols.
