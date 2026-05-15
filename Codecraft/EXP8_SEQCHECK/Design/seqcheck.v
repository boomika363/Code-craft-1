`timescale 1ns/1ps

module seqcheck #(
    parameter int W = 5,
    parameter int K = 3
)(
    input  logic clk,
    input  logic rst_n,
    input  logic in_sig,
    output logic hit
);

    // Synchronizer
    logic sync1, sync2, prev_sync;

    // Ring buffer
    logic [W-1:0] rise_buffer;

    integer idx;
    integer rise_count;

    logic rise_detect;

    // Rising edge detection
    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            sync1 <= 0;
            sync2 <= 0;
            prev_sync <= 0;
        end

        else begin
            sync1 <= in_sig;
            sync2 <= sync1;
            prev_sync <= sync2;
        end

    end

    assign rise_detect = sync2 & ~prev_sync;

    // Main logic
    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            rise_buffer <= '0;
            idx <= 0;
            rise_count <= 0;
            hit <= 0;

        end

        else begin

            // Remove old bit from count
            rise_count <= rise_count - rise_buffer[idx] + rise_detect;

            // Store new rise bit
            rise_buffer[idx] <= rise_detect;

            // Circular index
            if (idx == W-1)
                idx <= 0;
            else
                idx <= idx + 1;

            // Generate hit pulse
            if ((rise_count - rise_buffer[idx] + rise_detect) >= K)
                hit <= 1'b1;
            else
                hit <= 1'b0;

        end

    end

endmodule