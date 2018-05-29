package Adder;

// Bluespec wrapper, created by Import BVI Wizard
// Created on: Tue May 17 12:10:00 IST 2016
// Created by: nsharma
// Bluespec version: 2015.09.beta2 2015-09-07 34689
// Hand-edited to merge methods and simplify schedules

import Adder_IFC :: *;

import "BVI" adder =
module mkAdder (Adder_IFC);

	default_clock clk_Cclk;
	default_reset rst_Rstn;

	input_clock clk_Cclk (Cclk)  <- exposeCurrentClock;
	input_reset rst_Rstn (Rstn) clocked_by(clk_Cclk)  <- exposeCurrentReset;


	method in (A, B /*{[31:0]}*/)
	   ready (Ack)
	   enable (Req)
	   clocked_by (clk_Cclk)
	   reset_by (rst_Rstn);

	method Sum out ()
	   ready (Ack)
	   clocked_by (clk_Cclk)
	   reset_by (rst_Rstn);

	schedule in C in;
	schedule out CF in;
	schedule out CF out;
endmodule

endpackage
