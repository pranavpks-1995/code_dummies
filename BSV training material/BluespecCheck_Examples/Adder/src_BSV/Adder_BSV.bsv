package Adder;

// ================================================================
// This is an adder for unsigned 32-bit values, which only uses 8-bit
// adds.

// ================================================================

import Adder_IFC :: *;

(* synthesize *)
module mkAdder (Adder_IFC);
   Reg #(Bool)       rg_ready  <- mkReg (True);
   Reg #(Bit #(32))  rg_x     <- mkRegU;
   Reg #(Bit #(32))  rg_y     <- mkRegU;
   Reg #(Bit #(32))  rg_z     <- mkReg (0);
   Reg #(Bit #(1))   rg_carry <- mkRegU;
   Reg #(Bit #(2))   rg_step  <- mkRegU;

   function Action fa_add_step (Bit #(32) x, Bit #(32) y, Bit #(32) z, Bit #(1) carry, Bit #(2) step);
      action
	 Bit #(9) x9 = {1'b0, x [7:0]};
	 Bit #(9) y9 = {1'b0, y [7:0]};
	 Bit #(9) z9 = x9 + y9 + {8'b0, carry};

	 rg_carry <= z9 [8];
	 case (step)
	    0: rg_z <= { 0, z9 };
	    1: rg_z <= { 0, z9, rg_z [7:0] };
	    2: rg_z <= { 0, z9, rg_z [15:0] };
	    3: rg_z <= { z9 [7:0], rg_z [23:0] };
	 endcase
	 rg_step <= step + 1;

	 rg_ready <= ((x [31:8] | y [31:8]) == 24'b0);
	 rg_x <= { 8'b0, x [31:8] };
	 rg_y <= { 8'b0, y [31:8] };
      endaction
   endfunction

   rule rl_step (! rg_ready);
      fa_add_step (rg_x, rg_y, rg_z, rg_carry, rg_step);
   endrule

   // ----------------------------------------------------------------
   // INTERFACE

   method Action in (Bit #(32) x, Bit #(32) y) if (rg_ready);
      fa_add_step (x, y, 0, 0, 0);
   endmethod

   method Bit #(32) out () if (rg_ready);
      return rg_z;
   endmethod
endmodule

endpackage
