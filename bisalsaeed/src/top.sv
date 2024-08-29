module Top_Module(
    input logic clk,
    input logic reset,
    input logic start,
    input logic [15:0] A,
    input logic [15:0] B,
    output logic [31:0] P,
    output logic ready
);

    // Wires to connect Control Unit and Data Path
    logic enReg, enCount, enShift;
    logic [3:0] count;

    // Instantiate the Control Unit
    Control_Unit cu (
        .clk(clk),
        .reset(reset),
        .start(start),
        .enReg(enReg),
        .count(count),
        .enCount(enCount),
        .enShift(enShift),
        .ready(ready)
    );

    // Instantiate the Data Path
    Data_path dp (
        .clk(clk),
        .reset(reset),
        .enReg(enReg),
        .ready(ready),
        .enCount(enCount),
        .enShift(enShift),
        .A(A),
        .B(B),
        .P(P),
        .count(count)
        //.start(start)
    );

endmodule
