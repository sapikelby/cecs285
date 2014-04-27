; Write a program to add BCD number 197795H to 344548H and save the BCD result in RAM memory locations starting at 50H. 

ORG 0

MOV A, #48H
ADD A, #95H ; 48H + 95H
DA A

MOV R0, A 

MOV A, #45H
ADD A, #77H ; 45h + 77H
DA A

MOV R1, A

MOV A, #34H
ADD A, #19H ; 34H + 89H
DA A

MOV R2, A

MOV 50H, R2
MOV 51H, R1
MOV 52H, R0

END


