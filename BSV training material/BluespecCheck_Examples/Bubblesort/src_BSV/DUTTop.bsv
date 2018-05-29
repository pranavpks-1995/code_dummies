// Copyright (c) 2013-2016 Bluespec, Inc.  All Rights Reserved.

package DUTTop;

// ================================================================
// Testbench to drive the sorting module.
// Feed n unsorted inputs to sorter,
// drain n sorted outputs and print
// ================================================================
// BSV lib imports

import LFSR   :: *;
import Vector :: *;

// ================================================================
// Project imports

import Utils      :: *;
import Bubblesort :: *;

// ================================================================
// Size of array to be sorted

typedef 5 N_t;
typedef UInt #(24)  MyT;

MyT n = fromInteger (valueOf (N_t));

// ================================================================
// DUT top level module

interface DUT_IFC;
   method Action put (MyT in);
   method ActionValue #(Vector #(N_t, MyT)) get;
endinterface

(* synthesize *)
module mkDUTTop (DUT_IFC);
   Vector #(N_t, Reg #(Maybe #(MyT))) rg_outS <- replicateM (mkReg (tagged Invalid));
   Reg #(Bool) rg_resultReady <- mkReg (False);

   // Instantiate the parallel sorter
   Bubblesort_IFC #(N_t, MyT) sorter <- mkBubblesort_20_UInt24;

   // Combine the sorted output into a Vector
   rule rl_drain_outputs;
      let y <- sorter.get;
      writeVReg (rg_outS, shiftInAtN (readVReg (rg_outS), tagged Valid y));
      if (isValid (rg_outS[1])) rg_resultReady <= True;
   endrule

   method Action put (MyT x) = sorter.put (x);

   method ActionValue #(Vector #(N_t, MyT)) get if (rg_resultReady);
   actionvalue
      Vector #(N_t, MyT) curOut = newVector;
      for (Integer i=0; i<valueOf(N_t); i=i+1)
         curOut [i] = rg_outS [i].Valid;
      rg_resultReady <= False;
      writeVReg (rg_outS, replicate (tagged Invalid));
      return (curOut);
   endactionvalue
   endmethod
endmodule

// ================================================================
// Instantiate and separately synthesize a Bubblesort module for size 'N_t'
// and type 'MyT'

(*synthesize*)
module mkBubblesort_20_UInt24 (Bubblesort_IFC #(N_t,MyT));
   Bubblesort_IFC #(N_t, MyT) m <- mkBubblesort;
   return m;
endmodule

// ================================================================

endpackage
