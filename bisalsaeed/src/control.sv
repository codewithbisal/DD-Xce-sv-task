module Control_Unit(
    input logic clk,
    input logic reset,
    input logic start,
    input logic [3:0] count,
    output logic enReg,
    output logic enCount,
    output logic enShift,
    output logic ready
);

    typedef enum logic [1:0] {START, LOAD, CALC, DONE} state_t;
    state_t state, next_state;

    always_ff @(posedge clk /*or posedge reset*/) begin
        if (reset) begin
            state <= START;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        enReg = 0;
        enCount = 0;
        enShift = 0;
        ready = 0;
        next_state = state;

        case (state)
            START: begin
                if (start) begin 
                    enReg = 1;
                    next_state = CALC;
                end
                else begin
                    next_state=START;
                end
            end
            CALC: begin
                if (count == 15) begin        
                    enShift = 0;
                    enCount=0;
                    ready = 1;
                    //next_state = DONE;
                    next_state = START;

                end else begin
                    enShift = 1;
                    enCount=1;
                    next_state = CALC;
                end
            end
           /* DONE:begin
                ready = 1;
                next_state = START;
            end*/
        endcase
    end

endmodule
