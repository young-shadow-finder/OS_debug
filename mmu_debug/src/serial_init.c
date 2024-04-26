#include "debug.h"

#define UART_BASE 0x09000000

#define UART_DR(base)   ((int *)(base + 0x00))
#define UART_FR(base)   ((int *)(base + 0x18))
#define UART_CR(base)   ((int *)(base + 0x30))
#define UART_IMSC(base) ((int *)(base + 0x38))
#define UART_ICR(base)  ((int *)(base + 0x44))

#define UARTFR_RXFE	 0x10
#define UARTFR_TXFF	 0x20
#define UARTIMSC_RXIM   0x10
#define UARTIMSC_TXIM   0x20
#define UARTICR_RXIC	0x10
#define UARTICR_TXIC	0x20

static int uart_putc(char c)
{
	struct hw_uart_device *uart;

	while (*UART_FR(UART_BASE) & UARTFR_TXFF);
	*UART_DR(UART_BASE) = c;

	return 1;
}

static int uart_getc(void)
{
	int ch;

	ch = -1;
	if (!(*UART_FR(UART_BASE) & UARTFR_RXFE))
	{
		ch = *UART_DR(UART_BASE) & 0xff;
	}

	return ch;
}

int serial_init(void)
{
	int ret = *UART_CR(UART_BASE);
	*UART_CR(UART_BASE) = (1 << 0) | (1 << 8) | (1 << 9);
	ret = *UART_CR(UART_BASE);
	uart_putc('m');
	uart_putc('m');
	uart_putc('u');
	uart_putc('_');
	uart_putc('d');
	uart_putc('e');
	uart_putc('b');
	uart_putc('u');
	uart_putc('g');
	uart_putc('\n');
	return 0;
}

void put_string(char *str, int len)
{
	for (int i = 0; i < len; i++) {
		uart_putc(str[i]);
	}
}