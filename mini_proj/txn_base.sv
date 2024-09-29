class cmd_base;
  logic [7:0] header;
  logic length;
  logic [7:0] cmd;
  bit en_random_data;
  
  function new();
    process_cmd(1);
  endfunction:new
  
  function void process_cmd(bit en_random_data=1);
    set_header();
    if(en_random_data==1) begin 
      fill_random_val();
    end
    finalize_cmd();
  endfunction:process_cmd
  
  virtual function void set_header();
  endfunction:set_header
  
  virtual function void fill_random_val();
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    cmd=new[length];
  endfunction:finalize_cmd
  
  function void print(string msg);
    string tmp_str,name;
    
    case (header)
      'h00: name="CPU_NOOP";
      'h01: name="CPU_ADD";
      'h02: name="CPU_SUB";
      'h40: name="MEM_WAIT";
      'h41: name="MEM_LOAD";
      'h42: name="MEM_STORE";
      'h43: name="MEM_COPY";
    endcase
    
    msg={msg,"Cmd is : ",name," : "};
    for(int i= 0;i<length;i++) begin
      $sformat(tmp_str,"%2h",cmd[i]);
      msg={msg,tmp_str};
    end
    
    $display("%s",msg);
  endfunction:print
endclass:cmd_base
               

class cpu_cmd_base extends cmd_base;
  virtual function void set_header();
    header[7:6]='b00;
  endfunction:set_header
endclass:cpu_cmd_base




class mem_cmd_base extends cmd_base;
  virtual function void set_header();
    header[7:6]='b01;
  endfunction:set_header
endclass:mem_cmd_base
     
  
 