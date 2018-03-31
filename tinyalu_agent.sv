class tinyalu_agent extends uvm_agent;
    `uvm_component_utils(tinyalu_agent)
    
    uvm_analysis_port #(tinyalu_transaction) agent_ap_before;
    uvm_analysis_port #(tinyalu_transaction) agent_ap_after;
    
    tinyalu_sequencer   ta_seqr;
    tinyalu_driver      ta_drv;
    tinyalu_monitor_before  ta_mon_before;
    tinyalu_monitor_after   ta_mon_after;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_ap_before = new(.name("agent_ap_before"), .parent(this));
        agent_ap_after = new(.name("agent_ap_after"), .parent(this));
        ta_seqr = tinyalu_sequencer::type_id::create(.name("ta_seqr"), .parent(this));
        ta_drv = tinyalu_driver::type_id::create(.name("ta_drv"), .parent(this));
        ta_mon_before = tinyalu_monitor_before::type_id::create(.name("ta_mon_before"), .parent(this));
        ta_mon_after = tinyalu_monitor_after::type_id::create(.name("ta_mon_after"), .parent(this));
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        ta_drv.seq_item_port.connect(ta_seqr.seq_item_export);
        ta_mon_before.mon_ap_before.connect(agent_ap_before);
        ta_mon_after.mon_ap_after.connect(agent_ap_after);
    endfunction
endclass