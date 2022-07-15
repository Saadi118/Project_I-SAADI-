//A container class that contains Mailbox, Generator, Driver, Monitor and Scoreboard
//Connects all the components of the verification environment
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //handles of all components
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  //mailbox handles
  mailbox gen2drv, mon2scb;
  //constructor passing arguments to all the components
    function new (virtual interface dut_if inf,int repeat_count);
    this.gen2drv =new();
    this.mon2scb =new();
    this.gen =new(gen2drv, repeat_count );
    this.drv = new(gen2drv, repeat_count, inf );
    this.mon = new(mon2scb, repeat_count, inf);
    this.scb = new(mon2scb, repeat_count);
  endfunction
  //pre_test methods
  task pre_test();
    drv.reset(); //resetting the master
  endtask : pre_test
  //test methods
  task test();
    fork
    gen.main();
    drv.main();
    mon.main();
    scb.main();
    join_any
  endtask
  //post_test methods
  task post_test();
    wait(gen.gen_comp.triggered);
    //$display("Generator Completed");
    wait(drv.drv_comp.triggered);
    //$display("Driver Completed");
    wait(scb.scb_comp.triggered);
    //$display("Scoreboard Completed");
  endtask 
  //run methods
    task run();
      pre_test();
      //$display("Reset Complete");
      test();
      //$display("Test Complete");
      post_test();
      //$display("Post Test Complete");
      $finish;
    endtask
endclass


