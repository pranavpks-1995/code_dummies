package Lock_Detectors;

    import Initial_Settings :: *;
    import processing :: *;
    import Real :: *;
    import FixedPoint :: *;
    import nco ::*;
    import Code_Generator :: *;
	function void Lock_Detector (Empty);
		if (loopcnt%20) == 0
		begin 
            Vector#(19, FixedPoint#(2,32)) I_P_array = trackResults(channelNr).I_P(loopcnt-19:loopcnt);
            Vector#(19, FixedPoint#(2,32)) Q_P_array = trackResults(channelNr).Q_P(loopcnt-19:loopcnt);
            Vector#(19, FixedPoint#(2,32)) I_P_array = trackResults(channelNr).I_P(loopcnt-19:loopcnt);
            Vector#(19, FixedPoint#(2,32)) Z; 
            Vector#(19, FixedPoint#(2,32)) N;

            for(Integer run = 0; run < 19; run = run + 1)
            begin
            	Z[i] = 0.5*(pow(I_P_array[i],2) + pow(Q_P_array[i],2))
            	N[i] = 0.5*((pow(Z[i] - I_P_array[i]),2) + pow((Z[i] - Q_P_array[i]),2)) 
            end

            /*NA = sqrt(Z^2-N);
            est_CNR_VSM = 10*log10(NA/(Z-NA)/1e-3)
            trackResults(channelNr).EST_CNR(loopcnt) = est_CNR_VSM;*/
		end
	endfunction
endpackage