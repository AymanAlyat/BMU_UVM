class gorc_operation_seq extends uvm_sequence #(bmu_sequence_item);

  `uvm_object_utils(gorc_operation_seq)

  bmu_sequence_item req;


  function new(string name = "gorc_operation_seq");
    super.new(name);
  endfunction


  task body();

    req = bmu_sequence_item::type_id::create("req");

    repeat (20) begin

      start_item(req);

      if (!req.randomize())
        `uvm_fatal("RAND_ERROR", "Randomization failed")

      req.ap             = '0;
      req.rst_l          = 1'b1;
      req.scan_mode      = 1'b0;
      req.valid_in       = 1'b1;
      req.csr_ren_in     = 1'b0;
      req.csr_rddata_in  = 32'b0;

      // GORC operation
      req.ap.gorc = 1'b1;
      //req.b_in[4:0] = 5'b00111;
      //try b_in=24 or 7 during simulation 
      //RTL talk about subset take 7  ==> assign ap_orc_b = ap.gorc & (b_in[4:0] == 5'b00111);

      finish_item(req);

    end

  endtask

endclass