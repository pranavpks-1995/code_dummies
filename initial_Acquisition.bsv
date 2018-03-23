package Initial_Acquisition;


    import Initial_Settings :: *;
    import Processing :: *;
    import Real :: *;
    import FixedPoint :: *;
    import nco ::*;
    import Code_Generator :: *;

    typedef struct
    {
        trackResults;
        Int#(32) Acq_Ratio_Array[32];
    }finalResults deriving (Bits, Eq); 

    //function [trackResults, Acq_Ratio_Array] = Initial_Acquisition(trackResults,settings,rawdata)
    // Function is used for a cold start case
    // Inputs are rawdata and settings
    // Takes rawdata, perform acquisition and updates trackResults 
    // find out the no of satellites visible and acquisition parameters for them

    function finalResults mkInitialAcq(rawdata)


        //No_of_visible_sats=0; 
        Int#(32) No_of_visible_sats = 0; // initialize the variables

        //samples_per_code = (samplingFreq/codeFreqBasis)*1.023e3;
        Int#(32) samples_per_code = (samplingFreq/codeFreqBasis)*1023; // No of samples taken for the processing
        // The starting blocks of incoming data each of length equals to 1 code
        
        //signal1_raw = rawdata(1:samples_per_code);
        signal1_raw = rawdata(1:samples_per_code);
        // Downsampling of the incoming signal for acquisition
        //downByFactor = ceil(samplingFreq/codeFreqBasis/12);
        //downByFactor = downByFactor;
        Int#(32) samples_per_code = (samplingFreq/downByFactor/codeFreqBasis)*1023;//new no of samples per block
        
        Real step_freq = 500;// The step size in frequency domain
        // Downsample 
        signal1 = signal1_raw(1:downByFactor:end);

       
        
        PRN=0; // Initially//
        Int PRN_Max = 32; // Max possible PRN for GPS change it for IRNSS
        

        //Acq_Ratio_Array = zeros(1,PRN_Max); //For storing acq ratio of all the satellites 
        //UInt#(32) Acq_Ratio_Array [PRN_Max];
        Vector#(PRN_Max,Int) Acq_Ratio_Array = replicate(0);
        // Perform Acquisition for the no of channels available
        
        //for channelNr=1:numberOfChannels
        for (Integer channelNr = 1; channelNr <= numberOfChannels; channelNr = channelNr+1)
        begin
//
            FixedPoint#(4,32) AcqTh = 0; // Initailization
            
            // Search Every PRN in increasing order and go to next channel whenever
            // one is acquired
            //while (AcqTh < acqThreshold && PRN < PRN_Max)
            while (AcqTh < acqThreshold && PRN < PRN_Max)
            begin 
                PRN = PRN+1; // Increment in PRNs
            
            // Ref code for selected PRN
            //ref_code = Code_Generator(settings,PRN,downByFactor);
                Integer limit = IntegrationTime * fromReal(1e-3) / (1/samplingFreq);
                Vector#(limit,Int) ref_code = Code_Generator(PRN, downByFactor);
                //caCodeFreqDom = fft(fliplr(ref_code));// FFT for parallel search
                //numberOfFrqBins = round(acqSearchBand * 1e3/step_freq) + 1;// No of bins in frequency
                Int numberOfFrqBins = fromReal(round(acqSearchBand * 1000/step_freq)) + 1;
                //Initialize acq results

                Vector#(numberOfFrqBins,Vector#(limit,Int)) results;
                Vector#(limit,Int) acqRes1;
                //results = zeros(numberOfFrqBins,length(ref_code));
                //acqRes1 = zeros(1,length(ref_code));

            //--- Make the correlation for whole frequency band (for all freq. bins)
                //for frqBinIndex = 1:numberOfFrqBins // Serial Frequency Search
                for (int frqBinIndex = 1; frqBinIndex < numberOfFrqBins; frqBinIndex = frqBinIndex+1)
                begin
                    //frqBinIndex
                    //--- Generate carrier wave frequency grid (0.5kHz step) -----------
                    //frqBin = settings.IF - (settings.acqSearchBand/2) * 1000 + step_freq * (frqBinIndex - 1);
                    Int#(32) frqBin = iF - (acqSearchBand/2)*1000 + step_freq * (frqBinIndex - 1);

                    //--- Generate local sine and cosine -------------------------------
                    //[sinCarr,cosCarr,~] = nco(frqBin,1,settings.samplingFreq/downByFactor,length(ref_code),0);
                    let x = mkNco(frqBin,1,samplingFreq/downByFactor,limit,0); 

                    //--- "Remove carrier" from the signal -----------------------------
                    Vector#(,FixedPoint#(2,32)) I1;
                    Vector#(,FixedPoint#(2,32)) Q1;

                    //I1      = sinCarr .* signal1;
                    //Q1      = cosCarr .* signal1;
                    for (Int i=0; i<size1; i = i+1)
                    begin
                        I1 = x.sinCarr[i] * signal1[i];
                        Q1 = x.cosCarr[i] * signal1[i];
                    end
                    
                    Vector#(,FixedPoint#(2,32)) temp1;
                    FixedPoint#(2,32) temp2,temp3;
                    // Serial Code Phase Search (comment if choosing parallel code phase search)
                   // //--- "Correlate with PN code"--------------------------------------
                    //for i=1:length(ref_code/settings.IntegrationTime)
                    for (Int i=0; i<limit/IntegrationTime; i = i+1)
                    begin
                        //acqRes1[i]=(mean([ref_code(end-i+1:end) ref_code(1:end-i)].*I1))^2+(mean([ref_code(end-i+1:end) ref_code(1:end-i)].*Q1))^2;
                        for(int j=0; j<i; j = j+1)
                        begin
                            temp1[i] = ref_code[limit-j];
                        end
                        for(int j=i; j<limit; j = j+1)
                        begin
                            temp1[i] = ref_code[j];
                        end

                        for(int j=0; j<limit; j++)
                        begin
                            temp2 = temp2 + temp1[i] * I1[i];
                            temp3 = temp3 + temp1[i] * Q1[i];
                        end
                        acqRes1[i] = (temp2*temp2) / (limit*limit) + (temp3*temp3) / (limit*limit);
                    end

                  //  // Fill the results for a frequency bin in Grid
                    //results(frqBinIndex, :) = acqRes1;
                    for(Int i=0; i<limit; i=i+1)
                    begin
                        results[frqBinIndex][i] = acqRes1[i];
                    end
                    
                end
                
                
                 //--- Find the correlation peak and the carrier frequency --------------
                //[~, frequencyBinIndex] = max(max(results, [], 2));
                Int peakSize=0;
                Int codePhase = 0;
                Int frequencyBinIndex = 0;
                for(Int i=0; i<numberOfFrqBins; i=i+1)
                begin
                    for(Int j=0; j<limit; j=j+1)
                    begin
                        if(results[i][j] > peakSize)
                        begin
                            peakSize = results[i][j];
                            frequencyBinIndex = i;
                            codePhase = j;
                        end
                    end
                end

                //--- Find code phase of the same correlation peak ---------------------
                //[peakSize, codePhase] = max(max(results));
                
                //--- Find 1 chip wide C/A code phase exclude range around the peak ----
                Int samplesPerCodeChip = fromReal(round(samplingFreq/downByFactor / codeFreqBasis));
                Int excludeRangeIndex1 = codePhase - samplesPerCodeChip;
                Int excludeRangeIndex2 = codePhase + samplesPerCodeChip;

                //--- Correct C/A code phase exclude range if the range includes array
                //boundaries
                List#(Integer) cpr1;
                if excludeRangeIndex1 < 2
                begin
                    //codePhaseRange = excludeRangeIndex2 : (samples_per_code + excludeRangeIndex1);
                    cpr1 = upto(excludeRangeIndex2,samples_per_code+excludeRangeIndex1);
                end                
                else if excludeRangeIndex2 >= samples_per_code
                begin
                    //codePhaseRange = (excludeRangeIndex2 - samples_per_code) : excludeRangeIndex1;
                    cpr1 = upto((excludeRangeIndex2 - samples_per_code) : excludeRangeIndex1);
                end
                else
                begin
                    //codePhaseRange = [1:excludeRangeIndex1, excludeRangeIndex2 : samples_per_code];
                    cpr1 = append( upto(1 : excludeRangeIndex1) , upto(excludeRangeIndex2 : samples_per_code));
                end
                Vector#(length(cpr1), Int) codePhaseRange = toVector(cpr1);
                //--- Find the second highest correlation peak in the same freq. bin ---
                //secondPeakSize = max(results(frequencyBinIndex, codePhaseRange));
                Int secondPeakSize=0;

                for(Int j=codePhaseRange[0]; j<length(codePhaseRange); j=j+1)
                begin
                    if(results[frequencyBinIndex][j] > secondPeakSize)
                    begin
                        secondPeakSize = results[i][j];
                    end
                end

                AcqTh = (abs(peakSize/secondPeakSize));
                
                Acq_Ratio_Array[PRN-1] = AcqTh;
                
                if AcqTh > acqThreshold
                begin
                    
                //--- Fill Results in structure -----    
                    trackResults[channelNr].carrFreq[0] = iF - (acqSearchBand/2) * 1000 + 0.5e3 * (frequencyBinIndex - 1);
                    trackResults[channelNr].codephase[0] =downByFactor*codePhase;
                    trackResults[channelNr].filtcodephase[0] =downByFactor*codePhase;
                    trackResults[channelNr].promptDelay[0] =downByFactor*codePhase;
                    trackResults[channelNr].DopplerFreq[0] =trackResults[channelNr].carrFreq[0]-iF;
                    trackResults[channelNr].AcqSkip[1] = 1;
                    
                    //trackResults[channelNr].Status            = 'T';
                    trackResults[channelNr].PRN            = PRN;
                    trackResults[channelNr].AcqTh            = AcqTh;
                    //fprintf('Satellite Found //d \n ', PRN);
                
//
//      CONTINUE FROM HERE AND RECHECK 
//
//
//
//
//
//



                  // Fine Frequency Search 
                    reference_code = [ref_code(end-codePhase+1:end) ref_code(1:end-codePhase)];
                    est_freq = trackResults[channelNr].carrFreq[0];
                    fine_freq_step = 10;
                    no_of_fine_frqbin = round(step_freq/fine_freq_step)+1;
                    Acq_fine_result1 = zeros(1,no_of_fine_frqbin);

                    for i=1:no_of_fine_frqbin
                    begin
                        freq = est_freq - step_freq/2 + fine_freq_step*(i-1);
                        [sinCarr,cosCarr,lastPhase] = nco(freq,1,samplingFreq/downByFactor,length(ref_code),0);
                        I1      = sinCarr .* signal1;
                        Q1      = cosCarr .* signal1;

                        Acq_fine_result1(i)=(sum(reference_code.*I1))^2+...
                               (sum(reference_code.*Q1))^2;

                    end
                    [max1, freq_index1] = max(abs(Acq_fine_result1));

                        freq_index = freq_index1;

                    trackResults[channelNr].carrFreq[0]=est_freq - step_freq/2 + fine_freq_step*(freq_index-1);
                    
                    trackResults[channelNr].AcqSkip[1]            = 1;
                    trackResults[channelNr].AcqTh            = AcqTh;
                    trackResults[channelNr].DopplerFreq[0]=trackResults[channelNr].carrFreq[0]-iF;
                    No_of_visible_sats = No_of_visible_sats+1;
                end
            end
        end
        // If sufficient no of satellites not visible, disable the remaining channels
        
        if No_of_visible_sats < numberOfChannels
        begin
            for channelNr=No_of_visible_sats+1:numberOfChannels
            begin
                trackResults[channelNr].AcqSkip[1]            = 3;
            end
        end
        

        return finalResults;

    endfunction
endpackage : Initial_Acquisition