package Code_Generator;
	import Initial_Settings :: * ;
	import Real :: *;

	Integer limit = IntegrationTime * fromReal(1e-3) / (1/samplingFreq);

	function Vector#(limit/downByFactor, Int) mkCodeGenerator (Int PRN, Int downByFactor);

		
		//Vector#(limit,Real) Index=(1/(samplingFreq):1/(samplingFreq):IntegrationTime*1e-3); // determine indices
		//Vector#(limit,Real) Ind=ceil((codeFreqBasis)*Index(1:end)); // Determining chip index for samples
		FixedPoint#(2,32) Index;
		FixedPoint#(2,32) Ind;
		Vector#(limit,Int) Ind_final=rem(Ind-1,1023)+1; // Modulo 1023
    
		for (Integer i = 0; i < limit; i = i+1)
		begin
			Index = (1/samplingFreq)*i + 1/samplingFreq;
			Ind = fromReal(ceil ((codeFreqBasis)*Index));
			Ind_final[i] = ((Ind-1) % 1023)+1;
		end


	    Vector#(1023, Int) CAcode=generatePRN(PRN); // 1023 chips for the selected PRN
	    //ref_code1=CAcode(Ind_final); // sampling of chips
	    Vector#(limit, Int) ref_code1;
	    for(Integer i = 0; i<limit; i = i+1)
	    begin
	    	ref_code1[i] = CAcode[Ind_final[i]];
	    end
	    //ref_code=ref_code1(1:downByFactor:end); // down sampling
	    Vector#(limit/downByFactor, Int) ref_code;
	    for (Integer i = 0; i< limit; i = i+downByFactor)
	    begin
	    	ref_code[i] = ref_code1[i];
	    end

	    return ref_code;
	endfunction 

endpackage : Code_Generator


