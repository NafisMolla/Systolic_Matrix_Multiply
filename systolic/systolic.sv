`timescale 1 ps / 1 ps
`default_nettype none

module systolic
#
(
    parameter   D_W  = 8, //operand data width
    parameter   D_W_ACC = 16, //accumulator data width
    parameter   N1   = 4,
    parameter   N2   = 4,
    parameter   M    = 8
)
(
    input   wire                                        clk,
    input   wire                                        rst,
    input   wire                                        enable_row_count_A,
    output  wire    [$clog2(M)-1:0]                     pixel_cntr_A,
    output  wire    [($clog2(M/N1)?$clog2(M/N1):1)-1:0] slice_cntr_A,
    output  wire    [($clog2(M/N2)?$clog2(M/N2):1)-1:0] pixel_cntr_B,
    output  wire    [$clog2(M)-1:0]                     slice_cntr_B,
    output  wire    [$clog2((M*M)/N1)-1:0]              rd_addr_A,
    output  wire    [$clog2((M*M)/N2)-1:0]              rd_addr_B,
    input   wire    [D_W-1:0]                           A [N1-1:0], //m0
    input   wire    [D_W-1:0]                           B [N2-1:0], //m1
    output  wire    [D_W_ACC-1:0]                       D [N1-1:0], //m2
    output  wire    [N1-1:0]                             valid_D
);

wire    [D_W-1:0]         out_a      [N1-1:0][N2-1:0];
wire    [D_W-1:0]         out_b      [N1-1:0][N2-1:0];
wire    [D_W-1:0]         in_a       [N1-1:0][N2-1:0];
wire    [D_W-1:0]         in_b       [N1-1:0][N2-1:0];
wire    [N2-1:0]          in_valid   [N1-1:0];
wire    [N2-1:0]          out_valid  [N1-1:0];
wire    [(D_W_ACC)-1:0]   in_data    [N1-1:0][N2-1:0];
wire    [(D_W_ACC)-1:0]   out_data   [N1-1:0][N2-1:0];

wire    [N2-1:0] init_pe  [N1-1:0];

control #
(
  .N1       (N1),
  .N2       (N2),
  .M        (M)
)
control_inst
(

  .clk                  (clk),
  .rst                  (rst),
  .enable_row_count     (enable_row_count_A),

  .pixel_cntr_B         (pixel_cntr_B),
  .slice_cntr_B         (slice_cntr_B),

  .pixel_cntr_A         (pixel_cntr_A),
  .slice_cntr_A         (slice_cntr_A),

  .rd_addr_A            (rd_addr_A),
  .rd_addr_B            (rd_addr_B)
);

reg init_pe_tmp = 0; 
always @(posedge clk ) begin
  if(pixel_cntr_A == (M-1))begin
      init_pe_tmp <= init_pe_tmp << 1;
      init_pe_tmp <= 1;
  end

  else begin
    init_pe_tmp <= init_pe_tmp << 1;
  end


end

genvar x;
genvar y;
generate
for (x=0;x<N1;x=x+1) begin
  for(y=0;y<N2;y=y+1)begin

    //edge cases 
    if(x == 0) begin
      assign in_b[x][y] = B[y];
    end
    else begin
      assign in_b[x][y] = out_b[x-1][y];
    end

    if(y == 0) begin
      assign in_a[x][y] = A[x];
      assign in_valid[x][y] = 0;
      assign in_data[x][y] = 0;
    end
    else begin
      assign in_valid[x][y] = out_valid[x][y-1];
      assign in_data[x][y] = out_data[x][y-1];
      assign in_a[x][y] = out_a[x][y-1];
    end




    pipe #(
      .D_W(1),
      .pipes(x+y+1)
    )
    pipe_inst (
      .clk(clk),
      .rst(0),
      .in_p(init_pe_tmp),
      .out_p(init_pe[x][y])
    );

    //generate all the PEs
    pe #(.D_W_ACC(D_W_ACC), .D_W(D_W))
      pe_inst(
        .clk(clk),
        .rst(rst),
        .init(init_pe[x][y]),
        .in_a(in_a[x][y]),
        .in_b(in_b[x][y]),
        .in_data(in_data[x][y]),
        .in_valid(in_valid[x][y]),
        .out_valid(out_valid[x][y]),
        .out_data(out_data[x][y]),
        .out_a(out_a[x][y]),
        .out_b(out_b[x][y])
    );
  end
  //add those 2 lines
  assign D[x] = out_data[x][N2-1];
  assign valid_D[x] = out_valid[x][N2-1];
end
endgenerate



endmodule
