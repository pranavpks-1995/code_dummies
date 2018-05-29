
import "BDPI" function Bit#(8) my_and (Bit#(8) x, Bit#(8) y);

import "BDPI" my_C_or = function Bit#(8) my_or (Bit#(8) x, Bit#(8) y);

import "BDPI" function Action my_display (Bit#(8) x);

(* synthesize *)
module mkDirectC_Part1 ();
   rule r;
      let v1 = my_and(1,2);
      let v2 = my_or(1,2);
      my_display(v1);
      my_display(v2);
      $finish(0);
   endrule
endmodule

