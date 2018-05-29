package peaks;
	import BRAMCore ::*;
	import FixedPoint ::*;
	import Vector ::*;

		Vector#(100, FixedPoint#(8,32)) corr_data;

		FixedPoint#(8,32) max1_current = 0;
		FixedPoint#(8,32) max2_current = 0;
		FixedPoint#(8,32) max1_previous = 0;
		FixedPoint#(8,32) max2_previous = 0;
		
		for(Integer i = 0; i < 100; i = i + 1)
		begin
			corr_data[i] = max1_current + 1;	
			max1_current = max1_current + 1;
		end
		corr_data[80] = 250;
		corr_data[50] = 200; 

		max1_current = 0;

		Integer max1_current_index = 0;
		Integer max2_current_index = 0;
		Integer max1_previous_index = 0;
		Integer max2_previous_index = 0;

		function Bool inrange(Integer i, Integer j)
			Bool status;
			if(abs(i-j)<=10)
				status = True;
			else 
				status = False
			return status
		endfunction

		function compare_peaks(Empty);
			max1_current_index = max(max1_current_index,max1_previous_index);
			Integer temp = max(max2_current_index,max2_previous_index);
			
			if(inrange(max1_current_index,max1_previous_index) == True)
				max2_current_index = temp;
			else if(inrange(max1_current_index,max1_previous_index == False)
				max2_current_index = max(temp, min(max1_current_index,max1_previous_index));

	 		max1_current = corr_data[max1_current_index];
	 		max2_current = corr_data[max2_current_index];
	 		max1_previous = corr_data[max1_previous_index];
	 		max2_previous = corr_data[max2_previous_index];
		endfunction

		function FixedPoint#(8,32) findMax (Vector#(100, FixedPoint#(8,32)) corr_data)
			FixedPoint#(8,32)
			for (Integer i = 0; i < 100; i = i + 1)
			begin

			end
		endfunction

	module compare_peaks(Empty);

	endmodule 
endpackage