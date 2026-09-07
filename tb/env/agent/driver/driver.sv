class driver extends uvm_driver #(bmu_sequence_item);

`uvm_compenent_utils(driver)
 virtual Bit_Manipulation_intf.drv vif;


 function new(string name="driver" , uvm_compenent parent=null);
    super.new(name,parent)
        
 endfunction


 function void build_phase(uvm_phase phase);

  super.build_phase(phase);

  if (!uvm_config_db #(virtual Bit_Manipulation_intf.drv)::get( this,"", "vif", vif))

    `uvm_fatal("NO_VIF", "Driver virtual interface not found")

 endfunction 

 task run_phase(uvm_phase phase);

  forever begin

    seq_item_port.get_next_item(req);//req: ==>sequencer الايتم اللي  بستلمه من 

    @(vif.cb_drv);

    vif.cb_drv.rst_l         <= req.rst_l;
    vif.cb_drv.scan_mode     <= req.scan_mode;
    vif.cb_drv.valid_in      <= req.valid_in;
    vif.cb_drv.ap            <= req.ap;
    vif.cb_drv.csr_ren_in    <= req.csr_ren_in;
    vif.cb_drv.csr_rddata_in <= req.csr_rddata_in;
    vif.cb_drv.a_in          <= req.a_in;
    vif.cb_drv.b_in          <= req.b_in;

    seq_item_port.item_done();//Driver tells sequencer: tI finshed the current item , now can send the next item. Handshaking for this item are completed now.يعني وصل والرد وصل وتم

  end

endtask



endclass