`ifdef SCEMI_PCIE_VIRTEX6
  `include "Bridge_VIRTEX6_ML605.bsv"
`endif

`ifdef SCEMI_PCIE_VIRTEX5
  `include "Bridge_VIRTEX5_ML50X.bsv"
`endif

`ifdef SCEMI_TCP
  import SceMi::*;
  import SceMiLayer::*;
  
  (* synthesize *)
  module mkBridge ();
     Empty scemi <- buildSceMi(mkSceMiLayer, TCP);
  endmodule
`endif



