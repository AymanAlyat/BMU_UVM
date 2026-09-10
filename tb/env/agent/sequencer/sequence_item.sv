class bmu_sequence_item extends uvm_sequence_item;


  //We moved the definition of variables to above
  //الماكرو كان مش متعرف عليهن وهن تحت الماكرووز
  rand logic rst_l;
  rand logic scan_mode;
  rand logic valid_in;

  rand rtl_alu_pkt_t ap;

  rand logic        csr_ren_in;
  rand logic [31:0] csr_rddata_in;

  rand logic signed [31:0] a_in;
  rand logic        [31:0] b_in;

  logic [31:0] result_ff;
  logic        error;





  `uvm_object_utils_begin(bmu_sequence_item)

    `uvm_field_int(rst_l,         UVM_DEFAULT)
    `uvm_field_int(scan_mode,     UVM_DEFAULT)
    `uvm_field_int(valid_in,      UVM_DEFAULT)
    `uvm_field_int(ap,            UVM_DEFAULT)
    `uvm_field_int(csr_ren_in,    UVM_DEFAULT)
    `uvm_field_int(csr_rddata_in, UVM_DEFAULT)
    `uvm_field_int(a_in,          UVM_DEFAULT)
    `uvm_field_int(b_in,          UVM_DEFAULT)
    `uvm_field_int(result_ff,     UVM_DEFAULT)
    `uvm_field_int(error,         UVM_DEFAULT)

  `uvm_object_utils_end




  function new(string name = "bmu_sequence_item");
    super.new(name);
    
  endfunction


endclass