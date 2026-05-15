module graycoder(
    input wire clk,
    input wire [3:0] bin_in,
    output reg [3:0] gray_out
);

    always @(posedge clk) begin
        gray_out <= bin_in ^ (bin_in >> 1);
    end

endmodule