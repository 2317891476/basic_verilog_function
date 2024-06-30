module ksadder_16
#(parameter width = 16)
(
    input [width-1 :0] a_n,
    input [width-1:0] b_n,
    input cin,
    output [width-1:0] s_n,
    output cout
);
genvar i;
wire [width-1:0] g;
wire [width-1:0] p;

//PG参数
//Gij
wire gij15_14;//gij
wire gij15_12;//gij
wire gij15_8;//gij

wire gij14_13;
wire gij14_11;
wire gij14_7;

wire gij13_12;
wire gij13_10;
wire gij13_6;

wire gij12_11;
wire gij12_9;
wire gij12_5;

wire gij11_10;//gij
wire gij11_8;//gij
wire gij11_4;

wire gij10_9;
wire gij10_7;
wire gij10_3;

wire gij9_8;//gij
wire gij9_6;//gij
wire gij9_2;//gij

wire gij8_7;
wire gij8_5;
wire gij8_1;

wire gij7_6;//gij
wire gij7_4;//gij

wire gij6_5;//gij
wire gij6_3;//gij

wire gij5_4;//gij
wire gij5_2;//gij

wire gij4_3;//gij
wire gij4_1;//gij

wire gij3_2;//gij

wire gij2_1;
//C
wire [width:0] c;//gij
//pij
wire pij15_14;//gij
wire pij15_12;//gij
wire pij15_8;//gij
         
wire pij14_13;
wire pij14_11;
wire pij14_7;
         
wire pij13_12;
wire pij13_10;
wire pij13_6;
         
wire pij12_11;
wire pij12_9;
wire pij12_5;
         
wire pij11_10;//gij
wire pij11_8;//gij
wire pij11_4;
         
wire pij10_9;
wire pij10_7;
wire pij10_3;
         
wire pij9_8;//gij
wire pij9_6;//gij
wire pij9_2;//gij
         
wire pij8_7;
wire pij8_5;
wire pij8_1;
         
wire pij7_6;//gij
wire pij7_4;//gij
         
wire pij6_5;//gij
wire pij6_3;//gij
         
wire pij5_4;//gij
wire pij5_2;//gij
         
wire pij4_3;//gij
wire pij4_1;//gij
         
wire pij3_2;//gij
         
wire pij2_1;
//cin前
for (i = 0;i<width;i = i+1) begin
    assign p[i] = a_n[i] ^b_n[i];
    assign g[i] = a_n[i] *b_n[i];
end

assign gij1_0    = g[1 ] +  p[1 ] *g[0 ];
assign gij2_1    = g[2 ] +  p[2 ] *g[1 ];
assign gij3_2    = g[3 ] +  p[3 ] *g[2 ];
assign gij4_3    = g[4 ] +  p[4 ] *g[3 ];
assign gij5_4    = g[5 ] +  p[5 ] *g[4 ];
assign gij6_5    = g[6 ] +  p[6 ] *g[5 ];
assign gij7_6    = g[7 ] +  p[7 ] *g[6 ];
assign gij8_7    = g[8 ] +  p[8 ] *g[7 ];
assign gij9_8    = g[9 ] +  p[9 ] *g[8 ];
assign gij10_9   =  g[10] + p[10]*g[9 ];
assign gij11_10  = g[11] + p[11]*g[10];
assign gij12_11  = g[12] + p[12]*g[11];
assign gij13_12  = g[13] + p[13]*g[12];
assign gij14_13  = g[14] + p[14]*g[13];
assign gij15_14  = g[15] + p[15]*g[14];

assign pij1_0    =  p[1  ] *p[0 ];
assign pij2_1    =  p[2  ] *p[1 ];
assign pij3_2    =  p[3  ] *p[2 ];
assign pij4_3    =  p[4  ] *p[3 ];
assign pij5_4    =  p[5  ] *p[4 ];
assign pij6_5    =  p[6  ] *p[5 ];
assign pij7_6    =  p[7  ] *p[6 ];
assign pij8_7    =  p[8  ] *p[7 ];
assign pij9_8    =  p[9  ] *p[8 ];
assign pij10_9   = p[10 ] *p[9 ];
assign pij11_10  =p[11 ] *p[10 ];
assign pij12_11  =p[12 ] *p[11 ];
assign pij13_12  =p[13 ] *p[12 ];
assign pij14_13  =p[14 ] *p[13 ];
assign pij15_14  =p[15 ] *p[14 ];

assign gij4_1  = gij4_3  + pij4_3   * gij2_1 ;
assign gij5_2  = gij5_4  + pij5_4   * gij3_2 ;
assign gij6_3  = gij6_5  + pij6_5   * gij4_3 ;
assign gij7_4  = gij7_6  + pij7_6   * gij5_4 ;
assign gij8_5  = gij8_7  + pij8_7   * gij6_5 ;
assign gij9_6  = gij9_8  + pij9_8   * gij7_6 ;
assign gij10_7  = gij10_9  + pij10_9   * gij8_7 ;
assign gij11_8  = gij11_10 + pij11_10  * gij9_8 ;
assign gij12_9  = gij12_11 + pij12_11  * gij10_9 ;
assign gij13_10 = gij13_12 + pij13_12  * gij11_10;
assign gij14_11 = gij14_13 + pij14_13  * gij12_11;
assign gij15_12 = gij15_14 + pij15_14  * gij13_12;

assign pij4_1   = pij4_3    * pij2_1  ;
assign pij5_2   = pij5_4    * pij3_2  ;
assign pij6_3   = pij6_5    * pij4_3  ;
assign pij7_4   = pij7_6    * pij5_4  ;
assign pij8_5   = pij8_7    * pij6_5  ;
assign pij9_6   = pij9_8    * pij7_6  ;
assign pij10_7   = pij10_9    * pij8_7  ;
assign pij11_8   = pij11_10   * pij9_8  ;
assign pij12_9   = pij12_11   * pij10_9  ;
assign pij13_10  = pij13_12   * pij11_10 ;
assign pij14_11  = pij14_13   * pij12_11 ;
assign pij15_12  = pij15_14   * pij13_12 ;

assign gij8_1 = gij8_5  +pij8_5  * gij4_1;
assign gij9_2 = gij9_6  +pij9_6  * gij5_2;
assign gij10_3 = gij10_7  +pij10_7  * gij6_3;
assign gij11_4 = gij11_8  +pij11_8  * gij7_4;
assign gij12_5 = gij12_9  +pij12_9  * gij8_5;
assign gij13_6 = gij13_10 +pij13_10 * gij9_6;
assign gij14_7 = gij14_11 +pij14_11 * gij10_7;
assign gij15_8 = gij15_12 +pij15_12 * gij11_8;

assign pij8_1 = pij8_5  * pij4_1;
assign pij9_2 = pij9_6  * pij5_2;
assign pij10_3 = pij10_7  * pij6_3;
assign pij11_4 = pij11_8  * pij7_4;
assign pij12_5 = pij12_9  * pij8_5;
assign pij13_6 = pij13_10 * pij9_6;
assign pij14_7 = pij14_11 * pij10_7;
assign pij15_8 = pij15_12 * pij11_8;

//cin后     
assign c[0] = cin;

assign c[1] = g[0]+ p[0] * c[0];
assign c[2] =  g[1]+ p[1] * c[1];
assign c[3] =  gij2_1  + pij2_1  * c[1];
assign c[4]  = gij3_2  + pij3_2  * c[2];

assign c[5] =gij4_1 +pij4_1 *c[1];
assign c[6] =gij5_2 +pij5_2 *c[2];
assign c[7] =gij6_3 +pij6_3 *c[3];
assign c[8] =gij7_4 +pij7_4 *c[4];

assign c[9 ] = gij8_1 +pij8_1* c[1];
assign c[10] = gij9_2 + pij9_2 * c[2];
assign c[11] =gij10_3 +pij10_3 *c[3];
assign c[12] =gij11_4 +pij11_4 *c[4];
assign c[13] =gij12_5 +pij12_5 *c[5];
assign c[14] =gij13_6 +pij13_6 *c[6];
assign c[15] =gij14_7 +pij14_7 *c[7];
assign c[16] =gij15_8 +pij15_8 *c[8];

assign cout = c[16];
genvar k;  
for( k=0; k<width; k=k+1) begin
    assign s_n[k] = p[k] ^ c[k];
end        
endmodule  