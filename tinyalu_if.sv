interface tinyalu_if;
    import tinyalu_pkg::*;
    
    logic   [7:0]    A;
    logic   [7:0]    B;
    bit             clk;
    logic   [2:0]   op;
 
    bit             reset_n;
    bit             start;
    wire             done; 
    wire   [15:0]  result;
    // /*
    initial begin
          clk = 1'b1;
          reset_n = 1'b0;
          @(negedge clk);
          @(negedge clk);
          reset_n = 1'b1;
    end
    // */
 
    initial begin
    
    forever begin
    /*
         case (op) // handle the start signal
           3'b000: begin //no_op
              start = 1'b1;  
              @(posedge clk);
              #1;
              start = 1'b0;
           end
           3'b101: begin //no_op
              start = 1'b1;
              @(posedge clk);
              #1;
              start = 1'b0;
           end
           3'b110: begin //rst
              @(posedge clk);
              reset_n = 1'b0;
              start = 1'b0;
              @(posedge clk);
              #1;
              reset_n = 1'b1;
           end
           3'b111: begin //rst
              @(posedge clk);
              reset_n = 1'b0;
              start = 1'b0;
              @(posedge clk);
              #1;
              reset_n = 1'b1;
           end
           default: begin 
                start = 1'b1;
                do
                    @(negedge clk); 
                while(done == 0);
                start = 1'b0;             
           end
         endcase // case (op_set)
     */
     if(op == 3'b111) begin
        @(posedge clk);
        reset_n = 1'b0;
        start = 1'b0;
        @(posedge clk);
        #1;
        reset_n = 1'b1;
    end else begin
        @(negedge clk);
        start = 1'b1;
        if(op == 3'b000) begin
            @(posedge clk);
            #1;
            start = 1'b0;
        end else begin
            do
                @(negedge clk);
            while(done == 0);
            start = 1'b0;
        end
    end
     
     end
    end      
        
     //Clock generation
     always #10 clk = ~clk;
endinterface