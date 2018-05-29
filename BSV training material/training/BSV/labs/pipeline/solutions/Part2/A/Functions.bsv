/*  Copyright Bluespec Inc. 2005-2008  */

package Functions;

// This funtion takes a Int#(16), increments it and returns a Int#(16)
// In this version we use the function's name as the value to be returned

function Int#(16)  increment(Int#(16) value);
   increment = value + 1;
endfunction

// This function takes a Int#(16), decrements it and returns a Int#(16)
// In this version we use a 'return' statement instead of the function's name

function Int#(16)  decrement(Int#(16) value);
  return (value - 1);
endfunction

endpackage
