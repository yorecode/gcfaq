      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: March 2017
      *> Modified: 2021-09-21/19:43-0400 btiffin
      *>
      *> Requires a version of GnuCOBOL --with-rexx (and curl command)
      *> Tectonics: cobc -x -j=url curl-it.cob 
      *>+<*
      *> curl-it.cob, fetch a web resource and push lines to REXX stack
       identification division.
       program-id. curl-it.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       REPLACE ==newline== BY ==& x'0a' &==.

       data division.
       working-storage section.
       01 url              pic x(80).
       01 rexx-rc          pic 9(9).
       01 rexx-data        pic x(2048).

       procedure division.
       curl-it-main.

       accept url from command-line
       if url equal spaces then
           move "google.ca" to url
       end-if
       move rexx-unrestricted(
           "/* argument from parameter list */"                 newline
           "url = ARG(1)"                                       newline
           "/* use curl to read the url and queue results */"   newline
           "address system" &
           " 'curl -s -L' url with output stem data."           newline
           "do i = 1 to data.0"                                 newline
           "    queue data.i"                                   newline
           "end"                                                newline
           "push data.0; return data.0", trim(url))
         to rexx-rc
       display "<!- " rexx-rc " lines read from " trim(url) " ->"

      *> We already have rexx-rc with the item count
      *> Demonstrate nesting intrinsics to show the item count again 
       display trim(rexx("pull data.0; return '<!-' data.0 '->'"))

      *> Now we have a FIFO queue of data lines
      *> Skip some and show some

      *> pull will wait for data from stdin if there is no queue
       perform varying tally from 1 by 1 until tally > 40 or rexx-rc
           move rexx(
               "if queued() > 0 then"                           newline
               "    pull dataline"                              newline
               "else"                                           newline
               "    dataline = 'queue empty'"                   newline
               "return dataline")
             to rexx-data
       end-perform

       perform varying tally from tally by 1 until tally > rexx-rc
           move rexx(
               "if queued() > 0 then"                           newline
               "    pull dataline"                              newline
               "else"                                           newline
               "    dataline = 'queue empty'"                   newline
               "return dataline")
             to rexx-data
           display trim(rexx-data)
       end-perform
 
       goback.
       end program curl-it.
