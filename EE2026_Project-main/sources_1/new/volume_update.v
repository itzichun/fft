`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2021 11:10:52
// Design Name: 
// Module Name: volume_update
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


module volume_update(input clk, input [11:0]sample, output [15:0]volume);

    reg [10:0]COUNT;
    reg [11:0]max = 0;
    reg [11:0]max_so_far = 0;

    always @ (posedge clk) begin
        COUNT <= COUNT + 1;
        
        
    end
endmodule
