`timescale 1ns / 1ps

module tb ();

    // Testbench inputs (ui_in is an 8-bit register)
    reg [7:0] ui_in;  // 8 bits for 8 sensors
    reg clk;
    reg reset;

    // Testbench outputs (uo_out is an 8-bit wire)
    wire [7:0] uo_out;  // 8 bits for 8 buzzers

    // Instantiate the state_machine module (use ui_in and uo_out)
    tt_um_aditya_patra dut (
        .ui_in(ui_in),    // 8-bit input
        .clk(clk),
        .reset(reset),
        .uo_out(uo_out)   // 8-bit output
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test procedure
    initial begin
        $dumpfile("state_machine_tb.vcd");
        $dumpvars(0, tb);  // Correct the reference to the testbench module

        // Initialize inputs
        ui_in = 8'b00000000;  // All sensors off (low)
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

        // Case 2: Enable ui_in[0] (sensor1) and observe uo_out[0] (buzzer1) behavior
        ui_in[0] = 1;
        #100;
        ui_in[0] = 0;

        // Case 3: Enable ui_in[1] (sensor2) and observe uo_out[1] (buzzer2) behavior
        ui_in[1] = 1;
        #100;
        ui_in[1] = 0;

        // Case 4: Enable ui_in[2] (sensor3) and observe uo_out[2] (buzzer3) behavior
        ui_in[2] = 1;
        #100;
        ui_in[2] = 0;

        // Case 5: Combination of ui_in[2] (sensor3) and ui_in[1] (sensor2)
        ui_in[2] = 1;
        ui_in[1] = 1;
        #400;
        ui_in[2] = 0;
        ui_in[1] = 0;
        #100;

        // Case 6: All sensors enabled
        ui_in = 8'b11111111;  // All sensors on
        #200;
        ui_in = 8'b00000000;  // All sensors off
        #100;

        // End simulation
        #10 $finish;
    end

endmodule
