module tb_named_event;
  event start_event;
  
  initial begin
    $display("Process 1: Waiting for 10 time units to trigger the event");
    #10;
    $display("Process 1: Triggering start event at time %0t",$time);
    ->start_event;
  end
  
  initial begin
    $display("Process 2: Waiting for start event");
    @start_event;
    $display("Process 2: Detected start event at time %0t",$time);
  end
endmodule