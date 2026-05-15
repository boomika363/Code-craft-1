module bitbalancer(
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg [3:0] count
);

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'd0;
        end else begin
            count = 4'd0;

            // Count number of 1s in input
            for (i = 0; i < 8; i = i + 1) begin
                count = count + in[i];
            end
        end
    end

endmodule