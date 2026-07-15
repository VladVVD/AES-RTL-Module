`timescale 1ns / 1ps

module tb_aes_round();
    logic [127:0] test_state_in;
    logic [127:0] test_round_key;
    logic test_last_round;
    logic [127:0] test_state_out;

    aes_round uut (
        .state_in(test_state_in),
        .round_key(test_round_key),
        .last_round(test_last_round),
        .state_out(test_state_out)
    );
    
    initial begin
        $display("Starting");

        test_state_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
        test_round_key = 128'ha0fafe1788542cb123a339392a6c7605;
        test_last_round = 1'b0;
        #10;
        if (uut.sb_out == 128'hd42711aee0bf98f1b8b45de51e415230) $display("PASS");
        else                                                     $display("FAIL: (got %h), (expected d42711aee0bf98f1b8b45de51e415230)", uut.sb_out);

        if (uut.sr_out == 128'hd4bf5d30e0b452aeb84111f11e2798e5) $display("PASS");
        else                                                     $display("FAIL: (got %h), (expected d4bf5d30e0b452aeb84111f11e2798e5)", uut.sr_out);

        if (uut.mc_out == 128'h046681e5e0cb199a48f8d37a2806264c) $display("PASS");
        else                                                     $display("FAIL: (got %h), (expected 046681e5e0cb199a48f8d37a2806264c)", uut.mc_out);
        if (test_state_out == 128'ha49c7ff2689f352b6b5bea43026a5049) $display("PASS");
        else                                                         $display("FAIL: (got %h), (expected a49c7ff2689f352b6b5bea43026a5049)", test_state_out);

        $display("Test finished.");
        $finish;
    end
endmodule
