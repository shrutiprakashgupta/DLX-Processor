AKA BaseArray 0 
AKA EndArray 10*4
#Here both beginning and end of the array are small
#Thus directly immediate values are used

ADDI R1 R0 BaseArray

Loop1:
SLTI R2 R1 EndArray
BEQZ R0 R2 Halt

LW R2 R1 0
ADD R3 R1 R0
ADD R4 R1 R0

Loop2:
LW R5 R4 0
ADDI R4 R4 4
SLT R6 R5 R2
BEQZ R0 R6 NoUpdate
ADD R2 R5 R0
ADDI R3 R4 -4
NoUpdate:
SLTI R6 R4 EndArray 
BNEZ R0 R6 Loop2

Swap:
LW R4 R1 0
SW R2 R1 0
SW R4 R3 0

ADDI R1 R1 4
J Loop1
Halt: