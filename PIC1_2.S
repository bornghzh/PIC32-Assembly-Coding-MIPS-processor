/*********************************************************************
* Description:
* This project demonstrates how to program the PIC32 microcontroller so as to show the state of a switch (attached to the RB0pin) on an LED (attached to the RB8 pin), in real time.
********************************************************************/
#include <xc.h>
#include "configbits.c"
.global main
    
.ent main
main:
// As we want the B port (meaning pins B0, B1, ..., B15) to be digital I/O, ANSELB = 0x0000:
la $8,ANSELB// Now $8 contains the memory address of ANSELB (which is 0xbf88_6100 as the datasheet asserts), so now we can edit the ANSELB.
sw $0,0($8)// ANSELB = 0x0000
/* The equivalent instruction for the instructions above is:
* lui$8, 0xbf88
* sw$0, 0x6100($8)
*/
/* Now we are going to assign B0, B1, ..., B7 as inputs to read from these pins and B8, B9, ..., B15 as outputs. (Note that in this particular project we do not need RA pins)
* So TRISB[0] = TRISB[1] = ... = TRISB[7] = 1 and TRISB[8] = TRISB[9] = ... = TRISB[15] = 0.
* Therefore TRISB = 0x00ff
*/
la $8,TRISB// Now $8 contains the memory address of TRISB (which is 0xbf88_6110 as the datasheet asserts), so now we can edit the TRISB.
ori $9,$0,0x00ff
sw $9,0($8)// TRISB = 0x00ff
/* The equivalent instruction for the instructions above is:
* lui$8, 0xbf88
* ori$9, $0, 0x00ff
* sw$9, 0x6110($8)
*/
// Now RB0 to RB7 are set as inputs and RB8 to RB15 are set as outputs.
// We should have the address of PORTB to read from it and to detect any input; while we also need to have the address of LATB to write in it and show outputs:
la $10,PORTB// Now $10 contains the memory address of PORTB (which is 0xbf88_6120 as the datasheet asserts), so now we can read PORTB.
la $11,LATB// Now $11 contains the memory address of LATB (which is 0xbf88_6130 as the datasheet asserts), so now we can edit the LATB.
 
loop:
lw $8,0($10)// The input to our pins from an outer element (the swithces) is live detected and saved in the $8 register from PORTB.
//andi $8,$8,0x0001 The $8 is masked somehow we only detect RB0. Now the LSB of $8 shows whether the RB0 switch has been set.
sll $8,$8, 3
sw $8, 0($11)// The RB0 input is copied to the RB8 output, live.
j loop

.end main
