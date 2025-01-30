       program-id. Day4 as "Day4".

       environment division.
       
       configuration section.
       special-names.
           symbolic characters backslash is 93.
       
       input-output section.
       file-control.
       
           select input-file           assign to "inputDay4.txt"
                                       line sequential.
      *    select output-file assign to "output.txt" binary sequential.

       data division.
       file section.
       
       
       fd input-file.
       78 input-width value 140.
       78 input-height value 140.
      *78 input-width value 10.
      *78 input-height value 10.
       
       01 input-bytes.
           05 file-row pic X(input-width).
       
      *fd output-file.
      *01 out-bytes pic X(input-length).
       
       
       working-storage section.
       01 ws-eof pic x(1).
       01 result binary-long value 0.
       
       01 filler.
           05 row occurs input-height times indexed by y.
               10 cell pic X occurs input-width times indexed by x.
       
       
       01 coords-list.
         05 xs pic 9(10) occurs 4 times.
         05 ys pic 9(10) occurs 4 times.
       
       01 k-pointer binary-long value 0.
         
       01 test-word.
        05 test-letter pic X value zero occurs 4 times.
       
       01 temp-x binary-long.
       01 temp-y binary-long.
         
       procedure division.

           open input input-file
           set y to 1
           perform until ws-eof='y'
           read input-file
               at end move 'y' to ws-eof
               not at end
                   move file-row to row(y)
                   set y up by 1
           end-read
           end-perform.
           
      *    perform part-one
           perform part-two

           close input-file.
           
            
           display result
           goback.
       
       
       part-two.
           perform varying y from 1 by 1 until y > (input-height - 2)
               perform varying x from 1 by 1 until x > (input-width - 2)
                   if (
                       (    
                           cell(y, x) = 'M'
                           and cell(y + 2, x + 2) = 'S'  or
                           cell(y, x) = 'S'
                           and cell(y + 2, x + 2) = 'M' 
                       )
                       and
                       (    
                           cell(y, x + 2) = 'M'
                           and cell(y + 2, x) = 'S'  or
                           cell(y, x + 2) = 'S'
                           and cell(y + 2, x) = 'M' 
                       ) 
                       and
                           cell(y + 1, x + 1) = 'A'
                       )
                       add 1 to result
                   end-if
               end-perform
           end-perform.
           
           
           
       part-one.
           perform varying y from 1 by 1 until y>input-height
               perform varying x from 1 by 1 until x>input-width
                   perform count-and-check-part-one
               end-perform
           end-perform.
       
       
       count-and-check-part-one.
           perform count-e
           perform check-word
           perform count-w
           perform check-word
           perform count-n
           perform check-word
           perform count-s
           perform check-word
           perform count-se
           perform check-word
           perform count-sw
           perform check-word
           perform count-nw
           perform check-word
           perform count-ne
           perform check-word.
           

       count-e.
           perform reset-count
           perform 4 times
               if temp-x <= input-width
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               add 1 to temp-x
           end-perform.
           
       count-w.
           perform reset-count
           perform 4 times
               if temp-x >= 1
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               subtract 1 from temp-x
           end-perform.
           
       count-n.
           perform reset-count
           perform 4 times
               if temp-y >= 1
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               subtract 1 from temp-y
           end-perform.
       
       count-s.
           perform reset-count
           perform 4 times
               if temp-y <= input-height
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               add 1 to temp-y
           end-perform.
       
       count-se.
           perform reset-count
           perform 4 times
               if temp-y <= input-height and temp-x <= input-width 
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               add 1 to temp-y
               add 1 to temp-x
           end-perform.
       
       count-sw.
           perform reset-count
           perform 4 times
               if temp-y <= input-height and temp-x >= 1 
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               add 1 to temp-y
               subtract 1 from temp-x
           end-perform.
       
       count-nw.
           perform reset-count
           perform 4 times
               if temp-y >= 1 and temp-x >= 1 
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               subtract 1 from temp-y
               subtract 1 from temp-x
           end-perform.
               
       count-ne.
           perform reset-count
           perform 4 times
               if temp-y >= 1 and temp-x <= input-width 
                 move temp-x to xs(k-pointer)
                 move temp-y to ys(k-pointer)
               end-if
               add 1 to k-pointer
               subtract 1 from temp-y
               add 1 to temp-x
           end-perform.
           
           
       reset-count.
           set temp-y to y
           set temp-x to x
           move 1 to k-pointer
           move zeros to coords-list.

       check-word.
           if xs(4) > 0 and ys(4) > 0
               move cell(ys(1),xs(1)) to test-letter(1)
               move cell(ys(2),xs(2)) to test-letter(2)
               move cell(ys(3),xs(3)) to test-letter(3)
               move cell(ys(4),xs(4)) to test-letter(4)
               if test-word = 'XMAS'
      *            display ys(1) ", " xs(1)
                   add 1 to result
               end-if
           end-if
           
           
       end program Day4.
