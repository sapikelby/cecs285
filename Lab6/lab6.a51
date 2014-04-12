		ORG 0
MAIN:
		CLR A
		MOV R0, #40H ; destination address
		MOV R2, #10
AGAIN:	MOV @R0, P0
		ADD A, @R0
		
		JNC SKIP
		INC 4BH ; increment 4BH for each carry (HIGH BYTE)
		
SKIP:	INC R0  ; increment the location to which you are adding the string at position(i)
		DJNZ R2, AGAIN
		MOV 4AH, A ; MOVE LOW BYTE INTO 4AH
		END
