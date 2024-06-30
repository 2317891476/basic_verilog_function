module SKadder_16
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

wire gij14_12;
wire gij14_8;

wire gij13_12;
wire gij13_8;

wire gij12_8;

wire gij11_10;//gij
wire gij11_8;//gij

wire gij10_8;

wire gij9_8;//gij

wire gij7_6;//gij
wire gij7_4;//gij

wire gij5_4;//gij
wire gij3_2;//gij

wire gij2_1;
//C
wire [width:0] c;//gij
//pij
wire pij15_14;//gij
wire pij15_12;//gij
wire pij15_8;//gij
         
wire pij14_12;
wire pij14_8;
         
wire pij13_12;
wire pij13_8;
         
wire pij12_8;
         
wire pij11_10;//gij
wire pij11_8;//gij
         
wire pij10_8;
         
wire pij9_8;//gij
         
wire pij7_6;//gij
wire pij7_4;//gij
         
wire pij5_4;//gij
wire pij3_2;//gij

//cin前
for (i = 0;i<width;i = i+1) begin
    assign p[i] = a_n[i] ^b_n[i];
    assign g[i] = a_n[i] *b_n[i];
end

assign gij1_0    = g[1 ] +  p[1 ] *g[0 ];
assign gij3_2    = g[3 ] +  p[3 ] *g[2 ];
assign gij5_4    = g[5 ] +  p[5 ] *g[4 ];
assign gij7_6    = g[7 ] +  p[7 ] *g[6 ];
assign gij9_8    = g[9 ] +  p[9 ] *g[8 ];
assign gij11_10  = g[11] + p[11]*g[10];
assign gij13_12  = g[13] + p[13]*g[12];
assign gij15_14  = g[15] + p[15]*g[14];

assign pij1_0    =   p[1 ] * p[0  ];
assign pij3_2    =   p[3 ] * p[2  ];
assign pij5_4    =   p[5 ] * p[4  ];
assign pij7_6    =   p[7 ] * p[6  ];
assign pij9_8    =   p[9 ] * p[8  ];
assign pij11_10  = p[11] *p[10 ];
assign pij13_12  = p[13] *p[12 ];
assign pij15_14  = p[15] *p[14 ];

assign gij6_4    = g[6]  +  p[6]  *  gij5_4;
assign gij7_4    = gij7_6 +  pij7_6  *  gij5_4;
assign gij10_8  = g[10]  +  p[10]  *  gij9_8;
assign gij11_8  = gij11_10  +  pij11_10  *  gij9_8;
assign gij14_12= g[14]  +  p[14]  *  gij13_12;
assign gij15_12= gij15_14  +  pij15_14  *  gij13_12;

assign pij6_4    = p[6] &pij5_4;
assign pij7_4    = pij7_6 & pij5_4;
assign pij10_8  = p[10]&pij9_8;
assign pij11_8  = pij11_10&pij9_8;
assign pij14_12= p[14] &pij13_12;
assign pij15_12= pij15_14&pij13_12;

assign gij12_8  = g[12]  +  p[12]  *  gij11_8;
assign gij13_8  = gij13_12  +  pij13_12  *  gij11_8;
assign gij14_8  = gij14_12  +  pij14_12  *  gij11_8;
assign gij15_8  = gij15_12  +  pij15_12  *  gij11_8;

assign pij12_8  = p[12] &pij11_8;
assign pij13_8  =pij13_12&pij11_8;
assign pij14_8  =pij14_12&pij11_8;
assign pij15_8  =pij15_12&pij11_8;
//cin后     
assign c[0] = cin;

assign c[1] = g[0]+ p[0] * c[0];
assign c[2] =  g[1]  + p[1]  * c[1];
assign c[3] =  g[2]  + p[2]  * c[2];
assign c[4]  = gij3_2  + pij3_2  * c[2];

assign c[5] =  g[4]  + p[4 ]  * c[4];
assign c[6] = gij5_4 +pij5_4 *c[4];
assign c[7] =gij6_4 + pij6_4 *c[4];
assign c[8] =gij7_4 +pij7_4 * c[4];

assign c[9 ] =  g[8 ]  + p[8 ]  * c[8];
assign c[10] =gij9_8 +pij9_8 *c[8];
assign c[11] =gij10_8 +pij10_8 *c[8];
assign c[12] =gij11_8 +pij11_8 *c[8];
assign c[13] =gij12_8 +pij12_8 *c[8];
assign c[14] =gij13_8 +pij13_8 *c[8];
assign c[15] =gij14_8 +pij14_8 *c[8];
assign c[16] =gij15_8 +pij15_8 *c[8];

assign cout = c[16];
genvar k;  
for( k=0; k<width; k=k+1) begin
    assign s_n[k] = p[k] ^ c[k];
end        
endmodule  