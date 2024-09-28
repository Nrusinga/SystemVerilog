module tb();

  logic clk, reset_n;
  logic [7:0] data_in, data_out;
  logic valid;

  // Clocking block definition with input and output skews
  clocking cb @(posedge clk);
    input  #1 data_in;  // Sample `data_in` 1-time-unit after the clock edge
    output #2 data_out; // Drive `data_out` 2-time-units after the clock edge
    output #3 valid;    // Drive `valid` 3-time-units after the clock edge
  endclocking

  // Always block that simulates DUT behavior: `data_out` = `data_in` + 1
  always @(cb) begin
    if (reset_n) begin
      cb.data_out <= cb.data_in + 1;
      cb.valid <= 1'b1;
    end
    else begin
      cb.data_out <= 8'h00;
      cb.valid <= 1'b0;
    end
  end

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus generation (drive inputs to the DUT)
  initial begin
    reset_n = 0;
    #10 reset_n = 1;  // Release reset after 10 time units
    
    @(posedge clk); 
    data_in <= 8'hA5;  // Drive `data_in` directly, outside the clocking block
    
    @(posedge clk);
    data_in <= 8'h5A;  // Drive another value
    
    @(posedge clk);
    data_in <= 8'hFF;  // Drive yet another value
    
    #10 $finish;  // End simulation after some time
  end

endmodule
