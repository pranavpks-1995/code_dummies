package processing;
	import Initial_Settings::*;


	Int#(32) size1 = msToProcess/integrationTime;
	typedef struct 
	{
		//Real[msToProcess/integrationTime] i_P, i_E, i_L, q_E, q_P, q_L, theta, filttheta, freqdev, phi, dopplerFreq, carrFreq, codeFreq, codephase, filtcodephase,codeError, lockCheck, est_CNR, dPRange, data, data_boundary, acq_Skip;
		Vector#(size1, FixedPoint#(2,32)) i_P, i_E, i_L, q_E, q_P, q_L;
		Vector#(size1, FixedPoint#(2,32)) theta, filttheta, freqdev, phi, filtfreqdev, dopplerFreq, carrFreq, codeFreq;
		Vector#(size1, FixedPoint#(2,32)) codephase, filtcodephase,codeError, lockCheck, est_CNR, dPRange, data, data_boundary, acq_Skip;
	Int#(32) acqTh;
	Int#(32) prn;
	} track deriving (Bits, Eq);
	function mkProcess();
		Vector#(numberOfChannels,track) trackResults;
		for(Int#(32) i=0; i<numberOfChannels; i = i+1)
		begin
			trackResults[i].i_P = replicate(0);
			trackResults[i].i_E = replicate(0);
			trackResults[i].i_L = replicate(0);
			trackResults[i].q_P = replicate(0);
			trackResults[i].q_E = replicate(0);
			trackResults[i].q_L = replicate(0);

			trackResults[i].theta = replicate(0);
			trackResults[i].filttheta = replicate(0);
			trackResults[i].freqdev = replicate(0);
			trackResults[i].filtfreqdev = replicate(0);
			
			trackResults[i].phi = replicate(0);
			trackResults[i].dopplerFreq = replicate(0);
			trackResults[i].carrFreq = replicate(iF);

			trackResults[i].codeFreq = replicate(codeFreqBasis);
			trackResults[i].codephase = replicate(0);

			trackResults[i].filtcodephase = replicate(0);
			trackResults[i].codeError = replicate(0);
			
			trackResults[i].lockCheck = replicate(0);
			trackResults[i].est_CNR = replicate(0);

			trackResults[i].dPRange = replicate(0);
			trackResults[i].data = replicate(0);
			trackResults[i].data_boundary = replicate(0);

			trackResults[i].acq_Skip= replicate(0);

			trackResults[i].acqTh = 0;
			trackResults[i].prn = 0;
		end

		
	endfunction
endpackage: processing