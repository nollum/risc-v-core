module core_tb;

    // testbench signals
    reg clk;
    reg reset;
    reg [31:0] i_instr;
    reg req_instr; 

    core uut (
        .clk(clk),
        .reset(reset),
        .i_req_instr(req_instr),
        .i_instr(i_instr)
    );

    always #5 clk = ~clk; // 10ns period clock

    initial begin
        clk = 0;
        reset = 1;
        i_instr = 32'b0;
        req_instr = 0;

        #10;
        reset = 0;

        // ADD x1, x2, x3 
        req_instr = 1;
        i_instr = 32'b0000000_00011_00010_000_00001_0110011;
        #10;
        req_instr = 0;

        // SUB x1, x2, x3 
        req_instr = 1;
        i_instr = 32'b0100000_00011_00010_000_00001_0110011;
        #10;
        req_instr = 0;

        // SW x1, 0(x4) 
        req_instr = 1;
        i_instr = 32'b0000000_00001_00100_010_00000_0100011;
        #10;
        req_instr = 0;

        // LW x5, 0(x4)
        req_instr = 1;
        i_instr = 32'b0000000_00000_00100_010_00101_0000011; 
        #10;
        req_instr = 0;

        #10;
        $finish;
    end

    always @(negedge clk) begin
        $display("At time %t, PC: %h, Instr: %h, rd: %h, rs1: %h, rs2: %h, rd_data: %h, rs1_data: %h, rs2_data: %h",
                 $time, uut.pc, uut.instr, uut.rd_addr, uut.rs1_addr, uut.rs2_addr, uut.rd_data, uut.rs1_data, uut.rs2_data);
    end

    always @(negedge clk) begin
        $display("Memory at address %h at time %t: %h", uut.rf.registers[4], $time, uut.mem.mem_data[uut.rf.registers[4][11:2]]);
    end

    always @(negedge clk) begin
        $display("Value at register %h at time %t: %h", 5, $time, uut.rf.registers[5]);
    end

endmodule
