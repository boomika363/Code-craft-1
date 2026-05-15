`timescale 1ns/1ps

module edgehighlighter #(
    parameter bit USE_SYNC = 1
)(
    input  logic clk,
    input  logic rst_n,
    input  logic in_sig,
    output logic rise_pulse,
    output logic fall_pulse
);

    logic sync1, sync2;
    logic current_sig;
    logic prev_sig;

    // Optional 2FF Synchronizer
    generate
        if (USE_SYNC) begin
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sync1 <= 1'b0;
                    sync2 <= 1'b0;
                end
                else begin
                    sync1 <= in_sig;
                    sync2 <= sync1;
                end
            end

            assign current_sig = sync2;

        end else begin
            assign current_sig = in_sig;
        end
    endgenerate

    // Edge Detection
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_sig   <= 1'b0;
            rise_pulse <= 1'b0;
            fall_pulse <= 1'b0;
        end
        else begin

            rise_pulse <= current_sig & ~prev_sig;

            fall_pulse <= ~current_sig & prev_sig;

            prev_sig <= current_sig;
        end
    end

endmodule