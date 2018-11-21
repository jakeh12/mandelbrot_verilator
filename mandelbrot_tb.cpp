#include "Vmandelbrot_tb.h"
#include "verilated.h"
#include <time.h>
#include <stdio.h>


int main(int argc, char **argv)
{
	// pass command line args into verilator
	Verilated::commandArgs(argc, argv);
	
	// create instance of the translated verilog module
	Vmandelbrot_tb* m = new Vmandelbrot_tb;
	
	// prepare image for pixel output
	FILE *fp = fopen("output.ppm", "w");
	fprintf(fp, "P6\n%d %d\n255\n", 800, 600);
	unsigned char color[3];
	
	printf("simulation has started...\n");
	clock_t begin = clock();
	
	// generate reset
	int i;
	for (i = 0; i < 3; i++)
	{
		if (i == 0)
		{
			m->i_rstn = 0;
		}
		else if (i == 2)
		{
			m->i_rstn = 1;
	    }
	    
		m->i_clk = 1;
		m->eval();

		m->i_clk = 0;
		m->eval();
	}
	
	while (1)
	{
		// posedge clock
		m->i_clk = 1;
		m->eval();
		
		if (m->o_de)
		{
				color[0] = m->o_bgr       & 0xff % 256;
				color[1] = m->o_bgr >> 8  & 0xff % 256;
				color[2] = m->o_bgr >> 16 & 0xff % 256;			
				fwrite(color, 1, 3, fp);
		}
		
		// frame finished
		if (m->o_vs)
		{
			break;
		}
		
		// negedge clock
		m->i_clk = 0;
		m->eval();
		
		// increment simulation time
		i++;
	}
	
	clock_t end = clock();
	double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
	
	printf("simulation finished in %f seconds!\n", time_spent);
	delete m;
	return 0;
}

