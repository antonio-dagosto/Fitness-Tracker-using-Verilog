`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 12:53:19 PM
// Design Name: 
// Module Name: Rotation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Rotation(
input clk100Mhz, reset,
input [15:0] step_count_bcd, distance_bcd,
input [15:0]mode_bcd,
output reg[15:0]display_data,
output decimal_point
    );
    reg[1:0] state;
    
    reg[27:0] counter;
    
    parameter STEP_COUNT = 2'b00, DISTANCE = 2'b01, MODE = 2'b10;
    parameter INTERVAL = 200000000;
    
    always @(posedge clk100Mhz or posedge reset) begin
        if (reset) begin
            counter <= 0;
            state <= STEP_COUNT;
            display_data <= step_count_bcd;
        end else begin
            counter <= counter + 1;
            if (counter >= INTERVAL) begin
                counter <= 0;
                case (state)
                    STEP_COUNT: begin
                        display_data <= distance_bcd;
                        state <= DISTANCE;
                        
                    end
                    DISTANCE: begin
                        display_data <= mode_bcd;
                        state <= MODE;
                        
                    end
                    MODE: begin
                        display_data <= step_count_bcd;
                        state <= STEP_COUNT;
                        
                    end
                endcase
            end
        end
    end
    assign decimal_point = (display_data == distance_bcd)? 1'b0 : 1'b1;
endmodule
