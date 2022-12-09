module alucontrol (
    input funct7part, //Instruction [30]
    input [2:0] funct3,
    input [2:0] aluop,
    output [3:0] operator,
    
    input [31:0] pc,
    input [31:0] rdata1,
    input [31:0] rdata2,
    input [31:0] se_imm,
    output [31:0] src1,
    output [31:0] src2
    
);
    reg [3:0] operator;
    reg [31:0] src1;
    reg [31:0] src2;

    always @*
        begin
            if (aluop == 3'b000)          // LUI instruction
                begin
                    src1 = rdata1;
                    src2 = se_imm;
                    operator = 4'b0000;    //NOP operation
                end
            else if (aluop == 3'b001)     // AUIPC instruction
                begin
                    src1 = pc;
                    src2 = se_imm;
                    operator = 4'b0001; //ADD operation to be performed
                end
            else if (aluop == 3'b010)   // JAL/JALR instruction
                begin
                    src1 = pc;
                    src2 = rdata2;
                    operator  = 4'b1011; // ADD operation
                end
            else if (aluop == 3'b011)
                begin
                    src1 = rdata1;
                    src2 = rdata2;
                    operator = 4'b1100; // Branch operation
                end
            else if (aluop == 3'b100)   // Load instruction
                begin
                    src1 = rdata1;
                    src2 = se_imm;
                    operator = 4'b0001; // ADD operation to be performed
                end
            else if (aluop == 3'b101)  // Store operation
                begin
                    src1 = rdata1;
                    src2 = se_imm;
                    operator = 4'b0001; //ADD operation to be performed
                end
            else if (aluop == 3'b110)  // Immediate type ALU operations
                begin
                    src1 = rdata1;
                    src2 = se_imm;
                    if (funct3 == 3'b000)     //ADDI
                        operator = 4'b0001;  //ADD operation
                    else if (funct3 == 3'b010) //SLTI
                        operator = 4'b1001;
                    else if (funct3 == 3'b011) //SLTIU 
                        operator = 4'b1010;
                    else if (funct3 == 3'b100) //XORI
                        operator = 4'b0011;
                    else if (funct3 == 3'b110) //ORI
                        operator = 4'b0100;
                    else if (funct3 == 3'b111) //ANDI
                        operator = 4'b0101;
                    else if (funct3 == 3'b001) //SLLI
                        operator = 4'b0110;
                    else if (funct3 == 3'b101)
                        begin
                            if (funct7part == 0) //SRLI
                                operator = 4'b0111;
                            else               //SRAI
                                operator = 4'b1000;
                        end
                    else
                        operator = 4'b0000;  // Invalid; default NOP operation
                end
            else  // 111 - Regular R to R type ALU operations
                begin
                    src1 = rdata1;
                    src2 = rdata2;
                    if (funct3 == 3'b000)     
                        begin
                            if (funct7part == 0)        //ADD
                                operator = 4'b0001;
                            else                      //SUB
                                operator = 4'b0010;  
                        end
                    else if (funct3 == 3'b010) //SLT
                        operator = 4'b1001;
                    else if (funct3 == 3'b011) //SLTU 
                        operator = 4'b1010;
                    else if (funct3 == 3'b100) //XOR
                        operator = 4'b0011;
                    else if (funct3 == 3'b110) //OR
                        operator = 4'b0100;
                    else if (funct3 == 3'b111) //AND
                        operator = 4'b0101;
                    else if (funct3 == 3'b001) //SLL
                        operator = 4'b0110;
                    else //  (funct3 == 3'b101) & default
                        begin
                            if (funct7part == 0) //SRL
                                operator = 4'b0111;
                            else               //SRA
                                operator = 4'b1000;
                        end
                end
                                   
        end        
            
    
endmodule

