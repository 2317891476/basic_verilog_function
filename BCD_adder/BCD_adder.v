module BCD_adder(
    input trig,
    input [11:0] cin,
    output reg [11:0] cout
);
always @(*) begin
    if (!trig)
        cout = cin;
    else begin
        if (cin[3:0]!=9)
            cout = cin +1;
        else begin
            cout = cin;
            cout[3:0] = 4'b0;
            if (cin[7:4] !=9 )
                cout[7:4] = cin[7:4] +1;
            else begin
                cout [7:4] = 4'b0;
                if (cin[11:8] != 9)
                    cout [11:8] = cin[11:8] +1;
                else cout = 12'hfff;
            end
        end
    end
end
endmodule