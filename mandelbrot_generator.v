module mandelbrot_generator (
  input             i_clk,
  input             i_rstn,
  input             i_de,
  input             i_hs,
  input             i_vs,
  input      [10:0]  i_x,
  input      [10:0]  i_y,
  output reg        o_de,
  output reg        o_hs,
  output reg        o_vs,
  output reg [23:0] o_bgr
);

  parameter STAGE_NUM = 64;
  
  wire        [ 7:0] w_cnt_out;
  wire signed [15:0] w_cx_in;
  wire signed [15:0] w_cy_in;
  
  assign w_cx_in = {1'b0, i_x, 4'b0000} - 9600; // 800*(3/4)*16
  assign w_cy_in = {1'b0, i_y, 4'b0000} - 4800; // 600*(1/2)*16
  
  
  wire [15:0] w_x  [STAGE_NUM-2:0];
  wire [15:0] w_y  [STAGE_NUM-2:0];
  wire [15:0] w_cx [STAGE_NUM-2:0];
  wire [15:0] w_cy [STAGE_NUM-2:0];
  wire [ 7:0] w_cnt[STAGE_NUM-2:0];
  wire        w_de [STAGE_NUM-2:0];
  wire        w_vs [STAGE_NUM-2:0];
  wire        w_hs [STAGE_NUM-2:0];
  
  wire        w_de_out;
  wire        w_vs_out;
  wire        w_hs_out;
  
  genvar i;
  for (i = 0; i < STAGE_NUM; i = i + 1) begin
  
   if (i == 0) begin
		mandelbrot m_first (
		  .i_clk  (i_clk),
		  .i_rstn (i_rstn),
          .i_de   (i_de),
          .i_vs   (i_vs),
          .i_hs   (i_hs),
		  .i_x    (0),
		  .i_y    (0),
		  .i_cx   (w_cx_in),
		  .i_cy   (w_cy_in),
		  .i_cnt  (0),
          .o_de   (w_de [i]),
          .o_vs   (w_vs [i]),
          .o_hs   (w_hs [i]),
		  .o_x    (w_x  [i]),
		  .o_y    (w_y  [i]),
		  .o_cx   (w_cx [i]),
		  .o_cy   (w_cy [i]),
		  .o_cnt  (w_cnt[i])
		);
   end else if (i == STAGE_NUM-1) begin
   /* verilator lint_off PINCONNECTEMPTY */
		mandelbrot m_last (
		  .i_clk  (i_clk),
		  .i_rstn (i_rstn),
		  .i_de   (w_de [i-1]),
          .i_vs   (w_vs [i-1]),
          .i_hs   (w_hs [i-1]),
		  .i_x    (w_x  [i-1]),
		  .i_y    (w_y  [i-1]),
		  .i_cx   (w_cx [i-1]),
		  .i_cy   (w_cy [i-1]),
		  .i_cnt  (w_cnt[i-1]),
          .o_de   (w_de_out),
          .o_vs   (w_vs_out),
          .o_hs   (w_hs_out),
		  .o_x    (),
		  .o_y    (),
		  .o_cx   (),
		  .o_cy   (),
		  .o_cnt  (w_cnt_out)
		);
	/* verilator lint_off PINCONNECTEMPTY */
   end else begin
		mandelbrot m_intermediate (
		  .i_clk  (i_clk),
		  .i_rstn (i_rstn),
		  .i_de   (w_de [i-1]),
          .i_vs   (w_vs [i-1]),
          .i_hs   (w_hs [i-1]),
		  .i_x    (w_x  [i-1]),
		  .i_y    (w_y  [i-1]),
		  .i_cx   (w_cx [i-1]),
		  .i_cy   (w_cy [i-1]),
		  .i_cnt  (w_cnt[i-1]),
		  .o_de   (w_de [i]),
          .o_vs   (w_vs [i]),
          .o_hs   (w_hs [i]),
		  .o_x    (w_x  [i]),
		  .o_y    (w_y  [i]),
		  .o_cx   (w_cx [i]),
		  .o_cy   (w_cy [i]),
		  .o_cnt  (w_cnt[i])
		);
	end
  end
  
  always @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      o_de  <= 0;
      o_vs  <= 0;
      o_hs  <= 0;
      o_bgr <= 0;
	end else begin
	    o_de <= w_de_out;
        o_vs <= w_vs_out;
        o_hs <= w_hs_out;
// 		if (w_cnt_out == 15) begin
// 			o_bgr <= 24'hffffff;
// 		end else if (w_cnt_out == 14) begin
// 			o_bgr <= 24'heeeeee;
// 		end else if (w_cnt_out == 13) begin
// 			o_bgr <= 24'hdddddd;
// 		end else if (w_cnt_out == 12) begin
// 			o_bgr <= 24'hcccccc;
// 		end else if (w_cnt_out == 11) begin
// 			o_bgr <= 24'hbbbbbb;
// 		end else if (w_cnt_out == 10) begin
// 			o_bgr <= 24'haaaaaa;
// 		end else if (w_cnt_out ==  9) begin
// 			o_bgr <= 24'h999999;
// 		end else if (w_cnt_out ==  8) begin
// 			o_bgr <= 24'h888888;
// 		end else if (w_cnt_out ==  7) begin
// 			o_bgr <= 24'h777777;
// 		end else if (w_cnt_out ==  6) begin
// 			o_bgr <= 24'h666666;
// 		end else if (w_cnt_out ==  5) begin
// 			o_bgr <= 24'h555555;
// 		end else if (w_cnt_out ==  4) begin
// 			o_bgr <= 24'h444444;
// 		end else if (w_cnt_out ==  3) begin
// 			o_bgr <= 24'h333333;
// 		end else if (w_cnt_out ==  2) begin
// 			o_bgr <= 24'h222222;
// 		end else if (w_cnt_out ==  1) begin
// 			o_bgr <= 24'h111111;
// 		end else begin
//        		o_bgr <= 24'h000000;
//      	end
		o_bgr <= {w_cnt_out << 8-$clog2(STAGE_NUM-1), 
		          w_cnt_out << 8-$clog2(STAGE_NUM-1), 
		          w_cnt_out << 8-$clog2(STAGE_NUM-1)};
    end
  end
    
endmodule