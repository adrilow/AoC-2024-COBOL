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
       01 result binary-long value 0.
       
       01 display-number pic Z(19)9.
       
       78 max-num-stones value 1000000.
       01 filler.
         05 stones.
           10 stone pic 9(38) occurs max-num-stones times indexed by i. 
         05 stones-to-process.
           10 stone-to-process pic 9(38) occurs max-num-stones times 
           indexed by j.
      *  05 num-stones pic 9(10) value 2.                               inputDay11_short.txt
         05 num-stones pic 9(10) value 8.                               inputDay11.txt
         05 num-stones-to-process pic 9(10).
       
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
           
           perform part-one
      *    perform part-two
           
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
           
       
       one-blink.
           move stones to stones-to-process
           move num-stones to num-stones-to-process
           set i to 1
           perform varying j from 1 by 1 until j > num-stones-to-process
               move stone-to-process(j) to curr-stone
               compute log = 
                    1 + function integer(function log10(curr-stone))
           
               if curr-stone = 0
                   move 1 to stone(i)
                   set i up by 1
               else if function mod(log, 2) = 0
                   compute half-exp10 = function exp10(log / 2)
                   compute left-half = curr-stone / half-exp10
                   compute right-half = function mod(curr-stone, 
                                                     half-exp10)
                   move left-half to stone(i)
                   set i up by 1
                   move right-half to stone(i)
                   set i up by 1
                   set num-stones up by 1
               else
                   compute stone(i) = 2024 * curr-stone
                   set i up by 1
               end-if
               if i >= max-num-stones
                   go to panic
               end-if
           end-perform
           move num-stones to result.
           
       display-stones.
           perform varying i from 1 by 1 until i > num-stones
               move stone(i) to display-number
               display function trim(display-number) " " with no 
               advancing
           end-perform
           display " ".
       
       panic.
           display "Stack Overflow!".
           
       end program Day11.
