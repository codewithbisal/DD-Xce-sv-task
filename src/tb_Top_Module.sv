module tb_Top_Module;

    // Testbench signals
    logic clk;
    logic reset;
    logic start;
    logic [15:0] A;
    logic [15:0] B;
    logic [31:0] P;
    logic ready;

    //reference signals
    //logic [31:0] ref_product;
    //logic [15:0] A_ref, B_ref;

    Top_Module uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .P(P),
        .ready(ready)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 begin
            clk = ~clk;
        end 
    end

    // Test sequence
    initial begin
        clk = 0;
        reset = 0;
        start = 0;
        A = 16'h0000;
        B = 16'h0000; 
        
        // Test case 1
        reset = 1;
        @(posedge clk);
        reset = 0;
    
        A = 1;
        B = 1;
        
        start = 1;
        @(posedge clk);
        start = 0;
        while (!ready) begin
            @(posedge clk);
        end
        // wait(ready);
        // #10;

        
        // Display results for the first test case
        $display("Test Case 1: A = %b, B = %b, Product = %b, Ready = %b", A, B, P, ready);
        @(posedge clk);

        

        // Test case 1
        reset = 1;
        @(posedge clk);
        reset = 0;
    
        A = -1;
        B = 1;
        
        start = 1;
        @(posedge clk);
        start = 0;
        while (!ready) begin
            @(posedge clk);
        end
        // wait(ready);
        // #10;

        
        // Display results for the first test case
        $display("Test Case 1: A = %b, B = %b, Product = %b, Ready = %b", A, B, P, ready);
        @(posedge clk);
    end
        

endmodule


/*
module tb_Top_Module;

    // Testbench signals
    logic clk;
    logic reset;
    logic start;
    logic [15:0] A;
    logic [15:0] B;
    logic [31:0] P;
    logic ready;

    // Reference signals
    logic [31:0] ref_product;
    logic [15:0] A_ref, B_ref;
    
    // Instantiate the Top Module
    Top_Module uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .P(P),
        .ready(ready)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10 time units period
    end

    // Driver task to apply inputs
    task driver(input logic [15:0] test_A, input logic [15:0] test_B);
        A = test_A;
        B = test_B;
        A_ref = test_A;
        B_ref = test_B;
        start = 1;
        #10;
        start = 0;
    endtask

    // Monitor task to compare output
    task monitor();
        if (ready) begin
            ref_product = A_ref * B_ref; // Calculate reference product
            if (P !== ref_product) begin
                $display("FAIL: A = %h, B = %h, Expected = %h, Got = %h", A_ref, B_ref, ref_product, P);
            end else begin
                $display("PASS: A = %h, B = %h, Product = %h", A_ref, B_ref, P);
            end
        end
    endtask

    // Directed test cases task
    task directed_tests();
        // Test Case 1
        reset = 1;
        #10;
        reset = 0;
        driver(16'h0001, 16'h0001);
        wait(ready);
        #10;
        monitor();

        // Test Case 2
        reset = 1;
        #10;
        reset = 0;
        driver(16'hFFFD, 16'h0001); // -3 in signed, 1
        wait(ready);
        #100;
        monitor();
    endtask

    // Random test cases task
    task random_tests(int num_tests);
        for (int i = 0; i < num_tests; i++) begin
            driver($random, $random);
            wait(ready);
            #($urandom_range(5, 20)); // Random delay between inputs
            monitor();
        end
    endtask

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        start = 0;
        A = 16'h0000;
        B = 16'h0000;

        // Run directed tests
        directed_tests();

        // Run random testing for 10k iterations
        random_tests(10000);

        // Finish simulation
        $finish;
    end

endmodule
*/
