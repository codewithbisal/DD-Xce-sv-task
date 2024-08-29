module Data_path(
    input logic clk,
    input logic reset,
    input logic enReg,
    input logic enCount,
    input logic enShift,
    input logic ready,
    input logic [15:0] A,
    input logic [15:0] B,
    output logic [31:0] P,
    output logic [3:0] count
);

    logic [15:0] regA, regB;
    logic [31:0] product;
    logic [31:0] and_result;
    logic [15:0] exB;

    always_ff @( posedge clk or posedge reset) begin 
        if (reset) begin
            regA <= 16'b0;
            regB <= 16'b0;
            count <= 4'b0;
            product <= 32'b0;
        end
        else begin
            if (enReg) begin
                regA <= A;
                regB <= B;
                count <= 4'b0;
                product <= 32'b0;
            end else begin
                if (enCount) begin
                    count <= count + 1;
                    regB <= regB >> 1;
                end
            end
        end
    end

    always_comb begin
        if (enCount) begin 
            exB = {16{regB[0]}};
            and_result = regA & exB;
            if (count == 4'd15) begin
                and_result = ~and_result;
                and_result[15] = ~and_result[15];
                and_result = and_result << count;
            end else begin
                and_result[15] = ~and_result[15];
                and_result = and_result << count;
            end
        end
    end

    always_ff @(posedge clk or posedge reset) begin
        if (enShift) begin
            product <= product + and_result;
        end
    end

    assign P = ready ? (product +and_result+ 32'd65536) : 32'b0;

endmodule
