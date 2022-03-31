`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
  input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
  output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
  output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v

  input CLOCK,
  input [3:0]SW,
  input SW13,
  input SW14,
  input SW15 ,
  output [15:0]LED,
  output reg [7:0] CAT,
  output reg [3:0] AN,

  input reset,
  input btnL,
  input btnR,
  
  output cs,
  output sdin,
  output sclk,
  output d_cn,
  output resn,
  output vccen,
  output pmoden
);

    wire button;
    wire clk6p25m;
    wire clk3p125m;
    wire clk20kHz;
    wire [11:0]sample;
//    wire [31:0]audio_sample;
//    assign audio_sample[11:0] = sample[11:0];
    wire [15:0]pixel_data;
    wire [12:0]pixel_index;
    wire [15:0]volume_level;
    wire [6:0]x_left;
    wire [6:0]x_right;
    
    wire [23:0]freq_re;
    wire [23:0]freq_im;
    wire [22:0] freq_re_abs;
    wire [22:0] freq_im_abs;
    wire [23:0] freq_mag;
    wire [9:0] freq_addr;
    wire fft_done; 
    wire fft_out_rdy; 
    wire [464:0]freq_cnts;
    
    reg [2:0]state;
    
    wire [3:0]lock;
    
    //NEW
    wire frame_begin;
    //
    
    //State Selector//
    always @ (posedge CLOCK) begin
        if (~SW[2])
            state <= 0;
        else if (SW[2])
            state <= 1;
    end
    //////////////////
       
    reg [1:0] an_selector = 0;
    
    my_precise_clock newclk (CLOCK, 32'd7, clk6p25m);
    my_precise_clock newclk1 (CLOCK, 32'd2499, clk20kHz);
    my_precise_clock newclk2 (CLOCK, 32'd14, clk3p125m);
    Audio_Capture audio_capture(CLOCK, clk20kHz, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4, sample[11:0]);
    debounce_button debounce (clk6p25m, reset, button);
    volume_indicator VOLUME(clk20kHz, sample[11:0], volume_level[15:0]);
    
    bar_shifting shift_bar (clk20kHz, reset, btnL, btnR, x_left[6:0], x_right[6:0]);
    Oled_Display OLED (clk6p25m, button, frame_begin,,,pixel_index[12:0],pixel_data[15:0], cs, sdin, sclk, d_cn, resn, vccen, pmoden);
    draw_OLED OLED_Draw (clk6p25m, state, volume_level[15:0], pixel_index[12:0], SW[3:0], SW13, SW14, x_left[6:0], x_right[6:0], frame_begin, freq_cnts, pixel_data[15:0]);
    
    FFT fft (CLOCK, clk20kHz, sample[11:0], freq_re, freq_im, freq_re_abs, freq_im_abs, freq_mag, freq_addr, fft_done, fft_out_rdy);
    
    freq_counter fft_pt2 (CLOCK, fft_out_rdy, fft_done, freq_addr, freq_mag, freq_cnts);

    assign LED[0] = state == 0 ? (SW15 ? ((volume_level[0])? 1 : 0) : ((sample[0] == 1)? 1 : 0)) : 0;
    assign LED[1] = state == 0 ? (SW15 ? ((volume_level[1])? 1 : 0) : ((sample[1] == 1)? 1 : 0)) : 0;
    assign LED[2] = state == 0 ? (SW15 ? ((volume_level[2])? 1 : 0) : ((sample[2] == 1)? 1 : 0)) : 0;
    assign LED[3] = state == 0 ? (SW15 ? ((volume_level[3])? 1 : 0) : ((sample[3] == 1)? 1 : 0)) : 0;
    assign LED[4] = state == 0 ? (SW15 ? ((volume_level[4])? 1 : 0) : ((sample[4] == 1)? 1 : 0)) : 0;
    assign LED[5] = state == 0 ? (SW15 ? ((volume_level[5])? 1 : 0) : ((sample[5] == 1)? 1 : 0)) : 0;
    assign LED[6] = state == 0 ? (SW15 ? ((volume_level[6])? 1 : 0) : ((sample[6] == 1)? 1 : 0)) : 0;
    assign LED[7] = state == 0 ? (SW15 ? ((volume_level[7])? 1 : 0) : ((sample[7] == 1)? 1 : 0)) : 0;
    assign LED[8] = state == 0 ? (SW15 ? ((volume_level[8])? 1 : 0) : ((sample[8] == 1)? 1 : 0)) : 0;
    assign LED[9] = state == 0 ? (SW15 ? ((volume_level[9])? 1 : 0) : ((sample[9] == 1)? 1 : 0)) : 0;
    assign LED[10] = state == 0 ? (SW15 ? ((volume_level[10])? 1 : 0) : ((sample[10] == 1)? 1 : 0)) : 0;
    assign LED[11] = state == 0 ? (SW15 ? ((volume_level[11])? 1 : 0) : ((sample[11] == 1)? 1 : 0)) : 0;
    assign LED[12] = state == 0 ? (SW15 ? ((volume_level[12])? 1 : 0) : 0) : 0;
    assign LED[13] = state == 0 ? (SW15 ? ((volume_level[13])? 1 : 0) : 0) : 0;
    assign LED[14] = state == 0 ? (SW15 ? ((volume_level[14])? 1 : 0) : 0) : 0;
    assign LED[15] = state == 0 ? (SW15 ? ((volume_level[15])? 1 : 0) : 0) : 0;
    
    always @ (posedge clk20kHz) begin
        if (state == 0) begin
            an_selector <= an_selector + 1;
            if (an_selector == 2'b00) AN <= 4'b0111;
            if (an_selector == 2'b01) AN <= 4'b1011;
            if (an_selector == 2'b10) AN <= 4'b1111;
            if (an_selector == 2'b11) AN <= 4'b1110;     
            
            if (an_selector == 2'b00) begin
                if ((volume_level[0]) || (volume_level[1]) || (volume_level[2]) || (volume_level[3]) || (volume_level[4]) || (volume_level[5]) || (volume_level[6]) || (volume_level[7]) || (volume_level[8]) || (volume_level[9])) begin
                    CAT <= 8'b11111111;
                end 
                if ((volume_level[10]) || (volume_level[11]) || (volume_level[12]) || (volume_level[13]) || (volume_level[14]) || (volume_level[15]))
                    CAT <= 8'b11111001;
            end
            
            if (an_selector == 2'b01) begin
                if ((volume_level[0])) CAT <= 8'b11000000;
                if ((volume_level[1])) CAT <= 8'b11111001;
                if ((volume_level[2])) CAT <= 8'b10100100;
                if ((volume_level[3])) CAT <= 8'b10110000;
                if ((volume_level[4])) CAT <= 8'b10011001;
                if ((volume_level[5])) CAT <= 8'b10010010;
                if (volume_level[6]) CAT <= 8'b10000010;
                if (volume_level[7]) CAT <= 8'b11111000;
                if (volume_level[8]) CAT <= 8'b10000000;
                if (volume_level[9]) CAT <= 8'b10010000;
                if (volume_level[10]) CAT <= 8'b11000000;
                if (volume_level[11]) CAT <= 8'b11111001;
                if (volume_level[12]) CAT <= 8'b10100100;
                if (volume_level[13]) CAT <= 8'b10110000;
                if (volume_level[14]) CAT <= 8'b10011001;
                if (volume_level[15]) CAT <= 8'b10010010;
            end
            
            if (an_selector == 2'b11) begin
                if ((volume_level[0]) || (volume_level[1]) || (volume_level[2]) || (volume_level[3]) || (volume_level[4]) || (volume_level[5])) 
                    CAT <= 8'b11000111;
                if ((volume_level[6]) || (volume_level[7]) || (volume_level[8]) || (volume_level[9]) || (volume_level[10])) 
                    CAT <= 8'b11010100;
                if ((volume_level[10]) || (volume_level[11]) || (volume_level[12]) || (volume_level[13]) || (volume_level[14]) || (volume_level[15])) 
                    CAT <= 8'b10001001;
            end
        end
    end
    
endmodule