      *>-<*
      *> Author: Brian Tiffin
      *> Licensed under the GNU AGPL version 3 or later
      *>
      *> Date started: April 2017
      *> Modified: 2017-04-21/06:18-0400 btiffin
      *>+<*
      *>
      *> callmumps.cob, integrate FIS-GT.M MUMPS
      *> Tectonics:
      *>     requires GT.M demo setup and gtm_access.ci
      *>     cobc -xj callmumps.cob
      *>
       >>SOURCE FORMAT IS FREE
       identification division.
       program-id. callmumps.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 gtm-message-len constant as 2048.
       01 gtm-status usage binary-long.
       01 gtm-message pic x(gtm-message-len).
       
       01 gtm-error pic x(2048).
       01 err-key pic x(10).

       01 env pic x(2048).
       01 home pic x(2048).
       01 pwd pic x(2048).

       01 data-key occurs 3 times.
          05 filler pic x(32).
       01 data-value occurs 3 times.
          05 data-length usage binary-c-long.
          05 data-address usage pointer.
          05 data-cobol pic x(16).

       01 mumps-key pic x(32).
       01 mumps-value.
          05 mumps-length usage binary-c-long.
          05 mumps-address usage pointer.
          05 mumps-buffer pic x(16).

       01 gtm-zversion.
          05 value 'write $zversion,!'.
       01 gtm-zsystem.
          05 value 'zsystem "'.
       01 gtm-lke.
          05 value 'lke show"'.
       01 gtm-command pic x(256).

       procedure division.
       callmumps-main.
  
      *> Set up GT.M environment variables
       move all spaces to env
       accept env from environment "gtm_dist"
       if env equals spaces then
           set environment "gtm_dist" to
           "/usr/lib/x86_64-linux-gnu/fis-gtm/V6.2-002A-2build1_x86_64"
       end-if

       move all spaces to env
       accept env from environment "gtmgbldir"
       if env equals spaces then
           accept home from environment "HOME"
           set environment "gtmgbldir" to concatenate(
               trim(home) "/.fis-gtm/V6.2-002A_x86_64/g/gtm.gld")
       end-if
       
       move all spaces to env
       accept env from environment "gtmroutines"
       if env equals spaces then
           accept home from environment "HOME"
           move module-path to pwd
           move rexx("return filespec('PATH', arg(1))", pwd) to pwd
           accept env from environment "gtm_dist"
           set environment "gtmroutines" to concatenate(
               trim(pwd)
               space trim(home) "/.fis-gtm/V6.2-002A_x86_64/r"
               space trim(env) "/libgtmutil.so"
               space trim(env))
       end-if

       move all spaces to env
       accept env from environment "GTMCI"
       if env equals spaces then
           move module-path to pwd
           move rexx("return filespec('PATH', arg(1))", pwd) to pwd
           set environment "GTMCI" to concatenate(
               trim(pwd) "/gtm_access.ci")
       end-if

       move all spaces to env
       accept env from environment "gtmdir"
       if env equals spaces then
           accept home from environment "HOME"
           set environment "gtmdir" to concatenate(
               trim(home) "/.fis-gtm")
       end-if

       move all spaces to env
       accept env from environment "gtmver"
       if env equals spaces then
           set environment "gtmver" to "V6.2-002A_x86_64"
       end-if

      *> Initialize the GT.M runtime
       call "gtm_init" returning gtm-status
           on exception display "no gtm_init" upon syserr end-display
       end-call
       move "gtm_init:" to err-key
       perform gtm-error-test

      *> Enable the access routines, via the gtm_access.ci file       
       call "gtm_ci" using "gtminit" gtm-error returning gtm-status
           on exception display "no gtm_ci" upon syserr end-display
       end-call
       move "gtminit:" to err-key
       perform gtm-error-test

      *> prep some data
       move z'^Capital("Canada")' to data-key(1)
       move z"Ottawa" to data-cobol(1)
       set data-address(1) to address of data-cobol(1)
       move length(trim(data-cobol(1))) to data-length(1)

       move z'^Capital("United States")' to data-key(2)
       move z"Washington" to data-cobol(2)
       set data-address(2) to address of data-cobol(2)
       move length(trim(data-cobol(2))) to data-length(2)

       move z'^Capital("Mexico")' to data-key(3)
       move z"Mexico City" to data-cobol(3)
       set data-address(3) to address of data-cobol(3)
       move length(trim(data-cobol(3))) to data-length(3)
       
      *> Set some values
       move "gtmset:" to err-key
       perform varying tally from 1 by 1 until tally > 3
           call "gtm_ci" using "gtmset"
               data-key(tally) data-value(tally) gtm-error
               returning gtm-status
           end-call
           perform gtm-error-test
       end-perform

      *> Get a value
       display space
       display "Retrieve a capital city"
       move z'^Capital("United States")' to mumps-key
       set mumps-address to address of mumps-buffer
       move length(mumps-buffer) to mumps-length
       
       call "gtm_ci" using "gtmget" mumps-key mumps-value gtm-error
           returning gtm-status
       end-call
       move "gtmget:" to err-key
       perform gtm-error-test

       display mumps-length ", " 
               trim(substitute(mumps-buffer x"00" space))
       call "printf" using ":%.*s:" & x"0a00"
           by value mumps-length mumps-address

      *> grab a lock
       call "gtm_ci" using "gtmlock" "+^CIDemo($Job)" gtm-error
           returning gtm-status
       end-call
       move "gtmlock:" to err-key
       perform gtm-error-test

      *> interpret some MUMPS
       display space
       accept env from environment "gtm_dist"
       move concatenate(gtm-zversion space
                        gtm-zsystem trim(env) "/" gtm-lke x"00")
         to gtm-command
       display "Execute: " trim(substitute(gtm-command x"00" space))
       call "gtm_ci" using "gtmxecute" trim(gtm-command) gtm-error
           returning gtm-status
       end-call
       move "gtmxecute:" to err-key
       perform gtm-error-test

      *> clean up the demo storage
       display space
       display "Remove Capital data, then demonstrate error"

       call "gtm_ci" using "gtmkill" z"^Capital" gtm-error
           returning gtm-status
       end-call
       move "gtmkill:" to err-key
       perform gtm-error-test

      *> Get a value, which will fail as ^Capital is gone
       move z'^Capital("Canada")' to mumps-key
       move spaces to mumps-buffer
       move length(mumps-buffer) to mumps-length
       
       call "gtm_ci" using "gtmget" mumps-key mumps-value gtm-error
           returning gtm-status
       end-call
       move "gtmget:" to err-key
       perform gtm-error-test

      *> show an actual error message       
       perform gtm-error-display

      *> run down GT.M
       call "gtm_exit" returning gtm-status
           on exception display "no gtm_exit" upon syserr
       end-call
       move "gtm_exit:" to err-key
       perform gtm-error-test

      *> put up warning about tty settings
       display space
       display "GT.M engine will leave terminal in a custom state:"
       display "  ** use 'stty sane' or 'reset' to normalize **"
       goback.

      *> ****************
       gtm-error-test.
       if gtm-status not equal zero then
           display err-key space gtm-status trim(gtm-error) upon syserr
           call "gtm_zstatus" using gtm-message by value gtm-message-len
           display trim(substitute(gtm-message x"00" space)) upon syserr
       end-if
       .

       gtm-error-display.
       display err-key space gtm-status trim(gtm-error) upon syserr
       call "gtm_zstatus" using gtm-message by value gtm-message-len
       display trim(substitute(gtm-message x"00" space)) upon syserr
       .

       end program callmumps.
