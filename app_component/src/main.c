#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xtmrctr.h"
#include "sleep.h"

#define AES_BASE_ADDR XPAR_MYIP_0_BASEADDR

// Key registers
#define REG_KEY_0 (AES_BASE_ADDR + 0x00)
#define REG_KEY_1 (AES_BASE_ADDR + 0x04)
#define REG_KEY_2 (AES_BASE_ADDR + 0x08)
#define REG_KEY_3 (AES_BASE_ADDR + 0x0C)

// Plaintext register
#define REG_TEXT_0 (AES_BASE_ADDR + 0x10)
#define REG_TEXT_1 (AES_BASE_ADDR + 0x14)
#define REG_TEXT_2 (AES_BASE_ADDR + 0x18)
#define REG_TEXT_3 (AES_BASE_ADDR + 0x1C)

// Start register
#define REG_START (AES_BASE_ADDR + 0x20)

// Ciphertext register
#define REG_OUT_0 (AES_BASE_ADDR + 0x24)
#define REG_OUT_1 (AES_BASE_ADDR + 0x28)
#define REG_OUT_2 (AES_BASE_ADDR + 0x2C)
#define REG_OUT_3 (AES_BASE_ADDR + 0x30)

// Valid register
#define REG_VALID     (AES_BASE_ADDR + 0x34)

// AXI Timer
#define TIMER_DEVICE_ID XPAR_XTMRCTR_0_BASEADDR
#define TIMER_CLOCK_FREQ_HZ XPAR_XTMRCTR_0_CLOCK_FREQUENCY

#define BENCH_ITERATIONS 10000

static int aes_encrypt_block(int wait_timeout)
{
    Xil_Out32(REG_KEY_0, 0x2b7e1516);
    Xil_Out32(REG_KEY_1, 0x28aed2a6);
    Xil_Out32(REG_KEY_2, 0xabf71588);
    Xil_Out32(REG_KEY_3, 0x09cf4f3c);

    Xil_Out32(REG_TEXT_0, 0x3243f6a8);
    Xil_Out32(REG_TEXT_1, 0x885a308d);
    Xil_Out32(REG_TEXT_2, 0x313198a2);
    Xil_Out32(REG_TEXT_3, 0xe0370734);

    Xil_Out32(REG_START, 0x00000001);
    Xil_Out32(REG_START, 0x00000000);

    u32 valid_status = 0;
    int timeout = 0;
    
    while ((valid_status & 0x01) == 0)
    {
        valid_status = Xil_In32(REG_VALID);
        timeout++;
        if (wait_timeout && timeout > 1000000)
        {
            return 0;
        }
    }
    return 1;
}

static void run_functional_test(void)
{
    if (!aes_encrypt_block(1))
    {
        xil_printf("ERROR: Timeout. Valid is not 1.\r\n");
        return;
    }

    u32 c0 = Xil_In32(REG_OUT_0);
    u32 c1 = Xil_In32(REG_OUT_1);
    u32 c2 = Xil_In32(REG_OUT_2);
    u32 c3 = Xil_In32(REG_OUT_3);

    xil_printf("\r\n >>> PASS. Encryption complete <<<\r\n");
    xil_printf("Encrypted text (Ciphertext):\r\n");
    xil_printf("HEX: %08X %08X %08X %08X\r\n", c0, c1, c2, c3);
}

static void run_speed_benchmark(void)
{
    XTmrCtr timer;
    int status;

    status = XTmrCtr_Initialize(&timer, TIMER_DEVICE_ID);
    if (status != XST_SUCCESS)
    {
        xil_printf("ERROR: Failed to initialize AXI Timer (ID=%d).\r\n", TIMER_DEVICE_ID);
        return;
    }

    volatile u32 sink = 0;

    xil_printf("\r\n[Benchmark] %d blocks of 128 bit...\r\n", BENCH_ITERATIONS);

    XTmrCtr_Reset(&timer, 0);
    XTmrCtr_Start(&timer, 0);

    for (int i = 0; i < BENCH_ITERATIONS; i++)
    {
        aes_encrypt_block(0);
        sink ^= Xil_In32(REG_OUT_0);
    }

    u32 ticks = XTmrCtr_GetValue(&timer, 0);
    XTmrCtr_Stop(&timer, 0);

    u64 total_ns = ((u64)ticks * 1000000000ULL) / (u64)TIMER_CLOCK_FREQ_HZ;
    u64 per_block_ns = total_ns / (u64)BENCH_ITERATIONS;

    u64 total_us = total_ns / 1000ULL;
    if (total_us == 0) total_us = 1;

    u64 throughput_kbps = ((u64)128 * (u64)BENCH_ITERATIONS * 1000ULL) / total_us;

    xil_printf("Timer clock:             %u (Fclk = %u Hz)\r\n", (u32)ticks, (u32)TIMER_CLOCK_FREQ_HZ);
    xil_printf("Total time:              %u μs\r\n", (u32)total_us);
    xil_printf("Average time per block:  %u ns\r\n", (u32)per_block_ns);
    xil_printf("Bandwidth:   %u Kbit/s (~%u Mbit/s)\r\n", (u32)throughput_kbps, (u32)(throughput_kbps / 1000));
}

int main() {
    xil_printf("\r\n=========================================\r\n");
    xil_printf("  Running the AES-128 hardware test (JTAG)  \r\n");
    xil_printf("=========================================\r\n");

    run_functional_test();
    run_speed_benchmark();

    xil_printf("=========================================\r\n");
    return 0;
}