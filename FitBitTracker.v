`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 11:42:00 AM
// Design Name: 
// Module Name: FitBitTracker
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


module FitBitTracker(
input pulse, clk, reset,
output reg [13:0] step_count,
output reg OFLOW,
output reg [7:0] dist
    );
    parameter MAX_STEPS_DISPLAY = 9999;
    parameter MAX_DISTANCE = 190;
    
    reg [13:0] true_step_count;
    reg [16:0] step_count_for_distance;
    
    always @(posedge clk) begin
        if (reset) begin
            true_step_count <=0;
            step_count <=0;
            OFLOW<=0;
            
            step_count_for_distance<= 0;
        end
        else if (pulse) begin
            true_step_count <= true_step_count +1;
            
            if(step_count < MAX_STEPS_DISPLAY) begin
                step_count <= step_count +1;
             end else begin
                OFLOW <=1;
                end
            
               step_count_for_distance <= step_count_for_distance+1;
               if(step_count_for_distance >= 77824) begin
               step_count_for_distance <= 77824;
               end
                
       end
       end
           always@(*)begin
           if (step_count_for_distance<=2048) dist = 8'd0;
           else if (step_count_for_distance<=4096) dist = 8'd5;
           else if (step_count_for_distance<=6144) dist = 8'd10;
           else if (step_count_for_distance<=8192) dist = 8'd15;
           else if (step_count_for_distance<=10240) dist = 8'd20;
           else if (step_count_for_distance<=12288) dist = 8'd25;
           else if (step_count_for_distance<=14336) dist = 8'd30;
           else if (step_count_for_distance<=16384) dist = 8'd35;
           else if (step_count_for_distance<=18432) dist = 8'd40;
           else if (step_count_for_distance<=20480) dist = 8'd45;
           else if (step_count_for_distance<=22528) dist = 8'd50;
           else if (step_count_for_distance<=24576) dist = 8'd55;
           else if (step_count_for_distance<=26624) dist = 8'd60;
           else if (step_count_for_distance<=28672) dist = 8'd65;
           else if (step_count_for_distance<=30720) dist = 8'd70;
           else if (step_count_for_distance<=32768) dist = 8'd75;
           else if (step_count_for_distance<=34816) dist = 8'd80;
           else if (step_count_for_distance<=36864) dist = 8'd85;
           else if (step_count_for_distance<=38912) dist = 8'd90;
           else if (step_count_for_distance<=40960) dist = 8'd95;
           else if (step_count_for_distance<=43008) dist = 8'd100;
           else if (step_count_for_distance<=45056) dist = 8'd105;
           else if (step_count_for_distance<=47104) dist = 8'd110;
           else if (step_count_for_distance<=49152) dist = 8'd115;
           else if (step_count_for_distance<=51200) dist = 8'd120;
           else if (step_count_for_distance<=53248) dist = 8'd125;
           else if (step_count_for_distance<=55296) dist = 8'd130;
           else if (step_count_for_distance<=57344) dist = 8'd135;
           else if (step_count_for_distance<=59392) dist = 8'd140;
           else if (step_count_for_distance<=61440) dist = 8'd145;
           else if (step_count_for_distance<=63488) dist = 8'd150;
           else if (step_count_for_distance<=65536) dist = 8'd155;
           else if (step_count_for_distance<=67584) dist = 8'd160;
           else if (step_count_for_distance<=69632) dist = 8'd165;
           else if (step_count_for_distance<=71680) dist = 8'd170;
           else if (step_count_for_distance<=73728) dist = 8'd175;
           else if (step_count_for_distance<=75776) dist = 8'd180;
           else if (step_count_for_distance<=77824) dist = 8'd185;
           else if (step_count_for_distance<=79872) dist = 8'd190;
           else if (step_count_for_distance>=79872) dist = 8'd190;
           else if (reset) dist =0;
           end
    
endmodule
