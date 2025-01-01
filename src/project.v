// priority-encoded state machine with 4 states
// 3 input state enable signals from ui_in[0:2]
// 3 output state signals to uo_out[0:2]

// project is meant to warn visually impaired user of obstacles around them by using 3 LIDAR distance sensors as input and connecting speakers to state output
// when LIDAR sensor sends logic 1(object is close), state machine enables corresponding speaker warning user of obstacle in the direction of the LIDAR sensor

module tt_um_aditya_patra(
    input wire [7:0] ui_in,      // Using ui_in [0:2]
    output wire [7:0] uo_out,    // Using uo_out [0:2]
    input wire [7:0] uio_in,     // Unused
    output wire [7:0] uio_oe,    // Unused
    output wire [7:0] uio_out,   // Unused
    input wire clk,
    input wire ena,              // signal to enable design(mandatory for tiny tapeout designs)
    input wire rst_n             // active low reset
);

    // Define module variables
    reg [1:0] curr_state;          // current state

    
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
            // reset all variables to 0
            if (!rst_n) begin
                curr_state <= STATE_0;
                speaker1 <= 1'b0;
                speaker2 <= 1'b0;
                speaker3 <= 1'b0;
            end else begin
                //check current state and update output speakers accordingly
                case (curr_state)
                    //no speakers are logic 1
                    STATE_0:begin
                        speaker1 <= 0;
                        speaker2 <= 0;
                        speaker3 <= 0;
                    end
                    //speaker1 is logic 1
                    STATE_1:begin
                        speaker1 <= 1;
                        speaker2 <= 0;
                        speaker3 <= 0;
                    end
                    //speaker2 is logic 1
                    STATE_2:begin
                        speaker1 <= 0;
                        speaker2 <= 1;
                        speaker3 <= 0;
                    end
                    //speaker3 is logic 1
                    STATE_3:begin
                        speaker1 <= 0;
                        speaker2 <= 0;
                        speaker3 <= 1;
                    end
                    //all speakers logic 0 if curr_state has unknown value
                    default:begin
                        speaker1 <= 0;
                        speaker2 <= 0;
                        speaker3 <= 0;
                    end
                endcase
                //check which speaker is logic 1 and update curr_state accordingly
                //if sensor1 is logic 1, change curr_state to 1
                if (sensor1 == 1) begin
                    curr_state <= STATE_1;
                //if sensor2 is logic 1, change curr_state to 2
                end else if (sensor2 == 1) begin
                    curr_state <= STATE_2;
                //if sensor3 is logic 1, change curr_state to 3
                end else if (sensor3 == 1) begin
                    curr_state <= STATE_3;
                //if no sensors are logic 1, change curr_state to 0
                end else begin
                    curr_state <= STATE_0;
                end
            end
        end
    end
endmodule
