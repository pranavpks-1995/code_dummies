package code_generator_tracking
	module program(Empty);
	
		function code_generator_tracking(settings,trackResults,channelNr,loopcnt)
		begin
			Index=(1/settings.samplingFreq/2:1/settings.samplingFreq:settings.IntegrationTime*1e-3);  
			if (loopcnt>1) 
			begin
				Ind=ceil((((trackResults(channelNr).DopplerFreq(loopcnt-1))/1575.42e6+1)*settings.codeFreqBasis)*Index(1:end))
			end

			else
			begin
				Ind=ceil((settings.codeFreqBasis)*Index(1:end));
			end
			Ind_final=rem(Ind-1,1023)+1; 
			CAcode=generatePRN(trackResults(channelNr).PRN); 
			ref_code=CAcode(Ind_final); 
		end
	endmodule
endpackage