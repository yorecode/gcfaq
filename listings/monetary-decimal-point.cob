      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: January 2019
      *> Modified: 2019-01-26/20:35-0500 btiffin
      *>+<*
      *>
      *> monetary-decimal-point.cob
      *> Tectonics: cobc -xj monetary-decimal-point.cob
      *>
       >>SOURCE FORMAT IS FIXED
       identification division.
       program-id. monetary-decimal-point.

       procedure division.
       demonstrate-intrinsic.

       display "FUNCTION MONETARY-DECIMAL-POINT is """
           function monetary-decimal-point """, character code "
           function ord(function monetary-decimal-point)
       end-display
       .

       goback.
       end program monetary-decimal-point.
