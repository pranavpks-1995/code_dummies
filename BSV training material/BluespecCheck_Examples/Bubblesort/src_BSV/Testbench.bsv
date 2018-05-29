package Testbench;

import FIFOF	:: *;
import GetPut	:: *;
import StmtFSM  :: *;
import Vector   :: *;
import Clocks   :: *;
import BlueCheck:: *;
import DUTTop   :: *;

module [Specification] mkBBSortTBWRst#(Reset r) ();
   // DUT instance
   DUT_IFC dut <- mkDUTTop (reset_by r);
   Integer n = valueOf (N_t);

   function Bool fn_isOrdered (Vector #(N_t, MyT) x);
      Bool isOrdered = True;
      for (Integer i=0; i < n-1; i=i+1)
         isOrdered = isOrdered && (x[i] <= x[i+1]);
      return (isOrdered);
   endfunction : fn_isOrdered

   // This function allows us to make assertions in the properties
   Ensure ensure <- getEnsure;
   Reg #(MyT) inCtr <- mkReg (0);

   // This sequence checks that for a random sequence driven into the sorter, we get back an ordered sequence
   function Stmt listIsSorted (Vector #(N_t, MyT) x);
      return (
      seq
         for (inCtr <= 0; inCtr < fromInteger (n); inCtr <= inCtr + 1) seq
            dut.put (x [inCtr]);
         endseq

         action
            let y <- dut.get;
            ensure (fn_isOrdered (y));
         endaction
      endseq);
   endfunction

   prop("List Is Ordered", listIsSorted);

endmodule

// This is an example module when you want to modify the parameters controlling BlueCheck execution
module [Module] blueCheckWParamsModID# (BlueCheck#(Empty) bc, MakeResetIfc rst) (Stmt);
	let params = bcParamsID(rst);
	params.interactive = False;
	params.numIterations = 2;
	Stmt s <- mkModelChecker(bc, params);
	return s;
endmodule

// Non-synthesizable version (with ID) which writes State output directly to a file
(* synthesize *)
module [Module] mkTestbenchNoSynth ();
	Clock clk <- exposeCurrentClock;
	MakeResetIfc r <- mkReset (0, True, clk);
	Stmt s <- blueCheckWParamsModID (mkBBSortTBWRst (r.new_rst), r);
	mkAutoFSM(s);
endmodule

// Iterative deepening version that constructs a synthesisable checker with a get interface
module [Module] blueCheckIDSynthGP #(BlueCheck#(Empty) bc, MakeResetIfc rst) (Get#(Bit#(8)));
	FIFOF#(Bit#(8)) out <- mkSizedFIFOF (4);
	let params           = bcParamsID(rst);
	params.interactive   = False;
	params.outputFIFO    = tagged Valid out;
	params.useShrinking  = False;
	params.allowViewing  = True;
	params.numIterations = 2;
	Stmt s              <- mkModelChecker(bc, params);
	mkAutoFSM (s);
	return (toGet (out));
endmodule

(* synthesize *)
module [Module] mkTestbenchSynth (Get#(Bit#(8)));
	Clock clk <- exposeCurrentClock;
	MakeResetIfc r <- mkReset (0, True, clk);
	let _ifc <- blueCheckIDSynthGP (mkBBSortTBWRst (r.new_rst), r);
	return (_ifc);
endmodule

// Wrapper around synthesizable BlueCheck checker to redirect output to a file
(* synthesize *)
module [Module] mkTestbench (Empty);
	let		synthTB			<- mkTestbenchSynth;
	Reg #(File)	seedFile		<- mkReg (InvalidFile);
	Reg #(Bool)	rg_fileInit		<- mkReg (False);
	let filename = "State.txt";

       rule rl_fileInit (!rg_fileInit);
		$write("\nSaving state to '%s'", filename);

		// Open file for writing
		let file <- $fopen(filename, "w");

		// Check result
		if (file == InvalidFile) begin
			$display("Can't open file '%s'", filename);
			$finish(0);
		end
		seedFile <= file;
		rg_fileInit <= True;
       endrule : rl_fileInit

       rule rl_copyFIFOtoFile (rg_fileInit);
		let char <- synthTB.get;
		$fwrite (seedFile, "%c", char);
       endrule

endmodule
endpackage
