       program-id. Day6 as "Day6".

       environment division.
       
       configuration section.
       
       input-output section.
       file-control.
       
           select input-file assign to "inputDay6.txt"
               line sequential.
               
       data division.
       file section.

       fd input-file.
       78 input-height value 130.
       78 input-width value 130.
      *78 input-height value 10.
      *78 input-width value 10.
      
       01 input-line pic X(input-width).
       
       working-storage section.
       01 ws-eof pic x(1).
       
       01 result binary-long value 0.
       01 path-length binary-long value 1.
       01 cycle-count binary-long value 0.
       
       01 map-memory.
           05 map-line occurs input-height times indexed by y.
               10 map pic X occurs input-width times indexed by x.
                   copy 'Day6_MapCells.cpy'.
       
       78 up-flag value B#1000.
       78 down-flag value B#0100.
       78 left-flag value B#0010.
       78 right-flag value B#0001.
       01 visited-memory.
           05 filler occurs input-height times.
               10 cell-visited pic 9 usage comp-5 occurs input-width    
               times.
       
       01 map-memory-copy.
         05 filler occurs input-height times.
               10 filler pic X occurs input-width times.
       
       01 curr-cell-data.
         05 curr-cell pic X.
           copy 'Day6_MapCells.cpy'.
         05 visited-curr-cell pic 9 usage comp-5.
         05 curr-y pic 9(3).
         05 curr-x pic 9(3).
         
       01 curr-cell-data-copy.
         05 filler pic X.
         05 filler pic 9.
         05 filler pic 9(3).
         05 filler pic 9(3).
           
       01 next-cell-data.
         05 next-cell pic X.
           copy 'Day6_MapCells.cpy'.
         05 next-y pic 9(3).
         05 next-x pic 9(3).
       
       01 next-cell-data-copy.
         05 filler pic X.
         05 filler pic 9(3).
         05 filler pic 9(3).
           
       procedure division.

           open input input-file
               perform varying y from 1 by 1 until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end
                       move input-line to map-line(y)
                       perform varying x from 1 by 1 until x > 
                       input-width
                           move map(y,x) to next-cell
                           if guard of next-cell
                               move map(y,x) to curr-cell
                               set curr-y to y
                               set curr-x to x
                           end-if
                       end-perform
               end-read
               end-perform.
               move 'n' to ws-eof
           close input-file.
           
      *    perform part-one.
           perform part-two.
           
           display result
           goback.
       
       part-one.
           perform walk-guard-duty
           move path-length to result.
           
       part-two.
           perform varying y from 1 by 1 until y > input-height
               perform varying x from 1 by 1 until x > input-width
                   if path of map(y,x)
                       move map-memory to map-memory-copy
                       move curr-cell-data to curr-cell-data-copy
                       move next-cell-data to next-cell-data-copy
                       move 0 to visited-memory
                       
                       set artificial-wall of map(y,x) to true
                       perform walk-guard-duty
                       
                       move map-memory-copy to map-memory
                       move curr-cell-data-copy to curr-cell-data  
                       move next-cell-data-copy to next-cell-data  
                   end-if
               end-perform
           end-perform
           move cycle-count to result.
           
       walk-guard-duty.    
           perform test after until goal of next-cell
               perform set-next-cell
               perform process-next-cell
           end-perform.
           
       set-next-cell.
           evaluate true
               when guard-up of curr-cell 
                   compute next-y = curr-y - 1
                   set visited-curr-cell to up-flag   
                   move curr-x to next-x
               when guard-down of curr-cell 
                   compute next-y = curr-y + 1
                   set visited-curr-cell to down-flag                   
                   move curr-x to next-x
               when guard-right of curr-cell 
                   compute next-x = curr-x + 1
                   set visited-curr-cell to right-flag                  
                   move curr-y to next-y
               when guard-left of curr-cell 
                   compute next-x = curr-x - 1
                   set visited-curr-cell to left-flag                   
                   move curr-y to next-y
           end-evaluate
           if next-y >= 1 and next-y <= input-height 
             and next-x >= 1 and next-x <= input-width
               move map(next-y, next-x) to next-cell
           else
               set goal of next-cell to true
           end-if.
           
       process-next-cell.
           evaluate true
               when path of next-cell
                   if new-path of next-cell
                       add 1 to path-length
                   end-if
                   
                   if 
                     (cell-visited(next-y, next-x) b-and
                     visited-curr-cell) 
                   not equal to 0
                       add 1 to cycle-count
                       set goal of next-cell to true
                   end-if
                   
                   set visited-path of map(curr-y,curr-x) to true
                   
                   compute cell-visited(curr-y,curr-x) = 
                   cell-visited(curr-y,curr-x) b-or visited-curr-cell
                   
                   move curr-cell to map(next-y, next-x)
                   move next-y to curr-y
                   move next-x to curr-x
               when wall of next-cell
                   perform rotate-guard
           end-evaluate.
           
       rotate-guard.
           evaluate true
               when guard-up of curr-cell
                   set guard-right of curr-cell to true
               when guard-right of curr-cell
                   set guard-down of curr-cell to true
               when guard-down of curr-cell
                   set guard-left of curr-cell to true
               when guard-left of curr-cell
                   set guard-up of curr-cell to true
           end-evaluate.

           
       end program Day6.
