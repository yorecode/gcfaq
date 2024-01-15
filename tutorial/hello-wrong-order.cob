GCOBOL*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2017
      *> Modified: 2017-01-27/06:04-0500
      *>
      *> Tectonics:
      *>   cobc -x hello-wrong-order.cob
      *>+<*
      *>
      *> hello-wrong-order.cob, GnuCOBOL FAQ tutorial error example
      *> This program will NOT compile properly, divisions out of order
      *>
       procedure division.
       display "Hello, world"
       goback.

       identification division.
       program-id. hello-wrong.

       end program hello-wrong.
