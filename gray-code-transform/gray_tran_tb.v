module gray_tran_tb();
parameter N = 4;
reg [N-1:0] cin;
wire [N-1:0] cout;

gray_tran  #(N) 
uut(.cin(cin),.cout(cout));

initial begin
    cin = 0;
end

always begin
    cin <= cin+1;
    #10 
    if (cin == {N{1'b1}})
        cin <= 0;
end

endmodule