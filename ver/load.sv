
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module load(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] imm,
    input logic [31:0] mem_data,
    input logic [4:0] rd_in,
    input logic [2:0] load_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic rd_write_control,//rd_write_control
    output logic [4:0] rd_out,//RD_OUT
    output logic [31:0] rd_write_val,//rd_update_VAL
    output logic mem_rw_mode,
    output logic [31:0] mem_addr//mem_address_value -why is it required -combinational while loading 
);

// Edit the code here begin ---------------------------------------------------

    // assign stall_pc = 'b0;
    // assign ignore_curr_inst = 'b0;
    // assign rd_write_control = 'b0;
    // assign rd_out = 'b0;
    // assign rd_write_val = 'b0;
    // assign mem_rw_mode = 'b0;
    // assign mem_addr = 'b0;
    
// Edit the code here end -----------------------------------------------------

assign mem_rw_mode=1 ;
   always @(*)begin 
       if((load_control == 3'd1 )|(load_control == 3'd2 )|(load_control == 3'd3 )|(load_control == 3'd4 )|(load_control == 3'd5 ))begin
           stall_pc =1'b1;
           mem_addr = rs1_val + imm ;
       end  
       else begin 
           stall_pc =1'b0;
           mem_addr = 0;
       end

   end

reg [4:0] rd_in_prev;
reg [2:0] old_load_control ;
reg [31:0]  mem_prev ;

   always @(posedge i_clk or negedge i_rst) begin 
     rd_in_prev <=rd_in;
     old_load_control <=load_control;
     mem_prev <=mem_addr;
     
     if(!i_rst)begin
       ignore_curr_inst=1'b0;
       rd_in_prev<=0;
       rd_out  <=1'b0;
       old_load_control<=0;
       mem_prev<=0;
     end
     else begin 
         if((load_control == 3'd1 )|(load_control == 3'd2 )|(load_control == 3'd3 )|(load_control == 3'd4 )|(load_control == 3'd5 ))
         begin  ignore_curr_inst <=1'b1;end 
         else  ignore_curr_inst <=1'b0;
     end
   end



  always @(*)begin
 if (ignore_curr_inst) begin
        rd_write_control =1'b1; 
        rd_out =rd_in_prev; 
    
      case(old_load_control)
        3'd1:begin 
                case(mem_prev[1:0])
                2'b00:rd_write_val={{24{mem_data[7]}},mem_data[7:0]};
                2'b01:rd_write_val={{24{mem_data[15]}},mem_data[15:8]};
                2'b10:rd_write_val={{24{mem_data[23]}},mem_data[23:16]};
                2'b11:rd_write_val={{24{mem_data[31]}},mem_data[31:24]};
                endcase 
             end
        3'd2: rd_write_val= mem_prev[1] ? {{16{mem_data[31]}},mem_data[31:16]}:{{16{mem_data[15]}},mem_data[15:0]};
        3'd3: rd_write_val= mem_data;   
        3'd4:begin 
                 case(mem_prev[1:0])
                2'b00:rd_write_val={{24{1'b0}},mem_data[7:0]};
                2'b01:rd_write_val={{24{1'b0}},mem_data[15:8]};
                2'b10:rd_write_val={{24{1'b0}},mem_data[23:16]};
                2'b11:rd_write_val={{24{1'b0}},mem_data[31:24]};
                endcase 
                    
               end
        3'd5:rd_write_val= mem_prev[1] ? {{16{1'b0}},mem_data[31:16]}:{{16{1'b0}},mem_data[15:0]};
        default : begin stall_pc =0;
         rd_write_control=0 ;
         rd_out=0;
         rd_write_val=0;
         mem_addr =0; 
           end
        endcase 
 end
 else begin 
    rd_write_control=0 ;
         rd_out=0;
         rd_write_val=0;
        //  mem_addr =0; 
 end
  end





     /*else begin
        rd_write_val=0;
        case(load_control)
        3'd1:begin rd_write_val<=$signed(mem_data[7:0]);
                   rd_write_control <=1'b1; 
                   rd_out <=rd_in; 
    
             end
        3'd2: begin 
                  rd_write_val<=$signed(mem_data[15:0]);
                  rd_write_control <=1'b1; 
                   rd_out <=rd_in; 
                   ignore_curr_inst <= 1'b1; 
               end
        3'd3: begin rd_write_val[31:0]<=mem_data[31:0];
                    rd_write_control <=1'b1; 
                    rd_out <=rd_in; 
                    ignore_curr_inst <= 1'b1; 
               end
        3'd4:begin rd_write_val[7:0]<=mem_data[7:0];
                    rd_write_control <=1'b1; 
                    rd_out <=rd_in; 
                    ignore_curr_inst <= 1'b1; 
               end
        3'd5:begin rd_write_val[15:0]<=mem_data[15:0];
                    rd_write_control <=1'b1; 
                    rd_out <=rd_in; 
                    ignore_curr_inst <= 1'b1; 
               end
        default : begin stall_pc =0;
         ignore_curr_inst=0;
         rd_write_control=0 ;
         rd_out=0;
         rd_write_val=0;
         mem_addr =0; 
           end
        endcase 
     end
   end*/
/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/load.vcd");
        $dumpvars(0, load);
    end
`endif

endmodule
