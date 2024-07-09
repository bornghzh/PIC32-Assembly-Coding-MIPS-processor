#include <xc.h>
#include "configbits.c"
    
    .global main

.ent main
main:
    la t0, ANSELA                 //setting A and B to analog mode
    sw $0, 0(t0)
    la t0, ANSELB
    sw $0, 0(t0)
    
    la t0, TRISA                  //A0 is input and B8 is output
    addi t1, zero, 0x0001
    sw t1, 0(t0)
    la t0, TRISB
    addi t1, zero, 0x00ff
    sw t1, 0(t0)
    
    la a0, PORTA                  //reading A0 and writing in B8
    la a1, LATB
    and v0, $0, $0                //v0 contains LED information. we assume its inital state is off.
    addi a2, zero, 0x0100         //used for flipping the state of LED
    
    loop:
	lw s0, 0(a0)
	andi s0, s0, 0x0001
	beq s0, $0, update
	    xor v0, v0, a2        //flipping the RB8 bit
	update:
	sw v0, 0(a1)
    j loop

.end main