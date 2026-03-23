module code_lock_fsm (
    input        clk,
    input        reset,
    input        enter,
    input  [3:0] code,
    input        failed,
    output reg       lock,
    output reg [2:0] indicators,
    output reg       err_event
);

    localparam [2:0] idle              = 0,
                     Ev_code1          = 1,
                     get_code2         = 2,
                     Ev_code2          = 3,
                     Unlocked          = 4,
                     wrong_code        = 5,
                     permanently_locked = 6;
    localparam [3:0] code1 = 4'b1010,
                     code2 = 4'b0101;

    reg [2:0] present_state, next_state;

    always @(posedge clk) begin
        if (!reset)
            present_state <= idle;
        else
            present_state <= next_state;
    end

    always @(*) begin
        case (present_state)
            Unlocked: begin
                lock       <= 0;
                err_event  <= 0;
                indicators <= 3'b111;
            end
            wrong_code: begin
                err_event  <= 1;
                lock       <= 1;
                indicators <= 3'b000;
            end
            idle: begin
                lock       <= 1;
                err_event  <= 0;
                indicators <= 3'b100;
            end
            get_code2: begin
                lock       <= 1;
                err_event  <= 0;
                indicators <= 3'b110;
            end
            permanently_locked: begin
                lock       <= 1;
                err_event  <= 0;
                indicators <= 3'b000;
            end
            default: begin
                lock       <= 1;
                err_event  <= 0;
                indicators <= 3'b000;
            end
        endcase
    end

    always @(*) begin
        next_state = idle;
        case (present_state)
            idle:
                if (enter)
                    next_state = Ev_code1;
            Ev_code1:
                if (code == code1)
                    next_state = get_code2;
                else
                    next_state = wrong_code;
            get_code2:
                if (enter)
                    next_state = Ev_code2;
                else
                    next_state = get_code2;
            Ev_code2:
                if (code == code2)
                    next_state = Unlocked;
                else
                    next_state = wrong_code;
            Unlocked:
                if (enter)
                    next_state = idle;
                else
                    next_state = Unlocked;
            wrong_code:
                if (failed)
                    next_state = permanently_locked;
                else
                    next_state = idle;
            permanently_locked:
                next_state = permanently_locked;
            default:
                next_state = idle;
        endcase
    end

endmodule