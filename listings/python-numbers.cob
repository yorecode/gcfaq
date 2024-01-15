       identification division.
       program-id. numbers.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 result pic s9(9).

       procedure division.
       display ":" python("print(6 * 7 * -1)") ":"
       
       move python("result = 6 * 7 * -1") to result
       display ":" result ":"

       display ":" python("result = {'value': 6 * 7 * -1}") ":"
       goback.
       end program numbers.
