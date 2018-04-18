`include "tinyalu_pkg.sv"
`include "uvm_macros.svh"

module top;
    import uvm_pkg::*;
    import  tinyalu_pkg::*;

    tinyalu_if vif();

    tinyalu dut(vif.A,
             vif.B,
             vif.clk,
             vif.op,
             vif.reset_n,
             vif.start,
             vif.done,
             vif.result);
    initial begin
      uvm_resource_db#(virtual tinyalu_if)::set(.scope("ifs"), .name("tinyalu_if"), .val(vif));
      // uvm_config_db#(virtual tinyalu_if)::set(.cntxt(this), .inst_name(""), .field_name("tinyalu_if"), .value(vif));
      run_test();
    end
endmodule