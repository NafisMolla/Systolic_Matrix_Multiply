`timescale 1 ps / 1 ps

module pe
#(
    parameter   D_W_ACC  = 64, //accumulator data width
    parameter   D_W      = 32  //operand data width
)
(
    input   wire                    clk,
    input   wire                    rst,
    input   wire                    init,
    input   wire    [D_W-1:0]       in_a,
    input   wire    [D_W-1:0]       in_b,
    output  reg     [D_W-1:0]       out_b,
    output  reg     [D_W-1:0]       out_a,

    input   wire    [(D_W_ACC)-1:0] in_data,
    input   wire                    in_valid,
    output  reg     [(D_W_ACC)-1:0] out_data,
    output  reg                     out_valid
);

// Insert your RTL here
reg    [D_W_ACC-1:0]   out_sum;
reg    [(D_W_ACC)-1:0] in_data_tmp;
reg                    in_valid_tmp;


 always@(posedge clk) begin	
        out_a <= in_a;
        out_b <= in_b;	
        in_data_tmp <= in_data;
        in_valid_tmp <= in_valid;

      
    if(rst) begin
        out_a <= 0;
        out_b <= 0;
        in_data_tmp <=0;
        in_valid_tmp <= 0;
        out_sum <= 0;
        out_data <= 0;
        out_valid <= 0;
    end


    else if(init) begin
        out_sum <= in_a * in_b;
        out_data <= out_sum;
        out_valid <= 1;
    end else begin
        out_sum <= out_sum + (in_a * in_b);
        out_data <= in_data_tmp;
        out_valid <= in_valid_tmp;
    end

   
end
 
endmodule
