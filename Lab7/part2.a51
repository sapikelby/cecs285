ORG 0

;Write a program to subtract 197F9AH from 344548H and save the result in RAM memory locations starting at 45H. 
CLR C
MOV A, #48H
SUBB A, #9AH ; 48H - 9AH

MOV R0, A 

MOV A, #45H
SUBB A, #7FH ; BC - FC

MOV R1, A

MOV A, #34H
SUBB A, #19H ; 34H - 89H

MOV R2, A

MOV 45H, R2
MOV 46H, R1
MOV 47H, R0

END
