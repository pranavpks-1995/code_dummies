To build, in src_BSV, create two symbolic links:

  Adder.bsv
    pointing at one of:
        Adder_BSV.bsv
	Adder_Verilog_Wrapper.bsv

  Testbench.bsv
    pointing at one of:
        Testbench_adhoc.bsv
	Testbench_Bluecheck1.bsv
	Testbench_Bluecheck2.bsv
	Testbench_Bluecheck3.bsv

Then,
    make compile link simulate    for Bluesim
    make rtl vlink vsim           for Verilog sim

Note: if Adder.bsv points at Adder_Verilog_Wrapper.bsv,
    you can't use Bluesim, just Verilog sim
