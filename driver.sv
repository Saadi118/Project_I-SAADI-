//Gets the packet from generator and drive the transaction packet items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

class driver;
  //virtual interface handle
  virtual interface dut_if.DRIVER inf;
  //create mailbox handle
  mailbox gen2driv;
  int repeat_count;//indicates how many transaction should be drived to interface
    event drv_comp; 
    //constructor (getting the value from environment class)
    function new(mailbox gen2driv, int repeat_count, virtual interface dut_if.DRIVER inf);
    this.gen2driv =gen2driv;
    this.inf = inf;
    this.repeat_count =repeat_count;
  endfunction
  //reset methods making the signal to default value
    task reset();
      wait(!inf.hresetn); //waiting for reset to occur
      inf.driver_cb.haddr <= 0;
      inf.driver_cb.htrans <= 0;
      inf.driver_cb.hwrite <= 0;
      inf.driver_cb.hsize <= 0;
      inf.driver_cb.hburst <= 0;
      inf.driver_cb.hprot <= 0;
      inf.driver_cb.hwdata <= 0;
      inf.driver_cb.error <= 0;
      wait(inf.hresetn); //waiting for reset to become high again
    endtask : reset
  //drive methods
    task drive();
      transaction trans;
//       $display("*********Driver***********");
      repeat (repeat_count *2) //as generator puts two tranactions in one iteration 
        begin
          trans = new();
          gen2driv.get(trans); //getting the transaction in object trans from generator
          //trans.print_trans();
          @(posedge inf.hclk); //driving the interface at posedge of clk
          inf.driver_cb.hwrite <= trans.hwrite;  
          inf.driver_cb.haddr <= trans.haddr; 
          inf.driver_cb.htrans <= trans.htrans; 
          inf.driver_cb.hwdata <= trans.hwdata;
          inf.driver_cb.hsize <= trans.hsize;
          inf.driver_cb.hburst <= trans.hburst;
          inf.driver_cb.hprot <= trans.hprot;
          inf.driver_cb.hwdata <= trans.hwdata;
          @(posedge inf.hclk); //waiting for next posedge (2 cycles the data will not change)
//           $display("haddr=%d, htrans=%d, hwrite=%d, hsize=%d, hburst=%d, hprot=%d, hwdata=%d",inf.driver_cb.haddr, inf.driver_cb.htrans, inf.driver_cb.hwrite, inf.driver_cb.hsize, inf.driver_cb.hburst, inf.driver_cb.hprot, inf.driver_cb.hwdata);
        end
//       $display("****************************");
    endtask : drive
  //main methods
    task main();
      wait(inf.hresetn); //wait till reset goes high
      drive();
      -> drv_comp; //event trigered which indicates driver has drived the signals
    endtask : main
endclass