
if [file exists "work"] {vdel -all}
vlib work

vcom -f dut.f

vlog -f tb.f
vopt top -o top_optimized  +acc +cover=sbfec+tinyalu(rtl).

vsim top_optimized -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=tinyalu_test

set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -line 49 -code s
coverage exclude -src tinyalu_dut/single_cycle_add_and_xor.vhd -scope /top/dut/add_and_xor -line 49 -code b
coverage attribute -name TESTNAME -value tinyalu_test
coverage save tinyalu_test.ucdb

vcover merge  tinyalu.ucdb tinyalu_test.ucdb  
vcover report tinyalu.ucdb -cvg -details

quit

