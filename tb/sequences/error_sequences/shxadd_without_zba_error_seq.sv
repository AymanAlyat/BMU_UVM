class shxadd_without_zba_error_seq extends uvm_sequence #(bmu_sequence_item);

  `uvm_object_utils(shxadd_without_zba_error_seq)

  bmu_sequence_item req;

  function new(string name = "shxadd_without_zba_error_seq");
    super.new(name);
  endfunction

  task body();

    req = bmu_sequence_item::type_id::create("req");

    start_item(req);

    if (!req.randomize())
      `uvm_fatal("RAND_ERROR", "Randomization failed")

    req.ap            = '0;
    req.rst_l         = 1'b1;
    req.scan_mode     = 1'b0;
    req.valid_in      = 1'b1;
    req.csr_ren_in    = 1'b0;
    req.csr_rddata_in = 32'b0;

    // Invalid: SH2ADD without Zba
    req.ap.sh2add = 1'b1;
    req.ap.zba    = 1'b0;

    finish_item(req);


    start_item(req);

    if (!req.randomize())
      `uvm_fatal("RAND_ERROR", "Randomization failed")

    req.ap            = '0;
    req.rst_l         = 1'b1;
    req.scan_mode     = 1'b0;
    req.valid_in      = 1'b1;
    req.csr_ren_in    = 1'b0;
    req.csr_rddata_in = 32'b0;

    // Invalid: SH2ADD without Zba
    req.ap.sh1add = 1'b1;
    req.ap.zba    = 1'b0;

    finish_item(req);


    start_item(req);

    if (!req.randomize())
      `uvm_fatal("RAND_ERROR", "Randomization failed")

    req.ap            = '0;
    req.rst_l         = 1'b1;
    req.scan_mode     = 1'b0;
    req.valid_in      = 1'b1;
    req.csr_ren_in    = 1'b0;
    req.csr_rddata_in = 32'b0;

    // Invalid: SH3ADD without Zba
    req.ap.sh3add = 1'b1;
    req.ap.zba    = 1'b0;

    finish_item(req);

  endtask

endclass