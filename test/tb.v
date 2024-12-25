`timescale 1ns / 1ps


module tb ();

    // Testbench inputs
    reg sensor1;
    reg sensor2;
    reg sensor3;
    reg clk;
    reg reset;

    // Testbench outputs (from the DUT)
    wire buzzer1;
    wire buzzer2;
    wire buzzer3;

    // Instantiate the state_machine module
    tt_um_aditya_patra dut (
        .sensor1(sensor1),
        .sensor2(sensor2),
        .sensor3(sensor3),
        .clk(clk),
        .reset(reset),
        .buzzer1(buzzer1),
        .buzzer2(buzzer2),
        .buzzer3(buzzer3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test procedure
    initial begin
        $dumpfile("state_machine_tb.vcd");
        $dumpvars(0, state_machine_tb);
        // Initialize inputs
        sensor1 = 0;
        sensor2 = 0;
        sensor3 = 0;
        reset = 0;

        // Apply reset
        #5;
        reset = 1;

        // Test scenario: activate each sensor and observe outputs
        // Case 1: Reset state
        #15;
        reset = 0;  // Assert reset
        #10;
        reset = 0;  // Deassert reset
        #10;

        // Case 2: Enable sensor1 and observe buzzer1 behavior
        sensor1 = 1;
        #100;
        sensor1 = 0;

        // Case 3: Enable sensor2 and observe buzzer2 behavior
        sensor2 = 1;
        #100;
        sensor2 = 0;

        // Case 4: Enable sensorthree and observe buzzer3 behavior
        sensor3 = 1;
        #100;
        sensor3 = 0;

        // Case 5: Combination of sensors
        sensor3 = 1;
        sensor2 = 1;
        #400;
        sensor3 = 0;
        sensor2 = 0;
        #100;

        // End simulation
        #10 $finish;
    end

endmodule
