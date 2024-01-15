*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: February 5th, 2017
      *> Modified: 2017-02-07/16:42-0500 btiffin
      *>+<*
      *>
      *> callpascal.cob, Pascal integration with GnuCOBOL
      *>
      *> Tectonics:
      *>   fpc -CD hellofpc.pp  
      *>   LD_RUN_PATH=. cobc -xj callpascal.cob -L. -l:libhellofpc.so
      *>
       identification division.
       program-id. callpascal.

       procedure division.
       callfpc-main.

       call "HelloFpc" using by value 42 end-call
       display "fpc returned: " return-code
       move zero to return-code

       goback.
       end program callpascal.
