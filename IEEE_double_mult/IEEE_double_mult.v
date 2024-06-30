//IEEE Floating Point Multiplier (Double Precision)
//Copyright (C) Jonathan P Dawson 2014
//2014-01-10
module double_multiplier(
        input_a,
        input_b,
        clk,
        rstn,
        output_z);

  input     clk;
  input     rstn;
  input     [63:0] input_a;
  input     [63:0] input_b;
  output    [63:0] output_z;

  reg       [63:0] a, b, z;
  reg       [52:0] a_m, b_m, z_m;
  reg       [12:0] a_e, b_e, z_e,z_e_reg4;
  wire  [12:0] z_e_ff1,z_e_ff2,z_e_ff3,z_e_ff4;
  reg       a_s, b_s, z_s,z_s_reg1,z_s_reg2,z_s_reg3,z_s_reg4; 
  wire   z_s_ff1,z_s_ff2,z_s_ff3,z_s_ff4;
  reg       guard, round_bit, sticky;
  reg       [105:0] product;
  wire [52:0] a_m_w,b_m_w;
  wire [12:0] a_e_w,b_e_w;


  reg special_flag;
  wire special_flag_ff1,special_flag_ff2,special_flag_ff3,special_flag_ff4;
  reg  [63:0] z_special;
  wire [63:0] z_special_ff1,z_special_ff2,z_special_ff3,z_special_ff4;
  //special_cases
  assign a_m_w = a_m;
  assign a_e_w = a_e;
  assign b_m_w = b_m;
  assign b_e_w = b_e;

  always @(*) begin
    //get_a,get_b,unpack
    a = input_a;
    b = input_b;
    a_m[51:0] = a[51 : 0];
    b_m[51:0] = b[51 : 0];
    a_e = a[62 : 52] - 1023;
    b_e = b[62 : 52] - 1023;
    a_s = a[63];
    b_s = b[63];

      //special_cases
    //if a is NaN or b is NaN return NaN 
    if ((a_e_w == 1024 && a_m_w != 0) || (b_e_w == 1024 && b_m_w != 0)) begin
      z_special[63] = 1;
      z_special[62:52] = 2047;
      z_special[51] = 1;
      z_special[50:0] = 0;
      special_flag = 1;
    //if a is inf return inf
    end else if (a_e_w == 1024) begin
      z_special[63] = a_s ^ b_s;
      z_special[62:52] = 2047;
      z_special[51:0] = 0;
      special_flag = 1;
      //if b is zero return NaN
      if (($signed(b_e_w) == -1023) && (b_m_w == 0)) begin
        z_special[63] = 1;
        z_special[62:52] = 2047;
        z_special[51] = 1;
        z_special[50:0] = 0;
        special_flag = 1;
      end
    //if b is inf return inf
    end else if (b_e_w == 1024) begin
      z_special[63] = a_s ^ b_s;
      z_special[62:52] = 2047;
      z_special[51:0] = 0;
      //if b is zero return NaN
      if (($signed(a_e_w) == -1023) && (a_m_w == 0)) begin
        z_special[63] = 1;
        z_special[62:52] = 2047;
        z_special[51] = 1;
        z_special[50:0] = 0;
        special_flag = 1;
      end
      special_flag = 1;
    //if a is zero return zero
    end else if (($signed(a_e_w) == -1023) ) begin
      z_special[63] = a_s ^ b_s;
      z_special[62:52] = 0;
      z_special[51:0] = 0;
      special_flag = 1;
    //if b is zero return zero
    end else if (($signed(b_e_w) == -1023) ) begin
      z_special[63] = a_s ^ b_s;
      z_special[62:52] = 0;
      z_special[51:0] = 0;
      special_flag = 1;
    end 
    else if ($signed(b_e_w)+$signed(a_e_w)<-1023) begin
        z_special[63] = a_s ^ b_s;
        z_special[62:52] = 0;
        z_special[51:0] = 0;
        special_flag = 1;
    end

    else begin
      //Denormalised Number
      if ($signed(a_e_w) == -1023) begin
        a_e = -1022;
      end else begin
        z_special =64'b0;
        a_m[52] = 1;
      end
      //Denormalised Number
      if ($signed(b_e_w) == -1023) begin
        b_e = -1022;
      end else begin
        z_special =64'b0;
        b_m[52] = 1;
      end
      special_flag = 0;
    end
  end
always @(*) begin
    z_s = a_s ^ b_s;
    z_e = a_e + b_e + 1;
end
  //
  //booth_mult
  //------------------------ SIGNALS ------------------------//

  wire [31:0]  z0;            // abs(z) = 1
  wire [31:0]  z1;            // abs(z) = 2, use the shifted one
  wire [31:0]  n;             // negative
  wire [31:0]  cout0;

  wire [64:0]  pp   [31:0];   // partial product, consider shift
  wire [64:0]  pp2c [31:0];   // partial product with 2's complement
  wire [127:0] fpp  [31:0],fpp1  [31:0];   // final partial product
  wire [127:0] st1  [19:0];
  wire [127:0] st2  [13:0];
  reg  [127:0] st2r [13:0];   // reg
  wire [127:0] st3  [9:0];
  wire [127:0] st4  [5:0];
  reg  [127:0] st4r [5:0];
  wire [127:0] st5  [3:0];
  reg  [127:0] st5r [3:0];    // reg
  wire [127:0] st6  [1:0];
  wire [127:0] st7  [1:0];
  wire [127:0] st8  [1:0];
  reg  [127:0] st8r  [1:0];
  wire [127:0] result;

//------------------------ PROCESS ------------------------//

//************************* Stage 0: BOOTH ENCODE *************************//
wire       [63:0]  mul_op1_i;  // multiplicand
wire       [63:0]  mul_op2_i; // multiplier
assign mul_op1_i = {11'b0,a_m};
assign mul_op2_i = {11'b0,b_m};
//  Booth Encoding & Partial Product Generation

genvar i, u;    // u for unit, b for bit
generate
    for(u=0; u<32; u=u+1) begin : for_encode
        if(u==0) begin
            booth_encoder be0(
                .y   ({mul_op2_i[1], mul_op2_i[0], 1'b0}),
                .z0  (z0[u]),
                .z1  (z1[u]),
                .neg (n[u])
            );
        end else if(u==31) begin
            booth_encoder be1(
                .y   ({1'b0, 1'b0, mul_op2_i[63]}),
                .z0  (z0[u]),
                .z1  (z1[u]),
                .neg (n[u])
            );
        end else begin
            booth_encoder be2(
                .y   ({mul_op2_i[2*u+1], mul_op2_i[2*u], mul_op2_i[2*u-1]}),
                .z0  (z0[u]),
                .z1  (z1[u]),
                .neg (n[u])
            );
        end
        for(i=0; i<64; i=i+1) begin : for_sel
            if(i==0) begin
                booth_selector bs(     // LSB
                    .z0  (z0[u]),
                    .z1  (z1[u]),
                    .x   (mul_op1_i[i]),
                    .xs  (1'b0),
                    .neg (n[u]),
                    .p   (pp[u][i])
                );
                booth_selector bs0(
                    .z0  (z0[u]),
                    .z1  (z1[u]),
                    .x   (mul_op1_i[i+1]),
                    .xs  (mul_op1_i[i]),
                    .neg (n[u]),
                    .p   (pp[u][i+1])
                );
            end else if(i==63) begin
                booth_selector u_bs(
                    .z0  (z0[u]),
                    .z1  (z1[u]),
                    .x   (1'b0),
                    .xs  (mul_op1_i[i]),
                    .neg (n[u]),
                    .p   (pp[u][i+1])
                );
            end else begin
                booth_selector u_bs(
                    .z0  (z0[u]),
                    .z1  (z1[u]),
                    .x   (mul_op1_i[i+1]),
                    .xs  (mul_op1_i[i]),
                    .neg (n[u]),
                    .p   (pp[u][i+1])
                );
            end
        end
        RCA #(1) u_rca(
            .a    (pp[u][0]),
            .b    ({n[u]}),
            .cin  (1'b0),
            .sum  (pp2c[u][0]),
            .cout (cout0[u])
        );
        SKadder_64 #(64) u_rca1(
            .a    (pp[u][64:1]),
            .b    ({64'd0}),
            .cin  (cout0[u]),
            .sum  (pp2c[u][64:1]),
            .cout ()
        );
    end
endgenerate

// perform shift
generate
    for(i=0; i<32; i=i+1) begin : for_shift
        if(i==31) begin
            assign fpp[i] = {pp2c[31][63:0], {64{1'b0}}};
        end else begin
            assign fpp[i] = {{(63-2*i){n[i]  & (z0[i]  | z1[i])}} , pp2c[i], {(2*i){1'b0}}} ;
        end
    end
endgenerate


//***************************** Stage 1 *****************************//

genvar i1;
generate
    for(i1=0; i1<10; i1=i1+1) begin : for_st1
        CSA u_csa1(
            .a    (fpp[3*i1]),
            .b    (fpp[3*i1+1]),
            .cin  (fpp[3*i1+2]),
            .sum  (st1[2*i1]),
            .cout (st1[2*i1+1])
        );
    end
endgenerate

//***************************** Stage 2 REG *****************************//

genvar i2;
generate
    for(i2=0; i2<6; i2=i2+1) begin : for_st2
        CSA u_csa2(
            .a    (st1[3*i2]),
            .b    (st1[3*i2+1]),
            .cin  (st1[3*i2+2]),
            .sum  (st2[2*i2]),
            .cout (st2[2*i2+1])
        );
    end
    CSA u_csa2(
        .a    (st1[18]),
        .b    (st1[19]),
        .cin  (fpp[30]),
        .sum  (st2[12]),
        .cout (st2[13])
    );
endgenerate


pipelineregister #(13+1+1+64+128) pipereg1 (.in({z_e,z_s,special_flag,z_special,fpp[31]}),.clk(clk),.out({z_e_ff1,z_s_ff1,special_flag_ff1,z_special_ff1,fpp1[31]}));
integer r2;
always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        for(r2=0; r2<14; r2=r2+1) begin
            st2r[r2] <= 'd0;
        end
    end else begin
        for(r2=0; r2<14; r2=r2+1) begin
            st2r[r2] <= st2[r2];
        end
    end
end

//***************************** Stage 3 *****************************//

genvar i3;
generate
    for(i3=0; i3<4; i3=i3+1) begin : for_st3
        CSA u_csa3(
            .a    (st2r[3*i3]),
            .b    (st2r[3*i3+1]),
            .cin  (st2r[3*i3+2]),
            .sum  (st3[2*i3]),
            .cout (st3[2*i3+1])
        );
    end
    CSA u_csa3(
        .a    (st2r[12]),
        .b    (st2r[13]),
        .cin  (fpp1 [31]),
        .sum  (st3 [8]),
        .cout (st3 [9])   // remain
    );
endgenerate

//***************************** Stage 4 *****************************//

genvar i4;
generate
    for(i4=0; i4<3; i4=i4+1) begin : for_st4
        CSA u_csa4(
            .a    (st3[3*i4]),
            .b    (st3[3*i4+1]),
            .cin  (st3[3*i4+2]),
            .sum  (st4[2*i4]),
            .cout (st4[2*i4+1])
        );
    end
endgenerate

pipelineregister #(13+1+1+64) pipereg2 (.in({z_e_ff1,z_s_ff1,special_flag_ff1,z_special_ff1}),.clk(clk),.out({z_e_ff2,z_s_ff2,special_flag_ff2,z_special_ff2}));
integer r4;
always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        for(r4=0; r4<6; r4=r4+1) begin
            st4r[r4] <= 'd0;
        end
    end else begin
        for(r4=0; r4<6; r4=r4+1) begin
            st4r[r4] <= st4[r4];
        end
    end
end
//***************************** Stage 5 REG *****************************//

genvar i5;
generate
    for(i5=0; i5<2; i5=i5+1) begin : for_st5
        CSA u_csa5(
            .a    (st4r[3*i5]),
            .b    (st4r[3*i5+1]),
            .cin  (st4r[3*i5+2]),
            .sum  (st5[2*i5]),
            .cout (st5[2*i5+1])
        );
    end
endgenerate

pipelineregister #(1+13+1+64) pipereg3 (.in({z_e_ff2,z_s_ff2,special_flag_ff2,z_special_ff2}),.clk(clk),.out({z_e_ff3,z_s_ff3,special_flag_ff3,z_special_ff3}));
integer r5;
always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        for(r5=0; r5<4; r5=r5+1) begin
            st5r[r5] <= 'd0;
        end
    end else begin
        for(r5=0; r5<4; r5=r5+1) begin
            st5r[r5] <= st5[r5];
        end
    end
end

//***************************** Stage 6 *****************************//

generate
    CSA u_csa6(
        .a    (st5r[0]),
        .b    (st5r[1]),
        .cin  (st5r[2]),
        .sum  (st6 [0]),
        .cout (st6 [1])
    );
endgenerate

//***************************** Stage 7 *****************************//

generate
    CSA u_csa7(
        .a    (st6 [0]),
        .b    (st6 [1]),
        .cin  (st5r[3]),
        .sum  (st7 [0]),
        .cout (st7 [1])
    );
endgenerate

//***************************** Stage 8 REG *****************************//

generate
    CSA u_csa8(
        .a    (st7[0]),
        .b    (st7[1]),
        .cin  (st3[9]),
        .sum  (st8[0]),
        .cout (st8[1])
    );
endgenerate

pipelineregister #(1+13+1+64) pipereg4 (.in({z_e_ff3,z_s_ff3,special_flag_ff3,z_special_ff3}),.clk(clk),.out({z_e_ff4,z_s_ff4,special_flag_ff4,z_special_ff4}));
integer r8;
always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        for(r8=0; r8<2; r8=r8+1) begin
            st8r[r8] <= 'd0;
        end
    end else begin
        for(r8=0; r8<2; r5=r8+1) begin
            st8r[r8] <= st8[r8];
        end
    end
end

wire cout2;
//assign result = st8[0] + st8[1];    // half adder by compiler
SKadder_64 #(64) u_rca1(
            .a    (st8r[0][63:0]),
            .b    (st8r[1][63:0]),
            .cin  (0),
            .sum  (result[63:0]),
            .cout (cout2)
        );
 SKadder_64 #(64) u_rca11(
            .a    (st8r[0][127:64]),
            .b    (st8r[1][127:64]),
            .cin  (cout2),
            .sum  (result[127:64]),
            .cout ()
        );

//normalise,pack
always @(*) begin
    product = result[105:0];
    z_m = product[105:53];
    guard = product[52];
    round_bit = product[51];
    sticky = (product[50:0] != 0);
    z_e_reg4 = (z_m[52] == 0)?(z_e_ff4-1):z_e_ff4;
    if (z_m[52] == 0) begin
        z_m = z_m << 1;
        z_m[0] = guard;
        guard = round_bit;
        round_bit = 0;
    end
    if (guard && (round_bit | sticky | z_m[0])) begin
      z_m = z_m + 1;
      if (z_m == 53'h1fffffffffffff) begin
        z_e_reg4 =z_e_reg4 + 1;
      end
    end
    z[51 : 0] = z_m[51:0];
    z[62 : 52] = z_e_reg4[11:0] + 1023;
    z[63] = z_s_ff4;
    if ($signed(z_e_reg4) == -1022 && z_m[52] == 0) begin
      z[62 : 52] = 0;
    end
    //if overflow occurs, return inf
    if ($signed(z_e_reg4) > 1023) begin
      z[51 : 0] = 0;
      z[62 : 52] = 2047;
      z[63] = z_s_ff4;
    end
end

assign output_z = special_flag_ff4?z_special_ff4:z;

endmodule

//------------------------ SUBROUTINE ------------------------//

// Booth Encoder
module booth_encoder(y,z0,z1,neg);
input [2:0] y;      // y_{i+1}, y_i, y_{i-1}
output      z0;     // abs(z) = 1
output      z1;     // abs(z) = 2, use the shifted one
output      neg;    // negative
assign z0 = y[0] ^ y[1];
assign z1 = (y[0] & y[1] & ~y[2]) | (~y[0] & ~y[1] &y[2]);
assign neg = y[2] & ~(y[1] & y[0]);
endmodule

// Booth Selector
module booth_selector(z0,z1,x,xs,neg,p);
input   z0;
input   z1;
input   x;
input   xs;     // x shifted
input   neg;
output  p;      // product
assign  p = (neg ^ ((z0 & x) | (z1 & xs)));
endmodule

// Carry Save Adder
module CSA #(
    parameter WID = 128
)(a, b, cin, sum, cout);
input  [WID-1:0] a, b, cin;
output [WID-1:0] sum, cout;
wire   [WID-1:0] c; // shift 1-bit
genvar i;
generate
    for(i=0; i<WID; i=i+1) begin : for_csa
        if(i==WID-1) begin
            FA u_fa(
                .a    (a[i]),
                .b    (b[i]),
                .cin  (cin[i]),
                .sum  (sum[i]),
                .cout ()
            );
        end else begin
            FA u_fa(
                .a    (a[i]),
                .b    (b[i]),
                .cin  (cin[i]),
                .sum  (sum[i]),
                .cout (c[i+1])
            );
        end
    end
endgenerate
assign cout = {c[WID-1:1],1'b0};
endmodule

// Ripple Carry Adder
module RCA #(
    parameter WID = 64
)(a, b, cin, sum, cout);
input  [WID-1:0] a, b;
input  cin;
output [WID-1:0] sum;
output cout;
wire   [WID-1:0] c;
genvar i;
generate
    for(i=0; i<WID; i=i+1) begin : for_rca
        if(i==0) begin
            FA u_fa(
                .a    (a[i]),
                .b    (b[i]),
                .cin  (cin),
                .sum  (sum[i]),
                .cout (c[i])
            );
        end else begin
            FA u_fa(
                .a    (a[i]),
                .b    (b[i]),
                .cin  (c[i-1]),
                .sum  (sum[i]),
                .cout (c[i])
            );
        end
    end
endgenerate
assign cout = c[WID-1];
endmodule

// Full Adder
module FA(a,b,cin,sum,cout);
input  a, b, cin;
output sum, cout;
wire   x, y, z;
xor x1(x,a,b);
xor x2(sum,x,cin);
and a1(y,a,b);
and a2(z,x,cin);
or  o1(cout,y,z);
endmodule