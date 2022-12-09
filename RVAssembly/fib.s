.global fib
fib:
    
#If a non natural number input is fed in, program exits returning 0

    blez a0, .ERROR
    
    li a1, 1         #Load 1 to a1, the first number in Fibonacci series
    li a2, 1         #Load 1 to a1, the second number in Fibonacci series
    li a4, 2         #Load 2 to a4; represents the count of current Fibonacci number
    
    ble a0, a4,.TRIVIAL #Check if input (n) is less than or equal to 2, in which case branch to .TRIVIAL
    
    
.COMPUTE:

    #a2 represents the (current-1)th Fibonacci number, while a1 (current-2)th Fibonacci number
    #The program proceeds by adding the previous two numbers to generate the current number, until the required position is reached
    
    ADD a3, a2, a1      #Add the values in a2 and a1 and store in a3
    ADDI a4,a4,1        #Increment counter by 1
    beq a0,a4,.FINISH   #Check if a4 = a0, i.e., counter = n. If yes, then branch to FINISH 
    mv a1, a2           #Else, shift the numbers to lower registers to prepare for the next iteration
    mv a2, a3
    j .COMPUTE          #Compute the new number again

    
.FINISH:
    #Indicates completion of calculation. The result is stored in a3
    
    mv a0, a3 # Move result into reg a0, as that is the return register
    jr ra       # Return address was stored by original call. Jump to that address
    ecall

.TRIVIAL:

    #Indicates the case where n is either 1 or 2. In both cases, the Fibonacci number is 1
    
    li a0, 1
    jr ra
    ecall

.ERROR:

    #Indicates the case when input was not a natural number. Return 0 to flag error
    li a0, 0
    jr ra
    ecall
