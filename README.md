# GHDL Project Template

This is a simple project template for ghdl projects that use ghdl for analyses, yosys for synthesis, and netlistsvg for rtl visualization. It has a simple Makefile where you set the top level entity to be synthesized, and the top level for test benches.

## Make File Options
- `make import`: includes all the .vhdl files from your src and tests folders.
- `make`: elaborates the top level entity in TOP_LEVEL.
- `make synthesis`: uses yosys to synthesize, with the output in the synth folder. It also runs netlistsvg to attempt to generate a svg from the created rtl, placed in the out folder.
- `make test`: runs the test bench in TOP_TEST_LEVEL, you can also have it output a wave file of the simulation by uncommenting a line on the Makefile, which is saved in the out folder.
- `make clean`: clears the work, synth and out folders.

You usually would run them at the following order:
```bash
make import
make
make test # if you want to test
make synthesis # if you want to synthetize
make clean
```
