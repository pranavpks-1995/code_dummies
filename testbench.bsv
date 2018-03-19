// testbench

import nco::*;

module testbench(Empty);
Bit#(32) temp = 10;
let x = mkNco(temp,temp,temp,temp,temp);
endmodule