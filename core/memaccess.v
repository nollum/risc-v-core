// data memory unit and controller

module memaccess(
    input clk,
    input i_mem_read_en,
    input i_mem_write_en,
    input [31:0] i_aluresult,      // output from ALU
    input [31:0] i_write_data,
    output reg [31:0] o_read_data
);

    reg [31:0] mem_data [1023:0];

    // read logic 
    always @ (*) begin
        if (i_mem_read_en)
           o_read_data = mem_data[i_aluresult[11:2]]; 
    end

    // write logic 
    always @ (posedge clk) begin
        if (i_mem_write_en)
            mem_data[i_aluresult[11:2]] <= i_write_data;
    end

    // function [31:0] get_mem_data;
    //     input [31:0] addr;
    //     begin
    //         get_mem_data = mem_data[addr[11:2]];
    //     end
    // endfunction

    // function [31:0] set_mem_data;
    //     input [31:0] addr;
    //     input [31:0] data;
    //     begin
    //         mem_data[addr[11:2]] = data;
    //     end
    // endfunction

endmodule