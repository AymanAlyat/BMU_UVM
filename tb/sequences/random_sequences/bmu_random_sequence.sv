class bmu_random_sequence extends uvm_sequence #(bmu_sequence_item);//not posted in github yet

  `uvm_object_utils(bmu_random_sequence)

  bmu_sequence_item req;
  int operation;

  function new(string name = "bmu_random_sequence");
    super.new(name);
  endfunction


  task body();

    req = bmu_sequence_item::type_id::create("req");

    repeat (500) begin

      start_item(req);

      if (!req.randomize())
        `uvm_fatal("RAND_ERROR", "Randomization failed")

      // Default values
      req.ap            = '0;
      req.rst_l         = 1'b1;
      req.scan_mode     = 1'b0;
      req.valid_in      = 1'b1;
      req.csr_ren_in    = 1'b0;
      //req.csr_rddata_in = 32'b0; error انت هون بتصفره بعد الراندوم

      //no assumptions inside random test. ==> Specification يعني هون حطيت فقط الموضوح بال

      operation = $urandom_range(0, 38);

      case (operation)

        // AND
        0: begin
          req.ap.land = 1'b1;
          req.ap.zbb  = 1'b0;
        end



        // ANDN
        1: begin
          req.ap.land = 1'b1;
          req.ap.zbb  = 1'b1;
        end

        // OR

        2: begin
          req.ap.lor = 1'b1;
          req.ap.zbb = 1'b0;
        end

        // ORN
        3: begin
          req.ap.lor = 1'b1;
          req.ap.zbb = 1'b1;
        end

        // XOR
        4: begin
          req.ap.lxor = 1'b1;
          req.ap.zbb  = 1'b0;
        end

        // XNOR
        5: begin

          req.ap.lxor = 1'b1;
          req.ap.zbb  = 1'b1;
        end



        // SLL
        6: begin
          req.ap.sll = 1'b1;
        end

        // SRL
        7: begin
          req.ap.srl = 1'b1;
        end



        // SRA
        8: begin
          req.ap.sra = 1'b1;
        end

        // ROL
        9: begin
          req.ap.rol = 1'b1;
        end

        // ROR
        10: begin
          req.ap.ror = 1'b1;
        end

        // BSET
        11: begin

          req.ap.bset = 1'b1;
        end

        // BCLR

        12: begin
          req.ap.bclr = 1'b1;
        end



        // BINV
        13: begin
          req.ap.binv = 1'b1;
        end

        // BEXT
        14: begin
          req.ap.bext = 1'b1;

        end

        // SH1ADD
        15: begin

          req.ap.sh1add = 1'b1;
          req.ap.zba    = 1'b1;
        end

        // SH2ADD
        16: begin
          req.ap.sh2add = 1'b1;
          req.ap.zba    = 1'b1;
        end

        // SH3ADD
        17: begin
          req.ap.sh3add = 1'b1;
          req.ap.zba    = 1'b1;
        end

        // SUB
        18: begin
          req.ap.sub = 1'b1;
          req.ap.zba = 1'b0;
        end

        // SLT signed
        19: begin
          req.ap.slt    = 1'b1;
          req.ap.sub    = 1'b1;
          req.ap.unsign = 1'b0;
        end

        // SLT unsigned
        20: begin
          req.ap.slt    = 1'b1;
          req.ap.sub    = 1'b1;
          req.ap.unsign = 1'b1;
        end

        // CLZ

        21: begin
          req.ap.clz = 1'b1;
        end


        // CTZ
        22: begin
          req.ap.ctz = 1'b1;
        end

        // CPOP
        23: begin
          req.ap.cpop = 1'b1;
        end

        // SEXT.B
        24: begin
          req.ap.siext_b = 1'b1;
        end


        // SEXT.H
        25: begin
          req.ap.siext_h = 1'b1;
        end

        // MIN
        26: begin
          req.ap.min = 1'b1;
          req.ap.sub = 1'b1;
        end


        // MAX
        27: begin
          req.ap.max = 1'b1;
          req.ap.sub = 1'b1;
        end



        // PACK
        28: begin
          req.ap.pack = 1'b1;
        end

        // GREV
        29: begin
          req.ap.grev   = 1'b1;
          req.b_in[4:0] = 5'b11000;
        end

        // CSR Write
        30: begin
          req.ap.csr_write = 1'b1;
          req.ap.csr_imm   = $urandom_range(0, 1);
        end


        // CSR Read
        31: begin
          req.csr_ren_in = 1'b1;
        end

        32: begin
          req.ap.packh =1'b1;
          
        end
          //error=1
        33: begin
         req.ap.sub = 1'b1;
         req.ap.zba = 1'b1;
        end

         //error=1
        34: begin
         req.csr_ren_in = 1'b1;
         req.ap.bset   = 1'b1;
        end


        35: begin
         req.ap.lor  = 1'b1;
         req.ap.land = 1'b1;
        end

        36: begin
          req.ap.sh2add = 1'b1;
          req.ap.zba    = 1'b0;
        end

         //hold wiht error
        37: begin
          req.valid_in   = 1'b0;
          req.csr_ren_in = 1'b1;
          req.ap.bset    = 1'b1;
        end

        //hold withou error
        38: begin
          req.valid_in = 1'b0;
          req.ap.lor   = 1'b1;
        end



      endcase



      finish_item(req);

    end

  endtask

endclass