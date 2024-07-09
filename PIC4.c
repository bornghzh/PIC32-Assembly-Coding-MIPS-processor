/* 
 * File:   Main.c
 * Author: Farhad
 *
 * Created on May 29, 2024, 2:46 PM
 */
#include "mcc_generated_files/mcc.h"
#include "mcc_generated_files/lcd.h"

#include <stdio.h>
#include <stdlib.h>

char s1[8];


/*
 * 
 */
void portInitialize ()
{
    IO_RA0_SetDigitalOutput();
    IO_RA1_SetDigitalOutput();
    IO_RA2_SetDigitalOutput();
    IO_RA3_SetDigitalOutput();
    IO_RA4_SetDigitalOutput();
    
    TRISBbits.TRISB0 = 0;
    TRISBbits.TRISB1 = 0;
    TRISBbits.TRISB2 = 0;
    TRISBbits.TRISB3 = 0;
    IO_RB4_SetDigitalOutput();
    IO_RB5_SetDigitalOutput();
    IO_RB6_SetDigitalOutput();
    IO_RB7_SetDigitalOutput();
    IO_RB8_SetDigitalOutput();
    IO_RB9_SetDigitalOutput();
    IO_RB10_SetDigitalOutput();
    IO_RB11_SetDigitalOutput();
    IO_RB12_SetDigitalInput();
    IO_RB13_SetDigitalInput();
    IO_RB14_SetDigitalInput();
    IO_RB15_SetDigitalInput();
}

void writePortA (int A0, int A1, int A2, int A3, int A4)
{
    LATAbits.LATA0 = A0;
    LATAbits.LATA1 = A1;
    LATAbits.LATA2 = A2;
    LATAbits.LATA3 = A3;
    LATAbits.LATA4 = A4;
}

int readPortB (int B)
{
    switch (B)
    {
        case 12:
            return IO_RB12_GetValue();
            break;
        case 13:
            return IO_RB13_GetValue();
            break;
        case 14:
            return IO_RB14_GetValue();
            break;
        case 15:
            return IO_RB15_GetValue();
            break;
            
    }
}

int detectKey ()
{
    writePortA (1, 0, 0, 0, 0);
    // ?
    int a;
    
    a = readPortB(12);
    if (a)
        return 1;
    a = readPortB(13);
    if (a)
        return 6;
    a = readPortB(14);
    if (a)
        return 11;
    a = readPortB(15);
    if (a)
        return 16;
    
    writePortA (0, 1, 0, 0, 0);
    
    a = readPortB(12);
    if (a)
        return 2;
    a = readPortB(13);
    if (a)
        return 7;
    a = readPortB(14);
    if (a)
        return 12;
    a = readPortB(15);
    if (a)
        return 17;
    
    writePortA (0, 0, 1, 0, 0);
    
    a = readPortB(12);
    if (a)
        return 3;
    a = readPortB(13);
    if (a)
        return 8;
    a = readPortB(14);
    if (a)
        return 13;
    a = readPortB(15);
    if (a)
        return 18;
    
    writePortA (0, 0, 0, 1, 0);
    
    a = readPortB(12);
    if (a)
        return 4;
    a = readPortB(13);
    if (a)
        return 9;
    a = readPortB(14);
    if (a)
        return 14;
    a = readPortB(15);
    if (a)
        return 19;
    
    writePortA (0, 0, 0, 0, 1);
    
    a = readPortB(12);
    if (a)
        return 5;
    a = readPortB(13);
    if (a)
        return 10;
    a = readPortB(14);
    if (a)
        return 15;
    a = readPortB(15);
    if (a)
        return 20;
    
    return 0;
}

char keyMap()
{
    int a = detectKey();
    switch (a)
    {
        case 1:
            return '1';
            break;
        case 2:
            return '2';
            break;
        case 3:
            return '3';
            break;
        case 6:
            return '4';
            break;
        case 7:
            return '5';
            break;
        case 8:
            return '6';
            break;
        case 11:
            return '7';
            break;
        case 12:
            return '8';
            break;
        case 13:
            return '9';
            break;
        case 17:
            return '0';
            break;
        case 4:
            return '+';
            break;
        case 5:
            return '-';
            break;
        case 9:
            return 'X';
            break;
        case 10:
            return '/';
            break;
        case 20:
            return '=';
            break;
        default:
            return '.';
            break;
    }
}

int lengthInteger (int number)
{
    int length = 1;
    while (number > 10)
    {
        length = length + 1;
        number = number/10;
    }
    return length;
}

/*char* myString(int x)
{
    int lengthInt = lengthInteger(x);
    char string[3] = {'5', '5', '5'};
    int y = x;
    int ybefore = x;
    for (int i = 0; i<lengthInt; i = i + 1)
    {
        y = ybefore/10;
        y = ybefore*10;
        string[i] = '0' + ybefore - y;
        ybefore = ybefore/10;
    }
    return string;
}*/

int main(void)
{
    // initialize the device
    // Use ctrl+click to see inside of the functions
    SYSTEM_Initialize();
    LCD_Initialize();
    // remember to clear lcd before first usage
    LCDClear();
    //LCDPutCmd(LCD_CURSOR_ON);
    
    portInitialize();
    
    int i = 0;
    int row = 0;
    char key;
    int number1 = 0;
    int number2 = 0;
    int op;
    int result;
    int copyresult;
    int resultLength;
    while (1)
    {
        //LCDPutCmd(LCD_HOME);
        //LCDClear();
        LCDGoto(i, row);
        key = keyMap();
        if ((key == '+') || (key == '-') || (key == 'X') || (key == '/') || (key == '='))
        {
            if ((row == 0) && (key != '='))
            {
                switch (key)
                {
                    case '+':
                        op = 1;
                        break;
                    case '-':
                        op = 2;
                        break;
                    case 'X':
                        op = 3;
                        break;
                    case '/':
                        op = 4;
                        break;
                }
                LCDPutChar(key);
                i = 0;
                row = 1;
            }
            else if ((row == 1) && (key == '='))
            {
                i = 0;
                row = 0;
                LCDClear();
                switch (op)
                {
                    case 1:
                        result = number1 + number2;
                        break;
                    case 2:
                        result = number1 - number2;
                        break;
                    case 3:
                        result = number1 * number2;
                        break;
                    case 4:
                        result = number1 / number2;
                        break;
                }
                resultLength = lengthInteger(result);
                LCDPutChar('=');
                i = resultLength;
                for (int j = 0; j < resultLength; j = j + 1)
                {
                    copyresult = result;
                    copyresult = copyresult / 10;
                    copyresult = copyresult * 10;
                    LCDGoto(i, row);
                    LCDPutChar('0' + result - copyresult);
                    i = i - 1;
                    result = result / 10;
                }
            }
        }
        else if (key != '.')
        {
            if (row == 0)
                number1 = number1 * 10 + (key - '0');
            else
                number2 = number2 * 10 + (key - '0');
            LCDPutChar(key);
            i = i + 1;
        }
        if (i == 17)
        {
            LCDClear();
            i = 0;
        }
        __delay_ms(100);
    }
    
    
    /*
    int i=0;
    while (1)
    {
        LCDPutCmd(LCD_HOME);
        LCDGoto(i,0);
        LCDPutChar('0'+i);
        __delay_ms(500);
        i++;
        // Add your application code
        if(i==5){LCDClear();}
        if(i==10){
            i=0;
            LCDGoto(0,1);
            LCDPutStr("salam");
        }
    }
    */
    return -1;
}