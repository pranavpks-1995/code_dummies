package nco;
	`include "Initial_Settings.bsv"
	import Real :: *;
	typedef struct 
	{
		sincarr;
		coscarr;
		Int#(32) lastPhase;
	}Result1 deriving (Bits,Eq);
	function Result1 mkNco(Int#(32) frqBin, Int#(32) sanples_per_code)
		Real pi;
		Int#(32) t[samples_per_code];
		Int#(32) arg[samples_per_code];
		for(int i=0; i < samples_per_code; i++)
			t[i] = (i+1)/samplingFreq;

		arg = (frqBin*2*pi*t) + theta;



	endfunction
endpackage: nco