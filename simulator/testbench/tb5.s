;For J-type instructions (BEQZ BNEZ J)
AKA Five 5

ADDI R1 R0 Five
ADDI R1 R0 Five
ADDI R1 R0 Five
ADDI R1 R0 Five
Loop1:
BEQZ R0 R1 Halt1
SUBI R1 R1 1
J Loop1
Halt1:

ADDI R1 R0 Five
Loop2:
SUBI R1 R1 1
BNEZ R0 R1 Loop2
Halt2: