class fibonacci_test extends uvm_test;
    `uvm_component_utils(fibonacci_test)
    
    tinyalu_env ta_env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ta_env = tinyalu_env::type_id::create(.name("ta_env"), .parent(this));
    endfunction
    
    task run_phase(uvm_phase phase);
        fibonacci_sequence fibonacci;


        phase.raise_objection(this);
            fibonacci = fibonacci_sequence::type_id::create(.name("fibonacci"), .contxt(get_full_name()));
            assert(fibonacci.randomize());
            fibonacci.start(ta_env.ta_agent.ta_seqr);
        phase.drop_objection(this);
    endtask : run_phase

endclass