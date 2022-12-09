module alu(
    input [31:0] src1,
    input [31:0] src2,
    input [3:0] operator,
    input [2:0] branchtype, // Instruction [14:12]
    output [31:0] aluresult,
    output branchflag
);
   
//    wire signed [31:0] src1;
//    wire signed [31:0] src2;
    reg [31:0] aluresult;
    reg branchflag;
    
    
    always @*
        begin
            if (operator == 4'b0001) //ADD operation
                begin
                aluresult = src1 + src2;
                branchflag = 0;
                end
            else if (operator == 4'b0010) //SUB operation
                begin
                aluresult = src1 - src2;
                branchflag = 0;
                end
            else if (operator == 4'b0011) //XOR operation
                begin
                aluresult = src1 ^ src2;
                branchflag = 0;
                end
            else if (operator == 4'b0100) // OR operation
                begin
                aluresult = src1 | src2;
                branchflag = 0;
                end
            else if (operator == 4'b0101) //AND operation
                begin
                aluresult = src1 & src2;
                branchflag = 0;
                end
            else if (operator == 4'b0110) //SLL operation
                begin
                aluresult = src1 <<  src2[4:0];
                branchflag = 0;
                end
            else if (operator == 4'b0111) //SRL operation
                begin
                aluresult = src1 >>  src2[4:0];
                branchflag = 0;
                end
            else if (operator == 4'b1000) //SRA operation
                begin
                aluresult = src1 >>> src2[4:0];
                branchflag = 0;
                end
            else if (operator == 4'b1001) // SLT(I) operation
                begin
                if ($signed(src1) < $signed(src2))
                    aluresult = 1;
                else aluresult = 0;
                branchflag = 0;
                end
            else if (operator == 4'b1010) // SLT(I)U operation
                begin
                if (src1 < src2)
                    aluresult = 1;
                else aluresult = 0;
                branchflag = 0;
                end
            else if (operator == 4'b1011) // JAL/JALR type operations where alu output is pc+4
                begin
                aluresult = src1 + 4;
                branchflag = 1;
                end
            else if (operator == 4'b1100) // B Branch type operations
                begin
                aluresult = 32'b0;   // default assignment as it is not used 
                if (branchtype == 3'b000) begin// BEQ type
                    if (src1 == src2)
                        branchflag = 1;
                    else
                        branchflag = 0;
                    end
                else if (branchtype == 3'b001) begin// BNE type
                    if (src1 == src2) 
                        branchflag = 0;
                    else
                        branchflag = 1;
                    end
                    
                else if (branchtype == 3'b100) begin //BLT type
                    if ($signed(src1) < $signed(src2))
                        branchflag = 1;
                    else 
                        branchflag = 0;
                    end
                else if (branchtype == 3'b101) begin //BGE type
                    if ($signed(src1) >= $signed(src2))
                        branchflag = 1;
                    else
                        branchflag = 0;
                    end
                else if (branchtype == 3'b110) begin //BLTU type
                    if (src1 < src2)
                        branchflag = 1;
                    else 
                        branchflag = 0;
                    end
                else if (branchtype == 3'b111) begin //BGEU type
                    if (src1 >= src2)
                        branchflag = 1;
                    else 
                        branchflag = 0;
                    end
                else
                    branchflag = 0;
                end
            else // operator == 4'b0000 NOP - or LUI type operation : Default operation
                begin
                aluresult = src2;
                branchflag = 0;
                end
            
                
            
        end
    

endmodule
