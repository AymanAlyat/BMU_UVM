class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)


  uvm_analysis_imp #(bmu_sequence_item, scoreboard) analysis_export;//in env will connect this port with monitor



  bmu_sequence_item packet_queue[$];
  logic [31:0] last_expected_result = 32'b0;

  /*
  prev_item inputs ──► Expected
                         │
                         ▼
                    Compare
                         ▲
                         │
 current item.result_ff ──┘

  
  
  
  */

  


  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);


    analysis_export = new("analysis_export", this);

  endfunction



  function void write(bmu_sequence_item item);

    packet_queue.push_back(item);


  endfunction



  task run_phase(uvm_phase phase);

   bmu_sequence_item packet;
   bmu_sequence_item prev_packet;

   logic [31:0] expected_result;
   logic        expected_error;

   bit have_prev = 0;

   forever begin

    wait(packet_queue.size() > 0);

    packet = packet_queue.pop_front();

    if (!have_prev) begin

      prev_packet = bmu_sequence_item::type_id::create("prev_packet");
      prev_packet.copy(packet);

      have_prev = 1;

      end

    else begin

     calculate_expected(prev_packet,expected_result, expected_error);


     if ( (packet.result_ff === expected_result) && (packet.error     === expected_error) ) begin

       `uvm_info(
       "BMU_PASS",
       $sformatf(
       "PASS: Actual(result=%h error=%0b) Expected(result=%h error=%0b)",
        packet.result_ff,
        packet.error,
        expected_result,
        expected_error
        ),
        UVM_LOW
         )

      end
      else begin

       `uvm_error(
       "BMU_FAIL",
       $sformatf(
       {"FAIL: Actual(result=%h error=%0b) ",
       "Expected(result=%h error=%0b)"},
        packet.result_ff,
        packet.error,
        expected_result,
        expected_error
       )
        )

     end

     prev_packet.copy(packet);

    end


   end

  endtask


  function void calculate_expected(input  bmu_sequence_item packet,output logic [31:0] expected_result, output logic expected_error);

    expected_result = 32'b0;
    expected_error  = 1'b0;


    if (!packet.rst_l) begin

      expected_result = 32'b0;
      expected_error  = 1'b0;
      last_expected_result = 32'b0;

     end


    else if (!packet.valid_in) begin

     expected_result = last_expected_result;


     end


    else begin
      ////////////////////////////////////////////////////////
      

      

        
        if (packet.ap.land) begin

          if (!packet.ap.zbb)//AND
             expected_result = packet.a_in & packet.b_in;

          else
              expected_result = packet.a_in & ~packet.b_in;//ANDN

        end

        //////////////////////////////
        else if (packet.ap.lor) begin

          if (!packet.ap.zbb)
            expected_result = packet.a_in | packet.b_in;
          else
            expected_result = packet.a_in | ~packet.b_in;

        end
        ////////////////////////////////
        else if (packet.ap.lxor) begin

         if (!packet.ap.zbb)
           expected_result = packet.a_in ^ packet.b_in;      // XOR
         else
           expected_result = packet.a_in ^ ~packet.b_in;     // XNOR ==>can you prove it .

        end

        ///////////

        else if (packet.ap.sll) begin

         expected_result = packet.a_in << packet.b_in[4:0];

        end

        else if (packet.ap.srl) begin

          expected_result = packet.a_in >> packet.b_in[4:0];

        end
       ///////////////////////////////////////////

        else if (packet.ap.sra) begin

          expected_result = packet.a_in >>> packet.b_in[4:0];

        end


        ////////////////////////////////

        else if (packet.ap.rol) begin

          expected_result =(packet.a_in << packet.b_in[4:0]) | (packet.a_in >> (32 - packet.b_in[4:0]));

        end



        ///////////////////////
        else if (packet.ap.ror) begin

          expected_result = (packet.a_in >> packet.b_in[4:0]) |(packet.a_in << (32 - packet.b_in[4:0]));

        end


        ////////////////////
        else if (packet.ap.bset) begin

          expected_result = packet.a_in | (32'b1 << packet.b_in[4:0]);

        end

        //////////////////////////
        else if (packet.ap.bclr) begin

          expected_result = packet.a_in & ~(32'b1 << packet.b_in[4:0]);

        end

        else if (packet.ap.binv) begin

          expected_result =packet.a_in ^ (32'b1 << packet.b_in[4:0]);

        end

        else if (packet.ap.bext) begin

          expected_result = packet.a_in[packet.b_in[4:0]];

        end

        else if (packet.ap.bext) begin

          expected_result = packet.a_in[packet.b_in[4:0]];

        end

        else if (packet.ap.sh1add) begin

         expected_result = (packet.a_in << 1) + packet.b_in;

        end

        else if (packet.ap.sh2add) begin

          expected_result = (packet.a_in << 2) + packet.b_in;

        end

        else if (packet.ap.sh3add) begin

          expected_result = (packet.a_in << 3) + packet.b_in;

        end


        //else if (packet.ap.sub ) wrong
        else if (packet.ap.sub && !packet.ap.slt) begin//ممكن الاشارتين تكونن واحد ويلقط اشاره الطرح عشان هيك حطيت انه الاشاره الثانيه لازم تكون صفر

          expected_result = packet.a_in - packet.b_in;

        end


        else if (packet.ap.slt && packet.ap.sub) begin

          if (packet.ap.unsign)

             expected_result = ($unsigned(packet.a_in) < packet.b_in);

          else

             expected_result = (packet.a_in < $signed(packet.b_in));

        end

        else if (packet.ap.clz) begin

         expected_result = 32;

         for (int i = 31; i >= 0; i--) begin
           if (packet.a_in[i]) begin
             expected_result = 31 - i;
             break;
            end
          end

end







        





        /////////////////////////////

         last_expected_result = expected_result;

      end










      ////////////////////////////////////////////////////////

     // هون لاحقاً:
     // valid_in
     // operations
     // error conditions

     

  endfunction







endclass


/*


Monitor :will send item on port are connected in env
   |
   | analysis_port.write(item)
   v
Scoreboard analysis_export هاذ رح يستقبل الايتم لانه عملتلو ربط مع البوورت تاع المونيتور
   |
   v
scoreboard.write(item) بس يستقبل تنفذ هاي الفنكشن

*/



//1
/*
 prev_item = bmu_sequence_item::type_id::create("prev_item");
    prev_item.copy(item);//1

prev_item.copy(item); It creates a completely independent copy. بتعمل نسخه مستقله تماما



الاثنين ماسكين نفس الاوبجكت
prev_item = item;It make a shared copy.ما بتعمل نسخه مستقله بل بصرن الثنين ياشرن على نفس النسخه
prev_item ──┐
            ├──> نفس الـobject
item ───────┘


new :The object that we will create will not have the values ​​of the object that was created, but will be filled with default values.

prev_item = new("prev_item");هاذ قيمه مش قيم الايتم اللي انت بدك اياه هاذ رح يتعبى بالديفولت



*/