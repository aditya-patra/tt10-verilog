// priority-encoded state machine with 4 states
// 3 input state enable signals from ui_in[0:2]
// 3 output state signals to uo_out[0:2]

// project is meant to warn visually impaired user of obstacles around them by using 3 distance sensors as input and connecting alerting devices to state output
// when distance sensor sends logic 1(object is close), state machine enables corresponding alerting device warning user of obstacle in the direction of the sensor

module tt_um_aditya_patra(
    input wire [7:0] ui_in,      // Using ui_in [2:0]
    output wire [7:0] uo_out,    // Using uo_out [2:0]
    input wire [7:0] uio_in,     // Unused
    output wire [7:0] uio_oe,    // Unused
    output wire [7:0] uio_out,   // Unused
    input wire clk,
    input wire ena,              // signal to enable design(mandatory for tiny tapeout designs)
    input wire rst_n             // active low reset
);

    // Define module variables
    reg [1:0] curr_state;          // current state
    reg [1:0] next_state;

    
    reg warning1;  // output signal of state 1
    reg warning2;  // output signal of state 2
    reg warning3;  // output signal of state 3
    
    // connecting state output signals to uo_out
    assign uo_out[0] = warning1;
    assign uo_out[1] = warning2;
    assign uo_out[2] = warning3;

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
    always @(*) begin
        if (ena) begin
            //check current state and update output warnings accordingly
            case (curr_state)
                //no warnings are logic 1
                STATE_0:begin
                    warning1 <= 0;
                    warning2 <= 0;
                    warning3 <= 0;
                end
                //warning1 is logic 1
                STATE_1:begin
                    warning1 <= 1;
                    warning2 <= 0;
                    warning3 <= 0;
                end
                //warning2 is logic 1
                STATE_2:begin
                    warning1 <= 0;
                    warning2 <= 1;
                    warning3 <= 0;
                end
                //warning3 is logic 1
                STATE_3:begin
                    warning1 <= 0;
                    warning2 <= 0;
                    warning3 <= 1;
                end
                //all warning2 logic 0 if curr_state has unknown value
                default:begin
                    warning1 <= 0;
                    warning2 <= 0;
                    warning3 <= 0;
                end
            endcase
                
            //check which sensor is logic 1 and update next_state accordingly
            //if sensor1 is logic 1, change curr_state to 1
            if (sensor1 == 1) begin
                next_state <= STATE_1;
            //if sensor2 is logic 1, change curr_state to 2
            end else if (sensor2 == 1) begin
                next_state <= STATE_2;
            //if sensor3 is logic 1, change curr_state to 3
            end else if (sensor3 == 1) begin
                next_state <= STATE_3;
            //if no sensors are logic 1, change curr_state to 0
            end else begin
                next_state <= STATE_0;
            end
        end
    end
    always @(posedge clk) begin
        if (ena) begin
            // reset all variables to 0
            if (!rst_n) begin
                curr_state <= STATE_0;
            end else begin
                // assign curr_state to next_state
                curr_state <= next_state;
            end
        end
    end
endmodule
