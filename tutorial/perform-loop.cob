*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-02-11/00:18-0500 btiffin
      *>
      *> Tectonics:
      *>   cobc -xj perform-loop.cob
      *>+<*
      *>
      *> perform-loop.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. perform-loop.

       data division.
       working-storage section.
       01 counter              pic 9   value 1.

       procedure division.

      *> normal flow starts here
       display counter
 
      *> loop using a procedure subroutine
       perform increment-counter until counter > 7
    
      *> show the result
       display counter

      *> return to the to the operating system
       goback.

      *> a named paragraph 
       increment-counter.
           add 1 to counter
       .

       end program perform-loop.
