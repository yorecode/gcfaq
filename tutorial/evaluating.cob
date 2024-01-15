*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-30/01:15-0500
      *>
      *> Tectonics:
      *>   cobc -x evaluating.cob
      *>   ./evaluating
      *>+<*
      *>
      *> evaluating.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. evaluating.

       data division.
       working-storage section.
       01 first-field           pic 9.
       01 second-field          pic X.

       procedure division.

       move 1 to first-field
       move "C" to second-field

      *> inside a when conditional, the subject need not be mentioned
       evaluate first-field also second-field
           when = 1         also = "A"
               display "1A"
           when = 1         also = "B"
               display "1B"
           when = 1         also = "C"
               display "1C"
               display "This is the when block that executes"
           when = 1         also any
               display "This is also true, but the first one wins"
           when other
               perform no-matches
       end-evaluate

       goback.

       no-matches.
           display "No matches found: " first-field ", " second-field
       .
       end program evaluating.
