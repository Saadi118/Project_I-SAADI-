//Interface groups the design signals, specifies the direction (Modport) and Synchronize the signals(Clocking Block)

interface dut_if #( AW = `AW,    // address bus width
   DW = `DW,    // data bus width
   DE = `DE,    // endianess
   RW = `RW)(input bit hclk, hresetn);

  // Add design signals here
  logic [AW-1:0] haddr;
  logic [1:0] htrans;
  logic hwrite;
  logic [2:0] hsize;
  logic [2:0] hburst;
  logic [3:0] hprot;
  logic [DW-1:0] hwdata;
  logic [DW-1:0] hrdata;
  logic hready;
  logic [RW-1:0] hresp;
  wor           error;
  //Master Clocking block - used for Drivers
  clocking driver_cb @(posedge hclk);
    default input #1 output #1;
    output haddr;
    output htrans;
    output hwrite;
    output  hsize;
    output hburst;
    output hprot;
    output hwdata;
    input hrdata;
    input hready;
    input hresp;
    output error;
  endclocking

  //Monitor Clocking block - For sampling by monitor components
  clocking monitor_cb @(posedge hclk);
    default input #1 output #1;
    input haddr;
    input htrans;
    input hwrite;
    input  hsize;
    input hburst;
    input hprot;
    input hwdata;
    input hrdata;
    input hready;
    input hresp;
    input error; 
  endclocking

  //Add modports here
  modport DRIVER  (clocking driver_cb,input hclk,hresetn);
    modport MONITOR (clocking monitor_cb,input hclk,hresetn);
endinterface
