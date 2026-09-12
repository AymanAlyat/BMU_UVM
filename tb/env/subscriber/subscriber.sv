class subscriber extends uvm_subscriber #(bmu_sequence_item);

  `uvm_component_utils(subscriber)
  //الاب انشئ المدخل انا ماليش علاقه

  bmu_sequence_item packet;


  //هس هو في طريقه ثانيه بس هاي انا مستوعبها اكثر الطريقه الثانيه مثلا عندك ست عمليات بدك ست بتات اول عمليه بتحط البت الاول واحد والعمليه الثانيه بتحط البت الثاني واحد وهيكا يعني بكون بت واحد من هذول السته فعال
  bit [2:0] operation;
  bit [1:0] bit_operation;
  bit [2:0] logic_operation;//AND,....



  // operation (SLT,SLTU,MIN,MAX)  relation(LESS Greatetr Equal)
  bit [1:0] compare_operation;
  bit [1:0] compare_relation;


  bit [1:0] count_operation;


  bit sext_operation;//sign extend byte or sign extend H
  bit sext_sign;// 0 or 1


  bit [1:0] arithmetic_operation;//sub,SH1ADD,SH2ADD,SH3ADD



  bit [1:0] pack_operation;
  bit [1:0] pack_a_kind;
  bit [1:0] pack_b_kind;


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



  /////////////////////////////////////



  covergroup compare_cg;

    option.per_instance = 1;

    cp_operation: coverpoint compare_operation {
      bins SLT  = {2'b00};
      bins SLTU = {2'b01};
      bins MIN  = {2'b10};
      bins MAX  = {2'b11};
    }

    cp_relation: coverpoint compare_relation {
      bins less    = {2'b00};
      bins equal   = {2'b01};
      bins greater = {2'b10};
    }

    operation_relation_cross: cross cp_operation, cp_relation;

  endgroup




  ////////////////////////////


  covergroup count_cg;

    option.per_instance = 1;

    cp_operation: coverpoint count_operation {
      bins CLZ  = {2'b00};
      bins CTZ  = {2'b01};
      bins CPOP = {2'b10};
    }

    cp_input: coverpoint $unsigned(packet.a_in) {
      bins zero   = {32'h0000_0000};
      bins ones   = {32'hFFFF_FFFF};
      bins others = {[32'h0000_0001:32'hFFFF_FFFE]};
    }

    operation_input_cross: cross cp_operation, cp_input;

  endgroup


  ///////////////////////////////

  covergroup sext_cg;

    option.per_instance = 1;

    cp_operation: coverpoint sext_operation {
      bins SEXT_B = {0};
      bins SEXT_H = {1};
    }

    cp_sign: coverpoint sext_sign {
      bins zero = {0};
      bins one  = {1};
    }

    operation_sign_cross: cross cp_operation, cp_sign;

  endgroup


  /////////////////////

  covergroup arithmetic_cg;

    option.per_instance = 1;

    cp_operation: coverpoint arithmetic_operation {
      bins SUB    = {2'b00};
      bins SH1ADD = {2'b01};
      bins SH2ADD = {2'b10};
      bins SH3ADD = {2'b11};
    }

    cp_a: coverpoint $unsigned(packet.a_in) {
      bins zero   = {32'h0000_0000};
      bins ones   = {32'hFFFF_FFFF};
      bins others = {[32'h0000_0001:32'hFFFF_FFFE]};
    }

    cp_b: coverpoint packet.b_in {
      bins zero   = {32'h0000_0000};
      bins ones   = {32'hFFFF_FFFF};
      bins others = {[32'h0000_0001:32'hFFFF_FFFE]};
    }

    operation_inputs_cross: cross cp_operation, cp_a, cp_b;

  endgroup

  ////////////////////////////////////


  covergroup pack_cg;

    option.per_instance = 1;

    cp_operation: coverpoint pack_operation {
      bins PACK  = {2'b00};
      bins PACKU = {2'b01};
      bins PACKH = {2'b10};
    }

    cp_a: coverpoint pack_a_kind {
      bins zero   = {0};
      bins ones   = {1};
      bins others = {2};
    }

    cp_b: coverpoint pack_b_kind {
      bins zero   = {0};
      bins ones   = {1};
      bins others = {2};
    }

    operation_inputs_cross: cross cp_operation, cp_a, cp_b;

  endgroup










/////////////////
  function new(string name = "subscriber", uvm_component parent = null);

    super.new(name, parent);
    shift_rotate_cg = new();
    bit_operations_cg = new();
    logic_cg = new();
    compare_cg = new();
    count_cg = new();
    sext_cg = new();
    arithmetic_cg = new();
    pack_cg = new();

  endfunction


  function void write(bmu_sequence_item t);

   

    packet = t;//packe pointer on t . t.ap.sll read the same signal  packet.ap.sll
    sample_shift_rotate();
    sample_bit_operations();
    sample_logic();
    sample_compare();
    sample_count();
    sample_sext();
    sample_arithmetic();
    sample_pack();
    



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


    `uvm_info(
      "COVERAGE",
      $sformatf("Compare coverage = %0.2f%%",
                compare_cg.get_coverage()),
      UVM_LOW
    )


    `uvm_info(
      "COVERAGE",
      $sformatf("Count coverage = %0.2f%%",
                count_cg.get_coverage()),
      UVM_LOW
    )

    `uvm_info(
      "COVERAGE",
      $sformatf("Sign extension coverage = %0.2f%%",
                sext_cg.get_coverage()),
      UVM_LOW
    )

    `uvm_info(
      "COVERAGE",
      $sformatf("Arithmetic coverage = %0.2f%%",
                arithmetic_cg.get_coverage()),
      UVM_LOW
    )

    `uvm_info(
      "COVERAGE",
      $sformatf("Pack coverage = %0.2f%%",
                pack_cg.get_coverage()),
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





  /////////////////////////



  function void sample_compare();

    int count;
    rtl_alu_pkt_t selected_ap;

    count = 0;

    if (packet.ap.slt) begin
      count++;

      if (packet.ap.unsign == 0)
        compare_operation = 2'b00;
      else
        compare_operation = 2'b01;
    end

    if (packet.ap.min) begin
      count++;
      compare_operation = 2'b10;
    end

    if (packet.ap.max) begin
      count++;
      compare_operation = 2'b11;
    end


    selected_ap = '0;

    selected_ap.slt = packet.ap.slt;
    selected_ap.min = packet.ap.min;
    selected_ap.max = packet.ap.max;
    selected_ap.sub = 1'b1;

    // Unsigned mode is allowed here only for SLT.
    //يعني هاي بتسمح نغطي اللي مع اشاره واللي بدون اشاره واذا اصلا مش مفعله هاي السجنال خلص كلشي بضل اصفار
    if (packet.ap.slt)
      selected_ap.unsign = packet.ap.unsign;//الشرط ضروري لانه اذا العمليه كانت ماكس والاشاره تاعه الساين كانت واحد هيك بنصير  نشتغل الماكس  بدون الاشاره وهيك مخالف للسبسفكيشن


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

          // SLTU: unsigned comparison.
          if (compare_operation == 2'b01) begin

            if ($unsigned(packet.a_in) < $unsigned(packet.b_in))
              compare_relation = 2'b00;
            else if (packet.a_in == packet.b_in)
              compare_relation = 2'b01;
            else
              compare_relation = 2'b10;

          end

          // SLT, MIN and MAX: signed comparison.
          //انا جربت الرقم كذا وكذا مع  الماكس مثلا
          else begin

            if ($signed(packet.a_in) < $signed(packet.b_in))
              compare_relation = 2'b00;
            else if (packet.a_in == packet.b_in)
              compare_relation = 2'b01;
            else
              compare_relation = 2'b10;

          end

          compare_cg.sample();

        end


        /*
        عني اللي افهمه انت بتجرب اوبريشن ورقمين اذا بكت الاوبريشن SLTU الارقام بتتعامل معهن كunsignedوبتشوف هل انت جربت الاكبر او الاغصر او يساوي واتذاSLTوماكس وهذول بتشوف الرقمين ك رقمين اشارات
        
        
        */

  endfunction




  ///////////////////////////////////


  function void sample_count();

    int count;
    rtl_alu_pkt_t selected_ap;

    count = 0;

    if (packet.ap.clz) begin
      count++;
      count_operation = 2'b00;
    end

    if (packet.ap.ctz) begin
      count++;
      count_operation = 2'b01;
    end

    if (packet.ap.cpop) begin
      count++;
      count_operation = 2'b10;
    end


    selected_ap = '0;

    selected_ap.clz  = packet.ap.clz;
    selected_ap.ctz  = packet.ap.ctz;
    selected_ap.cpop = packet.ap.cpop;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

      count_cg.sample();

    end

  endfunction


  ///////////////////////////////////////////


  function void sample_sext();

    int count;
    rtl_alu_pkt_t selected_ap;

    count = 0;

    if (packet.ap.siext_b) begin
      count++;
      sext_operation = 0;
      sext_sign = packet.a_in[7];
    end

    if (packet.ap.siext_h) begin
      count++;
      sext_operation = 1;
      sext_sign = packet.a_in[15];
    end


    selected_ap = '0;

    selected_ap.siext_b = packet.ap.siext_b;
    selected_ap.siext_h = packet.ap.siext_h;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

      sext_cg.sample();

    end

  endfunction


  ///////////////


  function void sample_arithmetic();

    int count;
    rtl_alu_pkt_t selected_ap;

    count = 0;

    if (packet.ap.sub) begin
      count++;
      arithmetic_operation = 2'b00;
    end

    if (packet.ap.sh1add) begin
      count++;
      arithmetic_operation = 2'b01;
    end

    if (packet.ap.sh2add) begin
      count++;
      arithmetic_operation = 2'b10;
    end

    if (packet.ap.sh3add) begin
      count++;
      arithmetic_operation = 2'b11;
    end


    selected_ap = '0;

    selected_ap.sub    = packet.ap.sub;
    selected_ap.sh1add = packet.ap.sh1add;
    selected_ap.sh2add = packet.ap.sh2add;
    selected_ap.sh3add = packet.ap.sh3add;

    // SHxADD requires zba = 1. Standalone SUB requires zba = 0.
    if (packet.ap.sh1add ||
        packet.ap.sh2add ||
        packet.ap.sh3add)
      selected_ap.zba = 1;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

      arithmetic_cg.sample();

    end

  endfunction


  ///////////////////////////////////////////////



  function void sample_pack();

    int count;
    rtl_alu_pkt_t selected_ap;

    logic [15:0] a_part;
    logic [15:0] b_part;
    logic [15:0] ones_value;

    count = 0;

    if (packet.ap.pack) begin
      count++;
      pack_operation = 2'b00;

      a_part = packet.a_in[15:0];
      b_part = packet.b_in[15:0];
      ones_value = 16'hFFFF;
    end

    if (packet.ap.packu) begin
      count++;
      pack_operation = 2'b01;

      a_part = packet.a_in[31:16];
      b_part = packet.b_in[31:16];
      ones_value = 16'hFFFF;
    end

    if (packet.ap.packh) begin
      count++;
      pack_operation = 2'b10;

      a_part = {8'b0, packet.a_in[7:0]};
      b_part = {8'b0, packet.b_in[7:0]};
      ones_value = 16'h00FF;
    end


    selected_ap = '0;

    selected_ap.pack  = packet.ap.pack;
    selected_ap.packu = packet.ap.packu;
    selected_ap.packh = packet.ap.packh;


    if (packet.rst_l == 1 &&
        packet.valid_in == 1 &&
        packet.csr_ren_in == 0 &&
        count == 1 &&
        packet.ap == selected_ap) begin

      if (a_part == 0)
        pack_a_kind = 0;
      else if (a_part == ones_value)
        pack_a_kind = 1;
      else
        pack_a_kind = 2;

      if (b_part == 0)
        pack_b_kind = 0;
      else if (b_part == ones_value)
        pack_b_kind = 1;
      else
        pack_b_kind = 2;

      pack_cg.sample();

    end

  endfunction














 ///////////////////////////////////

endclass