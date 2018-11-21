module mandelbrot_tb (
  input             i_clk,
  input             i_rstn,
  output            o_de,
  output            o_hs,
  output            o_vs,
  output     [23:0] o_bgr
);


  wire w_de, w_hs, w_vs;
  wire [10:0] w_x;
  wire [10:0] w_y;
  
  timing_generator #(
    .HAC (800),
    .HFP ( 40),
    .HSP (128),
    .HBP ( 88),
    .VAC (600),
    .VFP (  1),
    .VSP (  4),
    .VBP ( 23)
  )
  tg_0 (
    .i_clk  (i_clk),
    .i_rstn (i_rstn),
    .o_de   (w_de),
    .o_hs   (w_hs),
    .o_vs   (w_vs),
    .o_x    (w_x),
    .o_y    (w_y)
  );
  
	mandelbrot_generator #(
	  .STAGE_NUM (32)
	) 
	mg (
	  .i_clk  (i_clk),
	  .i_rstn (i_rstn),
	  .i_de   (w_de),
	  .i_hs   (w_hs),
	  .i_vs   (w_vs),
	  .i_x    (w_x),
	  .i_y    (w_y),
	  .o_de   (o_de),
	  .o_hs   (o_hs),
	  .o_vs   (o_vs),
	  .o_bgr  (o_bgr)
	);

    
endmodule