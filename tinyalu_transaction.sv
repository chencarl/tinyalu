class tinyalu_transaction extends uvm_sequence_item;
    rand    logic [7:0]   A;
    rand    logic [7:0]   B;
    rand    logic [2:0]  op;
    
    logic             done;
    logic     [15:0]  result;
    
    constraint op_con {op dist {3'b000 := 1, 3'b001 := 5, 3'b010:=5, 3'b011:=5,3'b100:=5, 3'b111:=1};}

   constraint data { A dist {8'h00:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
                     B dist {8'h00:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};} 
    
    function new(string name = "");
        super.new(name);
    endfunction

    
    `uvm_object_utils_begin(tinyalu_transaction)
    `uvm_field_int(A, UVM_ALL_ON)
    `uvm_field_int(B, UVM_ALL_ON)
    `uvm_field_int(op, UVM_ALL_ON)
    `uvm_field_int(done, UVM_ALL_ON)
    `uvm_field_int(result, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

 