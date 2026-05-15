`timescale 1ns/1ps

module lightchaser #(
    parameter int WIDTH = 8,
    parameter int TICKS_PER_STEP = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic enable,
    output logic [WIDTH-1:0] led_out
);

    logic [31:0] tick_count;

    // Rotate Left Function
    function automatic [WIDTH-1:0] rol1(input [WIDTH-1:0] x);
        rol1 = {x[WIDTH-2:0], x[WIDTH-1]};
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            led_out <= '0;
            led_out[0] <= 1'b1;
            tick_count <= 0;
        end

        else begin

            if (enable) begin

                if (TICKS_PER_STEP == 1) begin
                    led_out <= rol1(led_out);
                    tick_count <= 0;
                end

                else if (tick_count == TICKS_PER_STEP - 1) begin
                    led_out <= rol1(led_out);
                    tick_count <= 0;
                end

                else begin
                    tick_count <= tick_count + 1;
                end

            end

        end

    end

endmodule