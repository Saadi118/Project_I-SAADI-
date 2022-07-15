//A program block that creates the environment and initiate the stimulus
`include "environment.sv"
program test(dut_if inf);

  //declare environment handle
  environment env;
  initial begin
    //create environment
    env = new (inf, 10); //passing virtual interface and no. of transactions
    //initiate the stimulus by calling run of env
    env.run();
  end

endprogram
