module NoCRouterInputPort(
    input logic clk,
    input logic rst,
    input logic [13:0] packet,
    input logic packet_valid,
    input logic dst_ready,
    output logic dst_valid,
    output logic [1:0] dst_addr,
    output logic [1:0] pack_t,
    output logic [7:0] payload,
    output logic eop,
    output logic ack
);
    logic [13:0] packet_store [3:0][3:0]; // 4x4 array for 2x2 mesh
    logic [1:0] store_index [3:0]; // Index for storing packets based on addr
    logic [1:0] store_type_index [3:0][1:0]; // Index for packet type
    logic [13:0] fifo [3:0];
    logic [1:0] fifo_in, fifo_out;
    logic fifo_full, fifo_empty;
    logic stop_processing; 
    // Decoder
    assign dst_addr = packet[12:11];
    assign pack_t = packet[10:9];
    assign payload = packet[8:1];
    assign eop = packet[0];  
    // FIFO Management
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            fifo_in <= 0;
            fifo_out <= 0;
            fifo_full <= 0;
            fifo_empty <= 1;
        end else begin
            //got input and fifo is not full
            if (packet_valid && !fifo_full && !stop_processing) begin
                fifo[fifo_in] <= packet;
                fifo_in <= fifo_in + 1;
                fifo_empty <= 0;
            end
            //got input fifo is not full neither empty 
            if (packet_ready && !fifo_empty && !stop_processing) begin
                fifo_out <= fifo_out + 1;
                fifo_full <= 0;
            end
            //if fifo is empty
            if (fifo_in == fifo_out) begin
                fifo_empty <= 1;
            end
            //if fifo is full
            if ((fifo_in + 1) % 4 == fifo_out) begin
                fifo_full <= 1;
            end
        end
    end
    // Handle packet processing
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            foreach (packet_store[i][j]) packet_store[i][j] <= 14'b0;
            foreach (store_index[i]) store_index[i] <= 0;
            foreach (store_type_index[i][j]) store_type_index[i][j] <= 0;
            ack <= 0;
            dst_valid <= 0;
            stop_processing <= 0; 
        end else begin
            if (packet_valid && !fifo_full && !stop_processing) begin
                // Store the packet
                store_index[addr] <= store_index[addr] + 1;
                store_type_index[addr][type] <= store_type_index[addr][type] + 1;
                packet_store[addr][type] <= packet;
                ack <= 1;
                // Stop processing if EOP is detected
                if (eop) begin
                    stop_processing <= 1;
                end
            end else if (stop_processing) begin
                // When processing is stopped, keep the state stable
                ack <= 0;
                dst_valid <= 0;
            end
        end
    end
endmodule
