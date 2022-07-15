//Samples the interface signals, captures into transaction packet and sends the packet to scoreboard.

class monitor;
  
  //virtual interface handle
  virtual interface dut_if.MONITOR inf;
  //create mailbox handle
  mailbox mon2scb;
  int repeat_count;//indicates how many transaction should be monitored from design
  //constructor(getting the value from environment class)
    function new (mailbox mon2scb, int repeat_count, virtual interface dut_if.MONITOR inf );
      this.mon2scb =mon2scb;
      this.inf =inf;
      this.repeat_count =repeat_count;
    endfunction
  //main method
      task main();
        transaction trans;
        //$display("*********Monitor***********");
        repeat (repeat_count*2) //as generator puts two tranactions in one iteration 
          begin
            trans = new();
            @(posedge inf.hclk); //sampling the design signals at posedge of clk
            trans.hwrite = inf.monitor_cb.hwrite;
            trans.haddr = inf.monitor_cb.haddr; 
            trans.htrans = inf.monitor_cb.htrans; 
            trans.hwdata = inf.monitor_cb.hwdata;
            trans.hsize = inf.monitor_cb.hsize;
            trans.hburst = inf.monitor_cb.hburst;
            trans.hprot = inf.monitor_cb.hprot;
            trans.hwdata = inf.monitor_cb.hwdata;
            trans.hrdata = inf.monitor_cb.hrdata;
            trans.hready = inf.monitor_cb.hready;
            trans.hresp = inf.monitor_cb.hresp;
            @(posedge inf.hclk); //as hrdata is updated in next posedge
            //$display("hwrite=%d",inf.monitor_cb.hwrite);
//             $display("haddr=%d, htrans=%d, hwrite=%d, hsize=%d, hburst=%d, hprot=%d, hwdata=%d, hrdata=%d",inf.monitor_cb.haddr, inf.monitor_cb.htrans, inf.monitor_cb.hwrite, inf.monitor_cb.hsize, inf.monitor_cb.hburst, inf.monitor_cb.hprot, inf.monitor_cb.hwdata, inf.monitor_cb.hrdata);
             mon2scb.put(trans);
            //trans.print_trans();
          end
        $display("****************************");
      endtask : main

endclass