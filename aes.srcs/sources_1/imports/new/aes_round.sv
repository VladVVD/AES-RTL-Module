`timescale 1ns / 1ps

module aes_round(
    input logic [127:0] state_in,
    input logic [127:0] round_key,
    input logic last_round,
    output logic [127:0] state_out
    );
    
    logic [127:0] sb_out;
    logic [127:0] sr_out;
    logic [127:0] mc_out;
    logic [127:0] last_state;
    // SubBytes
    aes_sbox sbox_0 (.in_byte(state_in[7:0]), .out_byte(sb_out[7:0]));
    aes_sbox sbox_1 (.in_byte(state_in[15:8]), .out_byte(sb_out[15:8]));
    aes_sbox sbox_2 (.in_byte(state_in[23:16]), .out_byte(sb_out[23:16]));
    aes_sbox sbox_3 (.in_byte(state_in[31:24]), .out_byte(sb_out[31:24]));
    
    aes_sbox sbox_4 (.in_byte(state_in[39:32]), .out_byte(sb_out[39:32]));
    aes_sbox sbox_5 (.in_byte(state_in[47:40]), .out_byte(sb_out[47:40]));
    aes_sbox sbox_6 (.in_byte(state_in[55:48]), .out_byte(sb_out[55:48]));
    aes_sbox sbox_7 (.in_byte(state_in[63:56]), .out_byte(sb_out[63:56]));
    
    aes_sbox sbox_8 (.in_byte(state_in[71:64]), .out_byte(sb_out[71:64]));
    aes_sbox sbox_9 (.in_byte(state_in[79:72]), .out_byte(sb_out[79:72]));
    aes_sbox sbox_10 (.in_byte(state_in[87:80]), .out_byte(sb_out[87:80]));
    aes_sbox sbox_11 (.in_byte(state_in[95:88]), .out_byte(sb_out[95:88]));
    
    aes_sbox sbox_12 (.in_byte(state_in[103:96]), .out_byte(sb_out[103:96]));
    aes_sbox sbox_13 (.in_byte(state_in[111:104]), .out_byte(sb_out[111:104]));
    aes_sbox sbox_14 (.in_byte(state_in[119:112]), .out_byte(sb_out[119:112]));
    aes_sbox sbox_15 (.in_byte(state_in[127:120]), .out_byte(sb_out[127:120]));
    
    // ShiftRows
    aes_shift_rows shift_inst (.in_data(sb_out), .out_data(sr_out));
    
    // MixColumns
    aes_mix_columns column_0 (.in_col(sr_out[127:96]), .out_col(mc_out[127:96]));
    aes_mix_columns column_1 (.in_col(sr_out[95:64]), .out_col(mc_out[95:64]));
    aes_mix_columns column_2 (.in_col(sr_out[63:32]), .out_col(mc_out[63:32]));
    aes_mix_columns column_3 (.in_col(sr_out[31:0]), .out_col(mc_out[31:0]));
    
    assign last_state = (last_round) ? sr_out : mc_out;
    assign state_out = last_state ^ round_key;
    
endmodule
