`timescale 1ns/1ps
// -------------------------------------------------------------
// SeqCheck
// Detect K rising edges within a sliding window of W cycles.
// Emits a 1-cycle pulse 'hit' exactly when the running count
// of rises in the last W cycles crosses >= K.
// - 2FF synchronizer on in_sig
// - Ring buffer of rise bits + running sum (O(1) per cycle)
// Defaults: W=5, K=3.
// -------------------------------------------------------------
//module seqcheck #(
//    parameter int W = 5,     // window length (cycles)
//  parameter int K = 3      // required rising edges in window
// ) (
//    input  logic clk,
//    input  logic rst_n,      // async active-low reset
//    input  logic in_sig,     
//    output logic hit         // 1-cycle pulse when threshold crossed
// );

module tb_seqcheck;

    // Parameters for this experiment
    localparam int W      = 5;
    localparam int K      = 3;
    localparam int CLK_NS = 10;   // 100 MHz

    // DUT I/Os
    logic clk, rst_n, in_sig;
    logic hit;

    // Instantiate DUT
    seqcheck #(.W(W), .K(K)) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .in_sig(in_sig),
        .hit   (hit)
    );

    // Clock
    initial clk = 1'b0;
    always #(CLK_NS/2) clk = ~clk;

    // VCD
    initial begin
        $dumpfile("seqcheck_tb.vcd");
        $dumpvars(0, tb_seqcheck);
    end

    // ---------------- Reference Model (scoreboard) ----------------
    // Mirrors the fixed DUT algorithm exactly.

    // Synchronizer + rise detection
    logic s1_m, s2_m, prev_m, rise_m;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_m   <= 1'b0;
            s2_m   <= 1'b0;
            prev_m <= 1'b0;
        end else begin
            s1_m   <= in_sig;
            s2_m   <= s1_m;
            prev_m <= s2_m;
        end
    end
    assign rise_m = s2_m & ~prev_m;

    // Ring buffer + sum (reference)
    localparam int IW = (W <= 2) ? 1 : $clog2(W);
    localparam int SW = (W <= 1) ? 1 : $clog2(W+1);

    logic [SW-1:0] sum_m, next_sum_m;
    logic [IW-1:0] idx_m;
    logic [W-1:0]  rb_m;
    logic          cond_d_m, cond_next_m, hit_ref;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_m     <= '0;
            idx_m     <= '0;
            rb_m      <= '0;
            cond_d_m  <= 1'b0;
            hit_ref   <= 1'b0;
        end else begin
            next_sum_m = sum_m - rb_m[idx_m] + rise_m;

            sum_m     <= next_sum_m;
            rb_m[idx_m] <= rise_m;
            idx_m     <= (idx_m == W-1) ? '0 : (idx_m + 1'b1);

            cond_next_m = (next_sum_m >= K);
            hit_ref     <= cond_next_m & ~cond_d_m;
            cond_d_m    <= cond_next_m;
        end
    end

    // ---------------- Checker with assert + $fatal ----------------
    int errors;   // reset in checker
    int tests;    // incremented in stimulus

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            errors <= 0;
        end else begin
            assert (hit === hit_ref)
            else begin
                errors <= errors + 1;
                $fatal(1, "Mismatch t=%0t: hit=%0b REF=%0b", $time, hit, hit_ref);
            end
        end
    end

    final begin
        if (errors == 0)
            $display("PASS: All %0d tests passed (errors=%0d).", tests, errors);
        else
            $display("FAIL: errors=%0d after %0d tests.", errors, tests);
    end

    // ---------------- Helpers ----------------
    task automatic wait_cycles(input int n);
        repeat (n) @(posedge clk);
    endtask

    // Make a clean single-cycle high pulse (through sync it will appear after 1–2 cycles)
    task automatic pulse_1cyc_high;
        begin
            in_sig = 1'b0; @(posedge clk);
            in_sig = 1'b1; @(posedge clk);
            in_sig = 1'b0; @(posedge clk);
        end
    endtask

    // Hold constant low/high for n cycles
    task automatic force_low(input int n);
        begin in_sig = 1'b0; wait_cycles(n); end
    endtask
    task automatic force_high(input int n);
        begin in_sig = 1'b1; wait_cycles(n); end
    endtask

    // ---------------- Test Plan (deterministic) ----------------
    initial begin
        tests  = 0;
        in_sig = 1'b0;
        rst_n  = 1'b0;
        wait_cycles(4);
        rst_n  = 1'b1;
        wait_cycles(2);

        // CASE 1: Exactly 3 rising edges within W=5 cycles -> 1 pulse
        $display("\nCASE 1: 3 rises within W -> one hit");
        // Build three rises spaced 2 cycles apart (all within 5-cycle window)
        // Rise #1
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk); // gap 1
        // Rise #2
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk); // gap 1
        // Rise #3 -> should cross threshold and pulse
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; wait_cycles(3);
        tests++;

        // CASE 2: 3 rises spaced > W cycles -> no pulse
        $display("\nCASE 2: 3 rises spaced > W (no hit)");
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0;
        wait_cycles(W);  // break the window
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0;
        wait_cycles(W);
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; wait_cycles(3);
        tests++;

        // CASE 3: Dense edges -> multiple hits over time as window slides
        $display("\nCASE 3: Dense edges -> periodic hits");
        // Create rises on several consecutive odd cycles
        repeat (2) begin
            in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk);
            in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk);
            in_sig = 1'b1; @(posedge clk);                             // rise then hold a cycle
            @(posedge clk);
            in_sig = 1'b0; @(posedge clk);
        end
        wait_cycles(5);
        tests++;

        // CASE 4: Reset clears history
        $display("\nCASE 4: Reset clears window");
        // Prime with 2 rises
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk);
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk);
        // Reset
        rst_n = 1'b0; @(posedge clk); rst_n = 1'b1; @(posedge clk);
        // Next single rise must NOT complete old trio
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; wait_cycles(3);
        tests++;

        // CASE 5: Long HIGH (only first rise counts), then two more rises -> one hit
        $display("\nCASE 5: Long HIGH then two rises -> one hit");
        in_sig = 1'b1; @(posedge clk);              // 1st rise
        force_high(6);                              // stay high (no new rises)
        in_sig = 1'b0; @(posedge clk);              // drop
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; @(posedge clk); // 2nd rise
        in_sig = 1'b1; @(posedge clk); in_sig = 1'b0; wait_cycles(4); // 3rd rise -> hit
        tests++;

        // CASE 6: Alternate every cycle -> a rise each 2 cycles -> periodic hits
        $display("\nCASE 6: Alternate 0/1 each cycle");
        in_sig = 1'b0;
        repeat (16) begin
            @(posedge clk);
            in_sig <= ~in_sig;
        end
        force_low(5);
        tests++;

        // CASE 7: No edges at all -> no hits
        $display("\nCASE 7: Constant low (no edges)");
        force_low(20);
        tests++;

        // Wrap up
        wait_cycles(5);
        $finish;
    end

endmodule