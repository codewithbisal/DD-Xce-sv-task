module Control_Unit(
    input logic clk,
    input logic reset,
    input logic src_valid,
    input logic packet_valid,
    input logic ack,
    input logic dst_ready,
    input logic [3:0] count,
    output logic en_gen,
);

    typedef enum logic [1:0] {IDLE,GEN, PROCESS, WAIT} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        en_gen = 0;
        src_ready=0;
        dst_valid=0;
        next_state = state;

        case (state)
            IDLE: begin
                src_ready=1;
                next_state=GEN;
            end 
            GEN: begin
                if (packet_valid) begin 
                    en_gen = 1;
                    next_state = PROCESS;
                end
            end
            //fifo control signals implemented within NOC
            PROCESS: begin
                if (ack) begin        
                    dst_valid = 1;
                    if (dst_ready) begin
                        dst_valid=1;
                        next_state = IDLE;
                    end else begin
                        next_state = WAIT;
                    end
                end
                else begin
                    next_state = PRCOESS;
                end
            end
            WAIT: begin
                if(dst_ready) begin
                    dst_valid=1;
                    next_state=IDLE;
                end
            end
        endcase
    end

endmodule


