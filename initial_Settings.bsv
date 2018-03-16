// settings.fileName           = ...
//     '/home/lenovo/Project Final Work SPS/The Final Receiver_SPS/Recorded_Signals/compactdata.bin';

/*       '/home/lenovo/Project Final Work SPS/The Final Receiver_SPS/Recorded_Signals/IITJl1rxHBw_Run2.dat';
    
%        '/home/lenovo/Project Final Work SPS/The Final Receiver_SPS/Recorded_Signals/gioveAandB_short.bin';

%    '/home/lenovo/Project Final Work SPS/The Final Receiver_SPS/Recorded_Signals/compactdata.bin';*/

//  PRN list for warm start for the selected file

/*%settings.PRN=[1 3 7 11 14 19 20 22 24 28 31]; % for compactdata warm start
%settings.PRN=[22 19 14 18 32 6 11 3 28 9] % 28 9 for gioveAandB_short.bin
%start*/

/*% Initial Carrier Frequency Estimate for warm start

%settings.Init_Carr = [3566000 3559000 3566000 3564000 3563000 3560000 ...
    %3565000 3560000 3566000 3561000 3565500]; % for compactdata warm start


% Data type used to store one sample*/

settings.dataType           = 'ubit1'; //% for compactdata.bin
// %settings.dataType           = 'int8'; % for gioveAandB_short.bin
// %settings.dataType           = 'int8'; % for IITJl1rxHBw_Run2.dat



// % Intermediate, sampling and code frequencies

Reg#(Int#(64)) IF <= mkReg(3563000);   //   %[Hz] for compactdata.bin
// // %settings.IF                 = 4130400;      %[Hz] for gioveAandB_short.bin
// // %settings.IF                 = 6.4583475e6;      %[Hz]IITJl1rxHBw_Run2.dat


// %settings.samplingFreq       = 26e6;     %[Hz]IITJl1rxHBw_Run2.dat
Reg#(Int#(64)) samplingFreq <= mkReg(12000000);     //%[Hz] for compactdata.bin
// %settings.samplingFreq       = 16367600;     %[Hz] for gioveAandB_short.bin

Reg#(Int#(64)) codeFreqBasis <= mkReg(1023000);    //  %[Hz] chip rate

// % Define number of chips in a code period
Reg#(Int#(64)) codeLength <= mkReg(1023);

// %% Processing settings ====================================================
// % Number of milliseconds to be processed

Reg#(Int#(64)) msToProcess <= mkReg(500);        //%[ms]

//% Number of channels to be used for signal processing
Reg#(Int#(64)) numberOfChannels   <= mkReg(11);

/*% Move the starting point of processing. Can be used to start the signal
% processing at any point in the data record (e.g. for long records). fseek
% function is used to move the file read point, therefore advance is sample
% based only. */
Reg#(Int#(64)) skipNumberOfBytes     = mkReg(154457888000);
/*%settings.skipNumberOfBytes     =500*26e6; % for IITJl1rxHBw_Run2.dat


%% Acquisition settings ===================================================
% Band around IF to search for satellite signal. Depends on max Doppler*/
Reg#(Int#(64)) acqSearchBand <= mkReg(20);           //%[kHz] for cold start
Reg#(Int#(64)) acqSearchBand_warm_start <= mkReg(10);           //%[kHz] for warm start

//% Threshold for the signal presence decision rule

/*Original Val 1.9*/ Reg#(Int#(64)) acqThreshold <= mkReg(19);  //% Considered as the threshold for the ratio of signal power to noise power

//% Down sampling of the signal for acquisition
Reg#(Int#(64)) downByFactor <= mkReg(1);

//% The block length taken for processing
Reg#(Int#(64)) settings.IntegrationTime <= mkReg(1);// % in ms, currently receiver may not work properly if it is changed

/*%% Tracking loops settings ================================================
% Code tracking loop parameters
% Histogram filtering is applied for code phase smoothening 

% Carrier tracking loop parameters

% FLL loop filter coefficients*/
/*Original Val 0.305*/ Reg#(Int#(64)) k1_freq <= mkReg(305);
/*Original Val 0.695*/ Reg#(Int#(64)) k2_freq <= mkReg(695);

//% PLL loop filter coefficients
Reg#(Int#(64)) k1_phase <= mkReg(1);
Reg#(Int#(64)) k2_phase <= mkReg(0);





