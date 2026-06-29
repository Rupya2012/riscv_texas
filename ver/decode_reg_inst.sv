
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_reg_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [4:0] alu_control
);

// Edit the code here begin ---------------------------------------------------
    wire[9:0] funct;
    assign rs1 = instruction_code[19:15];
    assign rs2 = instruction_code[24:20];
    assign rd = instruction_code[11:7];

    assign funct= {instruction_code[31:25],instruction_code[14:12]};
    always @(*)begin
           case(funct)
              {7'h00,3'h0}:alu_control= `ADD;
              {7'h20,3'h0}:alu_control=`SUB;
              {7'h00,3'h4}:alu_control= `XOR;
              {7'h00,3'h6}:alu_control= `OR;
              {7'h00,3'h7}:alu_control= `AND;
              {7'h00,3'h1}:alu_control= `SLL;
              {7'h00,3'h5}:alu_control= `SRL;
              {7'h20,3'h5}:alu_control= `SRA;
              {7'h00,3'h2}:alu_control= `SLT;
              {7'h00,3'h3}:alu_control= `SLTU;
              default :alu_control=`ALU_NOP;
           endcase
    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_reg_inst.vcd");
        $dumpvars(0, decode_reg_inst);
    end
`endif

endmodule
