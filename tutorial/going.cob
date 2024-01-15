*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2018-07-21/03:27-0400 btiffin
      *>
      *> Tectonics:
      *>   cobc -x going.cob
      *>   ./going
      *>+<*
      *>
      *> going.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. going.

       data division.
       working-storage section.
       01 counter              pic 9   value 1.

       procedure division.

      *> normal flow starts here
       display counter
 
      *> then jumps
       go to the-bottom
    
      *> this is dead code, never executed
       display "Why am I even here?"

      *> the following full stop is required so that GnuCOBOL
      *> knows that this part of the program is terminated and to allow
      *> the next named paragraph to be recognized.
       .

      *> a named paragraph 
       the-bottom.
           display "Jumped to the-bottom"

           *> return to the caller, in this case the operating system
           goback.

       end program going.
