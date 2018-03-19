package nco;
	import Initial_Settings ::*;
	import Real :: *;
	UInt#(16) aarr[10];


	typedef struct 
	{
		UInt#(32) sincarr[10];
		UInt#(32) coscarr[10];
		UInt#(32) lastPhase;
	} Result1 deriving (Bits,Eq);

	function Result1 mkNco(UInt#(32) frqBin, UInt#(32) samples_per_code, UInt#(32) loopcnt, UInt#(32) samplingFreq, UInt#(32) theta);
		Real x = pi ;
		UInt#(32) sincarry[10];
		UInt#(32) coscarry[10];
		UInt#(32) lastPhase;
		UInt#(32) t[samples_per_code];
		UInt#(32) arg[samples_per_code];
		UInt#(32) i = 0;
		for( i=0; i < samples_per_code; i = i+1)
		begin
			t[i] = (i+1)/samplingFreq;
			arg[i] = (frqBin*2*x*t) + theta;
			sincarry[i] = sin(arg[i]);
			coscarry[i] = cos(arg[i]);
		end

		lastPhase = 2;
		Result1 ret = Result1{sincarr:sincarry ,coscarr:coscarry, lastPhase:lastPhase};
		return ret;
	endfunction
endpackage: nco