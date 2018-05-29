/*  Copyright Bluespec Inc. 2005-2008  */

package Functions;

// This funtion takes a Int#(n), increments it and returns a Int#(n)
// In this version we use the function's name as the value to be returned

function Int#(n)  increment(Int#(n) value);
   increment = value + 1;
endfunction

// This function takes a Int#(n), decrements it and returns a Int#(n)
// In this version we use a 'return' statement instead of the function's name

function Int#(n)  decrement(Int#(n) value);
  return (value - 1);
endfunction

endpackage
