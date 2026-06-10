class fifo_env;
  fifo_generator gen;
  fifo_driver drv;
  fifo_monitor mon;
  fifo_scoreboard scb;
  
  mailbox #(fifo_txn) gen_drv_wmbx;
  mailbox #(fifo_txn) gen_drv_rmbx;
  mailbox #(fifo_txn) mon_scb_wmbx;
  mailbox #(fifo_txn) mon_scb_rmbx;
  
  virtual fifo_if vif;
  
  function new(virtual fifo_if vif);
    
    this.vif=vif;
  endfunction
  
  task build();
  
    gen_drv_wmbx=new();
    gen_drv_rmbx=new();
    mon_scb_wmbx=new();
    mon_scb_rmbx=new();
  
    gen=new(gen_drv_wmbx,gen_drv_rmbx);
    drv=new(gen_drv_wmbx,gen_drv_rmbx,vif);
    mon=new(mon_scb_wmbx,mon_scb_rmbx,vif);
    scb=new(mon_scb_wmbx,mon_scb_rmbx);
  endtask
  task run();
  fork
    gen.run();
    drv.run();
    mon.run();
    scb.run();
  join_none
  endtask
endclass
    