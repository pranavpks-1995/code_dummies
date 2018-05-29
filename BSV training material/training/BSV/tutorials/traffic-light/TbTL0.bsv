package TbTL0;

import TL0::*;

(* synthesize *)
module mkTest();
   let dut <- sysTL;
   
   Reg#(UInt#(32)) ctr <- mkReg(0);

   rule inc_ctr;
      ctr <= ctr + 1;
   endrule

   rule stop (ctr > 100);
      $finish(0);
   endrule
endmodule

endpackage

     
