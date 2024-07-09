#include <xc.h>
#include "configbits.c"
    
    .global main

.data
    Number:
    .word 0x8, 0x4, 0x8, 0x4
    segments:
    .word 0x3f, 0x06, 0x5B, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f
.text 
    
.ent main
main:
    
    la t0, ANSELB         //setting B to digital mode
    sw $0, 0(t0)
    
    la t0, TRISB          //setting B to output mode
    sw $0, 0(t0)          
    
    la t9, LATB           //7 segment output
    
    add a0, zero, zero    //digit counter initialization
    addiu a1, zero, 0x0800  //determines which segments is on
    
    addi s0, zero, 0x000c   //number of digits: 4
    la s1, Number
    addi s2, zero, 0x0004   //used for turning bytes into words
    la s3, segments
    
    addiu s4, zero, 0x100
    addu s5, zero, zero
    
    loop:
    //output update
	add t0, s1, a0
	lw v0, 0(t0)        //stores the digit number
	multu v0, s2
	mflo v0             // the digit number multiplied by 4
	
	add t0, s3, v0
	lw v1, 0(t0)        //stores 7 segment decoded number
	or t8, a1, v1       //stores 7 segment current output
	sw t8, 0(t9)
	
    //counter update
    beq s5, s4, change
	addiu s5, s5, 0x0001
	j loop
    change:
	addu s5, zero, zero
	beq a0, s0, beginAgain
	    addi a0, a0, 0x0004
	    srl a1, a1, 0x0001
	    j loop
	beginAgain:
	    add a0, zero, zero
	    sll a1, a1, 0x0003
    j loop
    
.end main