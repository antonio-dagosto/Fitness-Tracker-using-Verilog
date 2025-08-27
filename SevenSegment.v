`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2024 04:11:12 PM
// Design Name: 
// Module Name: SevenSegment
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


module SevenSegment(
    input clk100Mhz, reset,
    input [15:0] display_data,
    input DP,
    output reg DPO,
    output reg [7:0] anode,
    output reg[6:0] cathode
    );
    
    reg [1:0] digit_select;
    reg [3:0] current_digit;
    reg [31:0] refresh_counter;

    localparam REFRESH_RATE = 100_000; // Refresh rate for multiplexing

    // Anode control logic: AN[7:4] is hardwired to 1, AN[3:0] cycles through active states
    always @(posedge clk100Mhz or posedge reset) begin
        if (reset) begin
            digit_select <= 0;
            anode <= 8'b11110000; // Upper 4 bits are always 1
            refresh_counter <= 0;
        end else if (refresh_counter < REFRESH_RATE) begin
            refresh_counter <= refresh_counter + 1;
        end else begin
            refresh_counter <= 0;
            digit_select <= digit_select + 1;

            // Update anode control and select current digit based on digit_select
            case (digit_select)
                2'b00: begin 
                    anode <= 8'b11110000 | 8'b1110; 
                    current_digit <= display_data[3:0]; 
                end
                2'b01: begin 
                    anode <= 8'b11110000 | 8'b1101; 
                    current_digit <= display_data[7:4]; 
                end
                2'b10: begin 
                    anode <= 8'b11110000 | 8'b1011; 
                    current_digit <= display_data[11:8]; 
                end
                2'b11: begin 
                    anode <= 8'b11110000 | 8'b0111; 
                    current_digit <= display_data[15:12]; 
                end
            endcase
        end
    end
// Cathode (segment) control logic: convert current digit to 7-segment encoding and set DP
    always @(negedge clk100Mhz) begin


        // Convert current_digit to 7-segment encoding
        case (current_digit)
            4'b0000: cathode = 7'b1000000;  // 0
            4'b0001: cathode = 7'b1111001;  // 1
            4'b0010: cathode = 7'b0100100;  // 2
            4'b0011: cathode = 7'b0110000;  // 3
            4'b0100: cathode = 7'b0011001;  // 4
            4'b0101: cathode = 7'b0010010;  // 5
            4'b0110: cathode = 7'b0000010;  // 6
            4'b0111: cathode = 7'b1111000;  // 7
            4'b1000: cathode = 7'b0000000;  // 8
            4'b1001: cathode = 7'b0010000;  // 9
            default: cathode = 7'b1111111;   // Blank
        endcase
    end

endmodule