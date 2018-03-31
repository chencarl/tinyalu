`include "uvm_macros.svh"
package tinyalu_pkg;
    import uvm_pkg::*;
    /*
    typedef enum bit [2:0] {
            no_op   = 3'b000,
            add_op  = 3'b001,
            and_op  = 3'b010,
            xor_op  = 3'b011,
            mul_op  = 3'b100,
            rst_op  = 3'b111
            } operation_t;
     */       
    `include "tinyalu_transaction.sv"
    typedef uvm_sequencer#(tinyalu_transaction) tinyalu_sequencer;
	`include "tinyalu_sequence.sv"
    `include "fibonacci_sequence.sv"
    
	`include "tinyalu_monitor.sv"
	`include "tinyalu_driver.sv"
	`include "tinyalu_agent.sv"
	`include "tinyalu_scoreboard.sv"
	//`include "tinyalu_config.sv"
	`include "tinyalu_env.sv"
	`include "tinyalu_test.sv"
    `include "fibonacci_test.sv"
    

   
endpackage