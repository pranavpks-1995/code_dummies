package Lock_Detectors;

    import Initial_Settings :: *;
    import processing :: *;
    import Real :: *;
    import FixedPoint :: *;
    import nco ::*;
    import Code_Generator :: *;
    import Complex :: *;

	module lock_Detector ();
	function int sign (FixedPoint#(2,32) x);
			if(x != 0)
			begin
				if (x < 0)
					return -1;

				else	
					return 1;
			end

			else 
				return 0;
		endfunction

		Vector#(19, FixedPoint#(2,32)); 
		Vector#(19, FixedPoint#(2,32));
            // Vector#(19, FixedPoint#(2,32)) i_P_array = trackResults[channelNr].i_P[loopcnt-19:loopcnt);
        Vector#(19, FixedPoint#(2,32)) z;
        Vector#(19, FixedPoint#(2,32)) n;
        Vector#(19, FixedPoint#(2,32)) nA;

        Complex#(Int#(32)) est_CNR_VSM;
        Int#(32) sign_changes_I = 0; 
        Int#(32) sign_changes_Q = 0;
        FixedPoint#(2,32) bit,temp;

// --------------------------------- Lock Check ----------------------------   
 // SNR Criterion
		if ([loopcnt%20) == 0)
		begin 
            i_P_array = takeAt[loopcnt - 19, trackResults[channelNr].i_P);
            q_P_array = takeAt[loopcnt - 19, trackResults[channelNr].q_P);
            // Vector#(19, FixedPoint#(2,32)) i_P_array = trackResults[channelNr].i_P[loopcnt-19:loopcnt);

            for(Integer run = 0; run < 19; run = run + 1)
            begin
            	let p = i_P_array[run];
            	let q = q_P_array[run];
            	let r = z[run];
            	z[run] = 0.5*(fxptMult(p,p) + fxptMult(q,q));
            	n[run] = 0.5*(fxptMult(p-r,p-r) + fxptMult(q-r,q-r));
            end

            /*NA = sqrt(Z^2-N);
            est_CNR_VSM = 10*log10(NA/(Z-NA)/1e-3)
            trackResults[channelNr].EST_CNR[loopcnt) = est_CNR_VSM;*/
        end


        for(Int#(32) i = 0; i < 19; i = i + 1)
        begin
        	sign_changes_I = sign_changes_I + sign(trackResults[channelNr].i_P[loopcnt-i]*trackResults[channelNr].i_P[loopcnt-i+1]);
            sign_changes_Q = sign_changes_Q + sign(trackResults[channelNr].q_P[loopcnt-i]*trackResults[channelNr].q_P[loopcnt-i+1]);
        end
            // %% Lock Lost        
		if (((sign_changes_I<15) && (sign_changes_Q<15)) || (real(est_CNR_VSM)<30) || (imag(est_CNR_VSM)>0))
		begin
			if (((real(est_CNR_VSM)<30) || (imag(est_CNR_VSM)>0)) && loopcnt>60) //% check if SNR is low
			begin
        			// % See if SNR is decreasing gradually    
		        CNR_diff1 = (abs(trackResults[channelNr].EST_CNR[loopcnt])-abs(trackResults[channelNr].EST_CNR[loopcnt-20]));
		        CNR_diff2 = (abs(trackResults[channelNr].EST_CNR[loopcnt-20])-abs(trackResults[channelNr].EST_CNR[loopcnt-40]));
		        if (abs(CNR_diff1-CNR_diff2) < 2)     //%%% lock is lost because satellite has gone away, means no need to try again			        begin
				begin        
					trackResults[channelNr].acq_Skip[loopcnt+1] = 3; //% Acq status is updated according to that
				    trackResults[channelNr].lockCheck[loopcnt] = 0;
			    end

			    else //% as SNR is very low - Satellite was not present,it was a false alarm  
			    begin
			        trackResults[channelNr].acq_Skip[loopcnt+1] = 3;
			        trackResults[channelNr].lockCheck[loopcnt] = 0;
		    	end
			end
			
			else if ((((sign_changes_I<15) && (sign_changes_Q<15)) || (real(est_CNR_VSM)<30) || (imag(est_CNR_VSM)>0)) && loopcnt==20) //% SNR is high, lock is lost for the first time due to gliches, give it a warm start
			begin
			    trackResults[channelNr].acq_Skip[loopcnt+2] = 0; //% in the next to next loopcnt as next ms may have a transition
			    trackResults[channelNr].lockCheck[loopcnt] = 0;
	        end
	     
			else //% SNR is high, lock is lost due to gliches, give it a hot start
			    trackResults[channelNr].acq_Skip[loopcnt+1] = 2;
			    trackResults[channelNr].lockCheck[loopcnt] = 0;
			end
    		trackResults[channelNr].data[loopcnt] = 0;    
		end

		else //% Lock is not lost, pass on previous acq status
		begin
		    trackResults[channelNr].lockCheck[loopcnt] = trackResults[channelNr].lockCheck[loopcnt-1] + 1;
		    trackResults[channelNr].acq_Skip[loopcnt + 1] = trackResults[channelNr].acq_Skip[loopcnt];
		end
                    
		else // % wait for 20 values to accumulate, pass on previous values for lock strength and status
		    trackResults[channelNr].lockCheck[loopcnt] = trackResults[channelNr].lockCheck[loopcnt - 1];
		    trackResults[channelNr].acq_Skip[loopcnt + 1] = trackResults[channelNr].acq_Skip[loopcnt];
		end

// %% Delta-PseudoRange Calculation
// % Delta pseudorange is the time elapsed between switching on of the
// % receiver and first data bit boundary
// % if the lock strength is good, check for next data transition and calculate pseudorange 
		if (trackResults[channelNr].lockCheck[loopcnt]>5 && sign(trackResults[channelNr].Q_P[loopcnt-1]*trackResults[channelNr].Q_P[loopcnt])==-1)
		begin
		    if (trackResults[channelNr].data_boundary == 0)
		    begin
		    	trackResults[channelNr].data_boundary = [loopcnt];
		    end

		    temp = loopcnt%20;
		    trackResults[channelNr].dPRange[loopcnt] = temp+trackResults[channelNr].filtcodephase[loopcnt]/samples_per_code;
		    temp = 0;

		    else    
		    begin
		    	trackResults[channelNr].dPRange[loopcnt] = trackResults[channelNr].dPRange[loopcnt-1];
		    end
		end


		// %% Data Demodulation
		if (trackResults[channelNr].data_boundary > 0 && rem([loopcnt]-trackResults[channelNr].data_boundary,20)==0 && trackResults[channelNr].lockCheck[loopcnt]>1) //% Select bit boundaries

			// % fill in the value of current bit
		    // bit = sign(sum(trackResults[channelNr].q_P(loopcnt-20:loopcnt-1)));
		    // trackResults[channelNr].Data(loopcnt-20:loopcnt-1)=bit;

		    for (i = loopcnt-20; i < loopcnt; i = i + 1)
		    begin
		    	temp = temp + trackResults[channelNr].q_P[i]; 
		    end
		    
		    bit = sign(temp);

		    for (i = loopcnt-20; i < loopcnt; i = i + 1)
		    begin
		    	trackResults[channelNr].data[i] = bit;
		    end

		end
	endmodule 
endpackage