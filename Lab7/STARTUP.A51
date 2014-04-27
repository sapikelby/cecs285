ORG 0

;Write a program to add 897F9AH to 34BC48H and save the result in RAM memory locations starting at 40H
CLR C
MOV A, #48H
ADD A, #9AH ; 48H + 9AH

MOV R0, A 

MOV A, #0BCH
ADDC A, #7FH ; BC + FC

MOV R1, A

MOV A, #34H
ADDC A, #89H ; 34H + 89H

MOV R2, A

MOV 40H, R2
MOV 41H, R1
MOV 42H, R0

END