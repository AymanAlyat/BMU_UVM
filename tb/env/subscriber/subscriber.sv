class subscriber extends uvm_subscriber #(bmu_sequence_item);

  `uvm_component_utils(subscriber)
  //الاب انشئ المدخل انا ماليش علاقه

  bmu_sequence_item packet;

  //هس هو في طريقه ثانيه بس هاي انا مستوعبها اكثر الطريقه الثانيه مثلا عندك ست عمليات بدك ست بتات اول عمليه بتحط البت الاول واحد والعمليه الثانيه بتحط البت الثاني واحد وهيكا يعني بكون بت واحد من هذول السته فعال
  bit [2:0] operation;
  bit [1:0] bit_operation;
  bit [2:0] logic_operation;//AND,....


  covergroup shift_rotate_cg;
  option.per_instance = 1;

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

    //how to calculate coverage percent
    /*
    
    cp_operation :  4/5   ===> 4 done ,however 1 not try yet .يعني جربت اربع عمليات وطلع عندي نسبه اسمها اكس
    cp_shift_amount: 4/4 ===> all value try it .وبطلع عندي نسبه اسمها صاد
    cross:طلع عندي مثلا 50 احتمال انا جربت منهن 20 ف كمان بطلع هون نسبه

    total percent= sumation percentage/number cp. وبطلع نسبه نهائيه 
    
    
    
    
    
    */


  endgroup
  ///////////////

  covergroup bit_operations_cg;
  option.per_instance = 1;

    cp_operation: coverpoint bit_operation {
      bins BSET = {2'b00};
      bins BCLR = {2'b01};
      bins BINV = {2'b10};
      bins BEXT = {2'b11};
    }

    cp_bit_position: coverpoint packet.b_in[4:0] {
      bins zero   = {0};
      bins one    = {1};
      bins middle = {[2:30]};
      bins last   = {31};
    }

    operation_bit_cross: cross cp_operation, cp_bit_position;

  endgroup




  /////////////////////////////////////////////////


  covergroup logic_cg;

    option.per_instance = 1;

    cp_operation: coverpoint logic_operation {
      bins AND_OP = {3'b000};
      bins ANDN   = {3'b001};
      bins OR_OP  = {3'b010};
      bins ORN    = {3'b011};
      bins XOR_OP = {3'b100};
      bins XNOR   = {3'b101};
    }

    cp_a: coverpoint $unsigned(packet.a_in) {//logic operation dont care sign 
      bins zero   = {32'h0000_0000};
      bins ones   = {32'hFFFF_FFFF};
      bins others = {[32'h0000_0001:32'h7FFF_FFFF]};
    }

    cp_b: coverpoint packet.b_in {
      bins zero   = {32'h0000_0000};
      bins ones   = {32'hFFFF_FFFF};
      bins others = {[32'h0000_0001:32'hFFFF_FFFE]};
    }

    operation_inputs_cross: cross cp_operation, cp_a, cp_b;

  endgroup






/////////////////
  function new(string name = "subscriber", uvm_component parent = null);

    super.new(name, parent);
    shift_rotate_cg = new();
    bit_operations_cg = new();
    logic_cg = new();

  endfunction


  function void write(bmu_sequence_item t);

   

    packet = t;//packe pointer on t . t.ap.sll read the same signal  packet.ap.sll
    sample_shift_rotate();
    sample_bit_operations();
    sample_logic();



  endfunction


  function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info(
      "COVERAGE",
      $sformatf("Shift/Rotate coverage = %0.2f%%",
                shift_rotate_cg.get_coverage()),
      UVM_LOW
    )

    `uvm_info(
      "COVERAGE",
      $sformatf("Bit operations coverage = %0.2f%%",
                bit_operations_cg.get_coverage()),
      UVM_LOW
    )


    `uvm_info(
      "COVERAGE",
      $sformatf("Logic coverage = %0.2f%%",
                logic_cg.get_coverage()),
      UVM_LOW
    )

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


 /////////////////////////////////////////////////

 function void sample_bit_operations();

    int count;
    rtl_alu_pkt_t selected_ap;

    count = 0;

    if (packet.ap.bset) begin
      count++;
      bit_operation = 2'b00;
    end

    if (packet.ap.bclr) begin
      count++;
      bit_operation = 2'b01;
    end

    if (packet.ap.binv) begin
      count++;
      bit_operation = 2'b10;
    end

    if (packet.ap.bext) begin
      count++;
      bit_operation = 2'b11;
    end


    selected_ap = '0;

    selected_ap.bset = packet.ap.bset;
    selected_ap.bclr = packet.ap.bclr;
    selected_ap.binv = packet.ap.binv;
    selected_ap.bext = packet.ap.bext;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

      bit_operations_cg.sample();

    end

  endfunction



  //////////////////////////////////

  function void sample_logic();

    int count;
    rtl_alu_pkt_t selected_ap;

    count = 0;

    if (packet.ap.land) begin
      count++;

      if (packet.ap.zbb == 0)
        logic_operation = 3'b000;
      else
        logic_operation = 3'b001;
    end

    if (packet.ap.lor) begin
      count++;

      if (packet.ap.zbb == 0)
        logic_operation = 3'b010;
      else
        logic_operation = 3'b011;
    end

    if (packet.ap.lxor) begin
      count++;

      if (packet.ap.zbb == 0)
        logic_operation = 3'b100;
      else
        logic_operation = 3'b101;
    end


    selected_ap = '0;

    selected_ap.land = packet.ap.land;
    selected_ap.lor  = packet.ap.lor;
    selected_ap.lxor = packet.ap.lxor;
    selected_ap.zbb  = packet.ap.zbb;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

      logic_cg.sample();

    end

  endfunction














 ///////////////////////////////////

endclass