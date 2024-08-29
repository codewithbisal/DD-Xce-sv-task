module TopModule(
    input logic clk,
    input logic reset,
    input logic [12:0] pkt_in,
    input logic src_valid,
    output logic [12:0] packet,
    output logic packet_valid,
    input logic dst_ready,
    output logic en_gen,
    output logic dst_valid,
    output logic [1:0] dst_addr,
    output logic [1:0] pack_t,
    output logic [7:0] payload,
    output logic eop,
    input logic ack
);

    // Instantiate PacketGenerator
    PacketGenerator pkt_gen (
        .clk(clk),
        .rst(reset),
        .src_valid(src_valid),
        .pkt_in(pkt_in),
        .packet(packet),
        .packet_valid(packet_valid)
    );

    // Instantiate NoCRouterInputPort
    NoCRouterInputPort router_input (
        .clk(clk),
        .rst(reset),
        .packet(packet),
        .packet_valid(packet_valid),
        .dst_ready(dst_ready),
        .dst_valid(dst_valid),
        .dst_addr(dst_addr),
        .pack_t(pack_t),
        .payload(payload),
        .eop(eop),
        .ack(ack)
    );

    // Instantiate Control_Unit
    Control_Unit ctrl_unit (
        .clk(clk),
        .reset(reset),
        .src_valid(src_valid),
        .packet_valid(packet_valid),
        .ack(ack),
        .dst_ready(dst_ready),
        .en_gen(en_gen)
    );
endmodule
