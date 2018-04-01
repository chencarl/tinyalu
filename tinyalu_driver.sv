class tinyalu_driver extends uvm_driver#(tinyalu_transaction);
    `uvm_component_utils(tinyalu_driver)
    
    protected virtual tinyalu_if    vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_resource_db#(virtual tinyalu_if)::read_by_name(.scope("ifs"), .name("tinyalu_if"), .val(vif)));
    endfunction
    
    task run_phase(uvm_phase phase);
        drive();//根据op上的指令，将A，B上的值送入到DUT中，等待start信号开始
    endtask
    
    virtual task drive();
        tinyalu_transaction ta_tx;
        forever  begin
            @(posedge vif.clk)begin
                if(vif.start)begin
                    seq_item_port.get_next_item(ta_tx);
                    vif.op = ta_tx.op;
                    vif.A = ta_tx.A;
                    vif.B = ta_tx.B;
                    seq_item_port.item_done();
                end
            end
        end
    endtask
endclass
