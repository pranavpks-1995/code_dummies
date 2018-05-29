package RefAdder;

import Adder_IFC :: *;

// ================================================================

interface RefAdder_IFC;
   interface Adder_IFC adder;

   method Action invoking_out;
   method Action dump_stats;
endinterface

// ================================================================

(* synthesize *)
module mkRefAdder (RefAdder_IFC);
   Reg #(Bit #(32))  rg_z         <- mkReg (0);

   Reg #(Bit #(32))  rg_cycle     <- mkReg (0);
   Reg #(Bit #(32))  rg_cycle_in  <- mkReg (0);
   Reg #(Bit #(32))  rg_cycle_out <- mkReg (0);

   Reg #(Bit #(32))  rg_num_ins    <- mkReg (0);
   Reg #(Bit #(32))  rg_num_outs   <- mkReg (0);
   Reg #(Bit #(32))  rg_num_inouts <- mkReg (0);

   PulseWire pw_input  <- mkPulseWire;
   PulseWire pw_output <- mkPulseWire;

   (* fire_when_enabled, no_implicit_conditions *)
   rule rl_collect_stats;
      rg_cycle <= rg_cycle + 1;

      if (pw_input && (! pw_output)) begin
	 // $display ("%0d: mkRefAdder: input.  %0d since last output", rg_cycle, rg_cycle - rg_cycle_out);
	 rg_cycle_in <= rg_cycle;
	 rg_num_ins <= rg_num_ins + 1;
      end
      else if ((! pw_input) && pw_output) begin
	 // $display ("%0d: mkRefAdder: output. %0d since last input", rg_cycle, rg_cycle - rg_cycle_in);
	 rg_cycle_out <= rg_cycle;
	 rg_num_outs <= rg_num_outs + 1;
      end
      else if (pw_input && pw_output) begin
	 // $display ("%0d: mkRefAdder: output. %0d since last input", rg_cycle, rg_cycle - rg_cycle_in);
	 // $display ("    mkRefAdder.out: %0d SIMULTANEOUS input and output", rg_cycle);
	 rg_cycle_in <= rg_cycle;
	 rg_cycle_out <= rg_cycle;
	 rg_num_inouts <= rg_num_inouts + 1;
      end
   endrule

   // ----------------------------------------------------------------
   // Interface

   interface Adder_IFC adder;
      method Action in (Bit #(32) x, Bit #(32) y);
	 pw_input.send;
	 rg_z <= x + y;
      endmethod

      method Bit #(32) out;
	 return rg_z;
      endmethod
   endinterface

   method Action invoking_out;
      pw_output.send;
   endmethod

   method Action dump_stats;
      $display ("'in's alone %0d, 'out's alone %0d, together %0d", rg_num_ins, rg_num_outs, rg_num_inouts);
   endmethod
endmodule

// ================================================================

endpackage
