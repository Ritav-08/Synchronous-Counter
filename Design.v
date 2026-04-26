`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2026 10:27:54
// Design Name: 
// Module Name: sCounter
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


module sCounter(
   input clk_i, 
   input rst_i, 
   input mode_i, 
   output [3:0]dout_o
);

//net(s)
wire Ta;
wire Tb;
wire Tc;
wire Td;
wire  Qa;
wire  Qb;
wire  Qc;
wire  Qd;
wire QaBar;
wire QbBar;
wire QcBar;
wire QdBar;

//intermediate connections
assign Ta = (mode_i & QbBar & QcBar & QdBar) | ((~mode_i) & Qb & Qc & Qd);
assign Tb = (mode_i & QcBar & QdBar) | ((~mode_i) & Qc & Qd);
assign Tc = (mode_i & QdBar) | ((~mode_i) & Qd);
assign Td = 1'b1;
assign dout_o = {Qa, Qb, Qc, Qd};

//T Flip Flop cconnections
Tff T1(.T_i(Ta), 
   .clk_i(clk_i), 
   .rst_i(rst_i), 
   .Q_o(Qa), 
   .Qbar_o(QaBar));
Tff T2(.T_i(Tb), 
   .clk_i(clk_i), 
   .rst_i(rst_i), 
   .Q_o(Qb), 
   .Qbar_o(QbBar));
Tff T3(.T_i(Tc), 
   .clk_i(clk_i), 
   .rst_i(rst_i), 
   .Q_o(Qc), 
   .Qbar_o(QcBar));
Tff T4(.T_i(Td), 
   .clk_i(clk_i), 
   .rst_i(rst_i), 
   .Q_o(Qd), 
   .Qbar_o(QdBar));

endmodule

//T Flip Flop
module Tff(
   input T_i, 
   input clk_i, 
   input rst_i, 
   output reg Q_o, 
   output Qbar_o
);

assign Qbar_o = ~Q_o;

always@(posedge clk_i)
   if(rst_i)
      Q_o <= 1'b0;
   else if(T_i)
      Q_o <= ~Q_o;

endmodule