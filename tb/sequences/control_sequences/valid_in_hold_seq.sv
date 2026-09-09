class valid_in_hold_seq extends uvm_sequence #(bmu_sequence_item);



  `uvm_object_utils(valid_in_hold_seq)

  bmu_sequence_item req;

  function new(string name = "valid_in_hold_seq");
    super.new(name);
  endfunction

  task body();

    req = bmu_sequence_item::type_id::create("req");

    //test contaain two stages to ensure from valid_in.

    // 1) Execute a valid operation
    start_item(req);

    if (!req.randomize())
      `uvm_fatal("RAND_ERROR", "Randomization failed")

    req.ap            = '0;
    req.rst_l         = 1'b1;
    req.scan_mode     = 1'b0;
    req.valid_in      = 1'b1;
    req.csr_ren_in    = 1'b0;
    req.csr_rddata_in = 32'b0;

    req.ap.lor = 1'b1;
    req.ap.zbb = 1'b0;

    finish_item(req);


    // 2) valid_in = 0 --> result_ff should hold
    start_item(req);

    if (!req.randomize())

      `uvm_fatal("RAND_ERROR", "Randomization failed")

    req.ap            = '0;
    req.rst_l         = 1'b1;
    req.scan_mode     = 1'b0;
    req.valid_in      = 1'b0;//restult_ff must be contain the last transaction result.
    req.csr_ren_in    = 1'b0;
    req.csr_rddata_in = 32'b0;


    req.ap.land = 1'b1;
    req.ap.zbb = 1'b0;

    finish_item(req);

  endtask

endclass