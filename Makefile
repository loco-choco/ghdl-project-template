SRC = ./src
TEST = ./tests
WORK = work
SYNTH = ./synth
OUT = ./out
TOP_LEVEL = adder
TOP_TEST_LEVEL = adder_tb

SYNTHESIZER = synth_gowin
ROUTER = nextpnr-gowin
PACKER = gowin_pack
DEVICE = GW2A-LV18PG256C8/I7
BOARD = tangprimer20k
CST = ./cst
FAMILY = GW2A-18

all: import
	ghdl -m --workdir=$(WORK) $(TOP_LEVEL)
import:
	ghdl -i --workdir=$(WORK) $(SRC)/*.vhdl $(TEST)/*.vhdl
synthesis: all
	cd ./$(WORK); yosys -m ghdl -p 'ghdl $(TOP_LEVEL); prep -top $(TOP_LEVEL); write_json .$(SYNTH)/$(TOP_LEVEL).json'
	netlistsvg $(SYNTH)/$(TOP_LEVEL).json -o $(OUT)/$(TOP_LEVEL).svg
clean:
	ghdl --remove --workdir=$(WORK)
	rm $(SYNTH)/*
	rm $(OUT)/*
test: all import
	ghdl -r --workdir=$(WORK) $(TOP_TEST_LEVEL)
	#for tests with waveforms outputs
	#ghdl -r --workdir=$(WORK) $(TOP_TEST_LEVEL) --wave=$(OUT)/wave.ghw
board_synthesis: synthesis
	yosys -p 'read_json $(SYNTH)/$(TOP_LEVEL).json; $(SYNTHESIZER) -json $(SYNTH)/$(TOP_LEVEL)_$(SYNTHESIZER).json'
board_route: board_synthesis
	$(ROUTER) --json $(SYNTH)/$(TOP_LEVEL)_$(SYNTHESIZER).json \
		--write $(SYNTH)/pnr$(TOP_LEVEL)_$(SYNTHESIZER).json \
		--device $(DEVICE) \
		--cst $(CST)/$(BOARD).cst \
		--family $(FAMILY)
board_pack: board_route
	$(PACKER) -d $(FAMILY) -o $(OUT)/$(BOARD)_$(FAMILY)_pack.fs \
		$(SYNTH)/pnr$(TOP_LEVEL)_$(SYNTHESIZER).json
board_upload: board_pack
	openFPGALoader -b $(BOARD) $(OUT)/$(BOARD)_$(FAMILY)_pack.fs
