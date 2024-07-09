#include <xc.h>
#include "configbits.c"
    
    .global main
	
.data
    segments:
    .word 0x3f, 0x06, 0x5B, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f
.text
    
.ent main
main:
    
    la t0, ANSELB
    sw $0, 0(t0)
    
    la t0, TRISB
    sw $0, 0(t0)
    
    la v0, LATB
    la s0, segments
    
    addu a0, zero, zero
    addu a1, zero, zero
    addu a2, zero, zero
    addu a3, zero, zero
    
    addu s5, zero, zero     //used for determining current digit
    addiu t0, zero, 0x0001
    addiu t1, zero, 0x0002
    addiu t2, zero, 0x0003
    
    addiu t7, zero, 0x0004
    addiu t8, zero, 0x0480
    
    addu s6, zero, zero     //used for digit changing
    addiu t3, zero, 0x0100
    
    addu s7, zero, zero
    lui t4, 0x0007
    
    addiu t5, 0x0024        // equals 9x4
    addiu t6, 0x0014        // equals 5x4
    
    loop:
    //screen:
	addu s1, s0, a0
	addu s2, s0, a1
	addu s3, s0, a2
	addu s4, s0, a3
	
	lw s1, 0(s1)
	lw s2, 0(s2)
	lw s3, 0(s3)
	lw s4, 0(s4)
	
	ori s1, s1, 0x0100
	ori s2, s2, 0x0200
	ori s3, s3, 0x0400
	ori s4, s4, 0x0800
	
	beq s5, zero, showDigit1
	beq s5, t0, showDigit2
	beq s5, t1, showDP
	beq s5, t2, showDigit3
	beq s5, t7, showDigit4
	showDigit1:
	    sw s1, 0(v0)
	    j endcase
	showDigit2:
	    sw s2, 0(v0)
	    j endcase
	showDP:
	    sw t8, 0(v0)
	    j endcase
	showDigit3:
	    sw s3, 0(v0)
	    j endcase
	showDigit4:
	    sw s4, 0(v0)
	endcase:
	
    //timer:
	beq s6, t3, changeDigit
	    addiu s6, s6, 0x0001
	    j changeDigitEnd
	changeDigit:
	    addu s6, zero, zero
	    beq s5, t7, resetDigit
		addiu s5, s5, 0x0001
		j changeDigitEnd
	    resetDigit:
		addu s5, zero, zero
	changeDigitEnd:
    
	//main timer:
	beq s7, t4, changeSecond
	    addiu s7, s7, 0x0001
	    j loop
	changeSecond:
	    addu s7, zero, zero
	    beq a0, t5, changeDecadeSecond
		addiu a0, a0, 0x0004
		j loop
	changeDecadeSecond:
	    addu a0, zero, zero
	    beq a1, t6, changeMinute
		addiu a1, a1, 0x0004
		j loop
	changeMinute:
	    addu a1, zero, zero
	    beq a2, t5, changeDecadeMinute
		addiu a2, a2, 0x0004
		j loop
	changeDecadeMinute:
	    addu a2, zero, zero
	    beq a3, t6, changeHour
		addiu a3, a3, 0x0004
		j loop
	changeHour:
	    addu a3, zero, zero
    
    j loop
    
.end main