`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"
`include "assertions.sv"
module top;
  
  fifo_if vif();
  async_fifo dut(.wclk(vif.wclk),
                 .wrst_n(vif.wrst_n),
                 .winc(vif.winc),
                 .wdata(vif.wdata),
                 .wfull(vif.wfull),
                 .awfull(vif.awfull),
                 .rclk(vif.rclk),
                 .rrst_n(vif.rrst_n),
                 .rinc(vif.rinc),
                 .rdata(vif.rdata),
                 .rempty(vif.rempty),
                 .arempty(vif.arempty)
                );
  fifo_test test;
 fifo_assert asrt(vif);
  
  initial begin
    vif.wclk=0;
    forever #5 vif.wclk=~vif.wclk;
  end
  initial begin
    vif.rclk=0;
    forever #8 vif.rclk=~vif.rclk;
  end
  
  initial begin
    vif.wrst_n=1;
    vif.rrst_n=1;
    #1;
    vif.wrst_n=0;
    vif.rrst_n=0;
    #10;
    vif.wrst_n=1;
    vif.rrst_n=1;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
end
 
  initial begin 
  test=new(vif);
  test.run();
  
  #500000
  $finish;
  end
 
        
  initial begin

  #490000;

  $display("\n========================================");
    $display("         FIFO TEST SUMMARY\n");
 

  $display("Writes      = %0d", test.env.scb.write_cnt);
  $display("Reads       = %0d", test.env.scb.read_cnt);
  $display("Passes      = %0d", test.env.scb.pass_cnt);
  $display("Fails       = %0d", test.env.scb.fail_cnt);

  $display("Empty Reads = %0d", test.env.scb.empty_cnt);

  $display("FULL Hits   = %0d", test.env.mon.full_cnt);
  $display("EMPTY Hits  = %0d", test.env.mon.empty_cnt);

  $display("Queue Left  = %0d", test.env.scb.exp_q.size());
    $display("Write-while-full attempts = %0d",
         asrt.write_full);

$display("Read-while-empty attempts = %0d",
         asrt.read_empty);
    $display("Coverage = %0.2f%%",
         test.env.mon.fifo_cg.get_coverage());
    $display("Operation Coverage      = %0.2f%%",
         test.env.mon.fifo_cg.cp_op.get_coverage());

$display("Full Coverage           = %0.2f%%",
         test.env.mon.fifo_cg.cp_full.get_coverage());

$display("Empty Coverage          = %0.2f%%",
         test.env.mon.fifo_cg.cp_empty.get_coverage());

$display("Almost Full Coverage    = %0.2f%%",
         test.env.mon.fifo_cg.cp_afull.get_coverage());

$display("Almost Empty Coverage   = %0.2f%%",
         test.env.mon.fifo_cg.cp_aempty.get_coverage());

  $display("========================================\n");

  $finish;

end
endmodule