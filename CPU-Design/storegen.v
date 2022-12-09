module storegen (
    input [31:0] rdata2,    // Word to be stored from register
    input [2:0] width,   // Size of load  Instruction[14:12]
    input [31:0] daddr,  // The data address, required for finding the appropriate byte/word
    input we,  // Input on whether write operation
    output [31:0] stdata,    // Data to be written into memory
    output [3:0] dwe      // Write enable for dmem
);

    reg [31:0] stdata;
    reg [3:0] dwe;
    
    wire [1:0] mempos;
    
    assign mempos = daddr[1:0];
    
    always @*
        begin
            if (we) begin
                if (width == 3'b010)  // Store word
                    begin
                    stdata = rdata2;
                    dwe = 4'b1111;
                    end
                
                else if (width == 3'b001) // Store half word
                    begin
                        if (mempos[1] == 0) begin
                            stdata = {{16{1'b0}},rdata2[15:0]};
                            dwe = 4'b0011;
                        end
                            
                        else begin
                            stdata = {rdata2[15:0],{16{1'b0}}};      // It has to be written in the upper half of the memory word
                            dwe = 4'b1100;
                        end
                        
                    end
                else // Store byte
                    begin
                        if (mempos[1] == 0 && mempos[0] == 0) begin
                            stdata = {{24{1'b0}},rdata2[7:0]};
                            dwe = 4'b0001;
                        end
                        else if (mempos[1] == 0 && mempos[0] == 1) begin
                            stdata = {{16{1'b0}},rdata2[7:0],{8{1'b0}}};
                            dwe = 4'b0010;
                        end
                        else if (mempos[1] == 1 && mempos[0] == 0) begin
                            stdata = {{8{1'b0}},rdata2[7:0],{16{1'b0}}};
                            dwe = 4'b0100;
                        end
                        else begin
                            stdata = {rdata2[7:0],{24{1'b0}}};
                            dwe = 4'b1000;
                        end
                    end
            end
            else begin
                stdata = 32'b0;
                dwe = 4'b0000;
            end
        end
                
    
endmodule