# GHDL Project Template

This is a simple project template for ghdl projects that use ghdl for analyses, yosys for synthesis, and netlistsvg for rtl visualization. It has a simple Makefile where you set the top level entity to be synthesized, and the top level for test benches.

## Make File Variables

### Project Related
- `SRC`: root of the folder with the vhdl project
- `TEST`: root of the folder with the test benches
- `WORK`: the name of the work directory for vhdl
- `SYNTH`: the name of the folder where the synthesized files will go
- `OUT`: general folder for outputs 
- `TOP_LEVEL`: top level entity of the vhdl project
- `TOP_TEST_LEVEL`: top level entity of the test bench

### Board Related
- `SYNTHESIZER`: the yosys synthesizer to be used for the board
- `ROUTER`: the nextpnr router to be used for the board
- `PACKER`: the packer to be used for the board
- `DEVICE`: the device name of the board
- `BOARD`: the board type (in openFPGALoader)
- `CST`: the folder that contains the .cst file for the pins to be routed in the board
- `FAMILY`: the family of the board

## Make File Options
- `make import`: includes all the .vhdl files from your src and tests folders.
- `make`: elaborates the top level entity in TOP_LEVEL.
- `make synthesis`: uses yosys to synthesize, with the output in the synth folder. It also runs netlistsvg to attempt to generate a svg from the created rtl, placed in the out folder.
- `make test`: runs the test bench in TOP_TEST_LEVEL, you can also have it output a wave file of the simulation by uncommenting a line on the Makefile, which is saved in the out folder.
- `make board_synthesis`: uses yosys to synthesize the json from `make synthesis` to the selected board, using the selected synthesizer in `SYNTHESIZER`. 
- `make board_route`: routes the synthesized rtl from `make synthesis` with the selected router in `ROUTER`. It routes based on the .cst file found inside the /cst folder for the selected board.
- `make board_pack`: packs it with your packer in `PACKER` for your board, and places the resulting .fs file in the out folder.
- `make board_upload`: uploads the routed and packed .fs from `make board_route` to the SRAM of the connected board via JTAG.
- `make clean`: clears the work, synth and out folders.

You would usually run them at the following order:
```bash
make import
make
make test # if you want to test
make synthesis # if you want to synthetize
make board_synthesis # if you want to synthesize
make board_route # route
make board_pack # pack
make board_upload # and then upload to a connected board
make clean
```
But if you just want to, for example, upload to the board, you can just run `make board_upload`, and all the intermediary steps will automatically run.
