`timescale 1ns / 1ps

module tb_aes_mix_columns();
    logic [31:0] test_in;
    logic [31:0] test_out;

    aes_mix_columns uut (
        .in_col(test_in),
        .out_col(test_out)
    );
    
    initial begin
        $display("Starting");

        test_in = 32'hD4BF5D30;
        #10;
        if (test_out == 32'h046681e5) $display("PASS: in=%h, out=%h", test_in, test_out);
        else                          $display("FAIL: in=%h, out=%h (expected 046681e5)", test_in, test_out);

        test_in = 32'he1fb967c;
        #10;
        if (test_out == 32'h25d1a9ad) $display("PASS: in=%h, out=%h", test_in, test_out);
        else                          $display("FAIL: in=%h, out=%h (expected 25d1a9ad)", test_in, test_out);

        test_in = 32'h876e46a6;
        #10;
        if (test_out == 32'h473794ed) $display("PASS: in=%h, out=%h", test_in, test_out);
        else                          $display("FAIL: in=%h, out=%h (expected 473794ed)", test_in, test_out);

        $display("Test finished.");
        $finish;
    end
endmodule
