// This program will receive single character, 
// display it on the on-board 8 LEDs, and repeat forever.
// Set the baud rate to be 9600, 8-bit data, and 1 stop
//
// To debug, open serial port 1 and UART window 1... anything you type in UART window
// will be displayed on port 1. If a letter is entered, then it will display the ascii code for that letter
	ORG 0

	MOV TMOD, #20H
	MOV TH1, #0FDH
	MOV SCON, #50H
	CLR RI			; clr to receive
	SETB TR1
STAY:	
	MOV C,RI
	JNC STAY
	MOV A, SBUF
    MOV P1, A    
	CLR RI
	SJMP STAY
	END