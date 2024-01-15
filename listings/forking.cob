*>GCOB*>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: February 5th, 2017
      *> Modified: 2017-02-05/13:52-0500 btiffin
      *>+<*
      *>
      *> forking.cob, CBL_GC_FORK example
      *>
      *> Tectonics:
      *>   cobc -xj forking.cob
      *>
       identification division.
       program-id. forking.

       data division.
       working-storage section.
       01 return-pid           usage binary-long.
       01 wait-status          usage binary-long.

       01 copied-value         pic 9   value 7.

       procedure division.
       display "Forking"

      *> When the process forks, two processes will be running, at a
      *> point of execution of the "returning return-pid" part. 
       call "CBL_GC_FORK" returning return-pid

      *> all code from now on is being executed by two processes
      *> unless an error occurred and there is no child

      *> unlike fork(), GnuCOBOL uses -2 to mean not supported and
      *>                              -1 when fork() fails
       if return-pid < zero then
           display "forking error: " return-pid upon syserr
       else
           display "**Both processes evaluate this line ", return-pid
       end-if

       if return-pid equal zero then
      *> child will now branch off from the main control flow
           go to child-task
       end-if

      *> When the parent process exits, the child will be reaped as well
       display "This is still the original process: " return-pid
       display "Parent: copied value is: " copied-value
       add 1 to copied-value
       display "Parent: copied-value is now: " copied-value

      *> To ensure the child gets a chance to finish, waitpid is used
       call "CBL_GC_WAITPID" using return-pid returning wait-status
       display "Parent: status value from child: " wait-status
       display "Parent: copied-value is still: " copied-value
       display "Parent: leaves the building"
      *> libcob internals also set the parent return-code field
      *> during the call to CBL_GC_WAITPID (reset it to zero).
       move 0 to return-code
       goback.

      *> ********
      *> NOTE: this is not a thread, but is a separate process
      *>       evaluating an identical copy of the code as the parent
       child-task.
       display "    This is a new process space, a child"
       display "    Child: copied value is: " copied-value
       subtract 1 from copied-value
       display "    Child: copied-value is now: " copied-value

      *> exit the child process with a status value of 42
       display "    Child: leaves the building, setting return-code"
       move 42 to return-code
       goback.
       end program forking.
