
module mem(
    input logic i_clk,
    input logic i_rst,
    input logic [9:0] in_mem_addr,//Address for the memory 
    input logic in_mem_re_web,//read=1,write=0
    input logic [31:0] in_mem_write_data,//write data for the memory 
    input logic [3:0] in_mem_byte_en,//select which bytes to be written 
    output logic [31:0] out_mem_data//output data from memory
);

logic [31:0] memory_reg [0:1023];
// integer i;
// initial begin
// for(i=0;i<1024;i=i+1)begin
//     memory_reg [i]=32'b0;
// end
// end

// Edit the code here begin ---------------------------------------------------

  //  assign out_mem_data = 'b0;
    
// Edit the code here end -----------------------------------------------------
always @(posedge i_clk or negedge i_rst)begin
     if(!i_rst)begin
        out_mem_data <= 32'b0;
     end
     else begin
       if(in_mem_re_web==0)begin        
          for (int i=1;i<5;i=i+1)begin
              if(in_mem_byte_en[i-1])
                begin
                    for (int j = 0;j<8;j=j+1)begin
                        memory_reg[in_mem_addr][8*(i-1)+ j] <= in_mem_write_data[8*(i-1)+ j];
                    end
                    
                end
          end
      end
      else begin
             out_mem_data <= memory_reg [in_mem_addr];

     end
     end

end
/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/
generate 
      for (genvar ii=0; ii<1024; ii++) begin: gen_mem
        wire [31:0] mem_dump;
        assign mem_dump=memory_reg[ii];
      end
 endgenerate

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/mem.vcd");
        $dumpvars(0, mem);
    end
`endif

endmodule
