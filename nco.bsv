package nco;
	import Initial_Settings ::*;
	import Vector ::*;
	import Real ::*;
	UInt#(16) aarr[10];
	typedef struct 
	{
		// UInt#(32) sincarr[10];
		// UInt#(32) coscarr[10];
		Vector #(10, Real) sincarr;
		Vector #(10, Real) coscarr;
		Real lastPhase;
	} Result1 deriving (Bits,Eq);

	function Result1 mkNco(Real frqBin, Bit#(64) samples_per_code, Real loopcnt, Real samplingFreq, Real theta);
		Real x = pi ;
		// UInt#(32) sincarry[10];
		// UInt#(32) coscarry[10];
		// Bit#(64) samplespercode = $realtobits(samples_per_code);

		Vector #(10, Real) sincarry;
		Vector #(10, Real) coscarry;
		Real lastPhase;
		Real t[1000];
		Real arg[1000];
		Bit#(64) i = 0;

		for(i=0; i < samples_per_code; i = i+1)
		begin
			t[i] = $bitstoreal(i);

			t[i] = (t[i]+1)/samplingFreq;
			arg[i] = (frqBin*2*x*t[i]) + theta;
			sincarry[i] = sin(arg[i]);
			coscarry[i] = cos(arg[i]);
		end

		lastPhase = arg[0];
		Result1 ret = Result1{sincarr:sincarry, coscarr:coscarry, lastPhase:lastPhase};
		return ret;
	endfunction
endpackage: nco


/*package nco;
	import Initial_Settings ::*;
	import Vector ::*;
	import Real ::*;
	import FixedPoint ::*;
	UInt#(16) aarr[10];


	typedef struct 
	{
		// UInt#(32) sincarr[10];
		Vector #(10, FixedPoint#(4,10)) sincarr;
		Vector #(10, FixedPoint#(4,10)) coscarr;
		// UInt#(32) coscarr[10];
		Real lastPhase;
	} Result1 deriving (Bits,Eq);

	function Result1 mkNco(Int#(32) frqBin, Int#(32) samples_per_code, Int#(32) loopcnt, Int#(32) samplingFreq, Int#(32) theta);
		// Real x = pi ;
		FixedPoint#(4,10) pie = 3.14195;
		// UFixedPoint#(4,10) sincarry[10];
		// UFixedPoint#(4,10) coscarry[10];
		Vector #(10, FixedPoint#(4,10)) sincarry;
		Vector #(10, FixedPoint#(4,10)) coscarry;
		FixedPoint#(4,10) lastPhase;
		FixedPoint#(4,10) t[samples_per_code];
		FixedPoint#(4,10) arg[samples_per_code];
		Int#(32) i = 0;
		for( i=0; i < samples_per_code; i = i+1)
		begin
			t[i] = (i+1)/samplingFreq;
			arg[i] = (frqBin*2*pie*t) + theta;
			sincarry[i] = sin(arg[i]);
			coscarry[i] = cos(arg[i]);
		end

		lastPhase = 2;
		Result1 ret = Result1{sincarr:sincarry ,coscarr:coscarry, lastPhase:lastPhase};
		return ret;
	endfunction
endpackage: nco

function Result1 mkNco(Bit#(64) frqBin, Bit#(64) samples_per_code, Bit#(64) loopcnt, Bit#(64) samplingFreq, Bit#(64) theta);
Real frq_Bin = $bitstoreal(frqBin);
		Real samplespercode = $bitstoreal(samples_per_code);
		Real loop_cnt = $bitstoreal(loopcnt);
		Real sampling_Freq = $bitstoreal(samplingFreq);
		Real thita = $bitstoreal(theta);
*/