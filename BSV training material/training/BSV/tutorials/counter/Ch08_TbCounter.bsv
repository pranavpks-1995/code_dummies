import StmtFSM::*;
import Ch08_Counter::*;

(* synthesize *)
module mkTbCounter();
    Counter#(Bit#(8)) counter <- mkCounter();
    Reg#(Bit#(16)) state <- mkReg(0);

    // check that the counter matches an expected value
    function check(expected_val);
        action
            if (counter.read() != expected_val)
            $display("FAIL: counter != %0d", expected_val);
        endaction
    endfunction

    Stmt test_seq = seq
            counter.load(42);
            check(42);
            $display("TESTS FINISHED");
        endseq;
    mkAutoFSM(test_seq);
endmodule
