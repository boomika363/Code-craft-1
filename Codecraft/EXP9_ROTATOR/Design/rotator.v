`timescale 1ns/1ps

module rotatorunit #(
    parameter int WIDTH = 8
)(
    input  logic              clk,
    input  logic              rst_n,
    input  logic              enable,
    input  logic              load,
    input  logic              dir,
    input  logic [WIDTH-1:0]  data_in,
    output logic [WIDTH-1:0]  data_out
);

    // Rotate Left Function
    function automatic [WIDTH-1:0] rol1(input [WIDTH-1:0] x);
        rol1 = {x[WIDTH-2:0], x[WIDTH-1]};
    endfunction

    // Rotate Right Function
    function automatic [WIDTH-1:0] ror1(input [WIDTH-1:0] x);
        ror1 = {x[0], x[WIDTH-1:1]};
    endfunction

    always_ff @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            data_out <= '0;
        end

        else if (enable) begin

            if (load)
                data_out <= data_in;

            else begin

                if (dir)
                    data_out <= ror1(data_out);

                else
                    data_out <= rol1(data_out);

            end

        end

    end

endmodule