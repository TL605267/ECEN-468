// Including files
`include "Control_Unit.v"
`include "Datapath_Unit.v"

// Module Definition
module UART_XMTR(Serial_out, Data_Bus, Load_XMT_datareg, Byte_ready, T_byte, Clock, rst_b);

	// Internal parameter
	parameter word_size = 8;			// size of data, e.g., 8 bits

	// Declare input/output ports
	// Declare internal wires
    output Serial_out;

    input       Load_XMT_datareg;
    input       Byte_ready;
    input       T_byte;
    input       rst_b;
    input       Clock;
    input [7:0] Data_Bus;

    wire        Load_XMT_DR, Load_XMT_shftreg, start, shift, clear, BC_lt_BCmax;

	// Connect Sub modules
	// a. Connect Control_Unit
    Control_Unit control_unit(  Load_XMT_DR,
                                Load_XMT_shftreg,
                                start,
                                shift,
                                clear,

                                Load_XMT_datareg,
                                Byte_ready,
                                T_byte,
                                BC_lt_BCmax,
                                Clock,
                                rst_b);
	// b. Connect Datapath_Unit
    Datapath_Unit datapath_unit(Serial_out,
                                BC_lt_BCmax,
                                Data_Bus,
                                Load_XMT_DR,
                                Load_XMT_shftreg,
                                start,
                                shift,
                                clear,
                                Clock,
                                rst_b);
endmodule
