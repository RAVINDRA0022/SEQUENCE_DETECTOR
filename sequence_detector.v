module sequence_detector (
    input clk,
    input reset,
    input in_bit,
    output reg detect
);

    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = in_bit ? S1 : S0;
            S1: next_state = in_bit ? S1 : S2;
            S2: next_state = in_bit ? S3 : S0;
            S3: next_state = in_bit ? S1 : S4;
            S4: next_state = in_bit ? S1 : S2; // allow overlap
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore type)
    always @(*) begin
        detect = (current_state == S4);
    end

endmodule
