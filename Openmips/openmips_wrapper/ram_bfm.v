// *********************************************************************************
// Project Name : CK_riscv
// Author       : Core_kingdom
// Website      : https://blog.csdn.net/weixin_40377195
// Create Time  : 2022-05-25
// File Name    : ram_bfm.v
// Module Name  : ram_bfm
// Called By    :
// Abstract     :
//
// 
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2022-05-25    Macro           1.0                     Original
//  
// *********************************************************************************




module ram_bfm
    #(
        parameter   DATA_WHITH  = 32            ,
        parameter   DATA_SIZE   = 8             ,
        parameter   ADDR_WHITH  = 30            ,
        parameter   RAM_DEPTH   = 53248    ,
        parameter   DATA_BYTE = DATA_WHITH/DATA_SIZE
    )
    (
    //system signals
    input                               clk     ,
    //RAM Control signals
    input                               cs      ,
    input           [DATA_BYTE-1:0]     we      ,
    input           [ADDR_WHITH-1:0]    addr    ,
    input           [DATA_WHITH-1:0]    wdata   ,
    output  reg     [DATA_WHITH-1:0]    rdata   

);


(*ram_style = "block"*)  reg [DATA_SIZE-1:0] mem    [0:53248] ;


//=================================================================================
// Body
//=================================================================================

always @(posedge clk) begin
    if(cs && we == 0)
        //rdata <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
        rdata <= {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
    else
        rdata <= 32'd0;
end


genvar i;

generate
    for(i=0; i<DATA_BYTE; i=i+1)begin:ram_with_mask
        always @(posedge clk)begin
            if(cs && we[i])
            begin
                mem[addr+i] <= wdata[(DATA_SIZE*i)+:DATA_SIZE];
                if(addr+i==30'h0000d000)
                begin
                    $display("%c", mem[30'h0000d000]);
                end
            end
        end
    end

endgenerate

`ifndef SYNTHESIS
initial begin
    $readmemh("E:\\Xilinx11\\VLSI-session\\RTL-code\\Openmips\\openmips_wrapper\\test_program_spt.hex", mem);
end


`endif 

endmodule
