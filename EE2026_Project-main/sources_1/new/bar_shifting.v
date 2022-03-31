`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2021 11:45:47
// Design Name: 
// Module Name: bar_shifting
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


module bar_shifting(input clk, input btnC, input btnL, input btnR, output reg [6:0]x_left = 41, output reg [6:0]x_right = 55);
    
    wire left;
    wire right;
    wire reset;
    
    debounce_button reset_leftright (clk, btnC, reset);
    debounce_button shift_left (clk, btnL, left);
    debounce_button shift_right (clk, btnR, right);
    
    always @ (posedge clk) begin
        if (left && x_left > 3) begin
            x_left <= x_left - 1;
            x_right <= x_right - 1;
        end
        if (right && x_right < 92) begin
            x_right <= x_right + 1;
            x_left <= x_left + 1;
        end
        if (reset) begin
            x_left <= 41;
            x_right <= 55;
        end
    end
endmodule
