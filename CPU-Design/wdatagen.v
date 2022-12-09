module wdatagen (
    input [31:0] aluresult,    // Result from ALU
    input [31:0] drdata, //Read data from dmem
    input  memtoreg, // Control signal indicating memory to be read
    input [2:0] ldsize,   // Size of load  Instruction[14:12]
    input [31:0] daddr,  // The data address, required for finding the appropriate byte/word
    output [31:0] regwdata    // Data to be written into register
);

    reg [31:0] regwdata;
    
    wire [1:0] mempos;
    
    assign mempos = daddr[1:0];
    
    always @*
        begin
            if (memtoreg == 0)  //ALU result to be stored sent to regfile
                regwdata = aluresult; 
            
            else 
                begin
                if (ldsize == 3'b001) // Load half word
                    begin
                        if (mempos[1] == 0)
                            regwdata = {{16{drdata[15]}},drdata[15:0]};
                        else
                            regwdata = {{16{drdata[31]}},drdata[31:16]};
                    end
                else if (ldsize == 3'b000) // Load byte
                    begin
                        if (mempos[1] == 0 && mempos[0] == 0)
                            regwdata = {{24{drdata[7]}},drdata[7:0]};
                        else if (mempos[1] == 0 && mempos[0] == 1)
                            regwdata = {{24{drdata[15]}},drdata[15:8]};
                        else if (mempos[1] == 1 && mempos[0] == 0)
                            regwdata = {{24{drdata[23]}},drdata[23:16]};
                        else
                            regwdata = {{24{drdata[31]}},drdata[31:24]};
                    end
                else if (ldsize == 3'b101) // Load half word unsigned
                    begin
                        if (mempos[1] == 0)
                            regwdata = {{16{1'b0}},drdata[15:0]};
                        else
                            regwdata = {{16{1'b0}},drdata[31:16]};
                    end
                else if (ldsize == 3'b100) // Load byte unsigned
                    begin
                        if (mempos[1] == 0 && mempos[0] == 0)
                            regwdata = {{24{1'b0}},drdata[7:0]};
                        else if (mempos[1] == 0 && mempos[0] == 1)
                            regwdata = {{24{1'b0}},drdata[15:8]};
                        else if (mempos[1] == 1 && mempos[0] == 0)
                            regwdata = {{24{1'b0}},drdata[23:16]};
                        else
                            regwdata = {{24{1'b0}},drdata[31:24]};
                    end
                else  // Default - Load word
                    regwdata = drdata;

                end
        end
                
    
endmodule
