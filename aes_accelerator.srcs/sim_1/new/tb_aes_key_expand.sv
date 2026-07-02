`timescale 1ns / 1ps

module tb_aes_key_expand();
    logic [127:0] test_in;
    logic [3:0] test_round;
    logic [127:0] test_out;

    aes_key_expand uut (
        .in_key(test_in),
        .round_idx(test_round),
        .out_key(test_out)
    );
    
    initial begin
        $display("Starting");

        test_in = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        test_round = 4'h1;
        #10;
        if (test_out == 128'ha0fafe1788542cb123a339392a6c7605) $display("PASS");
        else                                                   $display("FAIL: (got %h), (expected a0fafe1788542cb123a339392a6c7605)", test_out);

        test_in = 128'ha0fafe1788542cb123a339392a6c7605;
        test_round = 4'h2;
        #10;
        if (test_out == 128'hf2c295f27a96b9435935807a7359f67f) $display("PASS");
        else                                                   $display("FAIL: (got %h), (expected f2c295f27a96b9435935807a7359f67f)", test_out);

        test_in = 128'hac7766f319fadc2128d12941575c006e;
        test_round = 4'ha;
        #10;
        if (test_out == 128'hd014f9a8c9ee2589e13f0cc8b6630ca6) $display("PASS");
        else                                                   $display("FAIL: (got %h), (expected d014f9a8c9ee2589e13f0cc8b6630ca6)", test_out);

        $display("Test finished.");
        $finish;
    end
endmodule
