; ----- Kelby Sapien
; ----- Project 1

		ORG 0000H
		MOV P1, #0FFH
AGAIN: 	JNB P0.0, CHECK_COUNT	; JUMP if P0.0 is low, otherwise do bouncing cat
		LCALL BOUNCING			  ; lower pins have higher priority
		SJMP AGAIN
		
CHECK_COUNT:                                                                                                                                                                
		JNB P0.1, CHECK_DB  ; JUMP if P0.1 is low, otherwise do counting
		LCALL COUNT
		SJMP AGAIN		  ; AT EACH BRANCH, YOU WANT TO GO BACK TO AGAIN AND CHECK FOR PIN PRIORITY

CHECK_DB:
		JNB P0.2, CHECK_CYC ; JUMP if P0.2 is low, otherwise do double_bounce
		LCALL DOUBLE_BOUNCE
		SJMP AGAIN

CHECK_CYC: 
		JNB P0.3, ERR	; JUMP if P0.3 is low to error state, otherwise do cyclic mode
		LCALL CYCLIC
		SJMP AGAIN

ERR:	; IF ALL PINS ARE OFF, THEN JUST FLASH THEM                                                                                                                                                  
		MOV P1,#0FFH
		LCALL DELAY
		MOV P1, #0
		LCALL DELAY
		LJMP AGAIN

; ---- CYCLIC MODE
CYCLIC: 
		JB P0.0, JUMP2_BOUNCE ; RETURN TO PREVIOUS MODE IF PRESSED
		JB P0.1, COUNT
		JB P0.2, DOUBLE_BOUNCE
		JNB P0.3, CYCLIC_DONE	
		;MOV A, #0H
		MOV P1, #0
		LCALL DELAY
		MOV A, #80H
		MOV R5, #8
AGAIN2:		
		JB P0.0, BOUNCING ; RETURN TO PREVIOUS MODE IF PRESSED
		JB P0.1, COUNT
		JB P0.2, DOUBLE_BOUNCE
		JNB P0.3, CYCLIC_DONE
		MOV P1, A
		LCALL DELAY
		MOV R6, A
		RR A
		ORL A, R6
		;MOV P1, A
		;LCALL DELAY
		DJNZ R5, AGAIN2
		SJMP CYCLIC

CYCLIC_DONE: RET

JUMP2_BOUNCE:
		LJMP BOUNCING

;---- COUNTING MODE
COUNT: 	
		JB P0.0, BOUNCING
        MOV P1, #0
		MOV R3, #0FFH
DO_AGAIN:
		JB P0.0, BOUNCING
		JNB P0.1, C_DONE
		;JNB P0.3, ERR
        LCALL DELAY		
		INC P1
		DJNZ R3, DO_AGAIN
		SJMP AGAIN
C_DONE:	RET


; --- DOUBLE BOUNCE
; BE CAREFUL, R1-R3 ARE USED BY DELAY FUNCTION
; KEPT GETTING ERRORS B/C OF IT
; fix overlap by calling two different loops
DOUBLE_BOUNCE:
		JB P0.0, BOUNCING
		JB P0.1, COUNT ; JUMP BACK TO COUNTING MODE IF P0.1 IS HIGH
		JNB P0.2, D_BOUNCE_DONE
		MOV R4, #80H ; 1000 0000
		MOV R5, #01H ; 0000 0001
		MOV R6, #3 ; COUNTER
	
		MOV A, R4 ; store initial R1 VAL into A = 1000 0000
		
		ORL A, R5 ; A = 1000 0001
		MOV P1, A ; DISPLAYS IN LED
		LCALL DELAY
		
PART1:
		JB P0.0, BOUNCING
		JB P0.1, COUNT
		JNB P0.2, D_BOUNCE_DONE	
		;CLR A
		MOV A, R4 ; A = 1000 0000
		RR A   ; 	A = 0100 0000
		MOV R4, A ;R1 = 0100 0000
		MOV A, R5 ; A = 0000 0001
		RL A  	  ; A = 0000 0010
		MOV R5, A ;R2 = 0000 0010
		ORL A, R4 ; R1 OR R2 A = 0100 0010 FIRST RUN
		;CJNE A,   ; jump when 10 or 0001 1000
		MOV P1, A ; DISPLAY
		LCALL DELAY
		DJNZ R6, PART1
		MOV R6, #2 ; RESET COUNTER
		SJMP PART2

		
PART2:
		JB P0.0, BOUNCING
		JB P0.1, COUNT
		JNB P0.2, D_BOUNCE_DONE	
		;CLR A
		MOV A, R4 ; A = 1000 0000
		RL A   ; 	A = 0100 0000
		MOV R4, A ;R1 = 0100 0000
		MOV A, R5 ; A = 0000 0001
		RR A  	  ; A = 0000 0010
		MOV R5, A ;R2 = 0000 0010
		ORL A, R4 ; R1 OR R2 A = 0100 0010 FIRST RUN
		;CJNE A,   ; jump when 10 or 0001 1000
		MOV P1, A ; DISPLAY
		LCALL DELAY
		DJNZ R6, PART2
		SJMP DOUBLE_BOUNCE		
		

D_BOUNCE_DONE:	RET

; -- BOUNCING
BOUNCING:
		MOV A, #01H
		MOV R0, #8
LEFT: 	JNB P0.0, B_DONE	   ; RETURN IF DONE
		RR A
		MOV P1, A
		LCALL DELAY
		DJNZ R0, LEFT ; USE A LOOP TO MOVE 7 POSITIONS
		MOV R0, #6    ; RESET COUNTER
RIGHT:	JNB P0.0, B_DONE	   ; RETURN IF DONE
		RL A
		MOV P1, A
		
		LCALL DELAY
		DJNZ R0, RIGHT
		SJMP BOUNCING ; REPEAT THE WHOLE SEQUENCE AGAIN
B_DONE: RET


; -----------DELAY FUNCTION
DELAY:
		MOV R3, #220

HALF_SEC_CHK: 				 ; LOWER PINS HAVE HIGHER PRIORITY
		JNB P0.4, ONE_SEC_CHK	
		MOV R7, #1			  
		SJMP DLY

ONE_SEC_CHK: 	
		JNB P0.5, ONE_HALF_CHK	
		MOV R7, #2			  
		SJMP DLY

ONE_HALF_CHK: 	
		JNB P0.6, TWO_SEC_CHK	
		MOV R7, #3			  
		SJMP DLY
TWO_SEC_CHK: 	
		JNB P0.7, ERR_DELAY	
		MOV R7, #4			  
		SJMP DLY

ERR_DELAY:
		MOV R7, #1
		;LCALL DLY
		SJMP DLY
		 

DLY:
		
DLY0:  	MOV  R1, #0FFH
DLY1:  	MOV  R2, #0FFH
DLY2:  	DJNZ R2, DLY2
       	DJNZ R1, DLY1
        DJNZ R3, DLY0
		DJNZ R7, DLY ; DO THE WHOLE LOOP AGAIN	
		RET
	   	END	 
; -- DELAY FUNCTION ENDS