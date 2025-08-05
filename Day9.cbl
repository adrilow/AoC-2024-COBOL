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
       
       01 current-file binary-long value 0.
       01 current-file-size pic 9.
       
       01 filler pic X value 'N'.
           88 currently-free-space value 'Y' false 'N'.
       
       01 disk-map.
         05 map-entry occurs 30000 times indexed by j.
           10 map-entry-size pic 9 value 0.
           10 filler pic X value 'Y'.
               88 map-entry-empty value 'Y' false 'N'.
           10 map-entry-file-id binary-long.
         05 last-written-map-entry binary-long.
      *  When this is set, shift-map can be called, all elements at pos.
      *  >= insert-index will shift one index to the right. 
      *  map-entry(insert-index) will be en empty entry of size 0.
         05 insert-index binary-long.
           
       01 filler.
         05 block-file occurs 180000 times indexed by i.
           10 filler pic X value 'Y'.
               88 block-empty value 'Y' false 'N'.
           10 block-file-id binary-long.
         05 last-written-block binary-long.
       
       01 result pic 9(38) value 0.
       01 temp binary-long.
       
       01 compact-disk-fragmentation-variables.
         05 right-block binary-long.
         05 left-block binary-long.
       
       01 compact-disk-whole-files-variables.
         05 right-map-entry binary-long.
         05 left-map-entry binary-long.
         
       procedure division.
           set i j to 1
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
           subtract 1 from current-file
      *    perform part-one
           perform part-two
           goback.

       process-input-number.
           if currently-free-space
               set map-entry-empty(j) to true
               move input-number to map-entry-size(j)
               set currently-free-space to false
           else
               set map-entry-empty(j) to false
               move input-number to map-entry-size(j)
               move current-file to map-entry-file-id(j)
               add 1 to current-file
               set currently-free-space to true
           end-if
           set j up by 1
           set last-written-map-entry to j.
       
           
       part-one.
           perform disk-map-to-blocks
           perform compact-disk-fragmentation
           perform checksum
           display result.
           
       part-two.
           perform compact-disk-whole-files
           perform disk-map-to-blocks
           perform checksum
           display result.
       
       disk-map-to-blocks.
           set i to 1
           perform varying j from 1 by 1 until j >= 
           last-written-map-entry
               perform map-entry-size(j) times
                   if map-entry-empty(j)
                       set block-empty(i) to true
                   else
                       set block-empty(i) to false
                       move map-entry-file-id(j) to block-file-id(i)
                   end-if
                   set i up by 1
                   set last-written-block to i
               end-perform
           end-perform
           set last-written-block to i.
           
       compact-disk-fragmentation.
           compute right-block = last-written-block - 1
           move 1 to left-block
           perform until right-block <= left-block
               if block-empty(right-block)
                   subtract 1 from right-block
               else
                   if block-empty(left-block)
                       set block-empty(left-block) to false
                       set block-empty(right-block) to true
                       move block-file-id(right-block) to 
                       block-file-id(left-block)
                   else
                       add 1 to left-block
                   end-if
               end-if
           end-perform.
       
       compact-disk-whole-files.
           compute right-map-entry = last-written-map-entry - 1
           move 1 to left-map-entry
           perform test after until current-file = 0
               
               move last-written-map-entry to right-map-entry
               perform until 
                 not map-entry-empty(right-map-entry) 
                 and map-entry-file-id(right-map-entry)
                   = current-file
                   subtract 1 from right-map-entry
               end-perform
               move map-entry-size(right-map-entry) to current-file-size
               
               move 1 to left-map-entry
               perform until 
               map-entry-empty(left-map-entry) and 
               map-entry-size(left-map-entry) >=
               map-entry-size(right-map-entry)
               or
               left-map-entry = right-map-entry
                   add 1 to left-map-entry
               end-perform
               
               if left-map-entry < right-map-entry
                   if map-entry-size(left-map-entry) > current-file-size
                       move left-map-entry to insert-index
                       perform shift-map
                       add 1 to right-map-entry
                       subtract map-entry-size(right-map-entry) from 
                       map-entry-size(insert-index + 1)
                   end-if
                   move map-entry(right-map-entry) to 
                   map-entry(left-map-entry)
                   set map-entry-empty(right-map-entry) to true
               end-if
               
               subtract 1 from current-file
           end-perform.
       
       shift-map.
           subtract 1 from last-written-map-entry
           perform test after varying j from last-written-map-entry by 
           -1 until j = insert-index
               move map-entry(j) to map-entry(j + 1)
           end-perform
           set map-entry-empty(insert-index) to true
           move 0 to map-entry-size(insert-index)
           add 2 to last-written-map-entry.
           
       checksum.
           perform varying i from 1 by 1 until i >= last-written-block
               if not block-empty(i)
                   set temp to i
                   compute result = result + (temp - 1) 
                                           * block-file-id(i)
               end-if
           end-perform.
       
       display-disk-map.
           display "Sizes:"
           perform varying j from 1 by 1 until j >= 
           last-written-map-entry
               move map-entry-size(j) to display-number
               display function trim(display-number) with no 
               advancing
           end-perform
           display " "
           display "IDs:"
           perform varying j from 1 by 1 until j >= 
           last-written-map-entry
               if map-entry-empty(j)
                   display "e" with no advancing
               else
                   move map-entry-file-id(j) to display-number
                   display function trim(display-number) with no 
                   advancing
               end-if
           end-perform
           display " ".
           
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
