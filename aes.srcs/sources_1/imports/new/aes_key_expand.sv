`timescale 1ns / 1ps

module aes_key_expand(
    input logic [127:0] in_key,
    input logic [3:0] round_idx,
    output logic [127:0] out_key
    );
    
    logic [31:0] w0, w1, w2, w3;
    logic [31:0] w4, w5, w6, w7;
    
    assign w0 = in_key[127:96];
    assign w1 = in_key[95:64];    
    assign w2 = in_key[63:32];
    assign w3 = in_key[31:0];
    
    logic [31:0] rot;
    assign rot = {w3[23:16], w3[15:8], w3[7:0], w3[31:24]};
    
    logic [31:0] sub;
    aes_sbox sbox_0 (.in_byte(rot[31:24]), .out_byte(sub[31:24]));
    aes_sbox sbox_1 (.in_byte(rot[23:16]), .out_byte(sub[23:16]));
    aes_sbox sbox_2 (.in_byte(rot[15:8]), .out_byte(sub[15:8]));
    aes_sbox sbox_3 (.in_byte(rot[7:0]), .out_byte(sub[7:0]));
    
    logic [31:0] rcon;
    always_comb begin
        case (round_idx)
            4'h1: rcon = 32'h01000000;
            4'h2: rcon = 32'h02000000;
            4'h3: rcon = 32'h04000000;
            4'h4: rcon = 32'h08000000;
            4'h5: rcon = 32'h10000000;
            4'h6: rcon = 32'h20000000;
            4'h7: rcon = 32'h40000000;
            4'h8: rcon = 32'h80000000;
            4'h9: rcon = 32'h1b000000;
            4'ha: rcon = 32'h36000000;
            default: rcon = 32'h00000000;
        endcase
    end
    
    assign w4 = w0 ^ sub ^ rcon;
    assign w5 = w1 ^ w4;
    assign w6 = w2 ^ w5;
    assign w7 = w3 ^ w6;
    
    assign out_key = {w4, w5, w6, w7};
    
endmodule
