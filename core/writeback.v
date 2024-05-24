module writeback(
    // input [4:0] i_rd_addr,
    input i_mem_to_reg,
    input [31:0] i_write_data,
    input [31:0] i_aluresult,
    // output reg [4:0] o_rd_addr,
    output reg [31:0] o_write_data
);

    always @ (*) begin
        // o_rd_addr = i_rd_addr;
        if (i_mem_to_reg)
            o_write_data = i_write_data;
        else
            o_write_data = i_aluresult;
    end

endmodule