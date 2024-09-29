class my_env;
  cmd_generator gen;
  cmd_driver driver;
  mailbox mbox;
  
  function new();
    mbox=new();
    gen=new(mbox);
    driver=new(mbox);
  endfunction
  
  
  task run();
    fork
      gen.run();
      driver.run();
    join_none
    
    wait(gen.finished.tiggered);
    $finish();
    
  endtask
endclass
