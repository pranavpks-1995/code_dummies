import Ch02_Counter::*;

(* synthesize *)
module mkTbCounter();
    Counter counter <- mkCounter();
    Reg#(Bit#(16)) state <- mkReg(0);

    rule step0(state == 0);
        counter.load(42);
        state <= 1;
    endrule

    rule step1(state == 1);
        if (counter.read() != 42) $display("FAIL: counter.load(42)");
        state <= 2;
    endrule

    rule done(state == 2);
        $display("TESTS FINISHED");
        $finish(0);
    endrule
endmodule
