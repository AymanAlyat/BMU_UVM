class sequencer extends uvm_sequencer #(bmu_sequence_item);//الاب هو قايم بالشغل كله احنا بس قلناله نوع الايتم اللي بدو يتعامل معه

 
 `uvm_component_utils(sequencer)

  function new(string name="sequencer",uvm_component parent = null);
    super.new(name,parent);
        
  endfunction
endclass