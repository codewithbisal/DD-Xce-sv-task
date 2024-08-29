//VERIFICATION TESTBENCH
module TopModule_tb;
    logic clk;
    logic reset;
    logic [12:0] pkt_in;
    logic src_valid;
    logic dst_ready;
    logic [12:0] packet;
    logic packet_valid;
    logic en_gen;
    logic dst_valid;
    logic [1:0] dst_addr;
    logic [1:0] pack_t;
    logic [7:0] payload;
    logic eop;
    logic ack;

    TopModule uut (
        .clk(clk),
        .reset(reset),
        .pkt_in(pkt_in),
        .src_valid(src_valid),
        .packet(packet),
        .packet_valid(packet_valid),
        .dst_ready(dst_ready),
        .en_gen(en_gen),
        .dst_valid(dst_valid),
        .dst_addr(dst_addr),
        .pack_t(pack_t),
        .payload(payload),
        .eop(eop),
        .ack(ack)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //PACKET GENERATION
    task generate_random_packet(output logic [12:0] random_pkt);
        begin
            random_pkt = $random;
        end
    endtask

    // DRIVER GIVING INPUTS TO DUT
    task driver(input logic [12:0] packet_in);
        begin
            pkt_in = packet_in;
            src_valid = 1;
            while (@(posedge src_ready))
                @(posedge clk);
            src_valid = 0;
        end
    endtask

    task monitor();
        begin
            //check the PACK_GEN part
            if (packet_valid) begin
                $display("Packet generated: %b", packet);
            end else begin
                $display("No packet generated.");
            end
        end
    endtask

    task scoreboard(input logic [12:0] expected_packet, input logic [1:0] expected_dst_addr);
        begin
            if (dst_valid && (packet == expected_packet)) begin
                if (dst_addr == expected_dst_addr) begin
                    $display("PASSED : STORED AT CORRECT ADDRESS");
                end else begin
                    $display("FAILED : Expected destination %b, got %b", expected_dst_addr, dst_addr);
                end
            end else begin
                $display("FAILED : PACKET DIDNOT MATCH");
            end
        end
    endtask

    // Random tests
    task random_tests(input int num_tests);
        integer i;
        logic [12:0] random_pkt;
        
        begin
            for (i = 0; i < num_tests; i++) begin
                fork 
                generate_random_packet(random_pkt);
                driver(random_pkt, 1);
                @(posedge packet_valid);
                monitor();
                join
                //#($urandom_range(5, 20)); // Random delay 
            end
        end
    endtask

    // Test sequence
    initial begin
        clk = 0;
        reset = 0;
        src_valid = 0;
        pkt_in = 13'b0;
        dst_ready = 0;
        ack = 0;
        random_tests(100000);
        $finish;
    end

endmodule

//DIRECTED TEST 
/*module TopModule_tb;
    logic clk;
    logic reset;
    logic [12:0] pkt_in;
    logic src_valid;
    logic dst_ready;
    logic [12:0] packet;
    logic packet_valid;
    logic en_gen;
    logic dst_valid;
    logic [1:0] dst_addr;
    logic [1:0] pack_t;
    logic [7:0] payload;
    logic eop;
    logic ack;

    TopModule uut (
        .clk(clk),
        .reset(reset),
        .pkt_in(pkt_in),
        .src_valid(src_valid),
        .packet(packet),
        .packet_valid(packet_valid),
        .dst_ready(dst_ready),
        .en_gen(en_gen),
        .dst_valid(dst_valid),
        .dst_addr(dst_addr),
        .pack_t(pack_t),
        .payload(payload),
        .eop(eop),
        .ack(ack)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Test sequence
    initial begin
        reset = 1;
        src_valid = 0;
        pkt_in = 13'b0;
        dst_ready = 0;
        ack = 0;
        
        // Apply reset
        @(posedge clk);
        reset = 0;

        src_valid = 1;
        pkt_in = 13'b1010101010101;
        #10; 
        src_valid = 0;
        
        @(posedge packet_valid);
        @(posedge clk); 
        if (packet_valid) begin
            $display("Packet generated: %b", packet);
        end else begin
            $display("Packet not generated");
        end
        #50;
        $finish;
    end

endmodule
*/
