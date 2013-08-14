/*
 * Copyright (C) 2014 F4OS Authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

.globl _start
.globl _vectors
.section    .vector,"a"
_start:
_vectors:
    b       _reset
    b       _undefined_instruction
    b       _software_interrupt
    b       _prefetch_abort
    b       _data_abort
    b       _hypervisor_mode
    b       _irq
    b       _fiq

_reset:
    /* Set the vector table in VBAR */
    ldr     r0, =_vectors
    mcr     p15, 0, r0, c12, c0, 0

    /* Load stack pointer */
    ldr     sp, =CONFIG_INIT_STACK_POINTER

    /* Initialize C runtime */
    ldr     r0, =_bss_start
    ldr     r1, =_bss_end
    mov     r2, #0

clear_bss:
    cmp     r0, r1
    strlt   r2, [r0]
    addlt   r0, #4
    blt     clear_bss

#ifdef CONFIG_COPY_DATA
    ldr     r0, =_data_start
    ldr     r1, =_data_end
    ldr     r2, =_data_rom_start

copy_data:
    cmp     r0, r1
    ldrlt   r3, [r2]
    strlt   r3, [r0]
    addlt   r0, #4
    addlt   r2, #4
    blt     copy_data
#endif

    /* Good to go! */
    b       os_start

/* For now, all exceptions hang */
_undefined_instruction:
    b       .

_software_interrupt:
    b       .

_prefetch_abort:
    b       .

_data_abort:
    b       .

_hypervisor_mode:
    b       .

_irq:
    b       .

_fiq:
    b       .

.global     panic
.type       panic, %function
panic:
    b       .