BSC ?= bsc

.PHONY: help
help:
	@echo "Please specify a target:"
	@echo " mkTop.exe"
	@echo " run"
	@echo " clean"


mkTop.exe:  Test.bsv  SRAM_wrapper.bsv  Verilog_SRAM_model.v
	$(BSC) -verilog -u Test.bsv
	$(BSC) -o $@ -e mkTop *.v

.PHONY: run
run: mkTop.exe
	@./mkTop.exe | sed -e /^WARNING:/d

.PHONY: clean
clean:
	rm -r -f  *~  *.bi  *.bo  mk*.v  *.exe
