module immgen (
    input [31:0] instr,    // Input 32 bit instruction
    input [2:0] immtype,   // How the immediate has to be extended based on the opcode
    output [31:0] se_imm    // sign extended immediate
);

    reg [31:0] se_imm;
    
    always @*
        begin
            if (immtype == 3'b000)  //imm[31:12] - U type
                se_imm = {instr[31:12],{12{1'b0}}};  // Append zeroes to the end 
            
            else if (immtype == 3'b001) // imm[11:0] type 
                se_imm = {{20{instr[31]}},instr[31:20]};  // Sign extend to 32 bits
            
            else if (immtype == 3'b010) // Store type instructions imm[11:5] imm[4:0]
                se_imm = {{20{instr[31]}},instr[31:25],instr[11:7]};
            
            else if (immtype == 3'b011) // Immediate shift type -- this is redundant
                se_imm = {{27{1'b0}},instr[24:20]};
            
            else if (immtype == 3'b100) // Conditional branch type
                se_imm = {{21{instr[31]}},instr[7],instr[30:25],instr[11:8],{1{1'b0}}};
            
            else if (immtype == 3'b101) // JAL type
                se_imm = {{13{instr[31]}},instr[19:12],instr[20],instr[30:21],{1{1'b0}}};
                                   
            else 
                se_imm = instr;
                
        end
                
    
    
endmodule