       program-id. Day6 as "Day6".

       environment division.
       
       configuration section.
       
       input-output section.
       file-control.
       
           select input-file assign to "inputDay6.txt"
               line sequential.
               
      *    select output-file assign to "output.txt" line sequential.
       data division.
       file section.

       fd input-file.
       78 input-height value 130.
       78 input-width value 130.
      *78 input-height value 10.
      *78 input-width value 10.
       01 input-line pic X(input-width).
       
      *fd output-file.
      *01 out-line pic X(input-width).

       working-storage section.
       01 ws-eof pic x(1).
       
       01 result binary-long value 0.
       
       01 map-line occurs input-height times indexed by y.
           05 map pic X occurs input-width times indexed by x.
               copy 'Day6_MapCells.cpy'.
       
       01 filler.
         05 curr-cell pic X.
           copy 'Day6_MapCells.cpy'.
         05 curr-y pic 9(3).
         05 curr-x pic 9(3).
           
       01 filler.
         05 next-cell pic X.
           copy 'Day6_MapCells.cpy'.
         05 next-y pic 9(3).
         05 next-x pic 9(3).
           
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
                               add 1 to result
                               move map(y,x) to curr-cell
                               set curr-y to y
                               set curr-x to x
                           end-if
                       end-perform
               end-read
               end-perform.
               move 'n' to ws-eof
           close input-file.
           
           perform test after until goal of next-cell
               perform test after until not wall of next-cell
      *            perform print-map
           
                   perform set-next-cell
                   perform process-next-cell
               end-perform
           end-perform
           
      *    open output output-file
      *    perform varying y from 1 by 1 until y > input-height
      *        move map-line(y) to out-line
      *        write out-line
      *    end-perform
      *    close output-file

           display result
           goback.
       
       set-next-cell.
           evaluate true
               when guard-up of curr-cell 
                   compute next-y = curr-y - 1
                   move curr-x to next-x
               when guard-down of curr-cell 
                   compute next-y = curr-y + 1
                   move curr-x to next-x
               when guard-right of curr-cell 
                   compute next-x = curr-x + 1
                   move curr-y to next-y
               when guard-left of curr-cell 
                   compute next-x = curr-x - 1
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
                       add 1 to result
                   end-if
                   set visited-path of map(curr-y,curr-x) to true
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
