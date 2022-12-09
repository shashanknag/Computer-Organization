`timescale 1ns/1ps

module regfile (
    input clk,
    input [31:0] wdata,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input regwrite,
    input reset,
    output [31:0] rdata1,
    output [31:0] rdata2
);
    // Regfile for RV32I has 32 locations of 32 bits each
    reg [31:0] registers[0:31];  

    integer i;

    initial begin 
        for (i=0;i<32;i=i+1) begin
            registers[i] <= 0;
        end
    end

    assign rdata1 = registers[rs1];
    assign rdata2 = registers[rs2];
    
    always @(posedge clk) begin
        if (reset) begin
            for (i=0;i<32;i=i+1) begin
                registers[i] <= 0;
            end
        end
        else begin
            if (regwrite) registers[rd] <= wdata;
            registers[0] <= 0;
        end
    end

endmodule
