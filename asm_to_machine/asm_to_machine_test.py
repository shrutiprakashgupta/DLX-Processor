import re
import os
import random

instr_comb = open("instr_comb.txt",'r')
instrs = instr_comb.readlines()

for i in range(90):
    asm_file = open("asm.s","w")
    instr = instrs[i].strip()
    instr = re.split('\t+', instr)
    val1 = random.randint(1,3)
    val2 = random.randint(1,3)
    if(val1 == 1):
        asm_file.write("AKA Five 5 \n")
        print("AKA Five 5 \n")
    if(val2 == 1):
        asm_file.write("Loop: \n")
        print("Loop: \n")
    asm_file.write("%s %s %s %s\n" % (instr[0],instr[1],instr[2],instr[3]))
    print("%s %s %s %s\n" % (instr[0],instr[1],instr[2],instr[3]))
    asm_file.close()
    os.system('python asm_to_machine.py')
    input()
    os.system('cls')

for i in range(91,149):
    asm_file = open("asm.s","w")
    instr = instrs[i].strip()
    instr = re.split('\t+', instr)
    val1 = random.randint(1,3)
    val2 = random.randint(1,3)
    if(val1 == 1):
        asm_file.write("AKA Five 5 \n")
        print("AKA Five 5 \n")
    if(val2 == 1):
        asm_file.write("Loop: \n")
        print("Loop: \n")
    asm_file.write("%s %s\n" % (instr[0],instr[1]))
    print("%s %s\n" % (instr[0],instr[1]))
    asm_file.close()
    os.system('python asm_to_machine.py')
    input()
    os.system('cls')
