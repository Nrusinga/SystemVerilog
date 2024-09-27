// Code your testbench here
// or browse Examples
module tb();
  semaphore s1;
  initial begin
    s1=new(1);
  end
  
  task access_shared_resource(int id);
    $display("Process %0d is waiting to get the key at %0t",id,$time);
    
    s1.get();
    
    $display("Process %0d has entered the critical section at %0t",id,$time);
    
    #10 //Simulate some work
    
    $display("Process %0d has leaved the critical section at %0t",id,$time);
    
    s1.put();
    
  endtask
    
   initial begin 
     fork
       access_shared_resource(1);
       access_shared_resource(2);
       access_shared_resource(3);
     join
   end
endmodule:tb