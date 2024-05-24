// 0000 AND
// 0001 OR
// 0010 add
// 0110 subtract

// add branch support (SB-type)

module alu(
    input clk, 
    input [31:0] i_rs2_data, 
    input [31:0] i_rs1_data, 
    input [3:0] i_aluctrl, 
    input i_alusrc, 
    input [31:0] i_imm,
    output reg [31:0] o_aluresult
    // output wire o_alucarry
);
    reg [31:0] data2;

    always @ (*) begin 
        if (i_alusrc)
            data2 = i_imm;
        else
            data2 = i_rs2_data;
    end

    // wire [32:0] temp;
    // temp = {0,i_rs1_data} + {0,data2};
    // o_alucarry = temp[32];

    always @ (*) begin
        case(i_aluctrl)
        4'b0000:
            o_aluresult = i_rs1_data & data2;
        4'b0001:
            o_aluresult = i_rs1_data | data2;
        4'b0010:
            o_aluresult = i_rs1_data + data2; 
        4'b0110:
            o_aluresult = i_rs1_data - data2;
        default: o_aluresult = 0; 
        endcase
    end



endmodule