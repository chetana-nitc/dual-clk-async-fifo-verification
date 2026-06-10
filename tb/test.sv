class fifo_test;
  fifo_env env;
  virtual fifo_if vif;
  function new(virtual fifo_if vif);
    this.vif=vif;
    env=new(vif);
  endfunction
  
  task run();
    env.build();
    env.gen.count=10000;
    env.run();
  endtask
endclass
  