class subscriber extends uvm_subscriber #(bmu_sequence_item);

  `uvm_component_utils(subscriber)

  bmu_sequence_item packet;
  bit [2:0] operation;


  covergroup shift_rotate_cg;

    cp_operation: coverpoint operation {
      bins SLL = {3'b000};
      bins SRL = {3'b001};
      bins SRA = {3'b010};
      bins ROL = {3'b011};
      bins ROR = {3'b100};
    }

    cp_shift_amount: coverpoint packet.b_in[4:0] {
      bins zero   = {0};
      bins one    = {1};
      bins middle = {[2:30]};
      bins last   = {31};
    }

    operation_shift_cross: cross cp_operation, cp_shift_amount;

  endgroup


  function new(string name = "subscriber", uvm_component parent = null);

    super.new(name, parent);
    shift_rotate_cg = new();

  endfunction


  function void write(bmu_sequence_item t);

   

    packet = t;//packe pointer on t . t.ap.sll read the same signal  packet.ap.sll
    sample_shift_rotate();



  endfunction

  //////////////////////////////////////////////////

  function void sample_shift_rotate();

  
    int count;
    rtl_alu_pkt_t selected_ap;
    count = 0;

    if (packet.ap.sll) begin
      count++;
      operation = 3'b000;
    end

    if (packet.ap.srl) begin
      count++;
      operation = 3'b001;
    end

    if (packet.ap.sra) begin
      count++;
      operation = 3'b010;
    end

    if (packet.ap.rol) begin
      count++;
      operation = 3'b011;
    end

    if (packet.ap.ror) begin
      count++;
      operation = 3'b100;
    end


    // Copy only the five controls.
    // Comparing this with ap checks that other controls are zero.
    

    //تصفير النسخه المحليه
    selected_ap = '0;//slt=1,cpop=1  these signal are 0. يعني الاشارات اللي بره وانا هون مش مغطيها بمنع اخليها تعارض  ف بصفرهن
  

    //تعارض احد هاي العمليات بكشفه عن طريق الكاونتر
    selected_ap.sll = packet.ap.sll;
    selected_ap.srl = packet.ap.srl;
    selected_ap.sra = packet.ap.sra;
    selected_ap.rol = packet.ap.rol;
    selected_ap.ror = packet.ap.ror;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&

        packet.ap == selected_ap) begin        //لكشف التعارض احنا بنسختنا منصفر الاوبريشن هس الترانزاكشن لما يجي اذا بكا برضو مش مصفر معناتو تعارض 


      shift_rotate_cg.sample();

    end

 endfunction

endclass