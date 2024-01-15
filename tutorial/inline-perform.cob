*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-02-11/01:14-0500 btiffin
      *>
      *> Tectonics:
      *>   cobc -xj inline-perform.cob
      *>+<*
      *>
      *> inline-perform.cob, GnuCOBOL FAQ tutorial
      *>
       identification division.
       program-id. inline-perform.

       data division.
       working-storage section.
       01 counter              pic 99.

       procedure division.

      *> an inline perform loop
       perform varying counter from 1 by 1 until counter > 10
           display counter
       end-perform

      *> return to the to the operating system
       goback.
       end program inline-perform.
