module wrong_code(
    input err_event,
    input clk,
    input reset,
    output reg failed
);

localparam [1:0] err_0 = 0, err_1 = 1, err_2 = 2, err_3 = 3;
reg [1:0] present_state, next_state;

always @(posedge clk) begin
    if (!reset) present_state <= err_0;
    else present_state <= next_state;
end

always @(*) begin
    case (present_state)
        err_0: next_state = err_event ? err_1 : err_0;
        err_1: next_state = err_event ? err_2 : err_1;
        err_2: next_state = err_event ? err_3 : err_2;
        err_3: next_state = err_3;
        default: next_state = err_0;
    endcase
end

always @(*) begin
    failed = (present_state == err_3);
end

endmodule