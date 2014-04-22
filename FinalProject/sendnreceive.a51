// This program will receive single character, 
// display it on the on-board 8 LEDs, send message 
// "I received (put the received character here).", 
// and repeat forever. Set the baud rate to be 9600,
// 8-bit data, and 1 stop

// UART window tells you what it receives, and port 1 displays the ascii code for that transmission
// 9600 baud rate is how fast you send the info

	ORG 0

	MOV TMOD, #20H
	MOV TH1, #0FDH
	MOV SCON, #50H
REPEAT:    
    LCALL RECEIVE1BYTE
	MOV B, A
	MOV DPTR, #MSG_HEAD
	LCALL SEND1LINE
	MOV A, B
	LCALL SEND1BYTE
	MOV DPTR, #MSG_END
	LCALL SEND1LINE
    SJMP REPEAT

RECEIVE1BYTE:
	CLR RI
	SETB TR1
STAY1:	
	MOV C,RI
	JNC STAY1
	MOV A, SBUF		 ; move what we just received to register A
    MOV P1, A    
	CLR RI
	CLR TR1
	RET
	
SEND1BYTE:
	CLR TI
	SETB TR1
	MOV SBUF, A
STAY2:	
	MOV C,TI
	JNC STAY2
    CLR TI
	CLR TR1
    RET
	
SEND1LINE:
	CLR TI
	SETB TR1
AGAIN:	CLR A
	MOVC A, @A+DPTR
	JZ DONE
	INC DPTR
	MOV SBUF, A
STAY3:	
	MOV C,TI
	JNC STAY3
    CLR TI
	SJMP AGAIN
	CLR TR1
DONE:RET

MSG_HEAD: DB "I received ",0
MSG_END: DB '!', 0AH, 0DH, 0 ;ODH for carriage return, 0AH for newline

	END

