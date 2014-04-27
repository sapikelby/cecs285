ORG 0

AVG:
		CLR A
		MOV R1, #30H ; destination address
		MOV R0, #70H  ;// KEEP VALUE
		MOV R2, #9
		MOV B, #9
		MOV DPTR, #MYDATA
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
		

MAX_NUM:

MAX:
		MOV R1, #30H
		MOV R2, #9
		MOV B, #0
			
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
		;MOV B, A
		;MOV R5, A
		INC R1
		DJNZ R2, BIGLOOP
		
NEXT: 	MOV A, B
		MOV R5, A
		


ORG 250H
MYDATA:   DB   3, 9, 6, 9, 7, 6, 4, 2, 8
 

END