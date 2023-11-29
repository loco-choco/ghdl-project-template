SRC = ./src
TEST = ./tests
WORK = work
SYNTH = ./synth
OUT = ./out
TOP_LEVEL = adder
TOP_TEST_LEVEL = adder_tb

all:
	ghdl -m --workdir=$(WORK) $(TOP_LEVEL)
import:
	ghdl -i --workdir=$(WORK) $(SRC)/*.vhdl $(TEST)/*.vhdl
synthesis:
	cd ./$(WORK); yosys -m ghdl -p 'ghdl $(TOP_LEVEL); prep -top $(TOP_LEVEL); write_json .$(SYNTH)/$(TOP_LEVEL).json';
	netlistsvg $(SYNTH)/$(TOP_LEVEL).json -o $(OUT)/$(TOP_LEVEL).svg
clean:
	ghdl --remove --workdir=$(WORK)
	rm $(SYNTH)/*
	rm $(OUT)/*
test:
	ghdl -r --workdir=$(WORK) $(TOP_TEST_LEVEL)
	#for tests with waveforms outputs
	#ghdl -r --workdir=$(WORK) $(TOP_TEST_LEVEL) --wave=$(OUT)/wave.ghw

