class tinyalu_test extends uvm_test;
    `uvm_component_utils(tinyalu_test)
    
    tinyalu_env ta_env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ta_env = tinyalu_env::type_id::create(.name("ta_env"), .parent(this));
    endfunction
    
    task run_phase(uvm_phase phase);
        tinyalu_sequence    ta_seq;
        
        phase.raise_objection(this);
            ta_seq = tinyalu_sequence::type_id::create(.name("ta_seq"), .contxt(get_full_name()));
            assert(ta_seq.randomize());
            ta_seq.start(ta_env.ta_agent.ta_seqr);
        phase.drop_objection(this);
    endtask
endclass