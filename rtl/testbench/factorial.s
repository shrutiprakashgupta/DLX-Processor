AKA Num 5
ADDI R1 R1 Num
JAL factorial
J halt

factorial:
SW R1 R30 0	
SW R31 R30 -4
SUBI R30 R30 8
ADDI R2 R0 2
SLT R2 R1 R2
BEQZ R0 R2 else	
ADDI R3 R0 1
JR R0 R31 0	

else:
ADDI R1 R1 -1	
JAL factorial	
ADDI R30 R30 8	
LW R1 R30 0	
LW R31 R30 -4	

ADD R4 R0 R3	
SUBI R1 R1 1	
mul:
BEQZ R0 R1 mul_ret	
ADD R3 R3 R4	
SUBI R1 R1 1	
BEQZ R0 R0 mul	
mul_ret:

JR R0 R31 0	

halt:
SW R3 R0 0