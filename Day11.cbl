       program-id. Day11 as "Day11".

       environment division.
       
       configuration section.
       input-output section.
       file-control.
       
      *    select input-file           assign to "inputDay11_short.txt"       
           select input-file           assign to "inputDay11.txt"
                                       line sequential.

       data division.
       file section.
   
       fd input-file.
       01 input-line pic X(100).
       
       working-storage section.
       01 result pic 9(38) value 0.
       
       01 display-number pic Z(19)9.
       
       78 num-high-value value 99999999999999999999999999999999999999.
       
       78 num-dict-entries value 10000.
       01 filler.
         05 insert-engraved pic 9(38).
         05 insert-num pic 9(38).
         05 stone-dict.
           10 stone-dict-size pic 9(38) value 0.
           10 sdmemory occurs num-dict-entries times indexed by i. 
             15 engraved-number pic 9(38) value num-high-value.
             15 num-with-number pic 9(38) value 0.
         05 stone-dict-old.
           10 stone-dict-old-size pic 9(38) value 0.
           10 sdoldmemory occurs num-dict-entries times indexed by j.
             15 engraved-number-old pic 9(38) value num-high-value.
             15 num-with-number-old pic 9(38) value 0.
       

       01 filler.
      *  05 num-stones pic 9(10) value 2.                               inputDay11_short.txt
         05 num-stones pic 9(10) value 8.                               inputDay11.txt
         05 stones.
           10 stone binary-long occurs 10 times indexed by k value -1.
         
       01 one-blink-variables.
         05 curr-stone pic 9(38).
         05 log pic 9(38).
         05 half-exp10 pic 9(38).
         05 left-half pic 9(38).
         05 right-half pic 9(38).

       procedure division.
           open input input-file
           
           read input-file
           
           unstring input-line delimited by ' '
            into 
            stone(1) stone(2) stone(3) stone(4)
            stone(5) stone(6) stone(7) stone(8)
            stone(9) stone(10)
            
           close input-file.
           
           perform varying k from 1 by 1 until k > num-stones
               move stone(k) to insert-engraved
               move 1 to insert-num
               perform dict-insert
           end-perform
           
      *    perform part-one
           perform part-two
           
           display result
           
           goback.
       
       part-two.
           perform 75 times
               perform one-blink
           end-perform.

       
       part-one.
           perform 25 times
               perform one-blink
           end-perform.
           
       
       dict-reset.
           move 0 to stone-dict-size
           perform varying i from 1 by 1 until i > num-dict-entries
               move num-high-value to engraved-number(i)
               move 0 to num-with-number(i)
           end-perform.
           
       dict-insert.
           set i to 1
           search sdmemory varying i 
               at end
                   set stone-dict-size up by 1
                   if stone-dict-size > num-dict-entries
                       go to panic
                   end-if
                   move insert-engraved to 
                       engraved-number(stone-dict-size)
                   move insert-num to num-with-number(stone-dict-size)
               when engraved-number(i) = insert-engraved
                   add insert-num to num-with-number(i).
           
       one-blink.
           move stone-dict to stone-dict-old
           perform dict-reset
           set i to 1
           perform varying j from 1 by 1 until j > stone-dict-old-size  
               move engraved-number-old(j) to curr-stone
               move num-with-number-old(j) to insert-num
               compute log = 
                    1 + function integer(function log10(curr-stone))
           
               if curr-stone = 0
                   move 1 to insert-engraved
                   perform dict-insert
               else if function mod(log, 2) = 0
                   compute half-exp10 = function exp10(log / 2)
                   compute left-half = curr-stone / half-exp10
                   compute right-half = function mod(curr-stone, 
                                                     half-exp10)
                   move left-half to insert-engraved
                   perform dict-insert
                   move right-half to insert-engraved
                   perform dict-insert
               else
                   compute insert-engraved = 2024 * curr-stone          
                   perform dict-insert
               end-if
           end-perform
           perform count-stones.

       count-stones.
           move 0 to result
           perform varying i from 1 by 1 until i > stone-dict-size
               add num-with-number(i) to result
           end-perform.
           
       display-dict.
           perform varying i from 1 by 1 until i > stone-dict-size
               move engraved-number(i) to display-number
               display function trim(display-number) ": " with no 
               advancing
               move num-with-number(i) to display-number
               display function trim(display-number) ";  " with no 
               advancing
           end-perform
           display " ".
       
       panic.
           display "Stack Overflow!".
           
       end program Day11.
