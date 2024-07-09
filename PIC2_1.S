#include <xc.h>
#include "configbits.c"
    
    .global main

.data
    student_ID:
    .word 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x6, 0x5, 0x3
    segments:
    .word 0x13f, 0x106, 0x15B, 0x14f, 0x166, 0x16d, 0x17d, 0x107, 0x17f, 0x16f
.text 
    
.ent main
main:
    
    la t0, ANSELB         //setting B to digital mode
    sw $0, 0(t0)
    
    la t0, TRISB          //setting B to output mode
    sw $0, 0(t0)          
    
    la v1, LATB           //stores 7-segment output
    
    addi a0, zero, 0x0020     //number of digits: 9
    addi a1, zero, 0x0000         //the digit counter initialization
    add a2, zero, zero        //the pulse counter initialization
    
    la s0, student_ID
    la s1, segments
    addi s2, zero, 0x0004            //stores number 4 for byte address conversion
    lui s3, 0x0007                   //stores 1 million in order to count clock pulses
    
    loop:
    //output check
	add t0, s0, a1               //loading the corresponding digit of student ID
	lw v0, 0(t0)		     //storing the digit
	multu v0, s2
	mflo v0			     //storing the digit multiplied by 4
	add t0, s1, v0               //finding the corresponding 7 segment output
	lw s4, 0(t0)
	sw s4, 0(v1)
	
    //counter check 
	beq a2, s3, nextDigit
	    addiu a2, a2, 0x0001
	    j loop
	nextDigit:
	    addu a2, zero, zero        //resetting pulse counter
	    beq a1, a0, resetDigit
		addiu a1, a1, 0x0004
		j loop
	    resetDigit:
		addu a1, zero, zero    //resetting digit counter
		
    j loop
    
.end main