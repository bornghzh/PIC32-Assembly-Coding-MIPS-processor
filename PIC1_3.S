#include <xc.h>
#include "configbits.c"
    
    .global main

.ent main
main:
    la t0, ANSELB
    sw zero, 0(t0)    //setting port B to digital mode
    
    la t0, TRISB
    addi t1, zero, 0x00ff
    sw t1, 0(t0)      //setting RB{15:8] as output and RB[7:0] as input
    
    la a0, PORTB
    la a1, LATB       //storing the address of ports read and write data
    
    loop:
	lw s0, 0(a0)
	addu s1, zero, s0
	andi s1, s1, 0x000f       // $s1 stores the fisrt number
	srl s2, s0, 4
	andi s2, s2, 0x000f       // $s2 stores the second number
	
	addu v0, s1, s2           // $v0 stores the sum

	addi t0, zero, 0x000a     // $t0 stores 10
	divu $0, v0, t0
	mflo s3
	sll a2, s3, 4             // now $a2[7:4] contains MSB BCD of result
	multu s3, t0         
	mflo t1
	subu t2, v0, t1           // $t2 contains the LSB BCD of result
	addu a2, a2, t2           // now $a2[7:0] contains the output
	
	sll a2, a2, 8
	sw a2, 0(a1)              // now LATB contains output
    j loop
    
.end main