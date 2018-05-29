// This testbench checks functionality:
//    - compare DUT adder with BSV '+'
//    - Test commutativity and associativity
// It does not test performance in any way
//    (neither latency, nor pipeline pressure)

package Testbench;

import StmtFSM		:: *;
import Clocks		:: *;

import BlueCheck	:: *;

import Adder_IFC        :: *;
import Adder		:: *;

module [Specification] mkAdderTBWRst #(Reset r) ();
   // DUT instance
   Adder_IFC dut1 <- mkAdder (reset_by r);
   Adder_IFC dut2 <- mkAdder (reset_by r);

   Ensure ensure <- getEnsure;

   function Stmt addition (Bit #(31) a, Bit #(31) b);
	   return (
		   seq
		   dut1.in (extend (a), extend (b));
		   action
			let s = dut1.out;
			Bit#(32) a_32 = extend (a);
			Bit#(32) b_32 = extend (b);
			ensure (s == a_32 +  b_32);
		   endaction
		   endseq
	   );
   endfunction 

   // a+b = b+a
   function Stmt commutativity (Bit #(31) a, Bit #(31) b);
	   return (
		   seq
		   action
			Bit#(32) a_32 = extend (a);
			Bit#(32) b_32 = extend (b);
			dut1.in (a_32, b_32);
			dut2.in (b_32, a_32);
		   endaction

		   action
			let s1 = dut1.out;
			let s2 = dut2.out;
			ensure (s1 == s2);
		   endaction
		   endseq
	   );
   endfunction 

   // a+(b+c) = (a+b)+c
   function Stmt associativity (Bit #(31) a, Bit #(31) b, Bit #(31) c);
	   return (
		   seq
		   action
			Bit#(32) a_32 = extend (a);
			Bit#(32) b_32 = extend (b);
			Bit#(32) c_32 = extend (c);
			dut2.in (a_32, b_32);
			dut1.in (b_32, c_32);
		   endaction

		   action
			Bit#(32) a_32 = extend (a);
			Bit#(32) c_32 = extend (c);
		        let s1 = dut1.out;
		        let s2 = dut2.out;
			dut1.in (a_32, s1);
			dut2.in (c_32, s2);
		   endaction

		   action
			let s1 = dut1.out;
			let s2 = dut2.out;
			ensure (s1 == s2);
		   endaction
		   endseq
	   );
   endfunction

   prop ("Addition", addition);
   prop ("Commutative", commutativity);
   prop ("Associative", associativity);
endmodule

(* synthesize *)
module [Module] mkTestbench ();
	Clock clk <- exposeCurrentClock;
	MakeResetIfc r <- mkReset (0, True, clk);
	Stmt s <- blueCheckStmtID (mkAdderTBWRst (r.new_rst), r);
	mkAutoFSM(s);
endmodule
endpackage
