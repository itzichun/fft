`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2021 11:29:42
// Design Name: 
// Module Name: fft_sim
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


module fft_sim();

reg aclk;                        
    reg [7 : 0] s_axis_config_tdata;
    reg         s_axis_config_tvalid;        
    wire        s_axis_config_tready;       
    wire [31 : 0] s_axis_data_tdata;  
    reg         s_axis_data_tvalid;          
    wire        s_axis_data_tready;         
    reg         s_axis_data_tlast;           
    wire [31 : 0] m_axis_data_tdata;
    wire        m_axis_data_tvalid;         
    reg         m_axis_data_tready;  
    wire        m_axis_data_tlast;
    reg [15:0] real_data;
    reg [15:0] imag_data;
    wire [15:0] real_dataout;
    wire [15:0] imag_dataout;
    reg [9:0]  cnt;
    wire [15:0]freq_index;
    assign s_axis_data_tdata={real_data,imag_data};
    assign real_dataout = m_axis_data_tdata[31:16];
    assign imag_dataout = m_axis_data_tdata[15:0];
    initial begin
      aclk = 0;
      s_axis_config_tdata=8'b0;
      s_axis_config_tvalid=1'b0;
      s_axis_data_tvalid=1'b0;
      s_axis_data_tlast=1'b0;
      real_data=16'd0;
      imag_data=16'd0;
      cnt = 0;
      m_axis_data_tready=1'b1;
      #1000;
      s_axis_config_tdata=8'b0000_0001;
      s_axis_config_tvalid=1'b1;
      #10;
      s_axis_config_tdata=8'b0000_0000;
      s_axis_config_tvalid=1'b0;
      #1000;
      repeat(8)begin
        s_axis_data_tvalid=1'b1;
        real_data=real_data+16'd1;
        cnt=cnt+1;
        if(cnt==8) s_axis_data_tlast=1'b1;
        #10;
      end
      s_axis_data_tvalid=1'b0;
      s_axis_data_tlast=1'b0;
      real_data=16'd0;
      #1000;
      $stop;
    end
    always #(5) aclk= ~aclk;
my_FFT top_FFT(
      .aclk(aclk),                                                // input wire aclk
      .s_axis_config_tdata(s_axis_config_tdata),                  // input wire [7 : 0] s_axis_config_tdata
      .s_axis_config_tvalid(s_axis_config_tvalid),                // input wire s_axis_config_tvalid
      .s_axis_config_tready(s_axis_config_tready),                // output wire s_axis_config_tready
      .s_axis_data_tdata(s_axis_data_tdata),                      // input wire [31 : 0] s_axis_data_tdata
      .s_axis_data_tvalid(s_axis_data_tvalid),                    // input wire s_axis_data_tvalid
      .s_axis_data_tready(s_axis_data_tready),                    // output wire s_axis_data_tready
      .s_axis_data_tlast(s_axis_data_tlast),                      // input wire s_axis_data_tlast
      .m_axis_data_tdata(m_axis_data_tdata),                      // output wire [31 : 0] m_axis_data_tdata
      .m_axis_data_tuser (freq_index[15:0]), 
      .m_axis_data_tvalid(m_axis_data_tvalid),                    // output wire m_axis_data_tvalid
      .m_axis_data_tready(m_axis_data_tready),                    // input wire m_axis_data_tready
      .m_axis_data_tlast(m_axis_data_tlast)                      // output wire m_axis_data_tlast       
          );
endmodule

