interface Bit_Manipulation_intf(input logic clk);

  import rtl_pkg::*;

  logic rst_l;

  logic scan_mode;

  logic  valid_in;
  rtl_alu_pkt_t ap;//packet struct contaion control signals.

  logic csr_ren_in;
  logic [31:0]  csr_rddata_in;

  logic signed [31:0] a_in;
  logic  [31:0] b_in;


  logic [31:0] result_ff;

  logic error;



clocking cb_drv @(negedge clk);

  output rst_l;
  output scan_mode;
  output valid_in;
  output ap;
  output csr_ren_in;
  output csr_rddata_in;
  output a_in;
  output b_in;

endclocking



clocking cb_mon @(posedge clk);

  input rst_l;
  input scan_mode;
  input valid_in;
  input ap;
  input csr_ren_in;
  input csr_rddata_in;
  input a_in;
  input b_in;

  input result_ff;
  input error;

endclocking

// واحد وبدي كل كومبوننت يشوف الجزء اللي بخصه interface عنا 
modport drv (clocking cb_drv);
modport mon (clocking cb_mon);


endinterface