module cu_top(
    input rst_n,
    output[7:0] led,
);

assign led = rst_n ? 8'hAA : 8'h55;
    
endmodule
