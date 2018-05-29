// Copyright Bluespec Inc. 2009`-2010


#pragma once

// Include Bluespec's SceMi C++ api
#include "bsv_scemi.h"

// Define a class for the top-level transactor
class TbXactor {
 protected:
  // Data members include transactors contained in the model
  // Data Xactors
  InportProxyT<BitT<64> > 	m_datain;
  // Shutdown Xactor
  ShutdownXactor 		m_shutdown;

 public:
  // Constructor
  TbXactor (SceMi *scemi) ;
  // Destructor 
  ~ TbXactor();

  // Public interface .....
  bool putRequestNB(long);
  bool putRequestB (long);

  void shutdown();

 private:
  // Private helper members
};
