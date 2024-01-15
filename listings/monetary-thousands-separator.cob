      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2019
      *> Modified: 2019-01-26/20:58-0500 btiffin
      *>+<*
      *>
      *> monetary-thousands-separator.cob
      *> Tectonics: cobc -xj monetary-thousands-separator.cob
      *>
       >>SOURCE FORMAT IS FIXED
       identification division.
       program-id. monetary-thousands-separator.

       procedure division.
       demonstrate-intrinsic.

       display "FUNCTION MONETARY-THOUSANDS-SEPARATOR is """
           function monetary-thousands-separator """, character code "
           function ord(function monetary-thousands-separator)
       end-display
       .

       goback.
       end program monetary-thousands-separator.
