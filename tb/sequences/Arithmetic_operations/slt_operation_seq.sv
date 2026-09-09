//teat signed and unsigned

class slt_operation_seq extends uvm_sequence #(bmu_sequence_item);


  `uvm_object_utils(slt_operation_seq)

  bmu_sequence_item req;


  function new(string name = "slt_operation_seq");
    super.new(name);
  endfunction


  task body();

    req = bmu_sequence_item::type_id::create("req");


    // Signed SLT
    repeat (10) begin

      start_item(req);

      if (!req.randomize())
        `uvm_fatal("RAND_ERROR", "Randomization failed")

      req.ap             = '0;
      req.rst_l          = 1'b1;
      req.scan_mode      = 1'b0;
      req.valid_in       = 1'b1;
      req.csr_ren_in     = 1'b0;
      req.csr_rddata_in  = 32'b0;

      req.ap.slt    = 1'b1;
      req.ap.sub    = 1'b1;
      req.ap.unsign = 1'b0;

      finish_item(req);

    end


    // Unsigned SET LESS THAN
    repeat (10) begin

      start_item(req);

      if (!req.randomize())


        `uvm_fatal("RAND_ERROR", "Randomization failed")

      req.ap             = '0;
      req.rst_l          = 1'b1;
      req.scan_mode      = 1'b0;
      req.valid_in       = 1'b1;
      req.csr_ren_in     = 1'b0;
      req.csr_rddata_in  = 32'b0;

      req.ap.slt    = 1'b1;
      req.ap.sub    = 1'b1;
      req.ap.unsign = 1'b1;

      finish_item(req);

    end

  endtask

endclass