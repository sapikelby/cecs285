ORG 0

AVG:
		CLR A
		MOV R1, #30H ; destination address
		MOV R0, #70H  ;// KEEP VALUE
		MOV R2, #9 ; COUNTER
		MOV B, #9 ; USED TO DIVIDE (SUM/# OF NUMS)
		MOV DPTR, #MYDATA ; DPTRS USED TO TRAVERSE LOOKUP TABLE
AGAIN:	
		CLR A
		MOVC A, @A+DPTR
		MOV @R1, A
		ADD A, @R0
		MOV @R0, A
		
		INC R1
		INC DPTR
	
		DJNZ R2, AGAIN
		
		; divide
		MOV A, @R0
		DIV AB
		MOV R7, A 
		; end division
		
; ---- MIN ROUTINE
MIN:
		MOV R1, #30H
		MOV R2, #9
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
		MOV R5, A
		
; ---- END ROUTINE


; ---- MAX ROUTINE
MAX:
		MOV R1, #30H
		MOV R2, #9
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
		MOV R6, A
		
; ---- MAX ROUTINE ENDS

ORG 250H
MYDATA:   DB   3, 9, 6, 9, 7, 6, 4, 2, 8
 

END