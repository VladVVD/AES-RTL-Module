`timescale 1ns / 1ps

module aes_mix_columns(
    input logic [31:0] in_col,
    output logic [31:0] out_col  
    );
    
    function automatic [7:0] xtime(input logic [7:0] in_byte);
        xtime = (in_byte << 1) ^ (in_byte[7] ? 8'h1B : 8'h00);
    endfunction
    
    logic [7:0] s0, s1, s2, s3;
    logic [7:0] o0, o1, o2, o3;
    
    assign s0 = in_col[31:24];
    assign s1 = in_col[23:16];    
    assign s2 = in_col[15:8];
    assign s3 = in_col[7:0];
    
    assign o0 = xtime(s0) ^ (xtime(s1) ^ s1) ^ s2 ^ s3;
    assign o1 = s0 ^ xtime(s1) ^ (xtime(s2) ^ s2) ^ s3;
    assign o2 = s0 ^ s1 ^ xtime(s2) ^ (xtime(s3) ^ s3);
    assign o3 = (xtime(s0) ^ s0) ^ s1 ^ s2 ^ xtime(s3);
    
    assign out_col = {o0, o1, o2, o3};
    
endmodule
