module regfile (
    input clk,
    input i_reset,
    input [4:0] i_rs1_addr,
    input [4:0] i_rs2_addr,
    input [31:0] i_wr_data,
    input [4:0] i_wr_addr,
    input i_reg_write,
    output reg [31:0] o_rs1_data,
    output reg [31:0] o_rs2_data
);

    reg [31:0] registers [31:0]; 
    integer i;

    // write and reset logic
    always @(posedge clk or posedge i_reset) begin
        if (i_reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0; 
            end
        end else if (i_reg_write) begin
            registers[i_wr_addr] <= i_wr_data;
        end
        
    end

    // read logic 
    always @ (*) begin
        // testing
        registers[2] = 'h01;
        registers[3] = 'h10;

        o_rs1_data = registers[i_rs1_addr];
        o_rs2_data = registers[i_rs2_addr];
    end


endmodule
