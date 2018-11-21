all:
	@verilator -Wall -trace --cc mandelbrot_tb.v --exe mandelbrot_tb.cpp
	@make -s -j -C obj_dir -f Vmandelbrot_tb.mk Vmandelbrot_tb
	obj_dir/Vmandelbrot_tb

clean:
	rm -rf obj_dir
	rm trace.vcd
