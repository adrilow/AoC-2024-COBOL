       program-id. Day5 as "Day5".

       environment division.
       
       configuration section.
       
       input-output section.
       file-control.
       
           select input1-file assign to "inputDay5_inputPart1.txt"
               line sequential.
               
           select input2-file assign to "inputDay5_inputPart2.txt"
               line sequential.
               
       data division.
       file section.
       
       
       fd input1-file.
       01 filler.
          05 page-before pic 9(2).
          05 filler pic X.
          05 page-after pic 9(2).
       
       fd input2-file.
       01 filler.
         05 input-page occurs 25 times indexed by k.
           10 page-number pic 9(2).
           10 separator pic X.
          
       
       working-storage section.
       01 ws-eof pic x(1).
       
       01 filler.
           05 filler occurs 100 times.
               10 filler pic X occurs 100 times value '.'.
                   88 y-before-x value 'y'.
                   88 no-order value '.'.

       
       01 result binary-long value 0.
       
       01 print-queue pic 9(2) occurs 25 times indexed by i.
       
       01 current-page pic 9(2).
       01 other-page pic 9(2).
       
       01 swap-value pic 9(2).
       
       01 filler pic X.
           88 line-is-okay value 'y'.
           88 line-not-okay value 'n'.
             
           
       procedure division.

           open input input1-file
               perform until ws-eof='y'
               read input1-file
                   at end move 'y' to ws-eof
                   not at end
                       set y-before-x(page-before, page-after) to true
               end-read
               end-perform.
               move 'n' to ws-eof
           close input1-file.
           
           open input input2-file
               perform varying i from 1 by 1 until ws-eof='y'
               read input2-file
                   at end move 'y' to ws-eof
                   not at end
                       perform test after varying k from 1 by 1 until
                         separator of input-page(k) not equal to ','
                           set i to k
                           move page-number of input-page(k) to 
                           print-queue(i)
                       end-perform
                       perform check-line-okay
                       
      *                perform part-one
                       perform part-two
                       
               end-read
               end-perform.
               move 'n' to ws-eof
           close input2-file.
            
           display result
           goback.
       
       part-two.
      *Similar to part one, but when a sorting mismatch is found, do 
      *a bubble sort round.
           if line-not-okay
               perform until line-is-okay
                   perform check-line-okay
               end-perform
               perform add-current-line
           end-if.
           
           
       part-one.
           if line-is-okay
               perform add-current-line
           end-if.

       check-line-okay.
      *Check if line is okay, and if not perform one bubble-sort step.
      *This is okay for part one also, since when a line is okay
      *it will not be changed.
           set line-is-okay to true
           
           perform varying current-page from 1 by 1 
               until current-page > i
               perform varying other-page from 1 by 1
                 until other-page > i
                   if other-page < current-page
                       if y-before-x(print-queue(current-page),
                                     print-queue(other-page))
                           perform bubble-step
                           set line-not-okay to true
                       end-if
                   end-if
                   if other-page > current-page
                       if y-before-x(print-queue(other-page),
                                     print-queue(current-page))
                           perform bubble-step
                           set line-not-okay to true
                       end-if
                   end-if
               end-perform
           end-perform.
           
           
       bubble-step.
           move print-queue(current-page) to swap-value
           move print-queue(other-page) to print-queue(current-page)
           move swap-value to print-queue(other-page).
           
       add-current-line.
           if line-is-okay
               add print-queue((i/2) + 1) to result
           end-if.
       
       end program Day5.
