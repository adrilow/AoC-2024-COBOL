       program-id. Day10 as "Day10".

       environment division.
       
       configuration section.
       special-names.
           symbolic characters backslash is 93.
       
       input-output section.
       file-control.
       
           select input-file           assign to "inputDay10.txt"
                                       line sequential.
      *    select output-file assign to "output.txt" binary sequential.

       data division.
       file section.
       
       
       fd input-file.
       78 input-width value 44.
       78 input-height value 44.
      *78 input-width value 8.
      *78 input-height value 8.
       
       01 input-bytes.
           05 file-row pic X(input-width).
       
      *fd output-file.
      *01 out-bytes pic X(input-length).
       
       
       working-storage section.
       01 ws-eof pic x(1).
       01 result binary-long value 0.
       
       01 filler.
           05 row occurs input-height times indexed by y.
               10 cell pic 9 occurs input-width times indexed by x.
       
       01 filler.
         05 filler occurs input-height times indexed by y1.
           10 filler pic X occurs input-width times indexed by x1.
             88 visited value 'Y' false 'N'.
               
       78 stack-depth value 1000. 
       01 stack.
         05 stack-memory occurs stack-depth times indexed by sp.
           10 stack-x binary-long.
           10 stack-y binary-long.
           10 stack-height pic 9.
         05 head.
           10 head-x binary-long.
           10 head-y binary-long.
           10 head-height pic 9.
       
       01 k-pointer binary-long value 0.
       
       procedure division.

           open input input-file
           set y to 1
           set sp to 0
           perform until ws-eof='y'
           read input-file
               at end move 'y' to ws-eof
               not at end
                   move file-row to row(y)
                   set y up by 1
           end-read
           end-perform.
           
           perform process-trailheads

           close input-file.
           
            
           display result
           goback.
       
       
       process-trailheads.
           perform varying y from 1 by 1 until y > input-height
               perform varying x from 1 by 1 until x > input-width
      *            Trailhead found, process            
                   if cell(y,x) = 0
                       perform reset-visited
                       set head-x to x
                       set head-y to y
                       move 0 to head-height
                       perform stack-push
      *                perform part-one until sp = 0
                       perform part-two until sp = 0         
                   end-if
               end-perform
           end-perform.
       
           
      * Process one height of the trail
       part-one.
           perform stack-pop
           if head-height = 9
               if not visited(head-y,head-x)
                   set visited(head-y,head-x) to true
                   add 1 to result    
               end-if
           else
               perform check-e
               perform check-w
               perform check-n
               perform check-s
           end-if.
      
      * Process one height of the trail
       part-two.
           perform stack-pop
           if head-height = 9
               add 1 to result
           else
               perform check-e
               perform check-w
               perform check-n
               perform check-s
           end-if.
           
       
       check-e.
           set head-x up by 1
           if  head-x <= input-width 
           and cell(head-y,head-x) = head-height + 1
               set head-height up by 1
               perform stack-push
               set head-height down by 1
           end-if
           set head-x down by 1.
           
       check-w.
           set head-x down by 1
           if  head-x >= 1 
           and cell(head-y,head-x) = head-height + 1
               set head-height up by 1
               perform stack-push
               set head-height down by 1
           end-if
           set head-x up by 1.
           
       check-n.
           set head-y down by 1
           if  head-y >= 1 
           and cell(head-y,head-x) = head-height + 1
               set head-height up by 1
               perform stack-push
               set head-height down by 1
           end-if
           set head-y up by 1.
       
       check-s.
           set head-y up by 1
           if  head-y <= input-height 
           and cell(head-y,head-x) = head-height + 1
               set head-height up by 1
               perform stack-push
               set head-height down by 1
           end-if
           set head-y down by 1.
       
      
       stack-pop.
           move stack-memory(sp) to head
           set sp down by 1.
       
       stack-push.
           if sp >= stack-depth
               go to panic
           end-if
           set sp up by 1
           move head to stack-memory(sp).
       
       reset-visited.
           perform varying y1 from 1 by 1 until y1 > input-height
               perform varying x1 from 1 by 1 until x1 > input-width
                   set visited(y1,x1) to false
               end-perform
           end-perform.
       
       panic.
           display "Stack Overflow".
           
       end program Day10.
