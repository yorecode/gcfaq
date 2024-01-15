*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-29/17:28-0500
      *>
      *> Tectonics:
      *>   cobc -x performing.cob
      *>   ./performing
      *>+<*
      *>
      *> performing.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. performing.

       data division.
       working-storage section.
       01 counter              pic 9   value 1.

       procedure division.

      *> normal flow starts here
       display counter
 
      *> then branches to a procedure, then returns back
       perform increment-counter
    
      *> and carries on with the next line
       display counter

      *> then we return to the caller, in this case the operating system
       goback.

      *> a named paragraph 
       increment-counter.
           add 1 to counter
       .

       end program performing.
