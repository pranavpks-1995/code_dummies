package Code_Generator;
	import initial_settings ::*;
	module program (Empty);
		Index = (1/(samplingFreq):1/(samplingFreq):IntegrationTime*0.001); 
		Ind = ceil((codeFreqBasis)*Index(1:end)); 
		Ind_final = (Ind-1%1023)+1;
		    
		CAcode = generatePRN(PRN);
		ref_code1 = CAcode(Ind_final);
		ref_code = ref_code1(1:downByFactor:end);
	endmodule
endpackage