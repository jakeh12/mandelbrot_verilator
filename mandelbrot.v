module mandelbrot (
  input                i_clk,
  input                i_rstn,
  input                i_de,
  input                i_vs,
  input                i_hs,
  input signed  [15:0] i_x,
  input signed  [15:0] i_y,
  input signed  [15:0] i_cx,
  input signed  [15:0] i_cy,
  input         [7:0]  i_cnt,
  output               o_de,
  output               o_vs,
  output               o_hs,
  output signed [15:0] o_x,
  output signed [15:0] o_y,
  output signed [15:0] o_cx,
  output signed [15:0] o_cy,
  output        [7:0]  o_cnt
);
   
   // stage 0
   /* verilator lint_off UNUSED */
   reg signed [31:0] r_xx_0;
   reg signed [31:0] r_yy_0;
   reg signed [31:0] r_xy_0;
   /* verilator lint_off UNUSED */
   reg signed [15:0] r_cx_0;
   reg signed [15:0] r_cy_0;
   reg        [7:0]  r_cnt_0;
   reg               r_de_0;
   reg               r_vs_0;
   reg               r_hs_0;

   // stage 1
   reg signed [15:0] r_xx_m_yy_1;
   reg signed [15:0] r_2xy_1;
   reg signed [15:0] r_xx_p_yy_1;
   reg signed [15:0] r_cx_1;
   reg signed [15:0] r_cy_1;
   reg        [7:0]  r_cnt_1;
   reg               r_ovrf_1;
   reg               r_de_1;
   reg               r_vs_1;
   reg               r_hs_1;
   
   
   // stage 2
   reg signed [15:0] r_xx_m_yy_p_cx_2;
   reg signed [15:0] r_2xy_p_cy_2;
   reg signed [15:0] r_cx_2;
   reg signed [15:0] r_cy_2;
   reg        [7:0]  r_cnt_2;
   reg               r_de_2;
   reg               r_vs_2;
   reg               r_hs_2;
   
   always @(posedge i_clk, negedge i_rstn) begin
      if (!i_rstn) begin
	 // reset stuff
	 r_xx_0           <= 0;
	 r_yy_0           <= 0;
	 r_xy_0           <= 0;
	 r_cx_0           <= 0;
	 r_cy_0           <= 0;
	 r_cnt_0          <= 0;
	 r_de_0           <= 0;
	 r_vs_0           <= 0;
	 r_hs_0           <= 0;
	 r_xx_m_yy_1      <= 0;
	 r_2xy_1          <= 0;
	 r_xx_p_yy_1      <= 0;
	 r_cx_1           <= 0;
	 r_cy_1           <= 0;
	 r_cnt_1          <= 0;
	 r_de_1           <= 0;
	 r_vs_1           <= 0;
	 r_hs_1           <= 0;
	 r_xx_m_yy_p_cx_2 <= 0;
	 r_2xy_p_cy_2     <= 0;
	 r_cnt_2          <= 0;
	 r_de_2           <= 0;
	 r_vs_2           <= 0;
	 r_hs_2           <= 0;
      end else begin
	 // stage 0
	 r_xx_0  <= i_x * i_x;
	 r_yy_0  <= i_y * i_y;
	 r_xy_0  <= i_x * i_y;
	 r_cx_0  <= i_cx;
	 r_cy_0  <= i_cy;
	 r_cnt_0 <= i_cnt;
	 r_de_0  <= i_de;
	 r_vs_0  <= i_vs;
	 r_hs_0  <= i_hs;
	 	 
	 // stage 1
	 r_xx_m_yy_1 <= r_xx_0[27:12] - r_yy_0[27:12];
	 r_2xy_1     <= r_xy_0[27:12] << 1;
	 r_xx_p_yy_1 <= r_xx_0[27:12] + r_yy_0[27:12];
	 r_cx_1      <= r_cx_0;
	 r_cy_1      <= r_cy_0;
	 r_cnt_1     <= r_cnt_0;
	 r_de_1      <= r_de_0;
	 r_vs_1      <= r_vs_0;
	 r_hs_1      <= r_hs_0;
	 r_ovrf_1 <= r_xx_0[31:28] == 4'b0000 || 
	             r_yy_0[31:28] == 4'b0000 || 
	             r_xy_0[31:28] == 4'b0000 ? 0 : 1;
	
	 // stage 2
	 r_xx_m_yy_p_cx_2 <= r_xx_m_yy_1 + r_cx_1;
     r_2xy_p_cy_2     <= r_2xy_1 + r_cy_1;
	 r_cx_2           <= r_cx_1;
	 r_cy_2           <= r_cy_1;
	 r_de_2           <= r_de_1;
	 r_vs_2           <= r_vs_1;
	 r_hs_2           <= r_hs_1;
	 
	 if (r_xx_p_yy_1 <= 16'sb0100_0000_0000_0000 && !r_ovrf_1) begin
	    r_cnt_2       <= r_cnt_1 + 1;
	 end else begin
	    r_cnt_2       <= r_cnt_1;
	 end
      end
   end // always @ (posedge i_clk, negedge i_rstn)

   assign o_x   = r_xx_m_yy_p_cx_2;
   assign o_y   = r_2xy_p_cy_2;
   assign o_cnt = r_cnt_2;
   assign o_cx  = r_cx_2;
   assign o_cy  = r_cy_2;
   assign o_de  = r_de_2;
   assign o_vs  = r_vs_2;
   assign o_hs  = r_hs_2;
   
endmodule // mandelbrot