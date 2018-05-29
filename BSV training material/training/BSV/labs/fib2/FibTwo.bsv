interface Fib;
  // putRequest() takes an int, and performs an Action (side effects)
  method Action putRequest(int n);
  // getReply() returns an int, and has no side effects (no Action)
  method int getReply();
endinterface: Fib

(* synthesize *)
module mkFibTwo(Fib);  // this time mkFibTwo provides an interface (Fib)

  // TASK: implement Fibonacci circuit

  // HINT: use two registers to store fib(n) and fib(n-1)
  //       and one rule to compute fib(n+1)
  //       allow getReply() and putRequest() only when computation stops

endmodule: mkFibTwo

