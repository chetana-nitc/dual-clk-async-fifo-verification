module fifo_assert(fifo_if vif);
  int write_full=0;
  int read_empty=0;
  
 /* property p_full_stays_full;
  @(posedge vif.wclk)
  (vif.winc && vif.wfull) |=> vif.wfull;
endproperty

a_full_stays_full:
assert property(p_full_stays_full);
  
  property p_empty_stays_empty;
  @(posedge vif.rclk)
  (vif.rinc && vif.rempty) |=> vif.rempty;
endproperty

a_empty_stays_empty:
  assert property(p_empty_stays_empty);*/
    
  property p_reset_wfull;
  @(posedge vif.wclk)
  !vif.wrst_n |-> !vif.wfull;
endproperty

a_reset_wfull:
assert property(p_reset_wfull);
  
  property p_reset_rempty;
  @(posedge vif.rclk)
  !vif.rrst_n |-> vif.rempty;
endproperty

a_reset_rempty:
assert property(p_reset_rempty);
  
 always @(posedge vif.wclk)
  if(vif.winc && vif.wfull)
    write_full++;

always @(posedge vif.rclk)
  if(vif.rinc && vif.rempty)
    read_empty++;
    endmodule
  