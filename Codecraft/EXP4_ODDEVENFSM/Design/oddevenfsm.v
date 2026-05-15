module evenoddfsm(
    input wire clk,
    input wire reset,
    input wire in_valid,
    input wire [7:0] data_in,
    output reg even,
    output reg odd
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            even <= 1'b0;
            odd  <= 1'b0;
        end
        else if (in_valid) begin
            // Check LSB for even/odd
            if (data_in[0] == 1'b0) begin
                even <= 1'b1;
                odd  <= 1'b0;
            end
            else begin
                even <= 1'b0;
                odd  <= 1'b1;
            end
        end
        else begin
            // Hold previous state
            even <= even;
            odd  <= odd;
        end
    end

endmodule