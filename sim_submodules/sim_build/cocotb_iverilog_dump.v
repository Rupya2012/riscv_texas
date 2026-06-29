module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/inst_data_arbiter.fst");
    $dumpvars(0, inst_data_arbiter);
end
endmodule
