`timescale 1ns / 1ps
module Pulse_gen(
input START, STOP, clk, reset,
input [0:1] MODE,
output reg pulse

    );
    wire start_debounced, stop_debounced;
    
    parameter WALK_DIV = 3125000;
    parameter JOG_DIV = 1562500;
    parameter RUN_DIV = 781250;
    
    reg [21:0] counter;
    reg active;
    
    debouncer db_start(.clk100Mhz(clk), .rst(reset), .i_sig(START),.o_sig_debounced(start_debounced));
    debouncer db_stop(.clk100Mhz(clk), .rst(reset), .i_sig(STOP),.o_sig_debounced(stop_debounced));
    
    
    
    always @(posedge clk or posedge reset)
    begin
    if(reset)
    begin
    counter <= 0;
    pulse <= 0;
    active <=0;
    end else begin
    if(start_debounced) active <=1;
    if(stop_debounced) active <=0;
  
      if(active)begin
        if(MODE == 2'b00)begin
            if(counter >= WALK_DIV)begin
            pulse <=1;
            counter <=0;
          end else begin
            pulse <= 0;
            counter<= counter +1;
            end
        end else if(MODE == 2'b01)begin
                if(counter >= JOG_DIV)begin
            pulse <=1;
            counter <=0;
          end else begin
            pulse <= 0;
            counter<= counter +1;
            end
        end else if(MODE == 2'b10)begin
                if(counter >= RUN_DIV)begin
            pulse <=1;
            counter <=0;
          end else begin
            pulse <= 0;
            counter<= counter +1;
            end
        end else if(MODE == 2'b11)begin
        pulse<=0;
        counter<=0;
            end
    end else begin
    pulse <=0;
    counter <=0;
        end
    end
   end
endmodule
