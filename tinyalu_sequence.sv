class tinyalu_sequence extends uvm_sequence#(tinyalu_transaction);
    `uvm_object_utils(tinyalu_sequence)
    
    function new(string name = "");
        super.new(name);
    endfunction
    
    task body();
        tinyalu_transaction    ta_tx;
        repeat(15)  begin
            `uvm_do(ta_tx)
        end
    endtask
endclass

