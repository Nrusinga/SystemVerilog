class cmd_generator;
  mailbox mbox;
  event finished;
  
  function new(mailbox mbox);
    this.mbox=mbox;
  endfunction 
  
  
  task run();
    cpu_noop noop;
    cpu_add add;
    cpu_sub sub;
    
    mem_wait mwait;
    mem_load load;
    mem_store store;
    mem_copy copy;
    
    repeat(10) begin
      noop = new();
      noop.print("Generator Cmd: ");
      mbox.put(noop);
      
      add = new();
      add.print("Generator Cmd: ");
      mbox.put(add);
      
      sub = new();
      sub.print("Generator Cmd: ");
      mbox.put(sub);
      
      mwait = new();
      mwait.print("Generator Cmd: ");
      mbox.put(mwait);
      
      load = new();
      load.print("Generator Cmd: ");
      mbox.put(load);
      
      store = new();
      store.print("Generator Cmd: ");
      mbox.put(store);
      
      copy = new();
      copy.print("Generator Cmd: ");
      mbox.put(copy);
      
    end
    
    store=new();
    store.dest=16'hdffff;
    store.src=8'h22;
    store.process_cmd(0);
    store.print("Non randomized Store Reg Command-Generator cmd:");
    mbox.put(store);
    
    ->finished;
  endtask
endclass
      
      
      
  