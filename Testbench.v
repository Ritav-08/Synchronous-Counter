`timescale 1ns / 1ps

module tb_sCounter();
reg clk_ti;
reg rst_ti; 
reg mode_ti; 
wire [3:0]dout_to;

//net(s)
reg [3:0]exp_dout;
integer count;
integer pass;
integer fail;

//instantiation 
sCounter DUT(.clk_i(clk_ti), 
   .rst_i(rst_ti), 
   .mode_i(mode_ti), 
   .dout_o(dout_to));

//initialization
initial begin
   exp_dout = 4'b0000;
   count = 0;
   pass = 0;
   fail = 0;
end

//clock
initial begin
   clk_ti = 1'b0;
   forever begin
      #5 clk_ti = ~clk_ti;
   end
end

//reset
initial begin
rst_ti = 1'b1;
#7 rst_ti = 1'b0;
end

//feeding
initial begin 
mode_ti = 1'b0;
#180 mode_ti = 1'b1;
#180 mode_ti = 1'b0;
#50 mode_ti = 1'b1;
#25 mode_ti = 1'b0;
$display("-----------");
$display("Total checks: %d | Pass: %d, Fail: %d", count, pass, fail);
$display("-----------");
#5 $finish;
end

//self check
task checker(); begin
   if(mode_ti == 1'b0) //UP
       exp_dout = exp_dout + 1;
   else  //DOWN
      exp_dout = exp_dout - 1;
   if(exp_dout !== dout_to) begin
      $display("Error | Time: %0t | Clock: %b, Reset: %b, Mode: %b | Output: %d | Expected Output: %d", $time, clk_ti, rst_ti, mode_ti, dout_to, exp_dout);
      fail = fail + 1;
   end
   else begin
      pass = pass + 1;
   end
   count = count + 1;
end
endtask

//running self check
always@(posedge clk_ti)
   if(rst_ti)
      exp_dout = 4'b0000;
   else 
      #1 checker;

//capture
initial begin
   $dumpvars(0, tb_sCounter);
   $dumpfile("sCounter.vcd");
end

endmodule
