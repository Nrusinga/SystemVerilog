class cpu_noop extends cpu_cmd_base;
  virtual function void set_header();
    length=1;
    super.set_header();
    header[5:0]='h00;
  endfunction:set_header
  
  virtual function void fill_random_val();
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
  endfunction:finalize_cmd
  
endclass:cpu_noop


class cpu_add extends cpu_cmd_base;
  logic [7:0]op1,op2;
  virtual function void set_header();
    length=3;
    super.set_header();
    header[5:0]='h01;
  endfunction:set_header
  
  virtual function void fill_random_val();
    op1=$urandom_range(0,255);
    op2=$urandom_range(0,255);
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
    cmd[1]=op1;
    cmd[2]=op2;
  endfunction:finalize_cmd
  
endclass:cpu_add


class cpu_sub extends cpu_cmd_base;
  logic [7:0]op1,op2;
  virtual function void set_header();
    length=3;
    super.set_header();
    header[5:0]='h02;
  endfunction:set_header
  
  virtual function void fill_random_val();
    op1=$urandom_range(0,255);
    op2=$urandom_range(0,255);
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
    if(op1>op2) begin
      
      cmd[1]=op1;
      cmd[2]=op2;
    end else begin
      cmd[1]=op2;
      cmd[2]=op1;
    end
  endfunction:finalize_cmd
  
endclass:cpu_sub



class mem_wait extends mem_cmd_base;
  virtual function void set_header();
    length=1;
    super.set_header();
    header[5:0]='h00;
  endfunction:set_header
  
  virtual function void fill_random_val();
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
  endfunction:finalize_cmd
  
endclass:mem_wait




class mem_load extends mem_cmd_base;
  logic [7:0] rgr;
  logic [15:0]src;
  virtual function void set_header();
    length=4;
    super.set_header();
    header[5:0]='h01;
  endfunction:set_header
  
  virtual function void fill_random_val();
    rgr=$urandom_range(0,255);
    src=$urandom_range(0,'hffff);
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
    cmd[1]=rgr;
    cmd[2]=src[15:8];
    cmd[3]=src[7:0];
    
  endfunction:finalize_cmd
  
endclass:mem_load


class mem_store extends mem_cmd_base;
  logic [7:0] rgr;
  logic [15:0]dest;
  virtual function void set_header();
    length=4;
    super.set_header();
    header[5:0]='h02;
  endfunction:set_header
  
  virtual function void fill_random_val();
    rgr=$urandom_range(0,255);
    dest=$urandom_range(0,'hffff);
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
    cmd[1]=rgr;
    cmd[2]=dest[15:8];
    cmd[3]=dest[7:0];
    
  endfunction:finalize_cmd
  
endclass:mem_store


class mem_copy extends mem_cmd_base;
 
  logic [15:0]src;
  logic [15:0]dest;
  virtual function void set_header();
    length=5;
    super.set_header();
    header[5:0]='h03;
  endfunction:set_header
  
  virtual function void fill_random_val();
    dest=$urandom_range(0,255);
    src=$urandom_range(0,'hffff);
  endfunction:fill_random_val
  
  virtual function void finalize_cmd();
    super.finalize_cmd();
    cmd[0]=header;
    cmd[1]=src[15:8];
    cmd[2]=src[7:0];
    cmd[3]=dest[15:8];
    cmd[4]=dest[7:0];
    
  endfunction:finalize_cmd
  
endclass:mem_copy