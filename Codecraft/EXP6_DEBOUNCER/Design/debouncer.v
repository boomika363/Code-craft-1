module debouncerlite #(
    parameter integer N = 5
)(
    input  wire clk,
    input  wire rst_n,
    input  wire noisy_in,
    output reg  debounced
);

    // Synchronizer flip-flops
    reg sync1, sync2;

    // Counter width
    localparam CW = (N <= 2) ? 1 : $clog2(N);

    reg [CW:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync1      <= 1'b0;
            sync2      <= 1'b0;
            debounced  <= 1'b0;
            count      <= 0;
        end
        else begin
            // 2FF synchronizer
            sync1 <= noisy_in;
            sync2 <= sync1;

            // Debounce logic
            if (sync2 == debounced) begin
                count <= 0;
            end
            else begin
                if (count >= (N-1)) begin
                    debounced <= sync2;
                    count <= 0;
                end
                else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule