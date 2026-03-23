module synch(
    input async_sig,
    input clk,
    output reg rise,
    output reg fall
);

reg [2:0] resync;

always @(posedge clk) begin
    fall <= resync[1] & ~resync[2];
    rise <= resync[2] & ~resync[1];
    resync <= {~async_sig, resync[2:1]};
end

endmodule