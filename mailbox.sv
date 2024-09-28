class axi_txn;
  rand bit [3:0] id;
  rand bit [7:0] length;
  rand bit [31:0] addr;
  constraint cst {
    length inside {1 ,4 ,6 ,16};
    addr % 4 == 0;
  }
  
  function new();
    id = 0;
    length = 0;
    addr = 0;
  endfunction
  
endclass: axi_txn

class axi_generator;
  mailbox mb;

  function new();
    mb = new();
  endfunction
  
  task run();
    axi_txn txn;
    
    for (int i = 0; i < 10; i++) begin
      txn = new();
      assert(txn.randomize()); // Randomize the transaction
      mb.put(txn);             // Send txn to mailbox
      $display("Generated TXN: ID=%0h LEN=%0h ADDR=%0h", txn.id, txn.length, txn.addr);
      #5;
    end
  endtask: run
  
endclass: axi_generator

class axi_driver;
  mailbox mb;
  virtual axi_intf m_intf;

  function new();
    mb = new();
  endfunction 
  
  task run();
    axi_txn txn;
    
    for (int i = 0; i < 10; i++) begin
      mb.get(txn); // Get the transaction from mailbox

      // Drive AXI signals onto the interface
      m_intf.awid    = txn.id;
      m_intf.awlen   = txn.length;
      m_intf.awaddr  = txn.addr;
      m_intf.awvalid = 1'b1;

      // Wait for AWREADY handshake
      @(posedge m_intf.awready);
      m_intf.awvalid = 1'b0;
      $display("Sent TXN: ID=%0h LEN=%0h ADDR=%0h", txn.id, txn.length, txn.addr);
      #5;
    end
  endtask: run
endclass: axi_driver

interface axi_intf(input logic clk, input logic rst);
  logic [3:0]  awid;
  logic [7:0]  awlen;
  logic [31:0] awaddr;
  logic        awvalid;
  logic        awready;

  // Optional clocking block for timing control (not used in this example)
  clocking axi_cb @(posedge clk);
    output awid, awlen, awaddr, awvalid;
    input awready;
  endclocking
endinterface: axi_intf

module sample(axi_intf intf);
  // DUT monitors and processes transactions on the AXI interface
  always_ff @(posedge intf.awvalid) begin
    if (intf.awvalid && intf.awready) begin
      $display("DUT received TXN: ID=%0h LEN=%0h ADDR=%0h", intf.awid, intf.awlen, intf.awaddr);
    end
  end
endmodule: sample

module tb();
  // Instantiate AXI driver and generator
  axi_driver mdriver;
  axi_generator m_gen;
  logic clk, rst;  // Declare clock and reset as logic
  // Instantiate AXI interface and DUT
  axi_intf m_intf(clk, rst);
  sample dut1(.intf(m_intf));  // Connect DUT to the AXI interface

  

  // Clock generation
  always #5 clk = ~clk;

  // Reset generation
  initial begin
    rst = 1;
    #20 rst = 0;
  end

  // Testbench control logic
  initial begin
    // Create mailbox for communication between generator and driver
    mailbox mb1 = new();

    // Create instances of generator and driver
    mdriver = new();
    m_gen = new();

    // Connect mailbox and interface
    m_gen.mb = mb1;
    mdriver.mb = mb1;
    mdriver.m_intf = m_intf;

    // Run the generator and driver concurrently
    fork
      m_gen.run();
      mdriver.run();
    join

    $finish("Send all transactions");
  end
endmodule: tb
