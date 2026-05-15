`timescale 1ns/1ps

module tb_debouncerlite;

    parameter N = 5;

    logic clk;
    logic rst_n;
    logic noisy_in;
    logic debounced;

    // DUT
    debouncerlite #(.N(N)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .noisy_in(noisy_in),
        .debounced(debounced)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // VCD dump
    initial begin
        $dumpfile("debouncerlite.vcd");
        $dumpvars(0, tb_debouncerlite);
    end

    initial begin

        // Reset
        rst_n = 0;
        noisy_in = 0;

        #20;
        rst_n = 1;

        // CASE 1: Short glitch
        $display("CASE 1");
        noisy_in = 1;
        #20;
        noisy_in = 0;
        #50;

        // CASE 2: Stable HIGH
        $display("CASE 2");
        noisy_in = 1;
        #100;

        // CASE 3: Stable LOW
        $display("CASE 3");
        noisy_in = 0;
        #100;

        // CASE 4: Bouncing signal
        $display("CASE 4");
        noisy_in = 1; #10;
        noisy_in = 0; #10;
        noisy_in = 1; #10;
        noisy_in = 0; #10;
        noisy_in = 1; #100;

        // CASE 5: Rapid toggle
        $display("CASE 5");

        repeat (10) begin
            noisy_in = ~noisy_in;
            #10;
        end

        noisy_in = 0;
        #50;

        // CASE 6: Long stable HIGH
        $display("CASE 6");
        noisy_in = 1;
        #150;

        // CASE 7: Long stable LOW
        $display("CASE 7");
        noisy_in = 0;
        #150;

        $display("Simulation completed");

        $finish;
    end

endmodule