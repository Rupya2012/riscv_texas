
module ifu(
    input logic i_clk,
    input logic i_rst,
    input logic stall_pc,
    input logic pc_update_control,
    input logic [31:0] pc_update_val,
    output logic [31:0] pc,
    output logic [31:0] pc_prev
);

// Edit the code here begin ---------------------------------------------------

    // assign pc = 'b0;
    // assign pc_prev = 'b0;
    
// Edit the code here end -----------------------------------------------------

always @(posedge i_clk or negedge i_rst)begin
    if(!i_rst)begin
        pc <= 32'b0;
        pc_prev<=32'b0;
    end
    else begin 
       if (!stall_pc)begin
          if( pc_update_control)begin
             pc_prev<=pc;
             pc<=pc_update_val ;
          end
          else begin
             pc_prev=pc;
             pc=pc_prev+4;
          end
       
    end
   

end

end


/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/ifu.vcd");
        $dumpvars(0, ifu);
    end
`endif

endmodule
