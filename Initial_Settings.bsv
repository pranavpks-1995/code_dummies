
package Initial_Settings;

import FixedPoint :: *; 
import Real :: * ;

	`define fileName            '/home/Final/Project Final Work SPS/The Final Receiver_SPS/Signals/compactdata.bin'


	`define dataType            'ubit1' // for compactdata.bin


	

	// Intermediate, sampling and code frequencies

	Real iF                 = 3.563e6;      //[Hz] for compactdata.bin
	Real samplingFreq       = 12e6;     //[Hz] for compactdata.bin
	Real codeFreqBasis      = 1.023e6;      //[Hz] chip rate
	Real codeLength         = 1023;

	//// Processing settings ====================================================
	// Number of milliseconds to be processed
	Real msToProcess        = 500;        //[ms]
	// Number of channels to be used for signal processing
	Real numberOfChannels   = 11;
	// Move the starting point of processing.
	Real skipNumberOfBytes     = 500*26e6;


	//// Acquisition settings ===================================================
	// Band around IF to search for satellite signal. Depends on max Doppler
	Real acqSearchBand      = 20;           //[kHz] for cold start
	Real acqSearchBand_warm_start      = 10;           //[kHz] for warm start

	// Threshold for the signal presence decision rule
	Real acqThreshold       = 1.9; // Considered as the threshold for the ratio of signal power to noise power

	// Down sampling of the signal for acquisition
	Real downByFactor       = 1;


	// The block length taken for processing
	Real integrationTime    = 1; // in ms, currently receiver may not work properly if it is changed

	//// Tracking loops settings ================================================
	// Code tracking loop parameters
	// Histogram filtering is applied for code phase smoothening 

	// Carrier tracking loop parameters

	// FLL loop filter coefficients
	Real k1_freq = 0.305;
	Real k2_freq = 0.695;

	// PLL loop filter coefficients
	Real k1_phase = 1;
	Real k2_phase = 0;

	Real trackResults [500], i_P,	i_E, i_L, q_E, q_P, q_L,
			theta, filttheta, freqdev, phi, dopplerFreq, carrFreq, 
			codeFreq, codephase, filtcodephase,codeError, lockCheck, est_CNR, dPRange, data, data_boundary, acq_Skip;
	Real acqTh = 0;
	Real prn = 0;
	

endpackage: Initial_Settings