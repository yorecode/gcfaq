      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: June 2018
      *> Modified: 2018-10-03/05:42-0400 btiffin
      *>+<*
      *>
      *> Simple windowed application
      *> Tectonics:
      *>   cobc -xj swapp.cob cobweb-agar.cob `agar-config --libs`
      *>
       >>SOURCE FORMAT IS FIXED
       identification division.
       program-id. swapp.

       environment division.
       configuration section.
       repository.
           function agar-window
           function agar-box
           function agar-label
           function agar-button
           function agar-windowshow
           function agar-eventloop
           function all intrinsic.

       data division.
       working-storage section.
       01 window-positions.
          05 AG-WINDOW-CENTER          usage binary-long value 5.

       01 AG-NOFLAGS                   usage binary-long value 0.
       01 AG-WINDOW-SHOW               usage binary-long value 1.

       01 AG-BOX-HORIZ                 usage binary-long value 0.
       01 AG-BOX-EXPAND                usage binary-long value 6.

       01 AG-LABEL-EXPAND              usage binary-long value 3.

       01 agar-window-record.
          05 agar-win usage pointer.
    
       01 agar-box-record.
          05 agar-box-widget usage pointer.
    
       01 agar-label-record.
          05 agar-label-widget usage pointer.

       01 agar-button-record.
          05 agar-button-widget usage pointer.

       01 rc usage binary-long.

       01 total-clicks-plural.
          05 total-click-display.
             10 value "There have been ".
             10 total-clicks pic 9(6).
             10 value " click".
          05 value "s ".

       linkage section.
       01 event usage pointer.

       procedure division.
       simple-main.

       move agar-window(AG-WINDOW-CENTER, numval(280), numval(32),
                        "Click counter") to agar-window-record

       move agar-box(agar-win, AG-BOX-HORIZ, AG-BOX-EXPAND)
         to agar-box-record

       move agar-label(agar-box-widget, AG-LABEL-EXPAND,
            "There have been no clicks yet") to agar-label-record

       move agar-button(agar-box-widget, AG-NOFLAGS, "click me",
                        "upclick", "buttonname", numval(1))
         to agar-button-record

       move agar-windowshow(agar-win, AG-WINDOW-SHOW) to rc
       move agar-eventloop to rc

       goback.

      *> internal entry point for event callback
       entry "upclick" using by value event.
           add 1 to total-clicks
           if total-clicks equal 1
               *> tweaking a literal for sake of grammar and spelling
               inspect total-click-display
                   replacing all "have" by "has "
               call "AG_LabelTextS" using
                   by value agar-label-widget
                   by content concatenate(total-click-display, x"00")
                   returning omitted
               end-call
               inspect total-click-display
                   replacing all "has " by "have"
           else
               call "AG_LabelTextS" using
                   by value agar-label-widget
                   by content concatenate(total-clicks-plural, x"00")
                   returning omitted
               end-call
           end-if

       goback.
       end program swapp.
