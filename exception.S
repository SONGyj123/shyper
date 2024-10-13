

.macro save_regs exception_type
	sub sp, sp, (32+4)*8		// stack grow 32×8byte(32*64bits=32regs)
	stp x0, x1, [sp, 16*0]	// sp is not changing
	stp x2, x3, [sp, 16*1]
	stp x4, x5, [sp, 16*2]
	stp x6, x7, [sp, 16*3]
	stp x8, x9, [sp, 16*4]
	stp x10, x11, [sp, 16*5]
	stp x12, x13, [sp, 16*6]
	stp x14, x15, [sp, 16*7]
	stp x16, x17, [sp, 16*8]
	stp x18, x19, [sp, 16*9]
	stp x20, x21, [sp, 16*10]
	stp x22, x23, [sp, 16*11]
	stp x24, x25, [sp, 16*12]
	stp x26, x27, [sp, 16*13]
	stp x28, x29, [sp, 16*14]

	mrs x1, sp_el1
	stp x30, x1, [sp, 16*15]

	mrs x1, elr_el2			// pc addr
	mrs x2, spsr_el2		// PSTATE val
	stp x1, x2, [sp, 16*16]

	mrs x1, esr_el2
	mov x2, \exception_type
	stp x1, x2, [sp, 16*17]

	add x0, sp, #0			// pass the stack frame
.endm

.macro restore_regs
	add sp, sp, (30*8)
	ldp x30, x1, [sp], 16
	msr sp_el1, x1
	ldp x0, x1, [sp], 16
	msr elr_el2, x0
	msr spsr_el2, x0
	ldp x0, x1, [sp], 16
	msr esr_el2, x0

	sub sp, sp, (32+4)*8
	ldp x28, x29, [sp], 16
	ldp x26, x27, [sp], 16
	ldp x24, x25, [sp], 16
	ldp x22, x23, [sp], 16
	ldp x20, x21, [sp], 16
	ldp x18, x19, [sp], 16
	ldp x16, x17, [sp], 16
	ldp x14, x15, [sp], 16
	ldp x12, x13, [sp], 16
	ldp x10, x11, [sp], 16
	ldp x8, x9, [sp], 16
	ldp x6, x7, [sp], 16
	ldp x4, x5, [sp], 16
	ldp x2, x3, [sp], 16
	ldp x0, x1, [sp], 16

	add sp, sp, 6*8

	eret
.endm


.align 11
.global exception_vec_table_el2
exception_vec_table_el2:
	// exception from current EL
	// using SP_EL0
	.align 7
	b cur_el_sp_el0_sync
	.align 7
	b cur_el_sp_el0_irq
	.align 7
	b cur_el_sp_el0_fiq
	.align 7
	b cur_el_sp_el0_serror

	// exception from current EL
	// using SP_ELx
	.align 7
	b cur_el_sp_elx_sync
	.align 7
	b cur_el_sp_elx_irq
	.align 7
	b cur_el_sp_elx_fiq
	.align 7
	b cur_el_sp_elx_serror

	// exception from lower EL
	// at least one lower EL is aarch64
	.align 7
	b low_el_sp_el0_sync
	.align 7
	b low_el_sp_el0_irq
	.align 7
	b low_el_sp_el0_fiq
	.align 7
	b low_el_sp_el0_serror

	// exception from lower EL
	// all lower EL is aarch32
	.align 7
	b low_el_sp_elx_sync
	.align 7
	b low_el_sp_elx_irq
	.align 7
	b low_el_sp_elx_fiq
	.align 7
	b low_el_sp_elx_serror

cur_el_sp_el0_sync:
	save_regs 0
	b exception_handler_el2
	restore_regs
cur_el_sp_el0_irq:
	save_regs 1
	b exception_handler_el2
	restore_regs
cur_el_sp_el0_fiq:
	save_regs 2
	b exception_handler_el2
	restore_regs
cur_el_sp_el0_serror:
	save_regs 3
	b exception_handler_el2
	restore_regs

cur_el_sp_elx_sync:
	save_regs 4
	b exception_handler_el2
	restore_regs
cur_el_sp_elx_irq:
	save_regs 5
	b exception_handler_el2
	restore_regs
cur_el_sp_elx_fiq:
	save_regs 6
	b exception_handler_el2
	restore_regs
cur_el_sp_elx_serror:
	save_regs 7
	b exception_handler_el2
	restore_regs

low_el_sp_el0_sync:
	save_regs 8
	b exception_handler_el2
	restore_regs
low_el_sp_el0_irq:
	save_regs 9
	b exception_handler_el2
	restore_regs
low_el_sp_el0_fiq:
	save_regs 10
	b exception_handler_el2
	restore_regs
low_el_sp_el0_serror:
	save_regs 11
	b exception_handler_el2
	restore_regs

low_el_sp_elx_sync:
	save_regs 12
	b exception_handler_el2
	restore_regs
low_el_sp_elx_irq:
	save_regs 13
	b exception_handler_el2
	restore_regs
low_el_sp_elx_fiq:
	save_regs 14
	b exception_handler_el2
	restore_regs
low_el_sp_elx_serror:
	save_regs 15
	b exception_handler_el2
	restore_regs
