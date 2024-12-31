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
    input wire ena,              // signal to enable design
    input wire rst_n             // active low reset
);

    // Define module variables
    reg [1:0] curr_state;          // current state

    
    reg speaker1;  // output signal of state 1
    reg speaker2;  // output signal of state 2
    reg speaker3;  // output signal of state 3
    
    // connecting state output signals to uo_out
    assign uo_out = {5'b00000, speaker3, speaker2, speaker1};

    // assigning default value to unused output signals
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
                case (curr_state)
                    STATE_0:begin
                        speaker1 <= 0;
                        speaker2 <= 0;
                        speaker3 <= 0;
                    end
                    STATE_1:begin
                        speaker1 <= 1;
                        speaker2 <= 0;
                        speaker3 <= 0;
                    end
                    STATE_2:begin
                        speaker1 <= 0;
                        speaker2 <= 1;
                        speaker3 <= 0;
                    end
                    STATE_3:begin
                        speaker1 <= 0;
                        speaker2 <= 0;
                        speaker3 <= 1;
                    end
                    default:begin
                        speaker1 <= 0;
                        speaker2 <= 0;
                        speaker3 <= 0;
                    end
                endcase
                if (sensor1 == 1) begin
                    curr_state <= STATE_1;
                end else if (sensor2 == 1) begin
                    curr_state <= STATE_2;
                end else if (sensor3 == 1) begin
                    curr_state <= STATE_3;
                end else begin
                    curr_state <= STATE_0;
                end
            end
        end
    end
endmodule
