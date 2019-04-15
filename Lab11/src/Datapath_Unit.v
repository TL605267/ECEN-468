// Module Definition
module Datapath_Unit (
	Serial_out,
	BC_lt_BCmax,
	Data_Bus,
	Load_XMT_DR,
	Load_XMT_shftreg,
	start,
	shift,
	clear,
	Clock,
	rst_b);

	// Declare internal parameters
	parameter		word_size = 8;
	parameter		size_bit_count = 3;
	parameter		all_ones = {(word_size + 1){1'b1}};	// 9 bits of ones

	// Declare input/output
	output Serial_out;
	output BC_lt_BCmax;

	input [word_size-1:0]  Data_Bus;
	input                  Load_XMT_DR;
	input                  Load_XMT_shftreg;
	input                  start;
	input                  shift;
	input                  clear;
	input                  Clock;
	input                  rst_b;

	// Declare internal reg variable
	reg [word_size-1:0]    XMT_datareg;	// Transmit Data Register
	reg [word_size:0]      XMT_shftreg;	// Transmit Shift Register:{data, start bit}
	reg [size_bit_count:0] bit_count;	// Counts the bits that are transmitted

	assign Serial_out = XMT_shftreg[0];

	// Connect your UDP (User Defined Primitive)
	// Insert your code here.
    /*cmp cmp1(   BC_lt_BCmax,
                bit_count[0],
                bit_count[1],
                bit_count[2],
                bit_count[3]);
    */
    assign BC_lt_BCmax = (bit_count < word_size + 1);
    // Data Path for UART Transmitter
	always @(posedge Clock or negedge rst_b)
	begin
        if (!rst_b) begin
            //BC_lt_BCmax <= 1'b1;
            XMT_shftreg <= all_ones;
            bit_count   <= 4'b0;
        end
        else begin
            if (Load_XMT_DR)        XMT_datareg     <= Data_Bus;
            if (start)              XMT_shftreg[0]  <= 1'b0;
            if (clear)              bit_count       <= 4'b0000;
            if (Load_XMT_shftreg)   XMT_shftreg     <= {XMT_datareg, 1'b1};
            if (shift) begin
                XMT_shftreg <= {1'b1, XMT_shftreg[8:1]};
                bit_count <= bit_count + 1;
            end
        end
	end
endmodule

// UDP (User Defined Primitive)
/*In this lab, we will design comparing block to generate signal BC_lt_BCmax
using UDP. The signal BC_lt_BCmax should be ‘1’ if bit_count is less than 9
which is the maximum number of bits transmitted, otherwise ‘0’. Please put
output port as a first variable.*/
/*primitive cmp (
    BC_lt_BCmax,
    bit_count_0, // bit 0 of bit_count
    bit_count_1, // bit 1 of bit_count
    bit_count_2, // bit 2 of bit_count
    bit_count_3 // bit 3 of bit_count
);
    // In/Out declaration
    output BC_lt_BCmax;
    input  bit_count_0; // bit 0 of bit_count
    input  bit_count_1; // bit 1 of bit_count
    input  bit_count_2; // bit 2 of bit_count
    input  bit_count_3; // bit 3 of bit_count

    // UDP function code here
    table
        // B C : A
        0 ? ? ? : 1; // anything less than 7, output = 0
        ? ? ? 0 : 1; // anything even, output = 0 (bit is counted one by one)
        1 0 0 1 : 0; // when reaching 9, output = 1
    endtable
endprimitive
*/
