module control (
    input [4:0] instr,   // Instruction[6:2]
    input [2:0] width, // Instruction [14:12] for load/store width calculator
    output [1:0] jumptype,
    output memread, 
    output memtoreg,
    output we,
    output [1:0] alusrc, // alusrc[0] corresponds to rs1 and alusrc[1] corresponds to rs2. HIGH implies the source registers are being used
    output regwrite,
    output [2:0] aluop,
    output [2:0] immtype
);


    reg [1:0] jumptype;
    reg memread;
    reg memtoreg;
    reg we;
    reg [1:0] alusrc;
    reg regwrite;
    reg [2:0] aluop;
    reg [2:0] immtype;

    always @*
        begin
            
            if (instr == 5'b11000)   // Branch Instruction
            begin
                jumptype = 2'b01;
                memread = 0;
                memtoreg = 0;
                we = 0;
                alusrc = 2'b11; 
                regwrite = 0;
                aluop = 3'b011; 
                immtype = 3'b100;
                
            end
            else if (instr == 5'b00000) // Load type Instruction
            begin
                jumptype = 2'b00;
                memread = 1;
                memtoreg = 1;
                we = 0;
                alusrc = 2'b01;
                regwrite = 1;
                aluop = 3'b100;
                immtype = 3'b001;

            end
            else if (instr == 5'b01000) // Store type Instruction
            begin
                jumptype = 2'b00;
                memread = 0;
                memtoreg = 0;
                alusrc = 2'b01;
                regwrite = 0;
                aluop = 3'b101;
                immtype = 3'b010;
                we = 1;
            end
            else if (instr == 5'b01101) // LUI Instruction  ----- need to access pc here
            begin
                        jumptype = 2'b00;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b00;
                        regwrite = 1;
                        aluop = 3'b000; 
                        immtype = 3'b000;
            end
            else if (instr == 5'b00101) //AUIPC Instruction ------- need to access pc here
            begin
                        jumptype = 2'b00;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b00;
                        regwrite = 1;
                        aluop = 3'b001; 
                        immtype = 3'b000;
            end
            else if (instr == 5'b11011) //JAL Instruction  ------ need to access pc here
            begin
                        jumptype = 2'b01;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b00;
                        regwrite = 1;
                        aluop = 3'b010;
                        immtype = 3'b101;
            end
            else if (instr == 5'b11001) // JALR Instruction ------ need to access pc here
            begin
                        jumptype = 2'b10;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b00;
                        regwrite = 1;
                        aluop = 3'b010;
                        immtype = 3'b001;
            end
            else if (instr == 5'b00100) // ALU Immediate type Instructions
            begin
                        jumptype = 2'b00;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b01;
                        regwrite = 1;
                        aluop = 3'b110;
                        immtype = 3'b001;
            end
            else if (instr == 5'b01100) // ALU R to R Instructions
            begin
                        jumptype = 2'b00;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b11;
                        regwrite = 1;
                        aluop = 3'b111;
                        immtype = 3'b111;
            end
            else begin
                        jumptype = 2'b00;
                        memread = 0;
                        memtoreg = 0;
                        we = 0;
                        alusrc = 2'b00;
                        regwrite = 0;
                        aluop = 3'b000;
                        immtype = 3'b111;
            end

        end
    
endmodule
