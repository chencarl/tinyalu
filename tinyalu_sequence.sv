class tinyalu_sequence extends uvm_sequence#(tinyalu_transaction);
    `uvm_object_utils(tinyalu_sequence)
    
    function new(string name = "");
        super.new(name);
    endfunction
    
    task body();
        tinyalu_transaction    ta_tx;
        repeat(15)  begin
            ta_tx = tinyalu_transaction::type_id::create(.name("ta_tx"), .contxt(get_full_name()));
            
            start_item(ta_tx);
            assert(ta_tx.randomize());
            finish_item(ta_tx);
        end
    endtask
endclass

