module code_lock(
    input clk,
    input reset,
    input enter,
    input [3:0] code,
    output lock,
    output [2:0] debug
);

wire synched_sig, err_event, failed;

synch sy(
    .async_sig(enter),
    .clk(clk),
    .rise(),
    .fall(synched_sig)
);

code_lock_fsm cl_fsm(
    .clk(clk),
    .reset(reset),
    .enter(synched_sig),
    .code(code),
    .failed(failed),
    .lock(lock),
    .indicators(debug),
    .err_event(err_event)
);

wrong_code wc(
    .err_event(err_event),
    .clk(clk),
    .reset(reset),
    .failed(failed)
);

endmodule