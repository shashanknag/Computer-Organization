//                              -*- Mode: Verilog -*-
// Filename        : seq-mult.v
// Description     : Sequential multiplier
// Author          : Shashank Nag


// This style of modeling is 'behavioural', where the desired
// behaviour is described in terms of high level statements ('if'
// statements in verilog).  This is where the real power of the
// language is seen, since such modeling is closest to the way we
// think about the operation.  However, it is also the most difficult
// to translate into hardware, so a good understanding of the
// connection between the program and hardware is important.

`define width 8
`define ctrwidth 4

module seq_mult (
		 // Outputs
		 p, rdy, 
		 // Inputs
		 clk, reset, a, b
		 ) ;
   input 		 clk, reset;
   input [`width-1:0] 	 a, b;
   // *** Output declaration for 'p'
   output [2*`width - 1 :0] p;
   output 		 rdy;
   
   // *** Register declarations for p, multiplier, multiplicand
    reg [2*`width -1 :0] multiplier;
    reg [2*`width -1 :0] multiplicand;
    reg [2*`width -1 : 0] p;
    reg 			 rdy;
    reg [`ctrwidth:0] 	 ctr;

    always @(posedge clk)  // Changed it to synchronous reset due to synthesis issues
     if (reset) begin
        rdy <= 0;
        p   <= 0;
        ctr <= 0;
    
        multiplier <= {{`width{a[`width-1]}}, a}; // sign-extend into 2*`width sized 
        multiplicand <= {{`width{b[`width-1]}}, b}; // sign-extend into 2*`width sized 
     end 
    
     else begin 
         if (ctr < 2*`width)// Loop should run 2*`width times, which is the number of bits in the multiplier
            begin
            //Code for multiplication
             if (multiplier[ctr] == 0)  // The current bit essentially acts as the select line for the MUX
                begin
                  p <= p+0;  // If the bit is zero, MUX gives out zero which is fed into the adder
                end
             else
                begin
                  p <= p + (multiplicand << ctr); // If the current bit is 1, MUX feeds in the shifted multiplicand into the adder
                end
             ctr <= ctr+1;  // Updating the counter after an iteration 
            end 
         
         else begin
              rdy <= 1; 		// Assert 'rdy' signal to indicate end of multiplication
         end
     end
   
endmodule // seqmult
