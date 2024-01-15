      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: April 2017
      *> Modified: 2017-04-06/08:35-0400 btiffin
      *>+<*
      *>
      *> withpython.cob, embedded Python intrinsic
      *> Tectonics: cobc -xj withpython.cob
      *>
       >>SOURCE FORMAT IS FREE
       identification division.
       program-id. withpython.

       REPLACE ==newline== BY ==& x'0a' &==.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 answer                       pic x(80).       
       
       procedure division.
       sample-main.
       move python(
           "from time import time,ctime"                        newline
           "print('Python: Today is', ctime(time()))"           newline
           " "                                                  newline
           "def func(arg):"                                     newline
           "    return [ctime(time()), arg/2, arg, arg*2]"      newline
           " "                                                  newline
           "result = func(42)") to answer
       display "COBOL: " trim(answer)
       goback.
       end program withpython.
