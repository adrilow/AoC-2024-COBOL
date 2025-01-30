       program-id. Day1 as "Day1".

       environment division.
       
       configuration section.
       input-output section.
       file-control.
       
           select input-file           assign to "inputDay1.txt"
                                       line sequential.

       data division.
       file section.
   
       
       fd input-file.
       01 input-line.
           05 col1 pic 9(5).
           05 filler pic x(3).
           05 col2 pic 9(5).
       
       working-storage section.
       78 input-length value 1000. 
       
       01 left-col-table.
           05 left-col-line pic 9(5) occurs input-length times indexed 
           by i.
           
       01 right-col-table.
           05 right-col-line pic 9(5) occurs input-length times indexed 
           by j.
           
       01 result binary-long value 0.
       01 num-times binary-long value 0.
           
       01 ws-eof pic x(1).

       procedure division.
           open input input-file
           perform reset-counters
               perform until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end 
      *                display input-line
                       move col1 to left-col-line(i)
                       move col2 to right-col-line(j)
               end-read
               perform update-counters
               end-perform.
           close input-file.
           
           perform part-two
           
           display result
           
           goback.
       
       part-two.
           
           set i to 1.
           perform input-length times
               move zeros to num-times
               
               set j to 1
               perform input-length times
                   if right-col-line(j) = left-col-line(i)
                       compute num-times = num-times + left-col-line(i)
                   end-if
               set j up by 1
               end-perform
               
               compute result = result + num-times
               
               set i up by 1
           end-perform.
           
       part-one.
           sort left-col-line ascending.
           sort right-col-line ascending.
           
           perform reset-counters
           perform input-length times
               compute result = result + function abs(left-col-line(i) -
               right-col-line(j))
               perform update-counters
           end-perform.
         
       reset-counters.
           set i to 1.
           set j to 1.
       update-counters.
           set i up by 1.
           set j up by 1.

       end program Day1.
