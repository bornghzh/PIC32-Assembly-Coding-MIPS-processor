#include <xc.h>
#include "configbits.c"
    
    .global main

.data
    Number:
    .word 0x4, 0x0, 0x1, 0x1, 0x1, 0x0, 0x6, 0x5, 0x3
    segments:
    .word 0x3f, 0x06, 0x5B, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f
.text 
    
.ent main
main:
    
    la t0, ANSELB         //setting B to digital mode
    sw $0, 0(t0)
    
    la t0, TRISB          //setting B to output mode
    sw $0, 0(t0)          
    
    la a2, LATB           //memory address of output
    
    la a0, Number         //memory address of stored student ID
    la a1, segments	  //memory address of 7 segments codes
    
    addiu t0, zero, 0x0000      //digit 1 pointer
    addiu t1, zero, 0x0004      //digit 2 pointer
    addiu t2, zero, 0x0008      //digit 3 pointer
    addiu t3, zero, 0x000c      //digit 4 pointer
    
    addu t5, zero, zero         //used for current K
    
    addiu t6, zero, 0x0001      //constant value 1
    addiu t7, zero, 0x0002      //constant value 2
    addiu t8, zero, 0x0003      //constant value 3
    
    addiu t9, zero, 0x0100      //constant value 256 used for timing of K
    addu v0, zero, zero         //K timing counter
    
    addu s4, zero, zero         //shift timing counter
    lui s5, 0x0003              //a large number used for shift timing
    addiu s6, zero, 0x0024      //equals 9x4, used for detecting end of sequence
    
    loop:
	//screen:
	    addu s0, a0, t0
	    addu s1, a0, t1
	    addu s2, a0, t2
	    addu s3, a0, t3
	    
	    lw s0, 0(s0)
	    lw s1, 0(s1)
	    lw s2, 0(s2)
	    lw s3, 0(s3)
	    
	    sll s0, s0, 2
	    sll s1, s1, 2
	    sll s2, s2, 2
	    sll s3, s3, 2
	    
	    addu s0, a1, s0
	    addu s1, a1, s1
	    addu s2, a1, s2
	    addu s3, a1, s3
	    
	    lw s0, 0(s0)
	    lw s1, 0(s1)
	    lw s2, 0(s2)
	    lw s3, 0(s3)
	    
	    ori s0, s0, 0x0800
	    ori s1, s1, 0x0400
	    ori s2, s2, 0x0200
	    ori s3, s3, 0x0100
	    
	    beq t5, zero, number1          //case on which number has to be shown at the time
	    beq t5, t6, number2
	    beq t5, t7, number3
	    beq t5, t8, number4
	    number1:
		sw s0, 0(a2)
		j endcase
	    number2:
		sw s1, 0(a2)
		j endcase
	    number3:
		sw s2, 0(a2)
		j endcase
	    number4:
		sw s3, 0(a2)
	    endcase:
	    
	//counters:
	
	    beq v0, t9, changeDigit                    //Digit change counter
		addiu v0, v0, 0x0001
		j digitChangeEnd
	    changeDigit:
		addu v0, zero, zero
		beq t5, t8, restartDigit
		    addiu t5, t5, 0x0001
		    j digitChangeEnd
		restartDigit:
		    addu t5, zero, zero
	    digitChangeEnd:
    
	   
	    beq s4, s5, shift                          //shift counter
		addiu s4, s4, 0x0001
		j loop
	    shift:
		addu s4, zero, zero
		addiu t0, t0, 0x0004
		addiu t1, t1, 0x0004
		addiu t2, t2, 0x0004
		addiu t3, t3, 0x0004
		
		bne t0, s6, elseIfNumber2
		    addu t0, zero, zero
		    j loop
		elseIfNumber2:
		bne t1, s6, elseIfNumber3
		    addu t1, zero, zero
		    j loop
		elseIfNumber3:
		bne t2, s6, elseIfNumber4
		    addu t2, zero, zero
		    j loop
		elseIfNumber4:
		bne t3, s6, loop
		    addu t3, zero, zero
    j loop
    
.end main