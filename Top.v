`timescale 1ns / 1ps
module Top(
    input clk100Mhz,          // 100 MHz system clock
    input reset,              // System reset
    input start,              // Start pulse generator
    input stop,               // Stop pulse generator
    input [1:0] mode,         // Mode selection for pulse generator
    output [7:0] anode,       // Anode control for 7-segment display
    output [6:0] cathode,     // Cathode control for 7-segment display
    output OFLOW,             // Overflow flag from FitbitTracker
    output wire decimal_point
);


    // Wires for inter-module communication
    wire pulse;
    wire [13:0] total_step_count;
    wire [7:0] distance;
    wire [15:0] step_count_bcd;
    wire [15:0] distance_bcd;
    wire [15:0] mode_bcd;
    wire [15:0] display_data;



    
    // Instantiate Pulse Generator
    Pulse_gen pulse_gen (
        .clk(clk100Mhz),
        .reset(reset),
        .START(start),
        .STOP(stop),
        .MODE(mode),
        .pulse(pulse)
    );
// Instantiate Fitbit Tracker
    FitBitTracker tracker (
        .clk(clk100Mhz),
        .reset(reset),
        .pulse(pulse),
        .step_count(total_step_count),
        .dist(distance),
        .OFLOW(OFLOW)
    );

    // Instantiate Binary to BCD Converters (provided)
    bin2bcd step_count_bcd_conv (
        .clk100Mhz(clk100Mhz),
        .rst(reset),
        .start(1'b1),
        .bin(total_step_count),
        .bcd(step_count_bcd)
    );

    bin2bcd distance_bcd_conv (
        .clk100Mhz(clk100Mhz),
        .rst(reset),
        .start(1'b1),
        .bin({8'd0, distance}),  // Only need 4 bits for distance
        .bcd(distance_bcd)
    );

    bin2bcd mode_bcd_conv (
        .clk100Mhz(clk100Mhz),
        .rst(reset),
        .start(1'b1),
        .bin({14'd0, mode}),  // Mode is 2 bits, padded to 16 for BCD conversion
        .bcd(mode_bcd)
    );

    // Instantiate Rotation Module
    Rotation rotator (
        .clk100Mhz(clk100Mhz),
        .reset(reset),
        .step_count_bcd(step_count_bcd),
        .distance_bcd(distance_bcd),
        .mode_bcd(mode_bcd),
        .display_data(display_data),
        .decimal_point(decimal_point)
    );
// Instantiate 7-Segment Display Driver
    SevenSegment display_driver (
        .clk100Mhz(clk100Mhz),
        .reset(reset),
        .display_data(display_data),
        .anode(anode),
        .cathode(cathode)
    );

endmodule
