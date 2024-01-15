      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: August 2017
      *> Modified: 2017-08-14/19:29-0400 btiffin
      *>+<*
      *>
      *> xforms-clock.cob, demonstrate some clock objects
      *> Tectonics: cobc -xj xforms-clock.cob -lforms
      *>
       >>SOURCE FORMAT IS FREE
       identification division.
       program-id. sample.

       environment division.
       configuration section.
       repository.
           function all intrinsic.

       data division.
       working-storage section.

       COPY xforms.

       01 argc                         usage binary-long.
       01 argv                         usage pointer.

       01 form                         usage pointer.
       01 form-box                     usage pointer.
       01 clock-forms.
          05 clock-form                usage pointer occurs 4 times.
       01 exit-button                  usage pointer.
       01 form-button                  usage pointer.

       01 xforms-window                usage binary-long.
       01 xforms-display               usage pointer.

       01 close-callback               usage program-pointer.
       01 close-install-status         usage binary-long.

       01 hour                         usage binary-long.
       01 minute                       usage binary-long.
       01 second                       usage binary-long.
       01 show-hour                    pic 99.
       01 show-minute                  pic 99.
       01 show-second                  pic 99.

       procedure division.
       sample-main.
       call "CBL_GC_HOSTED" using argc "argc"
       call "CBL_GC_HOSTED" using argv "argv"

       call "fl_initialize" using argc argv z"XForms" NULL by value 0
           returning xforms-display
           on exception
               display
                   "Error: no XForms (-lforms)" upon syserr
               end-display
               goback
       end-call

      *> let GnuCOBOL control image shutdown from system menu
       set close-callback to entry "xforms-close"
       if close-callback not equal null then
           call "fl_set_atclose" using
               by value close-callback
               by reference NULL
               returning close-install-status
       else
           display "XForms close will terminate program" upon syserr
       end-if

       call "fl_bgn_form" using by value FL-UP-BOX 460 350
           returning form
       
       call "fl_add_box" using
           by value FL-UP-BOX 0 0 460 350
           by reference NULL
           returning form-box
   
       call "fl_add_clock" using
           by value FL-ANALOG-CLOCK 5 5 220 200
           by reference "Analog with seconds"
           returning clock-form(1)
      
       call "fl_add_clock" using
           by value FL-ANALOG-CLOCK 280 55 110 100
           by reference "Analog without seconds"
           returning clock-form(2)

      *> local patch
       call "fl_set_clock_hide_seconds" using
           by value clock-form(2) 1
           on exception continue
       end-call

       call "fl_add_clock" using
           by value FL-DIGITAL-CLOCK 65 240 100 35
           by reference "Digital with seconds"
           returning clock-form(3)
       call "fl_set_object_color" using
           by value clock-form(3) FL-COL1 FL-BLACK

       call "fl_add_clock" using
           by value FL-DIGITAL-CLOCK 290 240 100 35
           by reference "Digital am/pm"
           returning clock-form(4)
       call "fl_set_clock_hide_seconds" using
           by value clock-form(4) 1
           on exception continue
       end-call

       call "fl_set_clock_ampm" using
           by value clock-form(4) 1
       call "fl_set_object_color" using
           by value clock-form(4) FL-COL1 FL-BLACK
       call "fl_set_object_lsize" using
           by value clock-form(4) FL-MEDIUM-SIZE
       call "fl_set_object_lstyle" using 
           by value clock-form(4) FL-BOLD-STYLE

       call "fl_add_button" using
           by value FL-NORMAL-BUTTON 190 300 80 30
           by reference z"Exit"
           returning exit-button

       call "fl_end_form" returning omitted 

       call "fl_show_form" using
           by value form FL-PLACE-MOUSE FL-TRANSIENT
           by reference "Clocks"
           returning xforms-window
       call "fl_do_forms" returning form-button
       
       call "fl_get_clock" using
           by value clock-form(1)
           by reference hour minute second
       move hour to show-hour
       move minute to show-minute
       move second to show-second
       display "Exited at: " show-hour ":" show-minute ":" show-second

       call "fl_finish" returning omitted 
       goback.

       end program sample.
      *> ***************************************************************

      *> Give process rundown control to GnuCOBOL
       identification division.
       program-id. xforms-close.

       environment division.
       configuration section.
       special-names.
           call-convention 0 is extern.
   
       data division.
       working-storage section.
       01 FL-IGNORE constant as -1.

       linkage section.
       01 xform usage pointer.
       01 close-data usage pointer.

       procedure division extern using
           by value xform close-data.

      *> IGNORE close or just stop run, otherwise XForms calls exit()
       move FL-IGNORE to return-code
       stop run.

       end program xforms-close.
     *> ***************************************************************
