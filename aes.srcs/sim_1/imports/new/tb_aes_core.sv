`timescale 1ns / 1ps

module tb_aes_core();
    logic clk;
    logic rst;
    logic start;
    logic [127:0] plaintext;
    logic [127:0] key;
    logic [127:0] ciphertext;
    logic valid;
    
    aes_core uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext_in(plaintext),
        .key_in(key),
        .ciphertext_out(ciphertext),
        .valid(valid)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting");
        
        clk = 0;
        rst = 0;
        start = 0;
        
        // FIPS 197 Appendix B
        plaintext = 128'h3243f6a8885a308d313198a2e0370734;
        key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;

        #15; 
        rst = 1;
        
        #10;
        start = 1;
        #10;
        start = 0;

        wait(valid == 1'b1);
        
        $display("------------------------------------------------------------------");

        if (ciphertext == 128'h3925841d02dc09fbdc118597196a0b32) begin
            $display("PASS");
            $display("Result: %h", ciphertext);
        end else begin
            $display("FAIL");
            $display("Expected: 3925841d02dc09fbdc118597196a0b32");
            $display("Got: %h", ciphertext);
        end
        $display("------------------------------------------------------------------");
        $finish;
    end

    always @(negedge clk) begin
        if (uut.state_p == 2'b01) begin
            $display("Round %0d:", uut.round_p);
            $display("Start: %h", uut.matrix_p);
            $display("SubBytes: %h", uut.round_inst.sb_out);
            $display("ShiftRows: %h", uut.round_inst.sr_out);
            
            if (uut.round_p == 4'ha)
                $display("MixColumns: -");
            else
                $display("MixColumns: %h", uut.round_inst.mc_out);
                
            $display("Round Key: %h", uut.next_key);
            $display("");
        end
    end

endmodule
