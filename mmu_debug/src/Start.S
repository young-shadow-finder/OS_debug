.global _start
_start:
	// 关闭所有中断
//	msr daifset, #0xf
	// 默认启动在EL1
	mrs x3, CurrentEL
	// 当前是哪个核
	mrs x4, MPIDR_EL1

	// 设置栈指针
	ldr x1, =0x47000000
	mov sp, x1

	// 调用C函数
	bl serial_init

	bl mmu_debug_start

	// 无限循环
1:  b 1b
