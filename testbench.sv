// Code your testbench here
// or browse Examples
//Top most file which connets DUT, interface and the test

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
//`include "test1.sv"
//`include "test2.sv"
//`include "test3.sv"
//----------------------------------------------------------------
`include "interface.sv"
`include "test.sv"
`include "amba_ahb_defines.v"
module testbench_top;
  parameter MS = 1024;
  //declare clock and reset signal
  bit clk;
  bit reset;
  //clock generation
  always #5 clk = ~clk;
  //reset generation
  initial begin
    reset = 0;
    #5 reset =1;
  end
  //interface instance, inorder to connect DUT and testcase
  dut_if inf(clk, reset); //pasiing global signals
  //testcase instance, interface handle is passed to test as an argument
  test test1(inf); //passing virtual interface
  //DUT instance, interface signals are connected to the DUT ports
  amba_ahb_slave slave1(
    .hclk(inf.hclk),
    .hresetn(inf.hresetn),
    .hsel(1'b1),
    .haddr(inf.haddr),
    .htrans(inf.htrans),
    .hwrite(inf.hwrite),
    .hsize(inf.hsize),
    .hburst(inf.hburst),
    .hprot(inf.hprot),
    .hwdata(inf.hwdata),
    .hrdata(inf.hrdata),
    .hready(inf.hready),
    .hresp(inf.hresp),
    .error(inf.error));
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
endmodule
