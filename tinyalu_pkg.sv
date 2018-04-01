`include "uvm_macros.svh"
package tinyalu_pkg;
    import uvm_pkg::*;
	
    `include "tinyalu_transaction.sv"
    typedef uvm_sequencer#(tinyalu_transaction) tinyalu_sequencer;
	`include "tinyalu_sequence.sv"
    `include "fibonacci_sequence.sv"
    `include "tinyalu_monitor.sv"
    `include "tinyalu_driver.sv"
	`include "tinyalu_agent.sv"
	`include "tinyalu_scoreboard.sv"
	
	`include "tinyalu_env.sv"
	`include "tinyalu_test.sv"
    `include "fibonacci_test.sv"
    

   
endpackage
