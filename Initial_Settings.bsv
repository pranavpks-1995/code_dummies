
package Initial_Settings;

import FixedPoint :: *; 
//import Real :: * ;
import Vector :: * ;

	`define fileName            '/home/Final/Project Final Work SPS/The Final Receiver_SPS/Signals/compactdata.bin'


	`define dataType            'ubit1' // for compactdata.bin


	

	// Intermediate, sampling and code frequencies

	Int#(64) iF                 = 3563000;      //[Hz] for compactdata.bin
	Int#(64) samplingFreq       = 12000000;     //[Hz] for compactdata.bin
	Int#(64) codeFreqBasis      = 1023000;      //[Hz] chip rate
	Int#(32) codeLength         = 1023;

	//// Processing settings ====================================================
	// Number of milliseconds to be processed
	Int#(32) msToProcess        = 500;        //[ms]
	// Number of channels to be used for signal processing
	Int#(32) numberOfChannels   = 11;
	// Move the starting point of processing.
	Int#(64) skipNumberOfBytes     = 13000000000;

	//// Acquisition settings ===================================================
	// Band around IF to search for satellite signal. Depends on max Doppler
	Int#(32) acqSearchBand      = 20;           //[kHz] for cold start
	Int#(32) acqSearchBand_warm_start      = 10;           //[kHz] for warm start

	// Threshold for the signal presence decision rule
	FixedPoint#(2,32) acqThreshold       = 1.9; // Considered as the threshold for the ratio of signal power to noise power

	// Down sampling of the signal for acquisition
	Int#(32) downByFactor       = 1;


	// The block length taken for processing
	Int#(32) integrationTime    = 1; // in ms, currently receiver may not work properly if it is changed

	//// Tracking loops settings ================================================
	// Code tracking loop parameters
	// Histogram filtering is applied for code phase smoothening 

	// Carrier tracking loop parameters

	// FLL loop filter coefficients
	FixedPoint#(2,32) k1_freq = 0.305;
	FixedPoint#(2,32) k2_freq = 0.695;

	// PLL loop filter coefficients
	FixedPoint#(2,32) k1_phase = 1;
	FixedPoint#(2,32) k2_phase = 0;
endpackage: Initial_Settings