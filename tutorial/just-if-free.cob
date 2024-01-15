*>-<*
*> Author: Brian Tiffin
*> Dedicated to the public domain
*>
*> Date started: January 2017
*> Modified: 2017-01-29/14:17-0500
*>
*> Tectonics:
*>   cobc -free -x just-if-free.cob
*>   ./just-if-free
*>+<*
*>
*> just-if-free.cob, GnuCOBOL FAQ tutorial FORMAT FREE example
*>
identification division.
program-id. just-if-free.

data division.
working-storage section.
01 result               pic 999.

procedure division.

multiply 6 by 7 giving result

if result is less than 100 then
    display "The ultimate answer seems reasonable: " result
end-if

if result is greater than 100 then
    display "There is something wrong with the universe: " result
end-if

goback.
end program just-if-free.
