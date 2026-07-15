`timescale 1ns / 1ps

module aes_core (
    input logic clk,
    input logic rst,

    input logic start,

    input logic [127:0] plaintext_in,
    input logic [127:0] key_in,
    output logic [127:0] ciphertext_out,
    output logic valid
);

    typedef enum logic [1:0] {INIT, CALC, DONE} state_t;
    state_t state_p, state_n;
    
    logic [127:0] matrix_p, matrix_n;
    logic [127:0] key_p, key_n;
    logic [3:0] round_p, round_n;
    logic valid_p, valid_n;
    
    logic [127:0] next_key;
    logic [127:0] next_matrix;
    logic last_round;

    assign last_round = (round_p == 4'hA);

    aes_key_expand key_inst (
        .in_key(key_p),
        .round_idx(round_p),
        .out_key(next_key)
    );

    aes_round round_inst (
        .state_in(matrix_p),
        .round_key(next_key),
        .last_round(last_round),
        .state_out(next_matrix)
    );

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state_p <= INIT;
            matrix_p <= 128'h0;
            key_p <= 128'h0;
            round_p <= 4'h0;
            valid_p <= 1'b0;
        end else begin
            state_p <= state_n;
            matrix_p <= matrix_n;
            key_p <= key_n;
            round_p <= round_n;
            valid_p <= valid_n;
        end
    end
    
    always_comb begin
        state_n = state_p;
        matrix_n = matrix_p;
        key_n = key_p;
        round_n = round_p;
        valid_n = valid_p;
        
        case (state_p)
            INIT: begin            
                if (start) begin
                    valid_n = 1'b0;
                    matrix_n = plaintext_in ^ key_in;
                    key_n = key_in;
                    round_n = 4'h1;
                    state_n = CALC;
                 end
            end
            
            CALC: begin
                matrix_n = next_matrix;
                key_n = next_key;
                
                if (round_p == 4'ha) begin
                    state_n = DONE;
                end else begin
                    round_n = round_p + 1;
                end
            end
            
            DONE: begin
                valid_n = 1'b1;
                state_n = INIT;
            end
            default: begin
                state_n = INIT;
            end
        endcase
    end
    
    assign ciphertext_out = matrix_p;
    assign valid = valid_p;
    
endmodule
