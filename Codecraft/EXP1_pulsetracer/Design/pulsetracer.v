module PulseTracer #(
    parameter FILTER_LEN = 3  // Number of stable cycles required to consider signal valid
)(
    input  wire clk,
    input  wire rst_n,
    input  wire noisy_in,
    output reg  pulse_out
);

    // Internal registers
    reg [FILTER_LEN-1:0] filter_reg;  // Shift register for debounce
    reg                  debounced;   // Stable version of noisy_in
    reg                  prev_debounced;

    // Shift register debounce filter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            filter_reg      <= 0;
            debounced       <= 0;
            prev_debounced  <= 0;
            pulse_out       <= 0;
        end else begin
            // Shift in the current noisy input
            filter_reg <= {filter_reg[FILTER_LEN-2:0], noisy_in};

            // Check if all bits are high (i.e., stable high for FILTER_LEN cycles)
            if (&filter_reg) begin
                debounced <= 1'b1;
            end else if (~|filter_reg) begin
                debounced <= 1'b0;
            end
            // else: retain previous debounced state

            // Detect rising edge of debounced signal
            prev_debounced <= debounced;
            pulse_out <= (debounced & ~prev_debounced);  // One cycle pulse
        end
    end

endmodule