.global _Reset
_Reset:
	msr sctlr_el2, xzr
	msr hcr_el2, xzr

	mrs x0, scr_el3
	orr x0, x0, #(1<<10)
	orr x0, x0, #(1<<0)
	msr scr_el3, x0

	mov x0, #0b01001	// DAIF=0000 & m[3:0]=1001 el2
	msr spsr_el3, x0

	adr x0, EL2_ENTRY
	msr	elr_el3, x0
	eret

EL2_ENTRY:

    ldr x30, =stack_top	// setup stack
    mov sp, x30

	ldr x1, =exception_vec_table_el2
	msr vbar_el2, x1

	mrs x0, hcr_el2
	orr x0, x0, #(1<<5)
	orr x0, x0, #(1<<4)
	orr x0, x0, #(1<<3)
	msr hcr_el2, x0

	mov x0, #0x41000000
	br x0

    bl c_entry
