//Fields required to generate the stimulus are declared in the transaction class

class transaction;
  parameter AW = `AW;    // address bus width
  parameter DW = `DW;    // data bus width
  parameter DE = `DE;    // endianess
  parameter RW = `RW;    // response width
  //declare transaction items
  //randomizing output of the master excluding the hwrite signal
  randc bit [AW-1:0] haddr;
  rand bit [1:0] htrans;
  bit hwrite;
  rand bit [2:0] hsize;
  rand bit [2:0] hburst;
  rand bit [3:0] hprot;
  rand bit [DW-1:0] hwdata;
  bit [DW-1:0] hrdata;
  bit hready;
  bit [RW-1:0] hresp;
  //Add Constraints
  constraint c1 {hburst == 3'b000;} //no burst
  constraint c2 {htrans == 2'b10;} //only non sequence transfer
  constraint c3 {hsize inside {3'b010}; } //size = 32 bit 
  constraint c4 {hprot == 4'b0001;} 
  constraint c5 {if (hsize == 1) haddr % 2 ==0;
                 else if (hsize == 2) haddr % 4 ==0;}//contraint for haddr to produce only allingned address
  constraint c6 {haddr <= 1023;} //haddr should not be greater than 1024
  constraint c7 {hwdata <= 255;}//as we are not using burst operation therefor data should not go higher than 8 bits
  //Add print transaction method(optional)
  function void print_trans;
    $display("haddr= %d, htrans= %d, hwrite=%d, hsize=%d, hburst=%d, hprot=%d, hwdata=%d, hrdata=%d" ,haddr ,htrans ,hwrite ,hsize ,hburst ,hprot ,hwdata ,hrdata );
  endfunction : print_trans

    endclass
