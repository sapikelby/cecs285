;Write an 8051 assembly program that reads the following data from program ROM: 17, 37, 9, 18, 11, 26, 23, 43. 
;Save them to memory locations start from 40H, find the average, maximum number and minimum number and 
;save them to locations 48H, 49H and 4AH, then display the following menu to user:

;Please select from the following:
;1.	Display original data
;2.	Find and display average
;3.	Find and display maximum
;4.	Find and display minimum

; FINAL PROJECT CECS 285
; PROGRAMMER: KELBY SAPIEN

// UART window tells you what it receives, and port 1 displays the ascii code for that transmission
// 9600 baud rate is how fast you send the info

	ORG 0
	;MOV TMOD, #20H
	MOV TMOD, #20H
	MOV TH1, #0FDH
	MOV SCON, #50H
	;CLR A
MAIN:
	LCALL MOVING_DATA ; MOVE DATA INTO RAM

DISPLAY_MENU: 
	MOV DPTR, #MSG_HEAD
	LCALL SEND1LINE
	LCALL RECEIVE1BYTE
	LCALL CHECK_DISPLAY_ALL
	
    ;SJMP DISPLAY_MENU

CHECK_DISPLAY_ALL: 
		; ASCII REPRESENTATION OF NUMBER PRESSED GET PUSHED TO PORT 1
		; ASCII REP ON P1 == 31H
		; COMPARE PORT 1 TO 31H (HEX VAL OF 1) AND SO ON...
		MOV B, P1
		MOV A, #31H
		CJNE A, B, CHECK_AVG ; IF NOT EQUAL TO HEX VALUE JUMP TO NEXT CASE
		MOV DPTR, #MSG_ORIGINAL
		LCALL SEND1LINE
		LCALL DISPLAY_ASCII
		SJMP DISPLAY_MENU		 

CHECK_AVG:
		; ASCII REP ON P1 == 32H
		MOV B, P1
		MOV A, #32H
		CJNE A, B, CHECK_MIN ; IF NOT EQUAL TO HEX VALUE
		MOV DPTR, #MSG_AVG
		LCALL SEND1LINE
		LCALL AVG
		LCALL DISPLAY_AVG
		SJMP DISPLAY_MENU

CHECK_MIN: 
		; ASCII REP ON P1 == 33H
		MOV B, P1
		MOV A, #33H
		CJNE A, B, CHECK_MAX  ;COMPARE A AND B
		MOV DPTR, #MSG_MIN
		LCALL SEND1LINE
		LCALL MINIMUM
		;MOV A, @R0
		LCALL DISPLAY_AVG
		SJMP DISPLAY_MENU
		;MOV R0, A
		
CHECK_MAX:
		MOV B, P1
		MOV A, #34H
		CJNE A, B, INVALID_ENTRY  ;COMPARE A AND B
		MOV DPTR, #MSG_MAX
		LCALL SEND1LINE
		LCALL MAXIMUM
		LCALL DISPLAY_AVG
		SJMP DISPLAY_MENU

INVALID_ENTRY:
		MOV DPTR, #MSG_ERROR ; DISPLAY ERROR MESSAGE TO USER
		LCALL SEND1LINE
		SJMP DISPLAY_MENU
		
		
; --- INSERT DATA INTO RAM
MOVING_DATA:
		CLR A
		MOV R0, #40H ; destination address
		MOV R2, #8 ; counter
		MOV DPTR, #DATA_VALUES	

INSERT:
		CLR A
		MOVC A, @A+DPTR
		MOV @R0, A

		INC DPTR
		INC R0
		
		DJNZ R2, INSERT
		RET
; --- INSERT DATA INTO RAM ENDS

; ---- MIN ROUTINE
MINIMUM:
		MOV R0, #4AH
		MOV R1, #40H
		MOV R2, #8
		MOV B, @R1 ; ASSUME 1ST ELEMENT IS THE MIN VALUE
			
		CLR A
MINLOOP:
		MOV A, @R1
		CJNE A, B, LOOP1  ;COMPARE A AND B
		
LOOP1:  JNC LOOP2  ; JUMP IF A > B
		MOV B, A ; ELSE MOVE A TO B (A < B) 
		INC R1
		
		
		DJNZ R2, MINLOOP
		SJMP FINALSTEP
LOOP2: 
		INC R1
		;MOV B, A
		DJNZ R2, MINLOOP
		
FINALSTEP: 	
		MOV A, B
		MOV @R0, A
		RET
; ---- END ROUTINE


; ---- MAX ROUTINE
MAXIMUM:
		MOV R0, #49H
		MOV R1, #40H
		MOV R2, #8
		MOV B, #0 ; START MAX AT 0 OR 1ST ELEMENT
			
		CLR A
BIGLOOP:
		MOV A, @R1
		CJNE A, B, LOOP  ;COMPARE A AND B
		
LOOP:  	JC SECONDLOOP  ; JUMP IF A < B
		MOV B, A ; ELSE MOVE A TO B (A > B) 
		INC R1
		
		DJNZ R2, BIGLOOP
		SJMP NEXT
		
SECONDLOOP: 
		INC R1
		DJNZ R2, BIGLOOP
		
NEXT: 	MOV A, B
		MOV @R0, A
		RET
		
; ---- MAX ROUTINE ENDS


AVG:
		CLR A
		MOV 48H, #0
		;MOV R1, #40H ; destination address
		MOV R0, #48H  ; KEEP VALUE
		MOV R2, #8
		MOV B, #8
		MOV DPTR, #DATA_VALUES
AGAIN2:	
		CLR A
		MOVC A, @A+DPTR
		;MOV @R1, A
		ADD A, @R0
		MOV @R0, A
		
		;MOV @RO, A
		;INC R1
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


;---- DISPLAY ONE NUMBER ONLY
DISPLAY_AVG:
	CLR TI
	SETB TR1
	CLR A
	;MOV R0, #48H
	MOV A, @R0
	;JZ STAY_DONE
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
	
;STAY_DONE:	
;	MOV C,TI
;	JNC STAY_DONE
 ;   CLR TI	
	
	CLR TR1
	RET
;----

DISPLAY_ASCII:  ;CONVERTS NUMBERS TO ASCII REPRESENTATION FOR UART
	CLR TI
	SETB TR1
	;MOV DPTR, #DATA_VALUES
	MOV R0, #40H
	MOV DPTR, #DATA_VALUES
	
AGAIN1:	
	CLR A
	MOVC A, @A+DPTR
	JZ DONE1
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

;DATA_STRING: DB "Here is the original data:", 0AH, "17, 37, 9, 18, 11, 26, 23, 43", 0AH, 0 
;DATA_VALUES: DB "First", 17, 37, 9, 18, 11, 26, 23, 43  // TESTING THE FIRST STRING IS THE ONLY THING DISPLAYED BC ALREADY IN ASCII
;DATA_VALUES: DB 11H, 25H, 9H, 12H, 0BH, 1AH, 17H, 2BH
;DATA_VALUES: DB 41H, 55H, 39H, 42H, 3BH, 4AH, 47H, 5BH ; DATA VALUES + 30 FOR ASCII REP
DATA_VALUES: DB 17, 37, 9, 18, 11, 26, 23, 43, 0 
;MSG_HEAD: DB "I received ",0
;MSG_END: DB '!', 0AH, 0DH, 0 ;ODH for carriage return, 0AH for newline
;MSG_HEAD: DB "I received ",0
MSG_HEAD: DB 0AH, "Please select from the following:", 0AH, "1. Display original data", 0AH, "2. Find and display average", 0AH, "3. Find and display maximum", 0AH, "4. Find and display minimum", 0AH, 0 
MSG_ORIGINAL: DB 0AH, "Here is the original data: ", 0AH, 0
MSG_AVG: DB 0AH, "Average: ", 0AH, 0
MSG_MIN: DB 0AH, "Minimum: ", 0AH, 0
MSG_MAX: DB 0AH, "Maximum: ", 0AH, 0
MSG_ERROR: DB 0AH, "Invalid entry, try again!", 0AH, 0

;1.	Display original data - a prompt should follow it saying "original data: …" 
;2.	Find and display average
;3.	Find and display maximum
;4.	Find and display minimum

;MSG_END: DB '', 0AH, 0DH, 0 ;ODH for carriage return, 0AH for newline

	END












	


