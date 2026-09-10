class ror_operation_seq extends uvm_sequence #(bmu_sequence_item);

  `uvm_object_utils(ror_operation_seq)

  bmu_sequence_item req;


  function new(string name = "ror_operation_seq");
    super.new(name);
  endfunction


  task body();

    req = bmu_sequence_item::type_id::create("req");

    repeat (20) begin

      start_item(req);

      if (!req.randomize())
        `uvm_fatal("RAND_ERROR", "Randomization failed")

      // Default values
      req.ap             = '0;
      req.rst_l          = 1'b1;
      req.scan_mode      = 1'b0;
      req.valid_in       = 1'b1;
      req.csr_ren_in     = 1'b0;
      req.csr_rddata_in  = 32'b0;

      // ROR operation
      req.ap.ror = 1'b1;

      finish_item(req);

    end


    start_item(req);

      req.ap            = '0;
      req.rst_l         = 1'b1;
      req.scan_mode     = 1'b0;
      req.valid_in      = 1'b1;
      req.csr_ren_in    = 1'b0;
      req.csr_rddata_in = 32'b0;
      req.a_in          = 32'h0000_0001;
      req.b_in          = 32'd1;

      req.ap.ror = 1'b1;

    finish_item(req);

  endtask

endclass