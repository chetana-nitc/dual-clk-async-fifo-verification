class fifo_monitor;
  
  mailbox #(fifo_txn) mon_scb_wmbx;
  mailbox #(fifo_txn) mon_scb_rmbx;
  virtual fifo_if vif;
  function new(mailbox #(fifo_txn) mon_scb_wmbx,mailbox #(fifo_txn)mon_scb_rmbx,
               virtual fifo_if vif);
    this.mon_scb_wmbx=mon_scb_wmbx;
    this.mon_scb_rmbx=mon_scb_rmbx;
    this.vif=vif;
    fifo_cg=new();
  endfunction
  
  int full_cnt=0;
  int empty_cnt=0;
  

  task monitor_write();

  fifo_txn tr;

  forever begin

    @(posedge vif.wclk);    
     fifo_cg.sample();    
    if(vif.wfull) begin
      full_cnt++;
      /*$display("(monitor) FIFO FULL count=%0d time=%0t",
                full_cnt,$time);*/
    end

    if(vif.winc && !vif.wfull) begin

      tr = new();

      tr.winc  = vif.winc;
      tr.wdata = vif.wdata;
      tr.rinc  = 0;

      mon_scb_wmbx.put(tr);

    end

  end

endtask
 
  task monitor_read();

  fifo_txn tr;
  forever begin

    @(posedge vif.rclk);
    fifo_cg.sample();

    if(vif.rempty) begin
      empty_cnt++;
      /*$display("(monitor) FIFO EMPTY count=%0d time=%0t",
                empty_cnt,$time);*/
    end

    if(vif.rinc && !vif.rempty) begin

      tr = new();

      tr.rinc  = 1;
      tr.winc  = 0;
      tr.rdata = vif.rdata;

      mon_scb_rmbx.put(tr);

    end

  end

endtask
  
  task run();
    
      fork
        monitor_write();
        monitor_read();
      join_none
      
  endtask
  
  covergroup fifo_cg;
    cp_op:coverpoint {vif.winc,vif.rinc}{
      bins idle ={2'b00};
      bins read={2'b01};
      bins write={2'b10};
      bins both={2'b11};
  }
    cp_full: coverpoint vif.wfull{
      bins full={1};
  
  }
    cp_empty: coverpoint vif.rempty{
      bins empty={1};
  }
    cp_afull: coverpoint vif.awfull{
      bins almost_full={1};
  }
    cp_aempty: coverpoint vif.arempty{
      bins almost_empty={1};
  }
    cross cp_full,cp_op;
    cross cp_empty,cp_op;
  endgroup
endclass