package Lock_Detectors;

    import Initial_Settings :: *;
    import processing :: *;
    import Real :: *;
    import FixedPoint :: *;
    import nco ::*;
    import Code_Generator :: *;
    import Complex :: *;

	module lock_Detector ();
// --------------------------------- Lock Check ----------------------------   
 // SNR Criterion
		if ([loopcnt%20) == 0)
		begin 
            Vector#(19, FixedPoint#(2,32)) i_P_array = takeAt[loopcnt - 19, trackResults[channelNr].i_P);
            Vector#(19, FixedPoint#(2,32)) q_P_array = takeAt[loopcnt - 19, trackResults[channelNr].q_P);
            // Vector#(19, FixedPoint#(2,32)) i_P_array = trackResults[channelNr].i_P[loopcnt-19:loopcnt);
            Vector#(19, FixedPoint#(2,32)) z;
            Vector#(19, FixedPoint#(2,32)) n;
            Vector#(19, FixedPoint#(2,32)) nA;

            Complex#(Int#(32)) est_CNR_VSM;

            for(Integer run = 0; run < 19; run = run + 1)
            begin
            	let p = i_P_array[i];
            	let q = q_P_array[i];
            	let r = z[i];
            	z[i] = 0.5*(fxptMult(p,p) + fxptMult(q,q));
            	n[i] = 0.5*(fxptMult(p-r,p-r) + fxptMult(q-r,q-r));
            end

            /*NA = sqrt(Z^2-N);
            est_CNR_VSM = 10*log10(NA/(Z-NA)/1e-3)
            trackResults[channelNr].EST_CNR[loopcnt) = est_CNR_VSM;*/
        end

        Int#(32) sign_changes_I = 0; 
        Int#(32) sign_changes_Q = 0;

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
		        CNR_diff1=(abs(trackResults[channelNr].EST_CNR[loopcnt])-abs(trackResults[channelNr].EST_CNR[loopcnt-20]));
		        CNR_diff2=(abs(trackResults[channelNr].EST_CNR[loopcnt-20])-abs(trackResults[channelNr].EST_CNR[loopcnt-40]));
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
		    trackResults[channelNr].LockCheck[loopcnt] = trackResults[channelNr].LockCheck[loopcnt-1] + 1;
		    trackResults[channelNr].AcqSkip[loopcnt + 1] = trackResults[channelNr].AcqSkip[loopcnt];
		end
                    
		else // % wait for 20 values to accumulate, pass on previous values for lock strength and status
		    trackResults[channelNr].LockCheck[loopcnt] = trackResults[channelNr].LockCheck[loopcnt - 1];
		    trackResults[channelNr].AcqSkip[loopcnt + 1] = trackResults[channelNr].AcqSkip[loopcnt];
		end

	endmodule 
endpackage