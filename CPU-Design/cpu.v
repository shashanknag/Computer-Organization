module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
    reg [31:0] iaddr;
    
    wire [31:0] daddr;
    wire [3:0]  dwe_wire;
    
    wire [31:0] dwdata_wire;
    
    wire [31:0] wdata;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire regwrite;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    
    wire [1:0] jumptype; 
    wire memread;
    wire memtoreg;
    wire we;
    wire [1:0] alusrc;
    wire [2:0] aluop;
    wire [3:0] operator;
    wire [31:0] se_imm;
    wire [31:0] src1;
    wire [31:0] src2;
    wire [31:0] aluresult;
    wire branchflag;
    wire [2:0] immtype;
    
    wire [31:0] newpc;
    


    
    //Instantiate the RegFile
    regfile r1(.clk(clk),.wdata(wdata),.rs1(idata[19:15]),.rs2(idata[24:20]),.rd(idata[11:7]),.regwrite(regwrite),.reset(reset),.rdata1(rdata1),.rdata2(rdata2));
    
    //Instantiating control module
    control c1(  .instr(idata[6:2]),   // Instruction[6:2]
                    .width(idata[14:12]), // Instruction [14:12] for load/store width calculator
                    .jumptype(jumptype),
                    .memread(memread), 
                    .memtoreg(memtoreg),
                    .we(we),
                    .alusrc(alusrc), // alusrc[0] corresponds to rs1 and alusrc[1] corresponds to rs2. HIGH implies the source registers are being used
                    .regwrite(regwrite),
                    .aluop(aluop),
                    .immtype(immtype));

    //Instantiating the immediate generator module - this module is responsible for creating the appropriate immediate data as per the instruction decoding
    immgen imm1(    .instr(idata),    // Input 32 bit instruction
                      .immtype(immtype),   // How the immediate has to be extended based on the opcode
                      .se_imm(se_imm)    // sign extended immediate
                 );
    
    //Instantiating the alucontrol module. This module controls all the input signals to the ALU
    alucontrol aluc1 (   .funct7part(idata[30]), //Instruction [30]
                              .funct3(idata[14:12]),
                              .aluop(aluop),
                              .operator(operator),  
                              .pc(iaddr),
                              .rdata1(rdata1),
                              .rdata2(rdata2),
                              .se_imm(se_imm),
                              .src1(src1),
                              .src2(src2));

    
    //Instantiating THE ALU                       
    alu alu1(   .src1(src1),
               .src2(src2),
               .operator(operator),
               .branchtype(idata[14:12]), // Instruction [14:12]
               .aluresult(aluresult),
               .branchflag(branchflag));
    
    //Instantiating the pccalc module. This module is responsible for calculating the next instruction address based on whether on not the branch is taken
    pccalc p1 (    .pc(iaddr),    // 32 bit instruction address
                       .se_imm(se_imm),
                        .src1(rdata1),
                       .jumptype(jumptype),   // Type of jump/branch instruction
                       .branchflag(branchflag), // ALU result on whether to branch or not
                       .newpc(newpc));
    
    //Instantiating the wdatagen module. This module is responsible for computing the data that is to be loaded into the regfile in the next clock edge                       
    wdatagen w1(    .aluresult(aluresult),    // Result from ALU
                        .drdata(drdata), //Read data from dmem
                        .memtoreg(memtoreg), // Control signal indicating memory to be read
                        .ldsize(idata[14:12]),   // Size of load  Instruction[14:12]
                      .regwdata(wdata),    // Data to be written into register
                      .daddr(daddr)
                      );
    
    //Instantiating the storegen module. This module is responsible for computing the data that is to be stored in the dmem
    storegen s1 (  .rdata2(rdata2),    // Word to be stored from register
                       .we(we),  // Input on whether store operation
                       .width(idata[14:12]),   // Size of load  Instruction[14:12]
                       .daddr(daddr),  // The data address, required for finding the appropriate byte/word
                       .stdata(dwdata_wire),    // Data to be written into memory
                       .dwe(dwe_wire)
);
                           

    //Assigning the inputs to dmem using asynchronous reset
    assign daddr = reset?0:aluresult;
    assign dwdata = reset?0:dwdata_wire;
    assign dwe = reset?0:dwe_wire;
    
    
    //Assigning the instruction address at each clock edge based on the value computed by the pccalc module, alongwith a synchronous reset using the same signal
    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
        end 
        else 
            iaddr <= newpc;
    end

endmodule
