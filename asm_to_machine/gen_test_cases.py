opcode_r = {"ADD" : "100000", "AND" : "100100", "OR" : "100101", "SEQ" : "101000", "SLE" : "101100", "SLL" : "000100", "SLT" : "101010", "SNE" : "101001", "SRA" : "000111", "SRL" : "000110", "SUB" : "100010", "XOR" : "100110"}
opcode_i = {"ADDI" : "001000", "ANDI" : "001100", "LHI" : "001111", "LW" : "100011", "ORI" : "001101", "SEQI" : "011000", "SLEI" : "011100", "SLLI" : "010100", "SLTI" : "011010", "SNEI" : "011001", "SRAI" : "010111", "SRLI" : "010110", "SUBI" : "001010", "SW" : "101011", "XORI" : "001110"}
opcode_j = {"BEQZ" : "001001", "BNEZ" : "000101", "JALR" : "010011", "JR" : "010010",  "J" : "000010", "JAL" : "000011"}

asm_file = open("asm.s","a")

#tb_1 cases - For R-type operations (No Read after Write Conflict) 
#for op in opcode_r.keys():
#    asm_file.write("%s R6 R1 R2\n" % (op))

#for op in opcode_r.keys():
#    asm_file.write("%s R6 R4 R5\n" % (op))

#for op in opcode_r.keys():
#    asm_file.write("%s R6 R4 R4\n" % (op))

#for op in opcode_r.keys():
#    asm_file.write("%s R6 R5 R5\n" % (op))


#tb_2 cases - For I-type Instructions (No Read after Write Conflict)
#for op in opcode_i.keys():
#    asm_file.write("%s R1 R0 7\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R1 R0 -7\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R1 R0 32415\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R1 R0 -32415\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R2 R1 7\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R2 R1 -7\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R2 R1 32415\n" % (op))

#for op in opcode_i.keys():
#    asm_file.write("%s R2 R1 -32415\n" % (op))


#tb_3 cases - For R-type operations (With Read after Write Conflict) 
#Only first operand is allowed to conflict - Although any R-type instruction can be written in this form
#i = 0
#for op in opcode_r.keys():
#    if(i == 0):
#        asm_file.write("%s R6 R1 R2\n" % (op))
#        i = 1
#    else:
#        asm_file.write("%s R1 R6 R2\n" % (op))
#        i = 0

#i = 0
#for op in opcode_r.keys():
#    if(i == 0):
#        asm_file.write("%s R6 R4 R5\n" % (op))
#        i = 1
#    else:
#        asm_file.write("%s R4 R6 R5\n" % (op))
#        i = 0


#tb_4 cases - For I-type Instructions (With Read after Write Conflict)
#i = 0
#for op in opcode_i.keys():
#    if((op != "LW")&(op != "SW")):
#        if(i == 0):
#            asm_file.write("%s R2 R1 13\n" % (op))
#            i = 1
#        else:
#            asm_file.write("%s R1 R2 13\n" % (op))
#            i = 0

#i = 0
#for op in opcode_i.keys():
#    if((op != "LW")&(op != "SW")):
#        if(i == 0):
#            asm_file.write("%s R2 R1 -17\n" % (op))
#            i = 1
#        else:
#            asm_file.write("%s R1 R2 -17\n" % (op))
#            i = 0

#i = 0
#for op in opcode_i.keys():
#    if((op != "LW")&(op != "SW")):
#        if(i == 0):
#            asm_file.write("%s R2 R1 32415\n" % (op))
#            i = 1
#        else:
#            asm_file.write("%s R1 R2 32415\n" % (op))
#            i = 0

#i = 0
#for op in opcode_i.keys():
#    if((op != "LW")&(op != "SW")):
#        if(i == 0):
#            asm_file.write("%s R2 R1 -32415\n" % (op))
#            i = 1
#        else:
#            asm_file.write("%s R1 R2 -32415\n" % (op))
#            i = 0

asm_file.close()