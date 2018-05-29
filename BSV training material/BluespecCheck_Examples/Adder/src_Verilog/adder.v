module cadd (
   input        Ci,
   input  [7:0] A,
   input  [7:0] B,
   output [7:0] Sum,
   output       Co
   );
   assign {Co, Sum} = A + B + Ci;
endmodule

module adder(
   input  [31:0] A,
   input  [31:0] B,
   input         Req,
   output        Ack,
   output [31:0] Sum,
   input         Cclk,
   input         Rstn
   );
   reg           Ackr;
   reg    [31:0] Sumr;
   reg     [7:0] Ai, Bi;
   reg           Ci;
   wire          Co;
   wire    [7:0] So;
   reg     [2:0] cycles, count, bytes;
   reg    [31:0] Areg, Breg;
   reg           busy, Req_d;

   cadd shared_adder (Ci, Ai, Bi, So, Co);

   assign Sum = Sumr;
   assign Ack = ~Ackr;

   always @(A or B) begin
       if      (|{A[31:24], B[31:24], A[23:16], B[23:16], A[15:8], B[15:8]} == 0) bytes <= 1;
       else if (|{A[31:24], B[31:24], A[23:16], B[23:16]} == 0) bytes <= 2;
       else if (|{A[31:24], B[31:24]} == 0) bytes <= 3;
       else bytes = 4;
   end

   always @(A or B) begin
       if      (|{A[31:24], B[31:24], A[23:16], B[23:16], A[15:8], B[15:8]} == 0) bytes <= 1;
       else if (|{A[31:24], B[31:24], A[23:16], B[23:16]} == 0) bytes <= 2;
       else if (|{A[31:24], B[31:24]} == 0) bytes <= 3;
       else bytes = 4;
   end

   always @(posedge Cclk) begin
       if (Rstn == 0) begin
          cycles <= 1;
	  Ackr   <= 0;
	  Sumr   <= 0;
       end

       else begin /* if not in reset */
	  Req_d <= Req;
	  if (Req_d == 0 && Req == 1) begin
             Ackr <= 1;
             Areg <= A;
             Breg <= B;
             Ai <= A[7:0];
             Bi <= B[7:0];
             Ci <= 0;
             busy  <= 1;
             count <= 1;   /* if count == i at the rising edge of clk the i'th Sum byte is done and ready to be       registered */
             if (bytes == 1) cycles <= 1;
             else if (bytes == 2) cycles <= 2;
             else if (bytes == 3) cycles <= 3;
             else if (bytes == 4) cycles <= 4;
	  end /* if (Req_d == 0 && Req == 1) */

	  if (busy) begin
             if (count < cycles) begin
		if (count == 1) begin
		   Ai <= Areg[15:8];
		   Bi <= Breg[15:8];
		   Ci <= Co;
		end
		if (count == 2) begin
		   Ai <= Areg[23:16];
		   Bi <= Breg[23:16];
		   Ci <= Co;
		end
		if (count == 3) begin
		   Ai <= Areg[31:24];
		   Bi <= Breg[31:24];
		   Ci <= Co;
		end
             end

	     if (count <= cycles) begin
		if (count == 1) begin
		   Sumr[8:0]  <= {Co,So};
		   Sumr[31:9] <= 0;
		end
		else if (count == 2)  Sumr[16:8]  <= {Co,So};
		else if (count == 3)  Sumr[24:16] <= {Co,So};
		else if (count == 4)  Sumr[31:24] <= So;
             end

             if (count == cycles) begin
		busy <= 0;
		count <= 1;
		Ackr <= 0;
             end
             else count <= count + 1;
	  end /* if(busy) */
       end /* else - if not in reset */
    end /* always @(posedge Cclk) */
endmodule
