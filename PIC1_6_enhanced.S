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
    and v0, $0, $0                //$v0 contains LED information. we assume its inital state is off.
    addi a2, zero, 0x0100         //used for flipping the state of LED
    and v1, $0, $0                //$v1 contains the number of consecutive zero or ones detected. its initial value is 0.
    addi a3, zero, 0x00c8         //$a3 equals 200
    addi t8, zero, 0x0001         //equals 1 if waiting for consecutive 1's else waiting for consecutive 0's. at first it's waiting for 1's.
    loop:
	lw s0, 0(a0)
	andi s0, s0, 0x0001
	beq t8, $0, zerocheck                       //what to do if button signal is one
	//{
	    beq s0, $0, resetv1                     
	    //{
		beq v1, a3, toggle1
		//{
		    addi v1, v1, 0x0001             // one more consecutive 1 has detected
		j update
		//}
		toggle1:                            //200 consecutive 1 has detected
		//{
		    xor v0, v0, a2
		    and v1, $0, $0
		    and t8, $0, $0
		//}
	    j update
	    //}
	    resetv1:                                //when unwanted 0 detects
	    //{
		and v1, $0, $0
	    //}
	j update
	//}
	zerocheck:                                  //what to do if button signal is zero
	//{
	    bne s0, $0, resetzero
	    //{
		beq v1, a3, toggle2
		//{
		    addi v1, v1, 0x0001             // one more consecutive 0 has detected
		j update
		//}
		toggle2:                            //200 consecutive 0 has detected
		//{
		    and v1, $0, $0
		    addi t8, zero, 0x0001
		//}
	    j update
	    //}
	    resetzero:                              //when unwanted 1 detects
	    //{
		and v1, $0, $0
	    //}
	//}
	update:
	sw v0, 0(a1)
    j loop
    
.end main