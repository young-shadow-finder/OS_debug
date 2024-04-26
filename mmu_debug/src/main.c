#include "debug.h"

/*
 * This case show case no mmu
 * no mmu, every addr is phy addr, run well
 */
static void mmu_test_case_0(void)
{
	unsigned long ret;
//	asm volatile("mrs %0, SCTLR_EL1" :: "r"(ret));
//	ret |= 0x1;
//	asm volatile("msr SCTLR_EL1, %0" :: "r"(ret));

	put_string("enbale mmu over", strlen("enbale mmu over"));
}

/*
 * This case show case enable mmu without any other config
 * after enable mmu, every addr will become virt addr, but no mmu config, run failed
 */
static void mmu_test_case_1(void)
{
	unsigned long ret;

	asm volatile("mrs %0, SCTLR_EL1" :: "r"(ret));
	ret |= 0x1;
	asm volatile("msr SCTLR_EL1, %0" :: "r"(ret));

	put_string("enbale mmu over", strlen("enbale mmu over"));
}

/*
 * This case show config and pagetable config before enable mmu
 */
#define MEM_SIZE 0x8000000
#define MEM_START 0x40000000

#define PAGE_4K_SHIFT		12
#define PAGE_SIZE			(1 << PAGE_4K_SHIFT)
#define PAGE_MASK      (PAGE_SIZE - 1)
#define MMU_TBL_PAGE_4k_LEVEL 3

#define MMU_ADDRESS_BITS 39
#define MMU_LEVEL_MASK	0x1FFUL

static volatile unsigned long mmu_index[1] __attribute__((aligned(4 * 1024)));
static volatile unsigned long mmu_table_1[2][4096] __attribute__((aligned(4 * 1024)));
static volatile unsigned long mmu_table_2[64][4096] __attribute__((aligned(4 * 1024)));
static volatile unsigned long mmu_table_3[64][4096] __attribute__((aligned(4 * 1024)));

static volatile unsigned long mmu2_index[1] __attribute__((aligned(4 * 1024)));
static volatile unsigned long mmu2_table_1[2] __attribute__((aligned(4 * 1024)));
static volatile unsigned long mmu2_table_2[64] __attribute__((aligned(4 * 1024)));


#define MMU_TYPE_BLOCK 1UL
#define MMU_TYPE_TABLE 3UL

static void val_check_set_table(unsigned long *index, unsigned long *val)
{
	int ret = 1;
	if (*index == 0) {
		*index = ((unsigned long)(val) | MMU_TYPE_TABLE);
	} else if (*index != ((unsigned long)(val) | MMU_TYPE_TABLE)) {
		while(ret);
	}
}

#define MASK_ATTR 0x600
//#define MASK_ATTR (0)

static void val_check_set_block(unsigned long *index, unsigned long *val)
{
	int ret = 1;

	if (*index == 0) {
		*index = ((unsigned long)(val) | MMU_TYPE_BLOCK | MASK_ATTR);
	} else if (*index != ((unsigned long)(val) | MMU_TYPE_BLOCK | MASK_ATTR)) {
		while(ret);
	}
}

static int kernel_mem_map_4k(void *pa, void *va)
{
	uint64_t v = (uint64_t)(va);
	int i0,i1,i2,i3;

	i0 = (v >> 39) & MMU_LEVEL_MASK;
	i1 = (v >> 30) & MMU_LEVEL_MASK;
	i2 = (v >> 21) & MMU_LEVEL_MASK;
	i3 = (v >> 12) & MMU_LEVEL_MASK;
	val_check_set_table((unsigned long *)(&mmu_index[i0]), (unsigned long *)(&mmu_table_1[i0][0]));
	val_check_set_table((unsigned long *)(&mmu_table_1[i0][i1]), (unsigned long *)(&mmu_table_2[i1][0]));
	val_check_set_table((unsigned long *)(&mmu_table_2[i1][i2]), (unsigned long *)(&mmu_table_3[i2][0]));
	val_check_set_block((unsigned long *)(&mmu_table_3[i2][i3]), (unsigned long *)(pa));

//	val_check_set_table((unsigned long *)(&mmu2_index[i0]), (unsigned long *)(&mmu2_table_1[0]));
//	val_check_set_table((unsigned long *)(&mmu2_table_1[i1]), (unsigned long *)(&mmu2_table_2[0]));
//	val_check_set_block((unsigned long *)(&mmu2_table_2[i2]), (unsigned long *)(pa));

}

static void mmu_test_case_3(void)
{
	unsigned long ret;
	unsigned long val64;
	unsigned long pa_range;

	int si = (0x1 << 21);

	/*全部设置为普通内存*/
    val64 = 0x00447FUL;
    __asm__ volatile("msr MAIR_EL1, %0\n dsb sy\n" ::"r"(val64));

    /*只读寄存器*/
    __asm__ volatile ("mrs %0, ID_AA64MMFR0_EL1":"=r"(val64));
    pa_range = val64 & 0xf; /* PARange */

	for (int s = 0; s < MEM_SIZE; s+=4096) {
		kernel_mem_map_4k((void *)(MEM_START + s), (void *)(MEM_START + s));
	}

	__asm__ volatile("msr ttbr0_el1, %0" ::"r"((uint64_t)(&mmu_index[0])) : "memory");
//	__asm__ volatile("msr ttbr1_el1, %0" ::"r"((uint64_t)(&mmu_index[0])) : "memory");
	asm volatile("dsb sy");

	val64 = (16UL << 0)                /* t0sz 48bit */
            | (0x0UL << 6)             /* reserved */
            | (0x0UL << 7)             /* epd0 */
            | (0x3UL << 8)             /* t0 wb cacheable */
            | (0x3UL << 10)            /* inner shareable */
            | (0x2UL << 12)            /* t0 outer shareable */
            | (0x0UL << 14)            /* t0 4K */
            | (16UL << 16)             /* t1sz 48bit */
            | (0x0UL << 22)            /* define asid use ttbr0.asid */
            | (0x0UL << 23)            /* epd1 */
            | (0x3UL << 24)            /* t1 inner wb cacheable */
            | (0x3UL << 26)            /* t1 outer wb cacheable */
            | (0x2UL << 28)            /* t1 outer shareable */
            | (0x2UL << 30)            /* t1 4k */
            | (pa_range << 32)         /* PA range */
            | (0x0UL << 35)            /* reserved */
            | (0x1UL << 36)            /* as: 0:8bit 1:16bit */
            | (((uint64_t)(0)) << 37)  /* tbi0 */
            | (((uint64_t)(0)) << 38); /* tbi1 */
    __asm__ volatile("msr TCR_EL1, %0\n" ::"r"(val64));

//c51825
	asm volatile("dsb     ish");
    asm volatile("isb");
    asm volatile("ic      ialluis");
    asm volatile("dsb     ish");
    asm volatile("isb");
    asm volatile("tlbi    vmalle1");
    asm volatile("dsb     ish");
    asm volatile("isb");
	asm volatile("mrs %0, SCTLR_EL1":"=r"(val64));
	val64 |= (0x1 << 12) | (0x1 << 2) | (0x1);
	asm volatile("msr SCTLR_EL1, %0" :: "r"(val64));
	asm volatile("mrs x3, CurrentEL");
	put_string("enbale mmu over", strlen("enbale mmu over"));
}

void mmu_debug_start(void)
{
	int test_case = 0;

	mmu_test_case_3();
}