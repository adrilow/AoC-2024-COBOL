       program-id. Day9 as "Day9".

       environment division.
       
       configuration section.
       
       input-output section.
       file-control.
       
           select input-file assign to "inputDay9.txt"
               binary sequential.
               
       data division.
       file section.

       fd input-file.
       01 filler.
           05 input-byte pic X.
       
       working-storage section.
       01 ws-eof pic x(1).
       01 input-number pic 9.
       
       01 display-number pic Z(19)9.
       
       01 current-file binary-long value 1.
       01 filler pic X value 'N'.
           88 currently-free-space value 'Y' false 'N'.
       
       01 filler.
         05 block-id occurs 180000 times indexed by i.
           10 block-status pic X value 'Y'.
               88 block-empty value 'Y' false 'N'.
           10 block-file-id binary-long.
       
       01 last-written-block binary-long.
       
       01 result pic 9(38) value 0.
       01 temp binary-long.
       
       01 compact-disc-variables.
         05 right-pointer binary-long.
         05 left-pointer binary-long.
           
       procedure division.
           set i to 1
           open input input-file
               perform until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end
                       if input-byte is numeric
                           move input-byte to input-number
                           perform process-input-number
                       end-if
               end-read
               end-perform.
               move 'n' to ws-eof
           close input-file.
           perform part-one
           goback.

       process-input-number.
           if currently-free-space
               perform input-number times
                   set block-empty(i) to true
                   set i up by 1
               end-perform
               set currently-free-space to false
           else
               perform input-number times
                   set block-empty(i) to false
                   compute block-file-id(i) = current-file - 1
                   set i up by 1
               end-perform
               add 1 to current-file
               set currently-free-space to true
           end-if
           set last-written-block to i.
       
       part-one.
           perform compact-disk-fragmentation
           perform checksum
           display result.
           
       compact-disk-fragmentation.
           compute right-pointer = last-written-block - 1
           move 1 to left-pointer
           perform until right-pointer <= left-pointer
               if block-empty(right-pointer)
                   subtract 1 from right-pointer
               else
                   if block-empty(left-pointer)
                       set block-empty(left-pointer) to false
                       set block-empty(right-pointer) to true
                       move block-file-id(right-pointer) to 
                       block-file-id(left-pointer)
                   else
                       add 1 to left-pointer
                   end-if
               end-if
           end-perform.
       
       checksum.
           perform varying i from 1 by 1 until i >= last-written-block
               if not block-empty(i)
                   set temp to i
                   compute result = result + (temp - 1) 
                                           * block-file-id(i)
               end-if
           end-perform.
           
       display-disk.
           perform varying i from 1 by 1 until i >= last-written-block
               if block-empty(i)
                   display '.' with no advancing
               else
                   move block-file-id(i) to display-number 
                   display function trim(display-number) with no 
                   advancing
               end-if
           end-perform
           display " ".

       end program Day9.
