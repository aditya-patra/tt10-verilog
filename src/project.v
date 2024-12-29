// priority-encoded state machine with 4 states
// 3 input state enable signals from ui_in
// 3 output state signals in uo_out

// project is meant to warn visually impaired user of obstacles around them by using 3 LIDAR sensors as input and connecting speakers to state output
// when LIDAR sensor sends enabling signal, state machine enables corresponding speaker warning user of obstacle in the direction of the LIDAR sensor

module tt_um_aditya_patra(
    input wire [7:0] ui_in,      // Using ui_in [0:2]
    output wire [7:0] uo_out,    // Using uo_out [0:2]
    input wire [7:0] uio_in,     // Unused
    output wire [7:0] uio_oe,    // Unused
    output wire [7:0] uio_out,   // Unused
    input wire clk,
    input wire ena,              // signal to enable design
    input wire rst_n             // active low reset
);

    // Define module variables
    reg [27:0] counter;       // 27-bit counter to track duration of current state
    reg [6:0] input_validity; // 7-bit counter to ensure that input state-enabling signal is valid by checking that the signal lasts for a certain duration before enabling state
    reg [1:0] state;          // current state

    
    reg speaker1;  // output signal of state 1
    reg speaker2;  // output signal of state 2
    reg speaker3;  // output signal of state 3
    
    // connecting state output signals to uo_out
    assign uo_out[0] = speaker1;
    assign uo_out[1] = speaker2;
    assign uo_out[2] = speaker3;

    // assigning default value to unused output signals
    assign uo_out[3] = 1'b0;
    assign uo_out[4] = 1'b0;
    assign uo_out[5] = 1'b0;
    assign uo_out[6] = 1'b0;
    assign uo_out[7] = 1'b0;
    assign uio_oe = 8'b00000000;
    assign uio_out = 8'b00000000;

    wire sensor1;  // input signal for state 1 connected to ui_in[0]
    assign sensor1 = ui_in[0];
    wire sensor2;  // input signal for state 2 connected to ui_in[1]
    assign sensor2 = ui_in[1];
    wire sensor3;  // input signal for state 3 connected to ui_in[2]
    assign sensor3 = ui_in[2];

    // assigning unused input signals to floating variable
    wire [4:0] sensors;
    assign sensors = ui_in[7:3];
    // State definitions
    localparam STATE_0 = 7'b00;
    localparam STATE_1 = 7'b01;
    localparam STATE_2 = 7'b10;
    localparam STATE_3 = 7'b11;

    // Sequential logic for state and counter updates
    always @(posedge clk) begin
        if (ena) begin
            // reset conditions
            if (!rst_n) begin
                counter <= 27'b0;
                sensor_verify <= 7'b0;
                state <= STATE_0;
                speaker1 <= 1'b0;
                speaker2 <= 1'b0;
                speaker3 <= 1'b0;
            end else begin
                // if counter is 0, check sensor input signals
                if (counter == 27'd0) begin
                    // Check sensor_verify
                    // if sensor_verify is 100, reset sensor_verify, set counter to 1, and enable the corresponding speaker
                    if (sensor_verify == 7'd100) begin
                        sensor_verify <= 7'd0;
                        case (state)
                            STATE_0: begin
                                speaker1 <= 1'b0;
                                speaker2 <= 1'b0;
                                speaker3 <= 1'b0;
                                counter <= 27'd0;
                            end
                            STATE_1: begin
                                speaker1 <= 1'b1;
                                speaker2 <= 1'b0;
                                speaker3 <= 1'b0;
                                counter <= 27'd1;
                            end
                            STATE_2: begin
                                speaker1 <= 1'b0;
                                speaker2 <= 1'b1;
                                speaker3 <= 1'b0;
                                counter <= 27'd1;
                            end
                            STATE_3: begin
                                speaker1 <= 1'b0;
                                speaker2 <= 1'b0;
                                speaker3 <= 1'b1;
                                counter <= 27'd1;
                            end
                            default: begin
                                speaker1 <= 1'b0;
                                speaker2 <= 1'b0;
                                speaker3 <= 1'b0;
                                counter <= 27'd0;
                            end
                        endcase
                    end else begin
                        // if sensor_verify is not 100, check which sensor is enabled in order of priority
                        
                        // if sensor is enabled and corresponding state is enabled, increment sensor_verify
                        // else, change current state to state corresponding to enabling signal and set sensor_verify to 1
                        if (sensor1) begin
                            if (state == STATE_1)
                                sensor_verify <= sensor_verify + 1;
                            else begin
                                state <= STATE_1;
                                sensor_verify <= 7'd1;
                            end
                        end else if (sensor2) begin
                            if (state == STATE_2)
                                sensor_verify <= sensor_verify + 1;
                            else begin
                                state <= STATE_2;
                                sensor_verify <= 7'd1;
                            end
                        end else if (sensor3) begin
                            if (state == STATE_3)
                                sensor_verify <= sensor_verify + 1;
                            else begin
                                state <= STATE_3;
                                sensor_verify <= 7'd1;
                            end
                        end else begin
                            sensor_verify <= STATE_0;
                        end
                    end
                // if counter reaching 100000000, reset counter, state, and speaker values
                end else if (counter == 27'd100000000) begin
                    counter <= 27'd0;
                    state <= STATE_0;
                    speaker1 <= 0;
                    speaker2 <= 0;
                    speaker3 <= 0;
                // if counter >= 1, increment counter
                end else if (counter >= 1) begin
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule
