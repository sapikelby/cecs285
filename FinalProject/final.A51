// This program will receive single character, 
// display it on the on-board 8 LEDs, send message 
// "I received (put the received character here).", 
// and repeat forever. Set the baud rate to be 9600,
// 8-bit data, and 1 stop

// UART window tells you what it receives, and port 1 displays the ascii code for that transmission
// 9600 baud rate is how fast you send the info

	ORG 0
	;MOV TMOD, #20H
	MOV TMOD, #20H
	MOV TH1, #0FDH
	MOV SCON, #50H
	;CLR A
DISPLAY_MENU:    
    ;LCALL RECEIVE1BYTE
	;MOV B, A
	MOV DPTR, #MSG_HEAD
	LCALL SEND1LINE
	LCALL RECEIVE1BYTE
	LCALL CHECK_DISPLAY_ALL
	;MOV B, A
	
	;MOV A, B
	;LCALL SEND1BYTE
	;MOV DPTR, #MSG_END
	;LCALL SEND1LINE
    SJMP DISPLAY_MENU

CHECK_DISPLAY_ALL:                                                                                                                                                                
		JNB P1.0, CHECK_AVG  ; JUMP if P0.1 is low, otherwise CHECK_AVG
		;MOV DPTR, #DATA_STRING
		;MOV DPTR, #DATA_VALUES
		;LCALL SEND1LINE
		LCALL DISPLAY_ASCII
		SJMP DISPLAY_MENU		 

CHECK_AVG:
		JNB P1.1, DISPLAY_MENU ; JUMP if P0.2 is low, otherwise 
		LCALL AVG
		;LCALL SEND1BYTE
		MOV A, @R0 ; MOVE WHAT IS IN LOCATION 48H INTO A
		LCALL DISPLAY_ASCII
		SJMP DISPLAY_MENU

;DISPLAY_ORIGINAL: 
;		MOV DPTR, #DATA_STRING
;		LCALL SEND1LINE

AVG:
		CLR A
		MOV R1, #40H ; destination address
		MOV R0, #48H  ; KEEP VALUE
		MOV R2, #8
		MOV B, #8
		MOV DPTR, #DATA_VALUES
AGAIN2:	
		CLR A
		MOVC A, @A+DPTR
		MOV @R1, A
		ADD A, @R0
		MOV @R0, A
		
		;MOV @RO, A
		INC R1
		INC DPTR
		
		;INC R0  ; increment the location to which you are adding the string at position(i)
		DJNZ R2, AGAIN2
		
		MOV A, @R0
		DIV AB
		MOV @R0, A 
		RET

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
	
SEND1LINE:  ; WORKS ONLY FOR STRINGS
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


;---- DISPLAY AVG
DISPLAY_AVG:
	CLR TI
	SETB TR1
	CLR A
	;MOV R0, #48H
	MOV A, @R0
	JZ DONE
	MOV B, #10
	DIV AB 
	ADD A, #30H 
	MOV SBUF, A

STAY_AVG:	
	MOV C,TI
	JNC STAY_AVG
    CLR TI	
	
	MOV A, B ; B IS 7
	ADD A, #30H ; 37H
	MOV SBUF, A

STAY_AVG1:	
	MOV C,TI
	JNC STAY_AVG1
    CLR TI	
	
STAY_END:	
	MOV C,TI
	JNC STAY_END
    CLR TI	
	
	CLR TR1
	RET
;----

DISPLAY_ASCII:  ;CONVERTS NUMBERS TO ASCII REPRESENTATION FOR UART
	CLR TI
	SETB TR1
	MOV DPTR, #DATA_VALUES
	
AGAIN1:	CLR A
	MOVC A, @A+DPTR
	JZ DONE
	MOV B, #10
	DIV AB ; EX 17-- A IS NOW 1
	ADD A, #30H ; 31H
	MOV SBUF, A
	
STAY4:	
	MOV C,TI
	JNC STAY4
    CLR TI	
	
	MOV A, B ; B IS 7
	ADD A, #30H ; 37H
	MOV SBUF, A
STAY5:	
	MOV C,TI
	JNC STAY5
    CLR TI

; --- DISPLAY SPACE
	MOV A, #20H
	MOV SBUF, A
STAY_MIDDLE: 	
	MOV C,TI
	JNC STAY_MIDDLE
    CLR TI

	;JZ DONE
	INC DPTR

	SJMP AGAIN1
	CLR TR1
DONE1:RET
;ADD:
;		CLR A
;		MOV R0, #40H ; destination address
;		MOV R2, #8
;AGAIN:	MOV @R0, P0
;		ADD A, @R0
;		
;		JNC SKIP
;		INC 4BH ; increment 4BH for each carry (HIGH BYTE)
;		
;SKIP:	INC R0  ; increment the location to which you are adding the string at position(i)
;		DJNZ R2, AGAIN
;		MOV 4AH, A ; MOVE LOW BYTE INTO 4AH
;		END

DATA_STRING: DB "Here is the original data:", 0AH, "17, 37, 9, 18, 11, 26, 23, 43", 0AH, 0 
;DATA_VALUES: DB "First", 17, 37, 9, 18, 11, 26, 23, 43  // TESTING THE FIRST STRING IS THE ONLY THING DISPLAYED BC ALREADY IN ASCII
;DATA_VALUES: DB 11H, 25H, 9H, 12H, 0BH, 1AH, 17H, 2BH
;DATA_VALUES: DB 41H, 55H, 39H, 42H, 3BH, 4AH, 47H, 5BH ; DATA VALUES + 30 FOR ASCII REP
DATA_VALUES: DB 17, 37, 9, 18, 11, 26, 23, 43, 0 
;MSG_HEAD: DB "I received ",0
;MSG_END: DB '!', 0AH, 0DH, 0 ;ODH for carriage return, 0AH for newline
;MSG_HEAD: DB "I received ",0
MSG_HEAD: DB 0AH, "Please select from the following:", 0AH, "1. Display original data", 0AH, "2. Find and display average", 0AH, "3. Find and display maximum", 0AH, "4. Find and display minimum", 0AH, 0 
;1.	Display original data - a prompt should follow it saying "original data: …" 
;2.	Find and display average
;3.	Find and display maximum
;4.	Find and display minimum

;MSG_END: DB '', 0AH, 0DH, 0 ;ODH for carriage return, 0AH for newline

	END












	


