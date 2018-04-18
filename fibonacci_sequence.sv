class fibonacci_sequence extends uvm_sequence #(tinyalu_transaction);
    `uvm_object_utils(fibonacci_sequence)
    
    function new(string name = "");
        super.new(name);
    endfunction
    
    task body();
        tinyalu_transaction ta_tx;
        byte    unsigned    n_minus_2 = 0;
        byte    unsigned    n_minus_1 = 1;
        ta_tx = tinyalu_transaction::type_id::create(.name("ta_tx"), .contxt(get_full_name()));
        
        start_item(ta_tx);
            ta_tx.op = 3'b111;
        finish_item(ta_tx);
        
        for(int i = 3; i <= 14; i++) begin
            start_item(ta_tx);
            ta_tx.A = n_minus_2;
            ta_tx.B = n_minus_1;
            ta_tx.op = 3'b001;
            finish_item(ta_tx);
            n_minus_2 = n_minus_1;
            n_minus_1 = ta_tx.result;
        end
        
    endtask
endclass