//Gets the packet from monitor, generates the expected result and compares with the actual result received from the Monitor

class scoreboard;
   
  //create mailbox handle
  mailbox mon2scb;
  int repeat_count;//indicates how many transaction should be monitored from design
  event scb_comp;
  //array to use as local memory
  logic [7:0] mem [0:1023];
  //constructor(getting the value from environment class)
  function new(mailbox mon2scb, int repeat_count );
    this.repeat_count = repeat_count;
    this.mon2scb =mon2scb;
  endfunction
  //main method
  task main();
    transaction trans;
    int nfails =0; //counts the no of failed test
    $display("*********Scoreboard***********");
    repeat (repeat_count*2) //as generator puts two tranactions in one iteration 
      begin
        mon2scb.get(trans); //getting the transaction from monitor
        trans.print_trans;
        if (trans.hwrite ==1) mem[trans.haddr] = trans.hwdata; //writing the same data i.e. written to the design
        else
          begin
            if (mem[trans.haddr] != trans.hrdata) //compairing the data of local memory and data from the slave (both at same address) 
              begin
                nfails++;
                $display("mem[trans.haddr] =%d, trans.hrdata=%d",mem[trans.haddr] ,trans.hrdata );
              end
          end
      end
    if (nfails) $display("**********Test failed with %d failures************", nfails );
    else $display("***********Test Passed***************");
    $display("****************************");
    ->scb_comp; //event trigered which indicates scorboard has compared all the transactions
  endtask : main
    
endclass