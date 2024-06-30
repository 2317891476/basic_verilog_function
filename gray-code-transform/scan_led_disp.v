//时分复用选择数码管
module scan_led_disp
#(parameter N = 18)
(
    input clk,reset,
    input [3:0] hex3,hex2,hex1,hex0,
    input [3:0] dp_in,
    output reg [3:0] an,
    output reg [7:0] sseg
);
    reg [N-1:0] reg_n;
    reg [3:0] hex_in;
    reg dp;

    always @(posedge clk,posedge reset) begin
        if (reset) reg_n <= 0;
        else if(reg_n == {N{1'b1}})   reg_n <= 0;
        else reg_n <= reg_n + 1;
    end
    
    always @*begin
        case (reg_n[N-1:N-2])
            2'b00: begin
                an = 4'b1110;
                hex_in = hex0;
                dp = dp_in[0];
            end
            2'b01:begin
                an = 4'b1101;
                hex_in = hex1;
                dp = dp_in[1];
            end
            2'b10:begin
                an = 4'b1011;
                hex_in = hex2;
                dp = dp_in[2];
            end
            2'b11:begin
                an = 4'b0111;
                hex_in = hex3;
                dp = dp_in[3];
            end
        endcase
    end

    always @* begin
        case (hex_in)
            4'h0: sseg[6:0] =7'b000_0001;
            4'h1: sseg[6:0] =7'b100_1111;
            4'h2: sseg[6:0] =7'b001_0010;
            4'h3: sseg[6:0] =7'b000_0110;
            4'h4: sseg[6:0] =7'b100_1100;
            4'h5: sseg[6:0] =7'b010_0100;
            4'h6: sseg[6:0] =7'b010_0000;
            4'h7: sseg[6:0] =7'b000_1111;
            4'h8: sseg[6:0] =7'b000_0000;
            4'h9: sseg[6:0] =7'b000_0100;
            default :sseg[6:0] =7'b011_1000;
        endcase
        sseg[7] = dp;
    end

endmodule