class fifo_generator;
  
  mailbox #(fifo_txn) gen_drv_wmbx;
  mailbox #(fifo_txn) gen_drv_rmbx;
  
  
  function new(mailbox #(fifo_txn) gen_drv_wmbx,mailbox #(fifo_txn) gen_drv_rmbx);
    
    this.gen_drv_wmbx=gen_drv_wmbx;
    this.gen_drv_rmbx=gen_drv_rmbx;

  endfunction
  int count=1000;
  
  task run();
    fork
      begin
        repeat(count) begin
      
      fifo_txn tr_w;
 	  tr_w=new();
      assert(tr_w.randomize() with {op==write;});// inline constraint
      gen_drv_wmbx.put(tr_w);
      //$display((generator)\toperator=%s\twinc=%b\trinc=%b\twdata=%h",tr_w.op.name(),tr_w.winc,tr_w.rinc,tr_w.wdata);
        end
    end
      
      begin
        repeat(count) begin
          fifo_txn tr_r=new();
          assert(tr_r.randomize() with {op==read;});
          gen_drv_rmbx.put(tr_r);
         //$display((generator)\toperator=%s\twinc=%b\trinc=%b\twdata=%h",tr_r.op.name(),tr_r.winc,tr_r.rinc,tr_r.wdata);
        end
      end
    join
    
    // if we want to use the distribution of operators:
    
    /*repeat(count) begin
  fifo_txn tr = new();

  assert(tr.randomize());

  case(tr.op)

    write:
      gen_drv_wmbx.put(tr);

    read:
      gen_drv_rmbx.put(tr);

    both: begin
      gen_drv_wmbx.put(tr);
      gen_drv_rmbx.put(tr);
    end

    idle:
      ; 

  endcase
end*/
     
  endtask
 
endclass