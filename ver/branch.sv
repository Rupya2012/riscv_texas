
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module branch(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] pc_prev,
    input logic [31:0] imm,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [2:0] branch_control,
    output logic pc_update_control,
    output logic [31:0] pc_update_val,
    output logic ignore_curr_inst
);

// Edit the code here begin ---------------------------------------------------
reg jump_happening ;
      always @(*) begin
       case(branch_control)
             3'h1: if (rs1_val == rs2_val) begin 
                 pc_update_control=1'b1;
                 pc_update_val = pc_prev + imm;
                 jump_happening =1;
                 end
                 else begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end
             3'h2: if (rs1_val != rs2_val) begin 
                 pc_update_control=1'b1;
                 pc_update_val = pc_prev + imm;
                 jump_happening =1;
                 end
                  else begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end
             3'h3: if ($signed(rs1_val) < $signed(rs2_val)) begin 
                 pc_update_control=1'b1;
                 pc_update_val = pc_prev + imm;
                 jump_happening =1;
                 end
                  else begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end
             3'h4: if ($signed(rs1_val) >= $signed(rs2_val)) begin 
                 pc_update_control=1'b1;
                 pc_update_val = pc_prev + imm;
                 jump_happening =1;
                 end
                  else begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end
             3'h5: if (rs1_val < rs2_val) begin 
                 pc_update_control=1'b1;
                 pc_update_val = pc_prev + imm;
                 jump_happening =1;
                 end
                  else begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end
             3'h6: if (rs1_val >= rs2_val) begin 
                 pc_update_control=1'b1;
                 pc_update_val = pc_prev + imm;
                 jump_happening =1;
                 end
                  else begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end
          default : begin 
                    pc_update_control=1'b0;
                    pc_update_val =32'b0;
                    jump_happening =0;
                 end

       endcase

          
      end

   always @(posedge i_clk or negedge i_rst)begin
       if(!i_rst)begin
                 pc_update_control=1'b0;
                 pc_update_val =32'b0;
                 ignore_curr_inst =1'b0;
       end
       else begin 
            if(pc_update_control)
            begin ignore_curr_inst =1'b1; end
       
        else  begin ignore_curr_inst =1'b0; end
       end
   end 
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/branch.vcd");
        $dumpvars(0, branch);
    end
`endif

endmodule
