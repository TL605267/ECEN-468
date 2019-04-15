module SRAM ( InData, OutData, Address, bCE, bWE );

    parameter AddressSize = 18;		// 2^18 = 256K
    parameter WordSize = 8;			// 8 bits

    // Port Declaration
    input  [AddressSize-1 : 0]	Address;
    input  [WordSize-1 : 0]		InData;
    input				bCE, bWE;
    output [WordSize-1 : 0]		OutData;

    // Internal Variable
    reg [WordSize-1 : 0] sram [262143: 0];
	reg [WordSize-1 : 0] OutData;
    // Function Read
    always @(bCE or bWE or Address) begin
        if (!bCE && bWE)
            OutData <= sram[Address];
    end

    // Function Write
    always @(bCE or bWE or Address or InData) begin
        if (!bCE && !bWE)
            sram[Address] <= InData;
    end

endmodule
