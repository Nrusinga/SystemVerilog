interface simple_bus(input clk);
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic valid;
  logic ready;
  
  modport DUT_modport(
    input data_in,
    input ready,
    output data_out,
    output valid
  );
  
  modport TB_modport(
    output data_in,
    output ready,
    input data_out,
    input valid
  );
  
  clocking cb @(posedge clk);
    output #1 data_in;
    output #2 ready;
    input #1 data_out;
    input #1 valid;
  endclocking:cb
endinterface:simple_bus



  
module DUT(simple_bus.DUT_modport bus);
  // Declare outputs for the DUT
  logic [7:0] data_out;
  logic valid;
  always_ff @(posedge bus.clk) begin
    if(bus.ready) begin
      bus.data_out<=bus.data_in+1;
      bus.valid<=1'b1;
    end
    else begin
      bus.data_out<=8'b0;
      bus.valid<=1'b0;
    end
  end
endmodule:DUT


module tb();
  logic clk;
  simple_bus bus_if(clk);
  
  Dut dut(.bus(bus_if.DUT_modport));
  
  always #5 clk = ~clk;
  
  initial begin
    clk=1'b0;
    bus_if.cb.ready<=1'b0;
    bus_if.cb.data_in<=8'h00;
    
    repeat(3) @(posedge clk);
    
    @(posedge clk)
    bus_if.cb.ready<=1'b1;
    bus_if.cb.data_in<=8'hA5;
    
    @(posedge clk)
    bus_if.cb.data_in <= 8'h5A; 
    
    @(posedge clk);
    if (bus_if.cb.valid) begin
      $display("Received data_out: %0h", bus_if.cb.data_out);  // Sample data_out using `cb`
    end
    
    // Wait for a few more clock cycles and finish
    repeat (5) @(posedge clk);
    $finish;
  end
endmodule
