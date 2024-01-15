      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: Februrary 2017
      *> Modified: 2017-02-24/04:25-0500 btiffin
      *>
      *> Tectonics: cobc -m libcobjna.cob
      *>+<*
      *>
      *> Called from Scala via JNA as
      *>   var rc: Int = CobLibrary.Instance.cobjna("data")
      *> 
       identification division.
       program-id. cobjna.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 cli pic x(80).

       linkage section.
       01 args pic x(80).

       procedure division using args.
       cobjna-main.

       display "Hello, from GnuCOBOL at " CURRENT-DATE

      *> Seems JNA does not pass through the command line
       accept cli from command-line
       display "COMMAND-LINE: " trim(cli)

      *> Display the string parameter passed from Scala
       move spaces to cli
       string args delimited by low-value into cli
       display "passed: " trim(cli)

      *> Return the length of the item to Scala
       move length(trim(cli)) to return-code

       goback.
       end program cobjna.
