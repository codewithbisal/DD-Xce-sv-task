module PacketGenerator(
    input logic clk,
    input logic rst,
    input logic src_valid,
    input logic [12:0] pkt_in, 
    output logic [12:0] packet,
    output logic packet_valid
);
    logic [12:0] internal_packet;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            internal_packet <= 13'b0;
            packet_valid <=0;
        end else begin
            if (src_valid) begin
                internal_packet <= pkt_in; 
                packet_valid <= 1;
            end
            else begin
                internal_packet <= 0;
                packet_valid <=0;
            end
        end
    end
    assign packet = internal_packet;
endmodule
