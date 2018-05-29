package Mult2Tb;

import Mult::*;
import Mult2::*;

(* synthesize *)
module mkMult2Tb (Empty);

   Reg#(Tin) x    <- mkReg(1);
   Reg#(Tin) y    <- mkReg(0);
   
   // The dut
   Mult_IFC dut <- mkMult2;
   
   // RULES ----------------
   
   rule rule_tb_1 (x < 20);
      $display ("    x = %d, y = %d", x, y);
      dut.start (x, y);
      x <= x + 1;
      y <= y + 1;
   endrule
   
   rule rule_tb_2 (x < 20);
      let z = dut.result();
      $display("    Result = %d", z);
   endrule
   
   rule stop (x >= 20);
      $finish(0);
   endrule
   
   
endmodule: mkMult2Tb

endpackage: Mult2Tb
