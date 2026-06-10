class fifo_scoreboard #(parameter DSIZE=8);

  fifo_txn tr_w;
  fifo_txn tr_r;

  bit [DSIZE-1:0] expected;// reads the data given by the monitor stored in queue

  mailbox #(fifo_txn) mon_scb_wmbx;
  mailbox #(fifo_txn) mon_scb_rmbx;

  bit [DSIZE-1:0] exp_q[$];// $:dynamic queue

  
  int write_cnt = 0;
  int read_cnt  = 0;
  int pass_cnt  = 0;
  int fail_cnt  = 0;
  int empty_cnt = 0;

  function new(
    mailbox #(fifo_txn) mon_scb_wmbx,
    mailbox #(fifo_txn) mon_scb_rmbx
  );

    this.mon_scb_wmbx = mon_scb_wmbx;
    this.mon_scb_rmbx = mon_scb_rmbx;

  endfunction

  task run();

    fork

      forever begin

        mon_scb_wmbx.get(tr_w);

        exp_q.push_back(tr_w.wdata);

        write_cnt++;

       /* $display(
          "(scoreboard push) data=%h size=%0d writes=%0d",
          tr_w.wdata,
          exp_q.size(),
          write_cnt
        );*/

      end

      // READ SIDE
      forever begin

        mon_scb_rmbx.get(tr_r);

        if(exp_q.size()==0) begin

          empty_cnt++;

          /*$display(
            "(scoreboard) ERROR: READ WHEN EMPTY (count=%0d)",
            empty_cnt
          );*/

        end
        else begin

          expected = exp_q.pop_front();

          read_cnt++;

          if(expected == tr_r.rdata) begin

            pass_cnt++;

           /* $display(
              "(scoreboard) Read expected=%h actual=%h queue size=%0d PASS=%0d FAIL=%0d",
              expected,
              tr_r.rdata,
              exp_q.size(),
              pass_cnt,
              fail_cnt
            );*/

          end
          else begin

            fail_cnt++;

           /* $display(
              "(scoreboard) Read expected=%h actual=%h queue size=%0d PASS=%0d FAIL=%0d",
              expected,
              tr_r.rdata,
              exp_q.size(),
              pass_cnt,
              fail_cnt
            );*/

          end

        end

      end

    join

  endtask

endclass        
        
        
        
          