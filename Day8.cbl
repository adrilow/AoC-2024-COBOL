       program-id. Day8 as "Day8".

       environment division.
       
       configuration section.
       
       input-output section.
       file-control.
       
           select input-file assign to "inputDay8.txt"
               line sequential.
               
       data division.
       file section.

       fd input-file.
       78 input-height value 50.
       78 input-width value 50.
      *78 input-height value 12.
      *78 input-width value 12.
       
      
       01 input-line pic X occurs input-width times.
       
       working-storage section.
       01 ws-eof pic x(1).
       
       01 result binary-long value 0.
       
       01 map-memory.
           05 map-line occurs input-height times.
               10 map pic X value '.' occurs input-width times.
                   88 antinode value '#'.
                   88 empty value '.'.
             
       01 antennas.
         05 frequency occurs 255 times.
           10 number-antennas binary-long value 0.
           10 coords occurs 50 times.
               15 x binary-long.
               15 y binary-long.
            
       01 i binary-long.
       01 j binary-long.
       01 k binary-long.
       01 l binary-long.
       
       01 max-harmonics binary-long.
       
       01 freq-index binary-short.
       01 index-freq pic X.

       01 diff-x binary-long.
       01 diff-y binary-long.
       01 a-node-1.
           05 x-1 binary-long.
           05 y-1 binary-long.
       01 a-node-2.
           05 x-2 binary-long.
           05 y-2 binary-long.
               
       procedure division.

           open input input-file
               perform varying i from 1 by 1 until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end
                       perform test before varying j from 1 by 1  
                       until j > input-width
                           if input-line(j) not equal '.'
                               move function ord(input-line(j)) to 
                               freq-index
                               add 1 to number-antennas(freq-index)
                               move i to y(freq-index,
                               number-antennas(freq-index))
                               move j to x(freq-index,
                               number-antennas(freq-index))
                           end-if
                       end-perform
               end-read
               end-perform.
               move 'n' to ws-eof
           close input-file.
      *    perform output-antennas.    
      *    perform part-one.
           perform part-two.
           
           perform count-and-output-antinodes.
           
           display result
           
           goback.
       
       part-one.
           move 1 to max-harmonics
           perform detect-antinodes.
           
       part-two.
           move input-width to max-harmonics
           perform detect-antinodes
           perform varying i from 1 by 1 until i > 255
               if number-antennas(i) > 1
                   perform varying j from 1 by 1 until j > 
                   number-antennas(i)
                       set antinode(y(i,j), x(i,j)) to true
                   end-perform
               end-if
           end-perform.
       
       output-antennas.
           perform varying i from 1 by 1 until i > 255
               if number-antennas(i) > 0
                   move function char(i) to index-freq
                   display "Frequency " index-freq " has " 
                   number-antennas(i) " antennas:"
                   perform varying j from 1 by 1 until j > 
                   number-antennas(i)
                       display "x:" x(i,j) ",y:" y(i,j) "; " with no 
                       advancing
                   end-perform
                   display " "
               end-if
           end-perform.
           
       detect-antinodes.
           perform varying i from 1 by 1 until i > 255
           if number-antennas(i) > 0
               
           perform varying j from 1 by 1 until j > number-antennas(i)
           perform varying k from 1 by 1 until k > number-antennas(i)
               if j not equal to k
                   compute diff-x = x(i,j) - x(i,k)
                   compute diff-y = y(i,j) - y(i,k)
                   
                   perform varying l from 1 by 1 until l > 
                   max-harmonics
                       compute x-1 = x(i,k) - l * diff-x
                       compute y-1 = y(i,k) - l * diff-y
                       compute x-2 = x(i,j) + l * diff-x
                       compute y-2 = y(i,j) + l * diff-y
                   
                       if x-1 > 0 and x-1 <= input-width and
                          y-1 > 0 and y-1 <= input-height
                           set antinode(y-1, x-1) to true
                       end-if
                       if x-2 > 0 and x-2 <= input-width and
                          y-2 > 0 and y-2 <= input-height
                           set antinode(y-2, x-2) to true
                   end-if    
                   end-perform
               end-if
           end-perform
           end-perform
           
           end-if
           end-perform.

       count-and-output-antinodes.
           perform varying j from 1 by 1 until j > input-height
               perform varying i from 1 by 1 until i > input-width
                   display map(j,i) with no advancing
                   if antinode(j,i)
                       add 1 to result
                   end-if
               end-perform
               display " "
           end-perform

       end program Day8.
