
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_branch_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [12:0] imm,
    output logic [2:0] branch_control
);

// Edit the code here begin ---------------------------------------------------


    assign rs1 = instruction_code[19:15];
    assign rs2 = instruction_code[24:20];
    assign imm ={ instruction_code[31],instruction_code[7],instruction_code[30:25],instruction_code[11:8],1'b0};
    wire [2:0]funct3;
    assign  funct3=instruction_code[14:12];
    always @(*)begin
       case(funct3)
          3'h0: branch_control= `BEQ;
          3'h1: branch_control= `BNE;
          3'h4: branch_control= `BLT;
          3'h5: branch_control= `BGE;
          3'h6: branch_control= `BLTU;
          3'h7: branch_control= `BGEU;
          default :  branch_control= `BR_NOP ;

       endcase
    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_branch_inst.vcd");
        $dumpvars(0, decode_branch_inst);
    end
`endif

endmodule
