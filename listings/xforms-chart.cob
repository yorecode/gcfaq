      *>-<*
      *> Author: Brian Tiffin
      *> Dedicated to the public domain
      *>
      *> Date started: August 2017
      *> Modified: 2017-08-29/22:20-0400 btiffin
      *>+<*
      *>
      *> xforms-chart.cob, demonstrate a bar chart
      *> Tectonics: cobc -xj xforms-chart.cob -lforms
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

       01 base-colour                  pic 999.

       01 form                         usage pointer.
       01 form-box                     usage pointer.

       01 chart-objects.
          05 chart-object              usage pointer occurs 4 times.

       01 items                        constant as 12.
       01 chart-items.
          05 chart-item                occurs items times.
             10 chart-name             pic x(16).
             10 chart-value            usage float-long.
             10 chart-colour           usage binary-long.

       01 exit-button                  usage pointer.
       01 form-button                  usage pointer.

       01 xforms-window                usage binary-long.
       01 xforms-display               usage pointer.

       01 close-callback               usage program-pointer.
       01 close-install-status         usage binary-long.

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

      *> fill in some chart data
       move "Jan" to chart-name(1)
       move 23.23 to chart-value(1)

       move "Feb" to chart-name(2)
       move 42.42 to chart-value(2)

       move "Mar" to chart-name(3)
       move 64.64 to chart-value(3)

       move "Apr" to chart-name(4)
       move 13.13 to chart-value(4)

       move "May" to chart-name(5)
       move 84.84 to chart-value(5)

       move "Jun" to chart-name(6)
       move 66.66 to chart-value(6)

       move "Jul" to chart-name(7)
       move 77.77 to chart-value(7)

       move "Aug" to chart-name(8)
       move 12.12 to chart-value(8)

       move "Sep" to chart-name(9)
       move 55.55 to chart-value(9)

       move "Oct" to chart-name(10)
       move 99.99 to chart-value(10)

       move "Nov" to chart-name(11)
       move 42.42 to chart-value(11)

       move "Dec" to chart-name(12)
       move 66.66 to chart-value(12)

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

      *> Build a new form to demontrate the chart object
       call "fl_bgn_form" using by value FL-UP-BOX 320 270
           returning form
       
       call "fl_add_box" using
           by value FL-UP-BOX 0 0 320 270
           by reference NULL
           returning form-box

      *> Can be BAR, HORBAR, LINE, FILL, SPIKE, PIE or SPECIALPIE   
       call "fl_add_chart" using
           by value FL-BAR-CHART 5 5 310 200
           by reference "Bar chart"
           returning chart-object(1)
      *> call "fl_set_object_color" using
      *>     by value chart-object(1) FL-BLACK 0
      *> call "fl_set_chart_lcolor" using
      *>     by value chart-object(1) FL-WHITE

      *> stay safe with the incrementing colour range
       compute base-colour = random(form) * random() * 100
       if base-colour > 255 - items then
           compute base-colour = 255 - items
       end-if
       perform varying tally from 1 by 1 until tally > items
           compute chart-colour(tally) = tally + base-colour
           if chart-colour(tally) = FL-BLACK then
               move FL-WHITE to chart-colour(tally)
           end-if
           call "fl_add_chart_value" using
               by value chart-object(1)
               by value chart-value(tally)
               by reference
                   concatenate(trim(chart-name(tally) trailing), x"00")
               by value chart-colour(tally)
       end-perform
      
       call "fl_add_button" using
           by value FL-NORMAL-BUTTON 110 230 80 30
           by reference z"Exit"
           returning exit-button

       call "fl_end_form" returning omitted 

       call "fl_show_form" using
           by value form FL-PLACE-CENTER FL-TRANSIENT
           by reference "Charts"
           returning xforms-window

       call "fl_do_forms" returning form-button
       
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
