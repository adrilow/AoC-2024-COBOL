       program-id. Day2 as "Day2".

       environment division.
       
       configuration section.
       input-output section.
       file-control.
       
           select input-file           assign to "inputDay2.txt"
                                       line sequential.

       data division.
       file section.
   
       
       fd input-file.
       01 input-line pic X(100).
       
       working-storage section.
       78 input-length value 1000. 
       01 ws-eof pic x(1).
       
       01 report-input.
         05 rep pic 9(2) value zeros occurs 10 times indexed by i.
       01 j binary pic 9(4).
         
       01 report-len binary-long value 0.
           
       01 result binary-long value 0.
       
       01 grows pic 9 value 0.
       01 falls pic 9 value 0.
       01 is-safe pic 9 value 0.
       01 prev pic 9(2) value 0.
       01 deleted pic 9(2) value 0.
       01 delta pic 9(2) value 0.

       procedure division.
           open input input-file

               perform until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end 
      *                display input-line
                       move zeros to report-len
                       unstring input-line delimited by space into
                          rep(1), rep(2), rep(3), rep(4),
                          rep(5), rep(6), rep(7), rep(8),
                          rep(9), rep(10)
                       
                       perform part-two
                       
               end-read
               end-perform.
           close input-file.

           display result
           
           goback.
       
       part-two.
           perform part-one
           if is-safe = 0
               move 1 to j
               perform until j > 10 or is-safe > 0
                   move rep(j) to deleted
                   move 0 to rep(j)
                   perform part-one
                   move deleted to rep(j)
                   add 1 to j
               end-perform
           end-if.
       
           
       part-one.
           move zero to grows
           move zero to falls
           move 1 to is-safe
           move 0 to prev
           
           set i to 1
           perform until prev > 0
               move rep(i) to prev
               set i up by 1
           end-perform
           
           if rep(i) = 0
               set i up by 1
           end-if

           if rep(i) > prev 
               move 1 to grows
           else 
               move 1 to falls
           end-if
           
           
           perform until i > 10
               if rep(i) > 0
                   if grows > 0 and rep(i) <= prev
                       move zero to is-safe
                   end-if
                   if falls > 0 and rep(i) >= prev
                       move zero to is-safe
                   end-if
                   
                   compute delta = function abs(rep(i) - prev)
                   if delta < 1 or > 3
                       move zero to is-safe
                   end-if
                   move rep(i) to prev
               end-if
               set i up by 1
           end-perform
           add is-safe to result.

       end program Day2.
