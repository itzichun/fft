`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 11:08:47
// Design Name: 
// Module Name: debounce_button
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


module debounce_button(input sclock, reset, output button);
    wire Q;
    wire Qbar;
    
    my_dff dff1 (sclock, reset, Q);
    my_dff dff2 (sclock, Q, Qbar);
    assign button = Q & ~Qbar;
endmodule
