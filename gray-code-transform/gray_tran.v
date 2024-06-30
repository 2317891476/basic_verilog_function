//格雷码转换
module gray_tran #(
    parameter N =4
) (
    input [N-1:0] cin,
    output reg [N-1:0] cout
);
    integer i;
    always @* begin
        for (i = 0;i < N-1;i = i+1) begin
            cout[i] = (cin[i] ^ cin[i+1]);
        end
        cout[N-1] = cin[N-1];
    end
    
endmodule