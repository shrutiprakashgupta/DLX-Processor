#For J-type Instructions (J JAL JR)
ADDI R1 R0 5

J Call1

Fun:
Loop:
BEQZ R0 R1 Halt
SUBI R1 R1 1
J Loop
Halt:
JALR R0 R31 0
J End

Call1:
JAL Fun
Call2:
ADDI R1 R0 6
JR R0 R31 0
End: