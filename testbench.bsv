// testbench

import generatePRN::*;
	import Initial_Settings ::*;
	import Vector ::*;
	import Real ::*;
	import FixedPoint ::*;
	import Lock_Detectors ::*;
module test(Empty);
rule show;
	Lock_Detector;
	$display("Hello World");
endrule
endmodule
