module pccalc (
    input [31:0] pc,    // Input 32 bit instruction address
    input [31:0] se_imm,
    input [31:0] src1,
    input [1:0] jumptype,   // Type of jump/branch instruction
    input branchflag, // ALU result on whether to branch or not
    output [31:0] newpc 
);

    reg [31:0] jalrresult;
    reg [31:0] newpc;
    
    always @*
        begin
            if (branchflag == 0)
            newpc = pc + 4;
            else
            begin
                if (jumptype == 2'b01) // Asserted Branch or JAL type 
                    newpc = pc + se_imm;  // pc added with the offset
            
                else if (jumptype == 2'b10) // JALR type
                    begin
                        jalrresult = src1 + se_imm;
                        newpc = {{jalrresult[31:1]},{1{1'b0}}};
                    end                               
                else  //No branch
                    newpc = pc + 4;  // pc incremented by 4 to indicate next instruction 
            
            end   
        end
                
    
    
endmodule