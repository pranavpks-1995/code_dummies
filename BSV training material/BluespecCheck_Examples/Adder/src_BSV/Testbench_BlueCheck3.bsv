// This testbench checks functionality:
//    - compare DUT adder with reference adder (which has different latencies)
//    - pipeline pressure ("parallel" in and out)

package Testbench;

import FIFOF        :: *;
import SpecialFIFOs :: *;
import StmtFSM      :: *;
import Clocks       :: *;
import BlueCheck    :: *;

import Adder_IFC    :: *;
import Adder        :: *;
import RefAdder     :: *;

module [BlueCheck] checkAdderWithReset #(Reset r) (Empty);
   /* Specification instance */
   RefAdder_IFC refAdder <- mkRefAdder (reset_by r);

   /* Implementation instance */
   Adder_IFC imp  <- mkAdder (reset_by r);

   function ActionValue #(Bit #(32)) av_imp (Bit #(32) x, Bit #(32) y);
      actionvalue
	 imp.in (x, y);
	 return imp.out;
      endactionvalue
   endfunction

   function ActionValue #(Bit #(32)) av_ref (Bit #(32) x, Bit #(32) y);
      actionvalue
	 refAdder.adder.in (x, y);
	 refAdder.invoking_out;
	 return refAdder.adder.out;
      endactionvalue
   endfunction

   equiv ("equiv_in_out",  av_imp, av_ref);

   post ("refAdder stats", refAdder.dump_stats);
endmodule

// Iterative deepening version (with extra options)
(* synthesize *)
module [Module] mkTestbench ();
   Clock clk <- exposeCurrentClock;
   MakeResetIfc r <- mkReset(0, True, clk);

   // Customise default BlueCheck parameters
   BlueCheck_Params params = bcParamsID(r);
   params.useIterativeDeepening = True;
   params.showTime         = True;
   params.interactive      = False;
   params.numIterations    = 100;
   params.useShrinking     = True;

   function incr(x)        = x+1;
   params.id.initialDepth  = 20;
   params.id.incDepth      = incr;
   params.id.testsPerDepth = 10;

  // Generate checker
  Stmt s <- mkModelChecker (checkAdderWithReset (r.new_rst), params);
  mkAutoFSM(s);
endmodule

// ================================================================

endpackage
