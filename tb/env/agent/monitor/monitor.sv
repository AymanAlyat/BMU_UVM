class monitor extends uvm_monitor;//not paramitrize لانه ما بستقبل ايتم
//هاذ براقب الانترفيس وبوخذ القيم بس

  `uvm_component_utils(monitor)

  virtual Bit_Manipulation_intf.mon vif;

  uvm_analysis_port #(bmu_sequence_item) analysis_port;//المخرج تاع المونيتور اللي رح ابعت من خلاله للسكوربورد والسبسكرايبر
  /*
  uvm_analysis_port #(bmu_sequence_item) analysis_port;
 موصول عليه compenent لأي broadcast عشنان يرسل  analysis_port.write() مجهزله  UVM ال 
  
  uvm_analysis_port :class from UVM
  #(bmu_sequence_item): type data which port allow it to sent to another compenent.
  analysis_port: handle name
  
  */

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);//
  endfunction



  function void build_phase(uvm_phase phase);

  super.build_phase(phase);

  if (!uvm_config_db #(virtual Bit_Manipulation_intf.mon)::get( this, "", "vif", vif))

    `uvm_fatal("NO_VIF", "Monitor virtual interface not found")

 endfunction


 task run_phase(uvm_phase phase);

  bmu_sequence_item item;

  forever begin

    @(vif.cb_mon);

    item = bmu_sequence_item::type_id::create("item");

    item.rst_l         = vif.cb_mon.rst_l;
    item.scan_mode     = vif.cb_mon.scan_mode;
    item.valid_in      = vif.cb_mon.valid_in;
    item.ap            = vif.cb_mon.ap;
    item.csr_ren_in    = vif.cb_mon.csr_ren_in;
    item.csr_rddata_in = vif.cb_mon.csr_rddata_in;
    item.a_in          = vif.cb_mon.a_in;
    item.b_in          = vif.cb_mon.b_in;

    item.result_ff     = vif.cb_mon.result_ff;
    item.error         = vif.cb_mon.error;

    analysis_port.write(item);//sent item to any component connetct on analysis port.(scoreboard and subsicriber)

  end

 endtask

endclass