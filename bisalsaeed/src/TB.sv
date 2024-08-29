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
    logic pass_count;
    logic fail_coun;

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
            //generate random inputs for DUT
            random_pkt = $random;
            expected_payload = random_pkt [8:1];
            expected_dst_addr = random_pkt[12:11]; 
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
   //MONITORING THE MODULES
    task monitor();
        begin
            @(posedge src_valid);
            @(posedge src_ready);
            //check the PACK_GEN part
            if (packet_valid) begin
                $display("Packet generated: %b", packet);
            end else begin
                $display("No packet generated.");
            end
            //WAIT for output
            dst_ready = 1;
            while (@(posedge dst_valid)) begin
                @(posedge clk);
            end
            $display("Data %b at the adrr %b ", payload,dst_addr);
            dst_ready = 0;
        end
    endtask
    //CHECK PASS AND FAIL COUNT
    task scoreboard(input logic [12:0] expected_payload, input logic [1:0] expected_dst_addr);
        begin
            //check if data is correct or not 
            if (dst_valid && (payload == expected_payload)) begin
                //if placed at wrong address
                if (dst_addr == expected_dst_addr) begin
                    $display("PASSED : STORED AT CORRECT ADDRESS");
                    pass_count++;
                end else begin
                    $display("FAILED : Expected destination %b, got %b", expected_dst_addr, dst_addr);
                    fail_count++;
                end
            end else begin
                $display("FAILED : PACKET DIDNOT MATCH");
                fail_count++;
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
                    //#($urandom_range(5, 20)); // Random delay after one test 
                join
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
        random_tests(10000);
        $finish;
    end
endmodule
