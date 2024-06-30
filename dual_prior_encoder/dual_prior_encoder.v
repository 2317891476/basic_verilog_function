//双优先级译码器
module dual_prior_encoder#(
    parameter N=16
)(
    input [16-1:0] cin,
    output  [4-1:0] h_flag,
    output  [4-1:0] l_flag
);
    reg [3:0] count;//记录遍历完成一共有多少个为1的位
    integer i;
    reg [3:0] h_flag_temp,l_flag_temp;

    always @*begin
        count = 0;
        for(i = 15; i >=0 ;i = i-1) begin
            if(cin[i] == 1 && (count ==0 )) begin
                h_flag_temp = i;
                count = count+1;
            end
            else if (cin[i] == 1 && (count ==1 )) begin
                l_flag_temp = i;
                count = count +1;
            end
            else if (cin[i] == 1) 
                count = count +1;
        end
    end

    assign h_flag = (count>=2)? h_flag_temp:4'b1111;
    assign l_flag = (count>=2)? l_flag_temp:4'b1111;
endmodule