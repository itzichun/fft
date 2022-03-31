`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2021 10:08:34
// Design Name: 
// Module Name: draw_OLED
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

// SW[0] - ON/OFF BORDERS
// SW[1] - ON/OFF VOLUME BARS
// SW[1] - ON/OFF OTHER FEATURES
// SW14 - TOGGLE BORDER SIZE
// SW13 - TOGGLE COLOR SCHEME

module draw_OLED(input clk, input [2:0]state, input [15:0]audio_sample, input [12:0]pixel_index, input [2:0]SW, input SW13, input SW14, input [6:0]x_left, input [6:0]x_right, input frame_begin, input [464:0]freq_cnts, output [15:0]pixel_data);
    wire [6:0]x = pixel_index % 96;
    wire [6:0]y = pixel_index / 96;
    reg [5:0] freq_reg [0:14];


    always @(posedge clk) begin                    
        // store frequency values for this frame
        if (frame_begin) begin : storefreq
            integer k;
            for (k = 0; k < 15; k = k + 1   ) begin
                freq_reg[k] <= freq_cnts[30 * (k + 1) - 13 -: 6];
            end
        end
   end
           
//    // Original Color Scheme
    parameter [15:0]white_border = 16'b1111111111111111;
//    parameter [15:0]green_bar    = 16'b0000011111100000;
//    parameter [15:0]yellow_bar   = 16'b1111111111100000;
//    parameter [15:0]red_bar      = 16'b1111100000000000;
//    // Alternate Color Scheme
//    parameter [15:0]grey_background = 16'b1111011100111100;
//    parameter [15:0]orange_border   = 16'b1111010100001110;
//    parameter [15:0]purple_bar      = 16'b1111101011010001;
//    parameter [15:0]pink_bar        = 16'b1111101110011111;
//    parameter [15:0]blue_bar        = 16'b0110001100111111;
    
    wire [15:0]border      = SW13 ? 16'b1111111111111111 : 16'b1111010100001110;
    wire [15:0]background  = SW13 ? 16'b0000000000000000 : 16'b1111011100111100;
    wire [15:0]low_bar     = SW13 ? 16'b0000011111100000 : 16'b1111101110011111;
    wire [15:0]med_bar     = SW13 ? 16'b1111111111100000 : 16'b1111101011010001;
    wire [15:0]high_bar    = SW13 ? 16'b1111100000000000 : 16'b0110001100111111;
    wire [15:0]freq_bar    = SW13 ? 16'b1101111011111011 : 16'b0111111011111011;
    
    assign pixel_data = (SW14 && SW[0] && (((x <= 93 && x >= 2) && (y == 61 || y == 2)) || ((x == 93 || x == 2) && (y <= 61 && y >= 2)))) ? border : // 1px border
                        (~SW14 && SW[0] && (x >= 93 || x <= 2 || y >= 61 || y <= 2)) ? border : // 3px border
                        (SW[1] && state == 0 && audio_sample[0] && (x >= x_left && x <= x_right && y >= 58 && y <= 60)) ? low_bar : 
                        (SW[1] && state == 0 && audio_sample[1] && (x >= x_left && x <= x_right && y >= 54 && y <= 56)) ? low_bar : 
                        (SW[1] && state == 0 && audio_sample[2] && (x >= x_left && x <= x_right && y >= 50 && y <= 52)) ? low_bar : 
                        (SW[1] && state == 0 && audio_sample[3] && (x >= x_left && x <= x_right && y >= 46 && y <= 48)) ? low_bar : 
                        (SW[1] && state == 0 && audio_sample[4] && (x >= x_left && x <= x_right && y >= 42 && y <= 44)) ? low_bar : 
                        (SW[1] && state == 0 && audio_sample[5] && (x >= x_left && x <= x_right && y >= 38 && y <= 40)) ? low_bar :
                        
                        (SW[1] && state == 0 && audio_sample[6] && (x >= x_left && x <= x_right && y >= 34 && y <= 36)) ? med_bar :
                        (SW[1] && state == 0 && audio_sample[7] && (x >= x_left && x <= x_right && y >= 30 && y <= 32)) ? med_bar :
                        (SW[1] && state == 0 && audio_sample[8] && (x >= x_left && x <= x_right && y >= 26 && y <= 28)) ? med_bar :
                        (SW[1] && state == 0 && audio_sample[9] && (x >= x_left && x <= x_right && y >= 22 && y <= 24)) ? med_bar :
                        (SW[1] && state == 0 && audio_sample[10] && (x >= x_left && x <= x_right && y >= 18 && y <= 20)) ? med_bar :
                       
                        (SW[1] && state == 0 && audio_sample[11] && (x >= x_left && x <= x_right && y >= 15 && y <= 16)) ? high_bar :
                        (SW[1] && state == 0 && audio_sample[12] && (x >= x_left && x <= x_right && y >= 12 && y <= 13)) ? high_bar :
                        (SW[1] && state == 0 && audio_sample[13] && (x >= x_left && x <= x_right && y >= 9 && y <= 10)) ? high_bar :
                        (SW[1] && state == 0 && audio_sample[14] && (x >= x_left && x <= x_right && y >= 6 && y <= 7)) ? high_bar :
                        (SW[1] && state == 0 && audio_sample[15] && (x >= x_left && x <= x_right && y >= 3 && y <= 4)) ? high_bar : 
                        
                        (state == 1 && (x >= 3 && x <= 8 && y >= (57 - freq_reg[0]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 9 && x <= 15 && y >= (57 - freq_reg[1]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 16 && x <= 22 && y >= (57 - freq_reg[2]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 23 && x <= 29 && y >= (57 - freq_reg[3]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 30 && x <= 36 && y >= (57 - freq_reg[4]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 37 && x <= 43 && y >= (57 - freq_reg[5]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 44 && x <= 50 && y >= (57 - freq_reg[6]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 51 && x <= 57 && y >= (57 - freq_reg[7]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 58 && x <= 64 && y >= (57 - freq_reg[8]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 65 && x <= 71 && y >= (57 - freq_reg[9]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 72 && x <= 78 && y >= (57 - freq_reg[10]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 79 && x <= 85 && y >= (57 - freq_reg[11]) && y <= 60)) ? freq_bar :
                        (state == 1 && (x >= 86 && x <= 92 && y >= (57 - freq_reg[12]) && y <= 60)) ? freq_bar :
                        background;
    
    
endmodule
