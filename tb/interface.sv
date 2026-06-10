interface fifo_if #(parameter DSIZE =8);// parameterized interface
  // write signals
  logic wclk;
  logic wrst_n;
  logic winc;
  logic [DSIZE-1:0] wdata;
  
  logic wfull;
  logic awfull;
  
  //read signals
  logic rclk;
  logic rrst_n;
  logic rinc;
  logic [DSIZE-1:0] rdata;
  
  logic rempty;
  logic arempty;
endinterface