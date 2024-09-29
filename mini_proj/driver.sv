class cmd_driver;
  mailbox mbox;
  
  function new(mailbox mbox);
    this.mbox=mbox;
  endfunction
  
  task run();
    cmd_base txn;
    
    forever begin
      mbox.get(txn);
      txn.print("Command received in Driver: ");
      
      //Drive it tot DUT interface, decalre a pointer
    end
  endtask:run
endclass