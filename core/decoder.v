module decoder (
    input [31:0] i_instr,
    input [31:0] i_pc,
    output [31:0] o_pc,
    output reg [4:0] o_rd_addr,
    output reg [4:0] o_rs1_addr,
    output reg [4:0] o_rs2_addr,
    output reg [31:0] o_imm,
    output reg [3:0] o_aluctrl,
    output reg o_branch,
    output reg o_memread,
    output reg o_memtoreg,
    output reg o_memwrite,
    output reg o_alusrc,
    output reg o_regwrite
);   
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    reg [1:0] aluop;

    assign opcode = i_instr[6:0];
    assign funct3 = i_instr[14:12];
    assign funct7 = i_instr[31:25];

    always @(*) begin

        o_rs1_addr = i_instr[19:15];
        o_rs2_addr = i_instr[24:20];
        o_rd_addr = i_instr[11:7];

        case (opcode) 
            7'b0110011: begin // R-type
                if (funct7 == 7'b0000000 && funct3 == 3'b000)
                    o_aluctrl = 4'b0010; // ADD
                else if (funct7 == 7'b0100000 && funct3 == 3'b000)
                    o_aluctrl = 4'b0110; // SUB
                else if (funct7 == 7'b0000000 && funct3 == 3'b111)
                    o_aluctrl = 4'b0000; // AND
                else if (funct7 == 7'b0000000 && funct3 == 3'b110)
                    o_aluctrl = 4'b0001; // OR
                aluop = 2'b10;

                o_alusrc = 0;
                o_memread = 0;
                o_memtoreg = 0;
                o_memwrite = 0;
                o_branch = 0;
                o_regwrite = 1;
            end
            7'b0000011: begin // lw (I-type)
                aluop = 2'b00;
                o_aluctrl = 4'b0010;
                o_imm = {{20{i_instr[31]}}, i_instr[31:20]};

                o_alusrc = 1;
                o_memtoreg = 1;
                o_memwrite = 0;
                o_memread  = 1;
                o_branch = 0;
                o_regwrite = 1;
            end
            7'b0100011: begin // S-type
                aluop = 2'b00;
                o_aluctrl = 4'b0010;
                o_imm = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};

                o_alusrc = 1;
                o_memread = 0;
                o_memtoreg = 0; // don't care
                o_memwrite = 1;
                o_branch = 0;
                o_regwrite = 0;
            end
            7'b1100011: begin // SB-type
                aluop = 2'b01;
                o_aluctrl = 4'b0110;
                o_imm = {{19{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0};

                o_alusrc = 0;
                o_memtoreg = 0; // don't care
                o_memwrite = 0;
                o_memread  = 0;
                o_branch = 1;
                o_regwrite = 0;
            end
            default: begin
                o_aluctrl = 4'b0000; // NOP or undefined behavior
                o_alusrc = 0;
                o_memtoreg = 0;
                o_memwrite = 0;
                o_memread  = 0;
                o_branch = 0;
                o_regwrite = 0;
            end
        endcase
    end

endmodule
