`timescale 1ns / 1ps

module tb_aes_sbox();
    logic [7:0] test_in;
    logic [7:0] test_out;

    aes_sbox uut (
        .in_byte(test_in),
        .out_byte(test_out)
    );

    initial begin
        $display("Starting");

        test_in = 8'h00;
        #10;
        if (test_out == 8'h63) $display("PASS: in=%h, out=%h", test_in, test_out);
        else                   $display("FAIL: in=%h, out=%h (expected 63)", test_in, test_out);

        test_in = 8'h01;
        #10;
        if (test_out == 8'h7c) $display("PASS: in=%h, out=%h", test_in, test_out);
        else                   $display("FAIL: in=%h, out=%h (expected 7C)", test_in, test_out);

        test_in = 8'hFF;
        #10;
        if (test_out == 8'h16) $display("PASS: in=%h, out=%h", test_in, test_out);
        else                   $display("FAIL: in=%h, out=%h (expected 16)", test_in, test_out);

        $display("Test finished.");
        $finish;
    end

endmodule