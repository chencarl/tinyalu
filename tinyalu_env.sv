class tinyalu_env extends uvm_env;
    `uvm_component_utils(tinyalu_env)
    
    tinyalu_agent   ta_agent;
    tinyalu_scoreboard  ta_sb;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ta_agent = tinyalu_agent::type_id::create(.name("ta_agent"), .parent(this));
        ta_sb = tinyalu_scoreboard::type_id::create(.name("ta_sb"), .parent(this));
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ta_agent.agent_ap_before.connect(ta_sb.sb_export_before);
        ta_agent.agent_ap_after.connect(ta_sb.sb_export_after);
    endfunction
endclass