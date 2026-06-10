class fifo_txn #(parameter DSIZE =8);
  
  typedef enum [1:0]{   
    idle,
    read,
    write,
    both
  }fifo_op_t;
  rand fifo_op_t op;
  bit winc,rinc;
  rand bit [DSIZE-1:0] wdata;
  bit [DSIZE-1:0] rdata;
  
  constraint c_wdata{
    if(op!=write &&op!=both)
      wdata=='0;
  }
  
constraint c_op {
  op dist {     
    idle  := 10,
    both  := 0,
    write := 45,
    read  := 45
  };
}
  function void post_randomize();

  case(op)

    idle: begin
      winc = 0;
      rinc = 0;
    end

    write: begin
      winc = 1;
      rinc = 0;
    end

    read: begin
      winc = 0;
      rinc = 1;
    end

    both: begin
      winc = 1;
      rinc = 1;
    end

  endcase

endfunction
  
endclass