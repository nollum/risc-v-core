module core(
    input clk,
    input reset,
    input [31:0] i_instr,
    input i_req_instr
);


    // fetch
    wire branch_taken;
    wire [31:0] pc;
    wire [31:0] branch_target;
    wire [31:0] instr;

    // decoder & regfile
    wire [4:0] rd_addr;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [31:0] rd_data;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] imm;

    // control
    wire [3:0] aluctrl;
    wire memread;
    wire memtoreg;
    wire memwrite;
    wire alusrc;
    wire regwrite;

    // alu
    wire [31:0] aluresult;

    // mem access
    wire [31:0] mem_read_data;
    wire [9:0] mem_wr_addr;


    regfile rf(
        .clk(clk),
        .i_reset(reset),
        .i_rs1_addr(rs1_addr),
        .i_rs2_addr(rs2_addr),
        .i_wr_data(rd_data),
        .i_wr_addr(rd_addr),
        .i_reg_write(regwrite),
        .o_rs1_data(rs1_data),
        .o_rs2_data(rs2_data)
    );

    fetch f(
        .clk(clk),
        .i_reset(reset),
        .i_branch_taken(branch_taken),
        .i_instr(i_instr),
        .i_branch_target(branch_target),
        .i_req_instr(i_req_instr),
        .o_pc(pc),
        .o_instr(instr)
    );

    decoder dec(
        .i_instr(instr),
        .o_rd_addr(rd_addr),
        .o_rs1_addr(rs1_addr),
        .o_rs2_addr(rs2_addr),
        .o_imm(imm),
        .o_aluctrl(aluctrl),
        .o_branch(branch_taken),
        .o_memread(memread),
        .o_memtoreg(memtoreg),
        .o_memwrite(memwrite),
        .o_alusrc(alusrc),
        .o_regwrite(regwrite)
    );

    alu exec(
        .clk(clk),
        .i_rs2_data(rs2_data),
        .i_rs1_data(rs1_data),
        .i_aluctrl(aluctrl),
        .i_alusrc(alusrc),
        .i_imm(imm),
        .o_aluresult(aluresult)
    );

    memaccess mem(
        .clk(clk),
        .i_mem_read_en(memread),
        .i_mem_write_en(memwrite),
        .i_write_data(rs2_data),
        .i_aluresult(aluresult),
        .o_read_data(mem_read_data)
    );

    writeback wb(
        // .i_rd_addr(rd_addr),
        .i_mem_to_reg(memtoreg),
        .i_write_data(mem_read_data),
        .i_aluresult(aluresult),
        // .o_rd_addr(rd_addr),
        .o_write_data(rd_data)
    );

endmodule