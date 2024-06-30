module reg_n 
    # (parameter N= 64)
    (input wire clk,
    input wire load,reset,
    input [N-1:0] in_data,
    output reg [N-1:0] out_data
    );
    
    always @(posedge clk, posedge reset) begin
        if (reset)
            out_data <= 0;
        else if (load == 1)
            out_data <= in_data;
    end
endmodule