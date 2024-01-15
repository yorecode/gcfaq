GCobol >>SOURCE FORMAT IS FREE
>>IF docpass NOT DEFINED
      *>-<*
      *> ***************************************************************
      *>****J* gnucobol/intrinsic-rexx
      *> AUTHOR
      *>   Brian Tiffin
      *> DATE
      *>   20170307  Modified: 2017-03-12/19:24-0400 btiffin
      *> LICENSE
      *>   Copyright 2017 Brian Tiffin
      *>   GNU Lesser General Public License, LGPL, 3.0 (or superior)
      *> PURPOSE
      *>   Embedded Rexx in GnuCOBOL
      *> TECTONICS
      *>   cobc -xj -g -debug intrinsic-rexx.cob
      *> ***************************************************************
      *>+<*
       identification division.
       program-id. intrinsic-rexx.
       author. Brian Tiffin.
       date-written. 2017-03-07/03:42-0500.
       date-modified. 2017-03-12/19:24-0400.
       date-compiled.
       installation. Requires a build with --with-rexx and libregina.
       remarks. Rexx source evaluation, ALPHANUMERIC field returned.
       security. An embedded interpretter, use trusted sources.

       REPLACE ==newline== BY ==& x"0a" &==.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.
       01 answer pic 9(5).

      *> ***************************************************************
       procedure division.

      *> Hello, with an argument passed to Rexx
       perform 2 times
       display rexx("say 'Hello, REXX';" &
                    " parse arg a1; say arg(); say a1;" &
                    " return 'Hello, COBOL';", "test")
       end-perform
       display space

      *> invalid script data type
       display ":" rexx(1, 2) ":"
       perform soft-exception
       display space

      *> More arguments
       display rexx("say 'Hello, a second time';" &
                    " parse arg a1, a2, a3;" &
                    " say arg() a1 a2 a3;" &
                    " return 'Hello, again';", 1, 2, "abc")
       display space

      *> a little bit of realistic Rexx
       move rexx("delim = ';'" newline
           "parse arg theline" newline
           "do i = 1 by 1 while theline <> '' " newline
           "    parse var theline w.i (delim) theline" newline 
           "end" newline
           "w.0 = i - 1" newline
           "do i = 1 to w.0" newline
           "    say w.i" newline
           "end" newline
           "return w.0",
           "this;is;a;test;of;parsing;to;a;stem;variable")
         to answer
       display answer " components"
       display space

      *> Some math
       move rexx("return arg(1) * 6", 7) to answer
       display "Ultimate answer: " answer
       display space
  
      *> One way of sharing value between scripts is to use the stack
       display rexx(
           "a = 'abc'" newline
           "push a" newline
           "return a")
       display rexx(
           "pull a" newline
           "return a || 'def'")

      *> Some REXX date and string formatting features
       display rexx( 
           "/* get year, month, and day of month */" newline
           "parse value date('Standard') with yr 5 ." newline
           "return right(time( 'Civil'), 8)," newline
           " || center(date('Month'), 38)," newline
           " || substr(yr, 3)'.'right(date('Dayofyear'), 3, '0')")
 
      *> And a system command
       display rexx("address SYSTEM; 'ls *.cob'; return 'Nice'")
       
       goback.
      *> ***************************************************************

       REPLACE ALSO ==:EXCEPTION-HANDLERS:== BY
       ==
      *> informational warnings and abends
       soft-exception.
         display space upon syserr
         display "--Exception Report-- " upon syserr
         display "Time of exception:   " current-date upon syserr
         display "Module:              " module-id upon syserr
         display "Module-path:         " module-path upon syserr
         display "Module-source:       " module-source upon syserr
         display "Exception-file:      " exception-file upon syserr
         display "Exception-status:    " exception-status upon syserr
         display "Exception-location:  " exception-location upon syserr
         display "Exception-statement: " exception-statement upon syserr
       .

       hard-exception.
           perform soft-exception
           stop run returning 127
       .
       ==.

       :EXCEPTION-HANDLERS:

       end program intrinsic-rexx.
      *> ***************************************************************
      *>****
>>ELSE
!doc-marker!
==============
intrinsic-rexx
==============

.. contents::

Introduction
------------
Embedding Regina Rexx as a GnuCOBOL "intrinsic" function.

Tectonics
---------

::

    prompt$ ./configure --with-rexx
    prompt$ make
    prompt$ make check
    prompt$ sudo make install
    prompt$ sudo ldconfig

    prompt$ cobc -xj intrinsic-rexx.cob

Usage
-----

See http://regina-rexx.sourceforge.net/ for all the details of programming
with Regina Rexx.

Use rexx("script", ["args"...,]) as you would any other GnuCOBOL intrinsic
function (that returns an ALPHANUMERIC field).  For use with computational
COBOL verbs, wrap the REXX() function in NUMVAL().

.. codeblock:: cobolfree

    MOVE rexx("return arg(1) * arg(2)", 6, 7) TO answer
    COMPUTE answer = numval(rexx("return 42")) 
    

Source
------

.. include::  intrinsic-rexx.cob
   :code: cobolfree
>>END-IF
