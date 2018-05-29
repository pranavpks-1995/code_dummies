package Testbench;

import StmtFSM :: *;

import Adder_IFC :: *;
import Adder     :: *;
import RefAdder  :: *;

(* synthesize *)
module mkTestbench (Empty);
   Reg #(UInt #(32)) rg_cycle <- mkReg (0);

   Adder_IFC     adder    <- mkAdder;
   RefAdder_IFC  refAdder <- mkRefAdder;

   rule rl_count_cycles;
      rg_cycle <= rg_cycle + 1;
   endrule

   function Action fa_stim (Bit #(32) x, Bit #(32) y);
      action
	 adder.in (x, y);
	 refAdder.adder.in (x, y);
	 $display ("%0d: fa_stim:  %0d  %0d", rg_cycle, x, y);
      endaction
   endfunction

   mkAutoFSM (
      seq
	 fa_stim ('h00_00_00_81, 'h00_00_00_81);    // bogus output
	 fa_stim ('h00_00_81_81, 'h00_00_81_81);
	 fa_stim ('h00_81_00_81, 'h00_81_00_81);
	 fa_stim ('h81_00_00_81, 'h81_00_00_81);
	 delay (4);
	 refAdder.dump_stats;
      endseq
      );

   rule rl_output;
      let z     = adder.out;
      let z_ref = refAdder.adder.out;
      refAdder.invoking_out;
      $display ("%0d:                            z %0d z_ref %0d    equal: ", rg_cycle, z, z_ref, fshow (z == z_ref));
   endrule

endmodule

endpackage
