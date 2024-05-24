module fetch (
    input clk,
    input i_reset,           // pc reset
    input i_branch_taken,    // signal indicating a branch is taken
    input [31:0] i_branch_target, // target address for branch
    input [31:0] i_instr,
    input i_req_instr, // request for instruction
    output [31:0] o_pc,     // address of next instruction
    output reg [31:0] o_instr 
);
    reg [31:0] pc; // buffered PC 

    always @ (posedge clk or posedge i_reset) begin
        if (i_reset)
            pc <= 32'b0;
        else if (i_branch_taken)
            pc <= i_branch_target; 
        else if (i_req_instr)
            pc <= pc + 4;
    end
   
    always @ (posedge clk) begin
        if (i_req_instr)
            o_instr <= i_instr;   
    end

    assign o_pc = pc;

endmodule
