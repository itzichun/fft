`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2021 10:18:05
// Design Name: 
// Module Name: my_precise_clock
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


module my_precise_clock(input CLOCK, input [31:0]flip_count, output reg new_clk = 0);

    reg [31:0]COUNT = 32'b0;
    
    always @ (posedge CLOCK) begin
        COUNT <= (COUNT == flip_count) ? 0 : COUNT + 1;
        new_clk <= (COUNT == flip_count) ? ~new_clk : new_clk;
    end
endmodule
