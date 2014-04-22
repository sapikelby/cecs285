// This program transfers the message "A world without 
// strangers!" serially at 9600 baud, 8-bit data, 
// 1 stop bit.

	ORG 0

	MOV TMOD, #20H	   ; timer 1, mode 2
	MOV TH1, #0FDH	   ; baud rate
	MOV SCON, #50H
	CLR TI
	SETB TR1
	MOV DPTR, #MY_STR
AGAIN:	CLR A
	MOVC A, @A+DPTR
	JZ DONE	   ; is A zero, if yes then we're done (in other words, have you found the null terminator
	INC DPTR
	MOV SBUF, A
STAY:	
	MOV C,TI	 ;	checks to see if transfer is done
	JNC STAY	  ; is C zero? if not jump to STAY and keep checking
    CLR TI
	SJMP AGAIN
DONE:	SJMP $

MY_STR: DB "A world without strangers!",0 ;the zero acts as the null terminator
	END
