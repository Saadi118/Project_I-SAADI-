//Generates randomized transaction packets and put them in the mailbox to send the packets to driver 

class generator;
  
  //declare transaction class
  transaction trans, trans1;
  bit ok; //to check randomization 
  //create mailbox handle
  mailbox gen2driv;
  int repeat_count; //indicates how many transaction should be created
  //declare an event
  event gen_comp;
  //constructor(getting the value from environment class)
  function new (mailbox gen2driv, int repeat_count);
    this.gen2driv =gen2driv;
    this.repeat_count =repeat_count;
  endfunction
  
  //main methods
  task main();
    $display("*********Generator***********");
    repeat (repeat_count) 
      begin
        trans = new();
        //generating random transaction with write opeartion
        trans.hwrite =1; //write operation
        ok = trans.randomize; //randomizing the transaction
        if (ok) gen2driv.put(trans); //puting the transaction to mailbox
        trans.print_trans(); //printing for debug
        //generating same transaction with write opeartion
        trans1 = new trans; //generating same transaction in new object
        trans1.hwrite =0; //read operation
        if (ok)gen2driv.put(trans1); //puting the transaction to mailbox
        trans1.print_trans();//printing for debug
      end
    $display("******************************");
    -> gen_comp; //event trigered which indicates generator has generated the transactions
  endtask 
  
endclass