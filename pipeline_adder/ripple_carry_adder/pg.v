module pg(
    input g1,g2,p1,p2,
    output gout,pout
);
assign gout = g2 + p2 * g1;
assign pout = p1 *p2;
endmodule
