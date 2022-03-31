`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 10:21:05
// Design Name: 
// Module Name: my_dff
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


module my_dff(input DFF_CLOCK, D, output reg Q = 0);
    always @ (posedge DFF_CLOCK) begin
    Q <= D;
    end
endmodule
