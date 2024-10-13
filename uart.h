#ifndef __UART_H
#define __UART_H

#define UART_BASE	0x00000000

typedef unsigned int uint32;
typedef unsigned long uint64;

#define read_reg32(addr)	(*(volatile uint32 *)(addr))
#define write_reg32(addr, val)	(*(volatile uint32 *)(addr) = val)

typedef struct PL011
{
	uint64 base_addr;
	uint32 clk;
	uint32 baudrate;
	uint32 data_bits;
	uint32 stop_bits;
}PL011;

void uart_init(PL011 *dev);

#endif
