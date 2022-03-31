`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 13:25:03
// Design Name: 
// Module Name: FFT
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


module FFT(
    input clk100m,
    input clk20k,
    input [11:0] mic_in,
    // real and imaginary parts of frequency
    output [23:0] freq_re, 
    output [23:0] freq_im, 
    // real and imaginary parts of frequency
    output [22:0] freq_re_abs, 
    output [22:0] freq_im_abs, 
    output [23:0] freq_mag, // magnitude of frequency
    output reg [9:0] freq_addr = 10'b0, // the address of the frequency data being read out
    output fft_done, // strobed on fft completion
    output fft_out_rdy
    );
    
    reg clk20k_reg, clk20k_pipe;
    wire clk20k_signal;
    wire fft_reset;
    wire ampl_last; // asserted with last amplitude readout
    wire fft_in_rdy;
    reg fft_wait; // set while waiting for fft to complete 
    
    // ampl bram signals
    reg load_update = 1'b0; // is set if shifting BRAM data to accomodate new data point
    reg ampl_write = 1'b0; // ampl bram write enable
    reg [12:0] ampl_in; // amplitude selected to be written
    reg [9:0] sample_cnt = 10'b0; // number of data points shifted so far
    reg [9:0] ampl_addr_in = 10'b0; // the address to write amplitude data to
    wire [12:0] ampl_out; // amplitude value read out to fft
    
    // fft signals
    reg [9:0] load_cnt = 10'b0; // the number of amplitudes read in thus far
    reg [9:0] ampl_addr_out = 10'b0; // the address from which to read amplitude data
    
    parameter N_SUB_1 = 1023; // one less than the transform size
    
    // a for loading mic_in data, b for reading it into the fft core
    // can remove enable if it works without it
    bram ampl_data (.clka(clk100m), .wea(ampl_write), .addra(ampl_addr_in), .dina(ampl_in),
    .clkb(clk100m), .addrb(ampl_addr_out), .doutb(ampl_out));
    
    // TODO switch off clkena if done and waiting for next input
    // input is all positive and real, and hence is 0-padded
    my_FFT fft_core (.aclk(clk100m), .s_axis_config_tdata(8'b00000001), .s_axis_config_tvalid(1'b1),
    .s_axis_data_tdata({19'b0, ampl_out}), .s_axis_data_tvalid(1'b1), 
    .s_axis_data_tlast(ampl_last), .s_axis_data_tready(fft_in_rdy), 
    .m_axis_data_tdata({freq_im, freq_re}), .m_axis_data_tvalid(fft_out_rdy), .m_axis_data_tready(1'b1), 
    .aresetn(1'b1), .m_axis_data_tlast(fft_done));    
    
    /*
      input [7:0]s_axis_config_tdata; //1 for forward, 0 for inverse
      input s_axis_config_tvalid; //tie to 1, config doesn't change
      output s_axis_config_tready; //ignore, config doesn't change
      input [31:0]s_axis_data_tdata; // im and real parts
    */
    
    assign clk20k_signal = clk20k_pipe & ~clk20k_reg;
    assign ampl_last = (load_cnt == N_SUB_1);
     
    always @(posedge clk100m) begin
        // "debounce" positive edge of clk20k (sound updates)
        clk20k_pipe <= clk20k;
        clk20k_reg <= clk20k_pipe;
        
        if (clk20k_signal) begin // read mic data
            ampl_addr_in <= (ampl_addr_in == N_SUB_1) ? 10'b0 : ampl_addr_in + 1;
            ampl_write <= 1'b1;
            ampl_in <= mic_in; // write data over oldest entry
        end else if (ampl_write) begin // advance pointer to next-oldest entry
            ampl_write <= 1'b0;
        end
        
        // read data from BRAM into FFT core
        if (fft_in_rdy) begin
            // fetch next amplitude
            ampl_addr_out <= (ampl_addr_out == N_SUB_1) ? 10'b0 : ampl_addr_out + 1;
            load_cnt <= load_cnt + 1;
        end
        
        // write out fft results
        if (fft_out_rdy) begin
            freq_addr <= freq_addr + 1;
        end
        
        // get current frame of audio
        if (fft_done) begin
            ampl_addr_out <= ampl_addr_in;
            load_cnt <= 10'b0;
            freq_addr <= 10'b0;
        end
    end
    
    //magnitude hack from https://openofdm.readthedocs.io/en/latest/verilog.html
    assign freq_re_abs = (freq_re[23]) ? ~(freq_re[22:0]) + 1 : freq_re[22:0];
    assign freq_im_abs = (freq_im[23]) ? ~(freq_im[22:0]) + 1 : freq_im[22:0];
    assign freq_mag = (freq_re_abs > freq_im_abs) ? freq_re_abs + (freq_im_abs[22:2]) : freq_im_abs + (freq_re_abs[22:2]);
endmodule
