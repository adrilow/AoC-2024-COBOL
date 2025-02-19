       program-id. Day7 as "Day7".

       environment division.
       configuration section.
       repository.
           function explore-operators.
           
       
       input-output section.
       file-control.
           select input-file assign to "inputDay7.txt"
               line sequential.
       data division.
       file section.

       fd input-file.
       78 input-width value 50.
      
       01 input-line.
         05 input-char pic X occurs input-width times indexed by c.
       
       working-storage section.
       01 ws-eof pic x(1).
       
       01 result pic 9(20) value zero.
       01 acc pic 9(20) value zero.
       
       01 filler pic X.
           88 parsing-goal value 't'.
           88 parsing-operands value 'o'.
       
       01 i-explore pic 9(9).
       01 current-line.
           05 goal pic 9(20).
           05 n-operands pic 9(9).
           05 operands pic 9(20) occurs 20 times indexed by i.
       
       01 num-char pic 9.
       01 prev-char pic X.
       
       procedure division.

           open input input-file
               perform until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end
                       perform parse-line
                       perform call-function
               end-read
               end-perform.
               move 'n' to ws-eof
           close input-file.
           
           display result
           goback.

       parse-line.
           initialize current-line
           set i to 0
           set parsing-goal to true
           perform varying c from 1 by 1 until c > input-width
               evaluate true
                   when parsing-goal
                       if input-char(c) = ':'
                           set parsing-operands to true
                           move ' ' to prev-char
                       else
                           move input-char(c) to num-char
                           compute goal = 10 * goal + num-char
                       end-if
                   when parsing-operands
                       if input-char(c) not equals ' '
                           if prev-char = ' '
                               set i up by 1
                           end-if
                           move input-char(c) to num-char
                           compute operands(i) = 10 * operands(i) + 
                           num-char
                       end-if
                       move input-char(c) to prev-char
                   when any
                       display "Problem"
               end-evaluate
           end-perform
           set n-operands to i.
       call-function.
           move 2 to i-explore
           move operands(1) to acc
           compute result = result +
            function explore-operators(current-line, i-explore, acc).
           
       end program Day7.

       function-id. explore-operators as "explore-operators".
       data division.
       local-storage section.
       01 add-res pic 9(20).
       01 mul-res  pic 9(20).
       01 concat-res pic 9(20).
       01 concat-temp pic 9(20).
       01 explore-add pic 9(20).
       01 explore-mul pic 9(20).
       01 explore-concat pic 9(20).
       01 operand pic 9(20).
       01 i-next pic 9(9).
       linkage section.
       01 current-line.
           05 goal pic 9(20).
           05 n-operands pic 9(9).
           05 operands pic 9(20) occurs 20 times.
       01 i-explore pic 9(9).
       01 acc pic 9(20).
       01 ret  pic 9(20).
       procedure division using by reference current-line i-explore acc
       returning ret.
           if i-explore <= n-operands
               move operands(i-explore) to operand
               compute i-next = i-explore + 1
               compute add-res = acc + operand
               compute mul-res = acc * operand
               
               compute explore-add = 
               explore-operators(current-line, i-next, add-res)
               compute explore-mul = 
               explore-operators(current-line, i-next, mul-res)
               
               perform part-two

               if goal = explore-add or explore-mul or explore-concat                    
                   move goal to ret
               else
                   move zero to ret
               end-if
           else
               move acc to ret
           end-if
           goback.
           part-two.
               move acc to concat-res
               move operand to concat-temp
               perform test after until concat-temp <= 0
                   compute concat-res = 10 * concat-res
                   compute concat-temp = concat-temp / 10
               end-perform
               compute concat-res = concat-res + operand
               compute explore-concat =
               explore-operators(current-line, i-next, concat-res).
       end function explore-operators.
