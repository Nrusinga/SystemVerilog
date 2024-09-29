// Code your testbench here
// or browse Examples


/* Command spec:

Command: Header byte + variable number of bytes

header -> byte 1 -> byte 2 -> byte 3 ->.... byte n

2  types of command:

CPU commandL Header[7:6]=00
Memory command[7:6]=01

CPU commands :
NOOP: header[5:0]=000000, length=1, Function: Do nothing.
ADD: header[5:0]=000001, length=3, Function: Add Op1 and Op2
SUB: header[5:0]=000010, length=3, Function: Subtract Op1 and Op2

ADD: 0000_0001 op1 op2 or 'h1
Memory commands:
MWAIT : header[5:0]=000000, length=1, Functions: Do nothing 
LOAD_RGR : header[5:0]=000001, length=4, Functions: Load a register from the memory location
STORE_RGR : header[5:0]=000010, length=4, Functions: Store a register to the memory location
COPY : header[5:0]=000011, length=5, Functions: Copy a memory location to the other location

LOAD_RGR: 0100_0001 register src_mem_addr[15:8] src_mem_addr[7:0]
*/
`include "txn_base.sv"
`include "txn_def.sv"
`include "generator.sv"
`include "driver.sv"
`include "environment.sv"
module my_tb();
  my_design mydesign();
  
  my_env env;
  initial begin
    env=new();
    env.run();
  end
endmodule