
class fifo_driver;
  fifo_txn tr_w;
  fifo_txn tr_r;
  mailbox #(fifo_txn) gen_drv_wmbx;
  mailbox #(fifo_txn) gen_drv_rmbx;
  virtual fifo_if vif;/* class cannot directly access module signals, virtual
  interface creates a handle tothe interface*/
  
  function new(mailbox #(fifo_txn) gen_drv_wmbx,mailbox #(fifo_txn) gen_drv_rmbx,virtual fifo_if vif);
    this.gen_drv_wmbx=gen_drv_wmbx;
    this.gen_drv_rmbx=gen_drv_rmbx;
    this.vif=vif;
  endfunction
  
  task driver_write();
    @(posedge vif.wclk);
    vif.winc<=tr_w.winc;// to avoid race conditions with dut
    vif.wdata<=tr_w.wdata;
    @(posedge vif.wclk);
    vif.winc<=0;// deassert after one pulse
    
  endtask
  
  task driver_read();
    @(posedge vif.rclk);
    vif.rinc<=tr_r.rinc;
    @(posedge vif.rclk);
    vif.rinc<=0;
  endtask
  
              
  task run();
    vif.winc<=0;
    vif.rinc<=0;
    vif.wdata<=0;

      fork 
        
        forever begin
          gen_drv_wmbx.get(tr_w);
          //$display("(driver write)\twinc=%b\twdata=%h",tr_w.winc,tr_w.wdata);
          driver_write();
        end
        
        forever begin
          gen_drv_rmbx.get(tr_r);
         // $display("(driver read)\trinc=%b",tr_r.rinc);
          driver_read();
        end
      join_none
      
      
  endtask
endclass