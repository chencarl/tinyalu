class tinyalu_monitor_before extends uvm_monitor;
    `uvm_component_utils(tinyalu_monitor_before)
    
    uvm_analysis_port #(tinyalu_transaction) mon_ap_before;
    
    virtual tinyalu_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        void'(uvm_resource_db#(virtual tinyalu_if)::read_by_name(.scope("ifs"), .name("tinyalu_if"), .val(vif)));
        mon_ap_before = new(.name("mon_ap_before"), .parent(this));
    endfunction
    
    task run_phase(uvm_phase phase);
        tinyalu_transaction ta_tx;
        ta_tx = tinyalu_transaction::type_id::create(.name("ta_tx"), .contxt(get_full_name()));
        
        forever begin
            @(posedge vif.clk) begin
            if(vif.done == 1) begin
                ta_tx.result = vif.result;
                // ta_tx.done = vif.done;
                mon_ap_before.write(ta_tx);
            end
            end
        end
    endtask
endclass

class tinyalu_monitor_after extends uvm_monitor;
    `uvm_component_utils(tinyalu_monitor_after);
    
    uvm_analysis_port#(tinyalu_transaction) mon_ap_after;
    
    virtual tinyalu_if vif;
    
    tinyalu_transaction ta_tx;
    tinyalu_transaction ta_tx_cg;
    
    // typedef enum op_t{3'b001 = 3};
    
    covergroup op_cov;

    coverpoint ta_tx_cg.op {
         bins single_cycle[] = {[3'b001 : 3'b011], 3'b111,3'b000};
         bins multi_cycle = {3'b100};

         bins opn_rst[] = ([3'b001:3'b100] => 3'b111);
         bins rst_opn[] = (3'b111 => [3'b001:3'b100]);

         bins sngl_mul[] = ([3'b001:3'b011],3'b000 => 3'b100);
         bins mul_sngl[] = (3'b100 => [3'b001:3'b011], 3'b000);

         bins twoops[] = ([3'b001:3'b100] [* 2]);
         bins manymult = (3'b100 [* 3:5]);

         bins rstmulrst   = (3'b111 => 3'b100 [=  2] => 3'b111);
         bins rstmulrstim = (3'b111 => 3'b100 [-> 2] => 3'b111);

      }

    endgroup

    covergroup zeros_or_ones_on_ops;

      all_ops : coverpoint ta_tx_cg.op {
         ignore_bins null_ops = {3'b111, 3'b000};}

      a_leg: coverpoint ta_tx_cg.A {
         bins zeros = {'h00};
         bins others= {['h01:'hFE]};
         bins ones  = {'hFF};
      }

      b_leg: coverpoint ta_tx_cg.B {
         bins zeros = {'h00};
         bins others= {['h01:'hFE]};
         bins ones  = {'hFF};
      }

      op_00_FF:  cross a_leg, b_leg, all_ops {
         bins add_00 = binsof (all_ops) intersect {3'b001} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins add_FF = binsof (all_ops) intersect {3'b001} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins and_00 = binsof (all_ops) intersect {3'b010} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins and_FF = binsof (all_ops) intersect {3'b010} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins xor_00 = binsof (all_ops) intersect {3'b011} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins xor_FF = binsof (all_ops) intersect {3'b011} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_00 = binsof (all_ops) intersect {3'b100} &&
                       (binsof (a_leg.zeros) || binsof (b_leg.zeros));

         bins mul_FF = binsof (all_ops) intersect {3'b100} &&
                       (binsof (a_leg.ones) || binsof (b_leg.ones));

         bins mul_max = binsof (all_ops) intersect {3'b100} &&
                        (binsof (a_leg.ones) && binsof (b_leg.ones));

         ignore_bins others_only =
                                  binsof(a_leg.others) && binsof(b_leg.others);

      }

endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        op_cov = new;
        zeros_or_ones_on_ops = new;
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_resource_db#(virtual tinyalu_if)::read_by_name(.scope("ifs"), .name("tinyalu_if"), .val(vif)));
        mon_ap_after = new(.name("mon_ap_after"), .parent(this));
    endfunction
    
    task run_phase(uvm_phase phase);
        ta_tx = tinyalu_transaction::type_id::create(.name("ta_tx"), .contxt(get_full_name()));
        forever begin
            @(posedge vif.clk) begin
            if(!vif.reset_n) begin
                ta_tx.A = 0;
                ta_tx.B = 0;
            end 
            else if(vif.start) begin
                ta_tx.op = vif.op;
                ta_tx.A = vif.A;
                ta_tx.B = vif.B;
                predictor();
                ta_tx_cg = ta_tx;
                
                op_cov.sample();
                zeros_or_ones_on_ops.sample();
                mon_ap_after.write(ta_tx);
            end
            end
        end
    endtask
    
    virtual function void predictor();
        case (ta_tx.op)
            3'b001 : ta_tx.result = ta_tx.A + ta_tx.B;
            3'b010 : ta_tx.result = ta_tx.A & ta_tx.B;
            3'b011 : ta_tx.result = ta_tx.A ^ ta_tx.B;
            3'b100 : ta_tx.result = ta_tx.A * ta_tx.B;
            //default : ta_tx.result = 16'b0;
        endcase
        
    endfunction
endclass