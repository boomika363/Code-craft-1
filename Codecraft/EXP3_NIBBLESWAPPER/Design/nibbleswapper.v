module nibbleswapper(
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    input wire swap_en,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'h00;
        end
        else if (swap_en) begin
            // Swap upper and lower nibbles
            out <= {in[3:0], in[7:4]};
        end
        else begin
            // Hold previous output
            out <= out;
        end
    end

endmodule