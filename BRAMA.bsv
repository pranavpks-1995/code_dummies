package BRAMA;
	import BRAMCore ::*;
	import FixedPoint ::*;
	import Vector ::*;
	module mkBram(Empty);
		BRAM_PORT#(Bit#(7),FixedPoint#(8,32)) pks <- mkBRAMCore1(100,False);
		Reg#(Int#(3)) i <- mkReg(0);
		rule write(i==0);
			pks.put(True,2,16.32);
			i <= 1;
		endrule

		rule read (i==1);
			pks.put(False,2,?);
			i<=2;
		endrule

		rule readagain (i==2);
			let x = pks.read();
			fxptWrite(5,x);
			i<=3;
			$finish(0);
		endrule
	
	/*	Integer k = 12, j = 18;
		rule show(i==0);
			if (abs(k-j)<10)
				$display("%d",max(k,j));
			else 
				$display("%d",min(k,j));
				i <= 1;
			$finish(0);
		endrule */
	endmodule
endpackage