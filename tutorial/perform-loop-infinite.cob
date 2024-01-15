*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-02-11/01:12-0500 btiffin
      *>
      *> Tectonics:
      *>   cobc -xj perform-loop-infinite.cob
      *>+<*
      *>
      *> perform-loop-infinite.cob, infinite loop error
      *>
       identification division.
       program-id. perform-loop-infinite.

       data division.
       working-storage section.
       01 counter              pic 9   value 1.

       procedure division.

       display counter
 
      *> loop will never terminate, counter limited to max of nine.
       perform increment-counter until counter > 10
    
      *> show the result, which will never happen
       display counter

      *> return to the to the operating system, never happens
       goback.

      *> this add could have an ON SIZE ERROR clause
       increment-counter.
           add 1 to counter
       .

      *> this program will need operator intervention
       end program perform-loop-infinite.
