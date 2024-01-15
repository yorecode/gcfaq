      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: April 2017
      *> Modified: 2017-04-12/10:27-0400 btiffin
      *>+<*
      *>
      *> REXX character translation, only return characters in arg 2
      *> Tectonics: cobc -xj only.cob
      *>
       identification division.
       program-id. only.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       REPLACE ==newline== BY ==& x'0a' &==.

       data division.
       working-storage section.
      *> translate only the given characters, effectively a filter
       01 rexx-only.
          05 value "only: return space(translate(arg(1),," &
                   "translate(xrange(),,arg(2))),0)"       newline
                   "return only(arg(1), arg(2))".
     
       procedure division.
       only-main.
      *> only digits
       display rexx(rexx-only,
                    "1997-01-01 was a great day", "0123456789")

      *> only vowels
       display rexx(rexx-only,
                    "1997-01-01 was a great day", "aeiouy")
       goback.
       end program only.
