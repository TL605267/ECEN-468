task Send_Pixel_to_Mem;
	input [7:0] i;
	input [7:0] j;
	input [7:0] data_in;
	input [31:0] dOffset;
	begin
		bWE = 0;	        // Write Mode
		bCE = 1;			// Chip Disable
		dAddr = dOffset+(i*dWidth+j);
		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
		// WRITE TO MEMORY
		force DataBus = data_in;   force AddrBus = AddressOut;
		// Write Operation
		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
		#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
		#20;
	end
endtask

task Read_Pixel_from_Mem;
	input [7:0] i;
	input [7:0] j;
	input [31:0] dOffset;
    output [7:0] data_out;

	begin
		bWE = 1;	        // Read Mode
		bCE = 1;			// Chip Disable
		dAddr = dOffset+(i*dWidth+j);
		AddressOut = (IDMEM << 28)+(bCE << 19)+(bWE << 18)+dAddr;
		// WRITE TO MEMORY
		force AddrBus = AddressOut;
		// Write Operation
		#20 force AddrBus = AddressOut & ~(1<<`IDX_MEM_bCE);   //bCE = 0;
		#20 force data_out = DataBus;
		#20 force AddrBus = AddressOut | (1<<`IDX_MEM_bCE);    //bCE = 1;
		#20;
	end
endtask

task release_databus;
	begin
		#20 force DataBus = 8'hzz;
			force AddrBus = 32'h0000_0000;
		#20 release DataBus;
			release AddrBus;
	end
endtask

task SendUART;
	input [7:0] msg;
	begin
		#20 force DataBus = 8'hzz;
			force AddrBus = 32'h0000_0000;
		#20 release DataBus;
			release AddrBus;
			force AddrBus = 32'h2000_0000;
		#20 force DataBus = msg;
			force AddrBus = 32'h2000_0001;
		#20 force DataBus = 8'hzz;
			force AddrBus = 32'h2000_0002;
		#20 force AddrBus = 32'h20000004;
		#40;
	end
endtask

task Init_to_Mem;
	begin
		bWE = 0;
		bCE = 1;
		dAddr = 0;
		AddressOut = (IDMEM << 28)
					+(bCE << 19)
					+(bWE << 18)
					+dAddr;
		release DataBus;
		force AddrBus = AddressOut;
		#60;
	end
endtask

task Init_to_Canny;
	begin
		bWE = 0;
		bCE = 1;
		bOPEnable = 1;
		AddressOut = (IDCANNY << 28)+(bOPEnable << 27)+(OPMode << 24)+(dWriteReg << 20)+(dReadReg << 16)+(1<<5)+(1<<2)+(bWE<<1)+bCE;
		release DataBus;
		force AddrBus = AddressOut; #60;
		bWE = 0;
		bCE = 1;
		bOPEnable = 1;
	end
endtask

/*task Send_3x3_block_to_Canny;
	input 	[7:0] 	data_in[0:9];
	input 			dWriteReg_in;
	input 			OPMode_in;
	begin
 		for(k=0; k<3; k=k+1)   begin
     		for(l=0; l<3; l=l+1)   begin
         		force DataBus = data_in[k*3+l];
         		AddressOut = (IDCANNY		<< 28)
							+(bOPEnable 	<< 27)
 							+(OPMode_in		<< 24)
 							+(dWriteReg_in	<< 20)
 							+(dReadReg		<< 16)
 							+(k				<< 5)
 							+(l				<< 2)
 							+(bWE			<< 1)
 							+bCE;
         		force AddrBus = AddressOut;
         		#20 force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bCE);   //bCE = 0;
         		#20 force AddrBus = AddressOut | (1<<`IDX_CANNY_bCE);    //bCE = 1;
     		end
 		end
	end
endtask
*/
task Canny_OPEnable;
	begin
		#20	force AddrBus = AddressOut & ~(1<<`IDX_CANNY_bOPEnable);   //bOPEnable = 0;
		#80	force AddrBus = AddressOut | (1<<`IDX_CANNY_bOPEnable);    //bOPEnable = 1;
	end
endtask
