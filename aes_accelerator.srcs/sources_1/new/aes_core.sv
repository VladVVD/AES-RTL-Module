`timescale 1ns / 1ps

module aes_core (
    input  logic clk,
    input  logic rst_n,

    input  logic start,
    output logic done,

    input  logic [127:0] plaintext,
    input  logic [127:0] key,
    output logic [127:0] ciphertext
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ciphertext <= 128'b0;
            done <= 1'b0;
        end else if (start) begin
            ciphertext <= plaintext ^ key;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end

endmodule
