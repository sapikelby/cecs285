ORG	0000H

MAIN:   
		;values A3H, 24H, 38H, 7CH, D3H,79H 
		;move to 31H - 36H      
		MOV 31H, #0A3H
		MOV 32H, #24H
		MOV 33H, #38H
		MOV 34H, #7CH
		MOV 35H, #0D3H
		MOV 36H, #79H

		; push values found in 31H-36H to Stack (pointing to 7, but starting at 8) 
		; stack is then incremented by 1
		PUSH 31H 
		PUSH 32H
		PUSH 33H
		PUSH 34H
		PUSH 35H
		PUSH 36H
		
		; pops values found in stack 
		; registers 0-5 are then filled
		POP 0
		POP 1
		POP 2
		POP 3
		POP 4
		POP 5

		SJMP MAIN
	   	
		END
