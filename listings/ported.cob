      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Started: February 2017
      *> Modified: 2017-04-21/14:55-0400 btiffin
      *>+<*
      *>
      *> ported.cob, for use with Elixir and iex
      *>
      *> tectonics:
      *>   cobc -x ported.cob
      *>   iex> port = Port.open({:spawn, "./ported"}, [:binary])
      *>   iex> Port.command(port, "info 123\n")
      *>
       identification division.
       program-id. ported.
       author. Brian Tiffin.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 incoming pic x(32).
       01 data-flag    pic x.
          88 nodata    value low-values when set to false high-values.
       01 newline      pic xx value x"0d0a".

       01 command      pic x(32).
          88 exiting   value "exit".
          88 crashing  value "crash".
          88 infoing   value "info".
          88 statusing value "status".

       01 arg          pic x(32).
       01 dl           pic x occurs 2 times.

       01 void         pic x(4) value "void" based.
       01 attempts     usage binary-long.
       01 unknowns     usage binary-long.
      
       procedure division.
       start-ported.
      *> display "COBOL: In ported" newline upon syserr
       set nodata to false
       accept incoming on exception set nodata to true end-accept

       perform until nodata
           move substitute(incoming x"00" space x"0a" space) to incoming
      *>   display "COBOL: accepted " trim(incoming) newline upon syserr
           move spaces to command arg
           unstring incoming
               delimited by all space or all "," or x"0a"
               into command delimiter in dl(1)
                    arg     delimiter in dl(2)

           add 1 to attempts
           evaluate true
               when exiting
                   exit perform
               when crashing
                   set address of void to null
                   display void
               when statusing
                   display "Attempts: " attempts ", Errors: ", unknowns
               when infoing
                   if arg equals space then
                       display "Customer list..."
                   else
                       display "Customer " trim(arg) ": info"
                   end-if
               when other
                   add 1 to unknowns
           end-evaluate

           set nodata to false
           accept incoming on exception set nodata to true end-accept
       end-perform
      *> display "COBOL: Out ported" newline upon syserr

       goback.
       end program ported.
