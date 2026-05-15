`timescale 1ns/1ps
// -----------------------------------------------------------
// EdgeHighlighter
// - 2FF-synchronizes the input (optional param).
// - Emits 1-cycle pulses on rising and falling edges of the
//   synchronized input.
// - Async active-low reset.
// -----------------------------------------------------------
// module edgehighlighter #(
//    parameter bit USE_SYNC = 1   // 1: use 2FF sync on in_sig; 0: treat //as synchronous
//) (
//    input  logic clk,
//    input  logic rst_n,          // async active-low
//   input  logic in_sig,         // 
//    output logic rise_pulse,     // 1 when a 0->1 edge occurs (1 cycle)
//    output logic fall_pulse      // 1 when a 1->0 edge occurs (1 cycle)
// );
module tb_edgehighlighter;

    localparam int  CLK_NS   = 10;
    localparam bit  USE_SYNC = 1;   // keep aligned with DUT param

    // DUT I/O
    logic clk, rst_n, in_sig;
    logic rise_pulse, fall_pulse;

    // DUT
    edgehighlighter #(.USE_SYNC(USE_SYNC)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_sig(in_sig),
        .rise_pulse(rise_pulse),
        .fall_pulse(fall_pulse)
    );

    // Clock
    initial clk = 1'b0;
    always #(CLK_NS/2) clk = ~clk;

    // VCD
    initial begin
        $dumpfile("edgehighlighter_tb.vcd");
        $dumpvars(0, tb_edgehighlighter);
    end

    // ---------------- Reference Model (mirrors DUT) ----------------
    logic s1_m, s2_m, cur_m, prev_m;
    logic rise_ref, fall_ref;

    // Optional sync
    generate
        if (USE_SYNC) begin : g_sync_m
            (* ASYNC_REG="true" *) always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    s1_m <= 1'b0; s2_m <= 1'b0;
                end else begin
                    s1_m <= in_sig; s2_m <= s1_m;
                end
            end
            assign cur_m = s2_m;
        end else begin : g_nosync_m
            assign cur_m = in_sig;
        end
    endgenerate

    // Edge detect (1-cycle pulses)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_m   <= 1'b0;
            rise_ref <= 1'b0;
            fall_ref <= 1'b0;
        end else begin
            rise_ref <=  cur_m & ~prev_m;
            fall_ref <= ~cur_m &  prev_m;
            prev_m   <=  cur_m;
        end
    end

    // ---------------- Checker with assertions ----------------
    int errors;

    // No dual pulses in same cycle (mutually exclusive)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            errors <= 0;
        end else begin
            // DUT vs REF
            assert (rise_pulse === rise_ref)
            else begin
                errors <= errors + 1;
                $fatal(1, "Rise mismatch t=%0t: DUT=%0b REF=%0b", $time, rise_pulse, rise_ref);
            end

            assert (fall_pulse === fall_ref)
            else begin
                errors <= errors + 1;
                $fatal(1, "Fall mismatch t=%0t: DUT=%0b REF=%0b", $time, fall_pulse, fall_ref);
            end

            // Mutual exclusion
            assert (!(rise_pulse && fall_pulse))
            else begin
                errors <= errors + 1;
                $fatal(1, "Both pulses high at t=%0t (illegal).", $time);
            end
        end
    end

    final begin
        if (errors == 0)
            $display("PASS: All tests passed (errors=%0d).", errors);
        else
            $display("FAIL: errors=%0d.", errors);
    end

    // ---------------- Helpers ----------------
    task automatic wait_cycles(input int n);
        repeat (n) @(posedge clk);
    endtask

    // one clean 0->1->0 event with programmable high width (>=1 cycles)
    task automatic make_pulse(input int high_cycles);
        begin
            in_sig = 1'b0; @(posedge clk);
            in_sig = 1'b1; wait_cycles(high_cycles);
            in_sig = 1'b0; @(posedge clk);
        end
    endtask

    // ---------------- Test Plan (deterministic) ----------------
    initial begin
        in_sig = 1'b0;
        rst_n  = 1'b0;
        wait_cycles(4);
        rst_n  = 1'b1;
        wait_cycles(2);

        // CASE 1: Single 1-cycle pulse -> expect rise then (next fall)
        $display("\nCASE 1: Single 1-cycle high");
        make_pulse(1);
        wait_cycles(3);

        // CASE 2: Wide high (5 cycles) -> still 1 rise only, and one fall when it drops
        $display("\nCASE 2: Wide high (5 cycles)");
        make_pulse(5);
        wait_cycles(3);

        // CASE 3: Back-to-back pulses separated by 1 cycle low
        $display("\nCASE 3: Two pulses separated by 1 low cycle");
        make_pulse(2);
        in_sig = 1'b0; @(posedge clk);  // explicit 1-cycle low separator
        make_pulse(2);
        wait_cycles(3);

        // CASE 4: Long low (no edges)
        $display("\nCASE 4: Long low (no edges)");
        in_sig = 1'b0; wait_cycles(12);

        // CASE 5: Alternating every cycle (…010101…) -> rise/fall pulses every cycle alternately
        $display("\nCASE 5: Alternate every cycle");
        in_sig = 1'b0;
        repeat (12) begin
            @(posedge clk);
            in_sig <= ~in_sig;
        end
        wait_cycles(3);

        // CASE 6: Reset mid-stream clears history; next edge is treated fresh
        $display("\nCASE 6: Mid-stream reset");
        in_sig = 1'b1; @(posedge clk); // ensure we have a '1' before reset
        rst_n  = 1'b0; @(posedge clk); rst_n = 1'b1; @(posedge clk);
        // After reset, a drop creates no fall (history cleared) until we rise again
        in_sig = 1'b0; wait_cycles(2);
        make_pulse(3);
        wait_cycles(4);

        $finish;
    end

endmodule