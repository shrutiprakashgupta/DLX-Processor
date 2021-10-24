#Alias:
#AKA Alias Value is the standard format (value can also be a numerical expression)
#Label:
#Label: is the standard format (space between Label and : will generate error)
#If value mentioned then it is taken as difference in asm file (thus multiplied with 4)

import re

#OPCODES
opcode_r = {"ADD" : "100000", "AND" : "100100", "OR" : "100101", "SEQ" : "101000", "SLE" : "101100", "SLL" : "000100", "SLT" : "101010", "SNE" : "101001", "SRA" : "000111", "SRL" : "000110", "SUB" : "100010", "XOR" : "100110"}
opcode_i = {"ADDI" : "001000", "ANDI" : "001100", "BEQZ" : "001001", "BNEZ" : "000101", "JALR" : "010011", "JR" : "010010", "LHI" : "001111", "LW" : "100011", "ORI" : "001101", "SEQI" : "011000", "SLEI" : "011100", "SLLI" : "010100", "SLTI" : "011010", "SNEI" : "011001", "SRAI" : "010111", "SRLI" : "010110", "SUBI" : "001010", "SW" : "101011", "XORI" : "001110"}
opcode_j = { "J" : "000010", "JAL" : "000011"}

#Output file - machine code
instr_file_size = (1<<10)
instr_file = open("instr.txt",'w')

asm = open("asm.s", 'r')
instrs = asm.readlines()
count = 0
num = 0

labels = {}
alias = {}

for instr in instrs:
    instr = instr.strip()
    i = re.split(' +', instr)
    num = num + 1

    if(len(i) == 1) & (i[0] == "") :
        count = count 

    elif(i[0][0] == "#"):
        count = count

    elif(i[0] in opcode_r.keys()):
        #R-type
        count = count + 1

    elif(i[0] in opcode_i.keys()):
        #I-type
        count = count + 1

    elif(i[0] in opcode_j.keys()):
        #J-type
        count = count + 1
    
    elif(i[0][-1] == ":"): 
        #Label
        if(i[0][0] == ":"):
            raise ValueError("Line %d: Label must have atleast one character" % (num))
        elif((i[0][:-1] in opcode_r.keys()) | (i[0][:-1] in opcode_i.keys()) | (i[0][:-1] in opcode_j.keys())):
            raise ValueError("Line %d: Label must have a different name from instructions" % (num))
        elif(i[0][:-1] in alias.keys()):
            raise ValueError("Line %d: Label must be unique - Matching with immediate alias" % (num))
        elif(i[0][:-1] in labels.keys()):
            raise ValueError("Line %d: Label must be unique - Matching with predefined label" % (num))
        elif(i[0][0].isdigit()):
            raise ValueError("Line %d: Label must begin with alphabet" % (num))
        elif((i[0][0] == "R") & (i[0][1:3].isdigit())):
            if(int(i[0][1:3]) < 32):
                raise ValueError("Line %d: \"Rn\" where n is 0 to 31, is reserved. Use some other format for label" % (num))
        labels[i[0][:-1]] = count
        count = count       

    elif(i[0] == "AKA"):
        #Alias
        if(i[1][0].isdigit()):
            raise ValueError("Line %d: Alias must begin with alphabet" % (num))
        elif((i[1] in opcode_r.keys()) | (i[0][:-1] in opcode_i.keys()) | (i[0][:-1] in opcode_j.keys())):
            raise ValueError("Line %d: Alias must have a different name from instructions" % (num))
        elif(i[1] in alias.keys()):
            raise ValueError("Line %d: Alias must be unique - Matching with predefined alias" % (num))
        elif(i[1] in labels.keys()):
            raise ValueError("Line %d: Alias must be unique - Matching with predefined label" % (num))
        elif((i[1] == "R") & (i[0][1:3].isdigit())):
            if(int(i[0][1:3]) < 32):
                raise ValueError("Line %d: \"Rn\" where n is 0 to 31, is reserved. Use some other format for alias" % (num))
        alias[i[1]] = eval(i[2])
        count = count       

    else:
        raise ValueError("Line %d: Could not be resolved" % (num)) 

count = 0
num = 0
for instr in instrs:
    instr = instr.strip()
    i = re.split(' +', instr)
    num = num + 1

    if((len(i) == 1) & (i[0] == "")):
        count = count 

    elif(i[0][0] == "#"):
        count = count

    elif(i[0] in opcode_r.keys()):
        #R-type
        if(len(i) != 4):
            raise SyntaxError("Line %d: R-type instructions should have four attributes" % (num))
        elif((i[1][0] != "R") | (i[2][0] != "R") | (i[3][0] != "R")):
            raise SyntaxError("Line %d: R-type instructions should have form \"ADD R3 R2 R1\"" % (num))
        elif((i[1][1:3].isdigit() == 0) | (i[2][1:3].isdigit() == 0) | (i[3][1:3].isdigit() == 0)):
            raise SyntaxError("Line %d: Registers must be of form Rn where n = 0 to 31" % (num))
        elif((int(i[1][1:3]) > 31) | (int(i[1][1:3]) < 0) | (int(i[2][1:3]) > 31) | (int(i[2][1:3]) < 0) | (int(i[3][1:3]) > 31) | (int(i[3][1:3]) < 0)):
            raise SyntaxError("Line %d: Registers must be between R0 and R31" % (num))
        count = count + 1

    elif(i[0] in opcode_i.keys()):
        #I-type
        if(len(i) != 4):
            raise SyntaxError("Line %d: I-type instructions should have four attributes" % (num))
        elif((i[1][0] != "R") | (i[2][0] != "R")):
            raise SyntaxError("Line %d: R-type instructions should have form \"ADD R3 R2 5\"" % (num))
        elif((i[1][1:3].isdigit() == 0) | (i[2][1:3].isdigit() == 0)):
            raise SyntaxError("Line %d: Registers must be of form Rn where n = 0 to 31" % (num))
        elif((int(i[1][1:3]) > 31) | (int(i[1][1:3]) < 0) | (int(i[2][1:3]) > 31) | (int(i[2][1:3]) < 0)):
            raise SyntaxError("Line %d: Registers must be between R0 and R31" % (num))
        elif((i[0] == "BEQZ") | (i[0] == "BNEZ") | (i[0] == "JALR") | (i[0] == "JR")):
            if((i[3].lstrip("-").isdigit() == 0) & (i[3] not in labels.keys())):
                raise ValueError("Line %d: Undefined Label" % (num))
            elif(i[3].lstrip("-").isdigit() == 0):
                if((labels[i[3]] > 32767) | (labels[i[3]] < -32767)):
                    raise ValueError("Line %d: Immediate value for label must be in the range +-32767" % (num))
        else:
            if((i[3].lstrip("-").isdigit() == 0) & (i[3] not in alias.keys())):
                raise ValueError("Line %d: Undefined Alias" % (num))
            elif(i[3].lstrip("-").isdigit() == 0):
                if((alias[i[3]] > 32767) | (alias[i[3]] < -32767)):
                    raise ValueError("Line %d: Immediate value must be in the range +-32767" % (num))
        count = count + 1

    elif(i[0] in opcode_j.keys()):
        #J-type
        if(len(i) != 2):
            raise SyntaxError("Line %d: J-type instructions should have two attributes" % (num))
        elif((i[1].lstrip("-").isdigit() == 0) & (i[1] not in labels.keys())):
            raise ValueError("Line %d: Undefined Label" % (num))
        elif(i[1].lstrip("-").isdigit() == 0):
            if((labels[i[1]] > 8388607) | (labels[i[1]] < -8388607)):
                raise ValueError("Line %d: Label must be below +-8388607 instructions from current Instruction" % (num))
        count = count + 1

    elif(i[0][-1] == ":"): 
        #Label
        count = count        

    elif(i[0] == "AKA"):
        #Alias
        count = count       

    else:
        raise ValueError("Line %d: Could not be resolved" % (num)) 

print("ASM instructions resolved")
print(" ")

print("Label")
for label in labels.keys():
    print(label+" : "+str(labels[label]))
print(" ")

print("Alias")
for aka in alias.keys():
    print(aka+" : "+str(alias[aka]))
print(" ")

count = 0
for instr in instrs:
    instr = instr.strip()
    i = re.split(' +', instr)

    #R-type
    if(i[0] in opcode_r.keys()):
        #ADD Rd Rs1 Rs2
        op = opcode_r[i[0]]
        if(i[1][0] == "R"):
            rd = '{0:05b}'.format(int(i[1][1:],10))
        if(i[2][0] == "R"):
            rs1 = '{0:05b}'.format(int(i[2][1:],10))
        if(i[3][0] == "R"):
            rs2 = '{0:05b}'.format(int(i[3][1:],10))
        mch_code = "".join(["32'b000000_",rs1,"_",rs2,"_",rd,"_","00000","_",op])
        instr_file.write("10'b%s : memory <= %s;\n" % ('{0:010b}'.format(count),mch_code))
        count = count + 1
        
    #I-type
    elif(i[0] in opcode_i.keys()):
        #ADDI Rd Rs1 Imm
        op = opcode_i[i[0]]
        if(i[1][0] == "R"):
            rd = '{0:05b}'.format(int(i[1][1:],10))
        if(i[2][0] == "R"):
            rs1 = '{0:05b}'.format(int(i[2][1:],10))
        if((i[0] == "BEQZ") | (i[0] == "BNEZ") | (i[0] == "JALR") | (i[0] == "JR")):
            if(i[3] in labels.keys()):
                imm_val = (labels[i[3]] - count)*4
                if(imm_val < 0):
                    imm_val = (1<<16) + imm_val  
            else:
                imm_val = int(i[3])*4
                if(imm_val < 0):
                    imm_val = (1<<16) + imm_val  
        else:
            if(i[3] in alias):
                imm_val = alias[i[3]]
            else:
                imm_val = int(i[3])
            if(imm_val < 0):
                imm_val = (1<<16) + imm_val
        imm = '{0:016b}'.format(imm_val)
        mch_code = "".join(["32'b",op,"_",rs1,"_",rd,"_",imm])
        instr_file.write("10'b%s : memory <= %s;\n" % ('{0:010b}'.format(count),mch_code))
        count = count + 1

    elif(i[0] in opcode_j.keys()):
        #J Val
        op = opcode_j[i[0]]
        if(i[1] in labels.keys()):
            val = (labels[i[1]] - count)*4 
            if(val < 0):
                val = (1<<26) + val  
        else:
            val = int(i[1])*4
            if(val < 0):
                val = (1<<26) + val    
        val = '{0:026b}'.format(val)
        mch_code = "".join(["32'b",op,"_",val])
        instr_file.write("10'b%s : memory <= %s;\n" % ('{0:010b}'.format(count),mch_code))
        count = count + 1

    else:
        #Label or Alias or Blank line or Comment(#)
        count = count       
    
if(count < instr_file_size-1):
    while(count < instr_file_size):
        instr_file.write("10'b%s : memory <= 32'b000000_00000_00000_00000_00000_100100;\n" % ('{0:010b}'.format(count)))     
        count += 1        

print("Machine code generated")
