module tt_um_aditya_patra(
    input wire [7:0] ui_in,    // Inputs mapped to the pinout
    output wire [7:0] uo_out, // Outputs mapped to the pinout
    input wire [7:0] uio_in,
    output wire [7:0] uio_oe,
    output wire [7:0] uio_out,
    input wire clk,
    input wire ena,
    input wire rst_n
);

    // Define module variables
    reg [4:0] counter;       // 5-bit counter
    reg [2:0] state_checker;       // 3-bit checker
    reg [1:0] state_check;   // 2-bit state_check
    reg [1:0] curr_state;    // 2-bit current state
    reg [1:0] next_state;    // 2-bit next state

    
    reg buzzer1;
    reg buzzer2;
    reg buzzer3;
    assign uo_out[0] = buzzer1;
    assign uo_out[1] = buzzer2;
    assign uo_out[2] = buzzer3;
    wire sensor1;
    assign sensor1 = ui_in[0];
    wire sensor2;
    assign sensor2 = ui_in[1];
    wire sensor3;
    assign sensor3 = ui_in[2];
    // State definitions
    localparam STATE_0 = 2'b00;
    localparam STATE_1 = 2'b01;
    localparam STATE_2 = 2'b10;
    localparam STATE_3 = 2'b11;

    // Sequential logic for state and counter updates
    always @(posedge clk) begin
        if (ena) begin
            if (!rst_n) begin
                // Reset all registers
                curr_state <= STATE_0;
                next_state <= STATE_0;
                counter <= 5'b0;
                state_checker <= 3'b0;
                state_check <= 2'b0;
                buzzer1 <= 1'b0;
                buzzer2 <= 1'b0;
                buzzer3 <= 1'b0;
            end else begin
                // Update current state
                curr_state <= next_state;
                // Increment counter if it's not zero and check for overflow
    
                if (counter == 5'b0) begin
                    // Check checker logic: if checker is 7, reset checker, set counter to 1, and enable the corresponding buzzer
                    if (state_checker == 3'd7) begin
                        state_checker <= 3'd0;
                        case (state_check)
                            2'd0: begin
                                buzzer1 <= 1'b0;
                                buzzer2 <= 1'b0;
                                buzzer3 <= 1'b0;
                                counter <= 5'b0;
                            end
                            2'd1: begin
                                buzzer1 <= 1'b1;
                                buzzer2 <= 1'b0;
                                buzzer3 <= 1'b0;
                                counter <= 5'b1;
                            end
                            2'd2: begin
                                buzzer1 <= 1'b0;
                                buzzer2 <= 1'b1;
                                buzzer3 <= 1'b0;
                                counter <= 5'b1;
                            end
                            2'd3: begin
                                buzzer1 <= 1'b0;
                                buzzer2 <= 1'b0;
                                buzzer3 <= 1'b1;
                                counter <= 5'b1;
                            end
                            default: begin
                                buzzer1 <= 1'b0;
                                buzzer2 <= 1'b0;
                                buzzer3 <= 1'b0;
                                counter <= 5'b0;
                            end
                        endcase
                    end else begin
                        // Check which buzzer is enabled and update state_check
                        if (sensor1) begin
                            if (state_check == 2'd1)
                                state_checker <= state_checker + 1;
                            else begin
                                state_check <= 2'd1;
                                state_checker <= 3'd1;
                            end
                        end else if (sensor2) begin
                            if (state_check == 2'd2)
                                state_checker <= state_checker + 1;
                            else begin
                                state_check <= 2'd2;
                                state_checker <= 3'd1;
                            end
                        end else if (sensor3) begin
                            if (state_check == 2'd3)
                                state_checker <= state_checker + 1;
                            else begin
                                state_check <= 2'd3;
                                state_checker <= 3'd1;
                            end
                        end else begin
                            state_checker <= 3'd0;
                        end
                    end
                end
                if (counter == 5'd31) begin
                    counter <= 5'b0;
                    state_check <= 2'd0;
                    buzzer1 <= 0;
                    buzzer2 <= 0;
                    buzzer3 <= 0;
                end else if (counter >= 1) begin
                    counter <= counter + 1;
                end
            end
        end
    end
endmodule
