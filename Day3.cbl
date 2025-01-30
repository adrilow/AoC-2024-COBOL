       program-id. Day3 as "Day3".

       environment division.
       
       configuration section.
       special-names.
           symbolic characters backslash is 93.
       
       input-output section.
       file-control.
       
           select input-file           assign to "inputDay3.txt"
                                       binary sequential.
      *    select output-file assign to "output.txt" binary sequential.

       data division.
       file section.
       
       
       fd input-file.
       78 input-length value 19847.
      *78 input-length value 74.       
       01 input-bytes.
           05 char pic X occurs input-length times indexed by i.
       
      *fd output-file.
      *01 out-bytes pic X(input-length).
       
       
       working-storage section.
       01 ws-eof pic x(1).

       
       01 current-byte pic X.
       01 a-operand binary-long value 0.
       01 b-operand binary-long value 0.
       01 temp-operand binary-long value 0.

       
       01 result binary-long value 0.
       

       
       01 state pic X.
           88 start-state value '#'.
           88 m-state value 'm'.
           88 u-state value 'u'.
           88 l-state value 'l'.
           88 open-state value '('.
           88 a-state value 'a'.
           88 comma-state value ','.
           88 c-state value 'c'.
           88 close-state value ')'.
           


       procedure division.

           set start-state to true

           open input input-file

               perform until ws-eof='y'
               read input-file
                   at end move 'y' to ws-eof
                   not at end
               end-read
               end-perform.

      *Part 2    
           perform 1000 times
               inspect input-bytes replacing characters by "\" after 
               "don't()" before "do()"
               inspect input-bytes replacing first "don't()" by 
               "\\\\\\\"
               inspect input-bytes replacing all "do()" by 
               "\\\\" before "don't()"
               
           end-perform
           
      *    open output output-file
      *        move input-bytes to out-bytes
      *        write out-bytes
      *    close output-file
           
      *End Part 2
      
           set i to 1
           perform input-length times
               move char(i) to current-byte
               perform part-one
               set i up by 1
           end-perform           

           close input-file.
           
            
           display result
           goback.
       

       part-one.
           evaluate true also current-byte
               when start-state also 'm'
                   set m-state to true
               when m-state also 'u'
                   set u-state to true
               when u-state also 'l'
                   set l-state to true
               when l-state also '('
                   set open-state to true
               when open-state also '0' thru '9'
                   set a-state to true
                   move current-byte to a-operand
               when a-state also '0' thru '9'
                   move current-byte to temp-operand
                   compute a-operand = 10 * a-operand + temp-operand
               when a-state also ','
                   set comma-state to true
               when comma-state also '0' thru '9'
                   set c-state to true
                   move current-byte to b-operand
               when c-state also '0' thru '9'
                   move current-byte to temp-operand
                   compute b-operand = 10 * b-operand + temp-operand
               when c-state also ')'
                   compute result = result + (a-operand * b-operand)
                   move zeros to a-operand
                   move zeros to b-operand
                   move zeros to temp-operand
                   set start-state to true
               when any also any
                   move zeros to a-operand
                   move zeros to b-operand
                   move zeros to temp-operand
                   set start-state to true
           end-evaluate

       end program Day3.
