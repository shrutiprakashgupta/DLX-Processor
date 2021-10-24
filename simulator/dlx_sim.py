import re
import os

def bin_2_dec(val):
    if(val[0] == "1"):
        val = int(val,2) - (1<<len(val))
    else:
        val = int(val,2)
    return val

def dec_2_bin(val):
    if(val < 0):
        val = (1<<32) + val
    return val

def lsb32(val):
    if((val < (1<<31)) & (val > -(1<<31))):
        return val
    else:
        if(val < 0):
            val = (1<<(bin(val)-1)) + val
        val = bin(val)[-32:]
        if(val[0] == "1"):
            val = int(val,2) - (1<<32)
        else:
            val = int(val,2)
        return val

Reg_file = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1023, 0] #R30 - SP R31 - LR
memory = {0:3, 1:4, 2:9, 3:5, 4:-2, 5:-3, 6:0, 7:8, 8:2, 9:19}
instr_file = open("instr.txt","r")
instr_list = instr_file.readlines()
instr_list_size = len(instr_list)
pc = 0
instr = instr_list[pc]
instr = instr[31:-2]
    
#output_file = open("tb6_output.txt","a")
cmd = 'c'
while(pc < 1024):
    i = re.split('_', instr)

    if(i[0] == "000000"):
        if(i[5] == "100000"): 
            #ADD
            val = Reg_file[int(i[1],2)] + Reg_file[int(i[2],2)]
            Reg_file[int(i[3],2)] = lsb32(val)
            pc = pc + 1
        elif(i[5] == "100100"):
            #AND
            val1 = dec_2_bin(Reg_file[int(i[1],2)])
            val2 = dec_2_bin(Reg_file[int(i[2],2)])
            val = bin_2_dec('{0:032b}'.format(val1 & val2))
            Reg_file[int(i[3],2)] = val
            pc = pc + 1
        elif(i[5] == "100101"): 
            #OR
            val1 = dec_2_bin(Reg_file[int(i[1],2)])
            val2 = dec_2_bin(Reg_file[int(i[2],2)])
            val = bin_2_dec('{0:032b}'.format(val1 | val2))
            Reg_file[int(i[3],2)] = lsb32(val)
            pc = pc + 1
        elif(i[5] == "101000"):
            #SEQ
            if(Reg_file[int(i[1],2)] == Reg_file[int(i[2],2)]):
                Reg_file[int(i[3],2)] = 1
            else: 
                Reg_file[int(i[3],2)] = 0
            pc = pc + 1
        elif(i[5] == "101100"):
            #SLE
            if(Reg_file[int(i[1],2)] <= Reg_file[int(i[2],2)]):
                Reg_file[int(i[3],2)] = 1
            else: 
                Reg_file[int(i[3],2)] = 0
            pc = pc + 1
        elif(i[5] == "000100"):
            #SLL
            val1 = Reg_file[int(i[1],2)]
            val2 = dec_2_bin(Reg_file[int(i[2],2)])
            val = val1 << int('{0:032b}'.format(val2)[-4:],2)
            Reg_file[int(i[3],2)] = lsb32(val)
            pc = pc + 1
        elif(i[5] == "101010"):
            #SLT
            if(Reg_file[int(i[1],2)] < Reg_file[int(i[2],2)]):
                Reg_file[int(i[3],2)] = 1
            else: 
                Reg_file[int(i[3],2)] = 0
            pc = pc + 1
        elif(i[5] == "101001"):
            #SNE
            if(Reg_file[int(i[1],2)] != Reg_file[int(i[2],2)]):
                Reg_file[int(i[3],2)] = 1
            else: 
                Reg_file[int(i[3],2)] = 0
            pc = pc + 1
        elif(i[5] == "000111"):
            #SRA
            val1 = Reg_file[int(i[1],2)]
            val2 = dec_2_bin(Reg_file[int(i[2],2)])
            val = val1 >> int('{0:032b}'.format(val2)[-4:],2)
            Reg_file[int(i[3],2)] = lsb32(val)
            pc = pc + 1
        elif(i[5] == "000110"):
            #SRL
            val1 = dec_2_bin(Reg_file[int(i[1],2)])
            val2 = dec_2_bin(Reg_file[int(i[2],2)])
            val2 = int('{0:032b}'.format(val2)[-4:],2)
            val = '{0:032b}'.format(val1)[:-val2]
            Reg_file[int(i[3],2)] = lsb32(bin_2_dec(val2*"0"+val))
            pc = pc + 1
        elif(i[5] == "100010"):
            #SUB
            val = Reg_file[int(i[1],2)] - Reg_file[int(i[2],2)]
            Reg_file[int(i[3],2)] = lsb32(val)
            pc = pc + 1
        else:
            #XOR
            val1 = dec_2_bin(Reg_file[int(i[1],2)])
            val2 = dec_2_bin(Reg_file[int(i[2],2)])
            val = bin_2_dec('{0:032b}'.format(val1 ^ val2))
            Reg_file[int(i[3],2)] = val
            pc = pc + 1
    elif(i[0] == "001000"): 
        #ADDI
        val = Reg_file[int(i[1],2)] + bin_2_dec(i[3])
        Reg_file[int(i[2],2)] = lsb32(val)
        pc = pc + 1
    elif(i[0] == "001100"):
        #ANDI
        val1 = dec_2_bin(Reg_file[int(i[1],2)])
        val = bin_2_dec('{0:032b}'.format(val1 & dec_2_bin(bin_2_dec(i[3]))))
        Reg_file[int(i[2],2)] = val
        pc = pc + 1
    elif(i[0] == "001001"): 
        #BEQZ
        if(Reg_file[int(i[1],2)] == 0):
            offset = bin_2_dec(i[3])>>2
            pc = pc + offset
        else:
            pc = pc + 1
    elif(i[0] == "000101"):
        #BNEZ
        if(Reg_file[int(i[1],2)] != 0):
            offset = bin_2_dec(i[3])>>2
            pc = pc + offset
        else: 
            pc = pc + 1
    elif(i[0] == "000010"):
        #J
        offset = bin_2_dec(i[1])>>2
        pc = pc + offset
    elif(i[0] == "000011"):
        #JAL
        Reg_file[31] = (pc + 1)<<2
        offset = bin_2_dec(i[1])>>2
        pc = pc + offset
    elif(i[0] == "010011"):
        #JALR
        Reg_file[31] = (pc + 1)<<2
        pc = Reg_file[int(i[1],2)]>>2
    elif(i[0] == "010010"):
        #JR
        pc = Reg_file[int(i[1],2)]>>2
    elif(i[0] == "001111"):
        #LHI
        val = bin_2_dec(i[3]) << 16
        Reg_file[int(i[2],2)] = lsb32(val)
        pc = pc + 1
    elif(i[0] == "100011"):
        #LW
        add = (Reg_file[int(i[1],2)] + bin_2_dec(i[3]))>>2
        if(add in memory.keys()):
            Reg_file[int(i[2],2)] = memory[add]
        else:
            Reg_file[int(i[2],2)] = 0
        pc = pc + 1
    elif(i[0] == "001101"):
        #ORI
        val1 = dec_2_bin(Reg_file[int(i[1],2)])
        val2 = dec_2_bin(bin_2_dec(i[3]))
        val = bin_2_dec('{0:032b}'.format(val1 | val2))
        Reg_file[int(i[2],2)] = val
        pc = pc + 1
    elif(i[0] == "011000"):
        #SEQI
        if(Reg_file[int(i[1],2)] == bin_2_dec(i[3])):
            Reg_file[int(i[2],2)] = 1
        else: 
            Reg_file[int(i[2],2)] = 0
        pc = pc + 1
    elif(i[0] == "011100"):
        #SLEI
        if(Reg_file[int(i[1],2)] <= bin_2_dec(i[3])):
            Reg_file[int(i[2],2)] = 1
        else: 
            Reg_file[int(i[2],2)] = 0
        pc = pc + 1
    elif(i[0] == "010100"):
        #SLLI
        val1 = Reg_file[int(i[1],2)]
        val2 = dec_2_bin(bin_2_dec(i[3]))
        val = val1 << int('{0:032b}'.format(val2)[-4:],2)
        Reg_file[int(i[2],2)] = lsb32(val)
        pc = pc + 1
    elif(i[0] == "011010"):
        #SLTI
        if(Reg_file[int(i[1],2)] < bin_2_dec(i[3])):
            Reg_file[int(i[2],2)] = 1
        else: 
            Reg_file[int(i[2],2)] = 0
        pc = pc + 1
    elif(i[0] == "011001"):
        #SNEI
        if(Reg_file[int(i[1],2)] != bin_2_dec(i[3])):
            Reg_file[int(i[2],2)] = 1
        else: 
            Reg_file[int(i[2],2)] = 0
        pc = pc + 1
    elif(i[0] == "010111"):
        #SRAI
        val1 = Reg_file[int(i[1],2)]
        val2 = dec_2_bin(bin_2_dec(i[3]))
        val = val1 >> int('{0:032b}'.format(val2)[-4:],2)
        Reg_file[int(i[2],2)] = lsb32(val)
        pc = pc + 1
    elif(i[0] == "010110"):
        #SRLI
        val1 = dec_2_bin(Reg_file[int(i[1],2)])
        val2 = dec_2_bin(bin_2_dec(i[3]))
        val2 = int('{0:032b}'.format(val2)[-4:],2)
        val = '{0:032b}'.format(val1)[:-val2]
        Reg_file[int(i[2],2)] = lsb32(bin_2_dec(val2*"0"+val))
        pc = pc + 1
    elif(i[0] == "001010"):
        #SUBI
        val = Reg_file[int(i[1],2)] - bin_2_dec(i[3])
        Reg_file[int(i[2],2)] = lsb32(val)
        pc = pc + 1
    elif(i[0] == "101011"):
        #SW
        add = (Reg_file[int(i[1],2)] + bin_2_dec(i[3]))>>2
        memory[add] = Reg_file[int(i[2],2)]
        pc = pc + 1
    else:
        #XORI
        val1 = dec_2_bin(Reg_file[int(i[1],2)])
        val = bin_2_dec('{0:032b}'.format(val1 ^ dec_2_bin(bin_2_dec(i[3]))))
        Reg_file[int(i[2],2)] = val   
        pc = pc + 1

    Reg_file[0] = 0
    os.system('cls')
    print(i)
    print("PC : %d | %s" % (pc,'{0:032b}'.format(pc)))
    for r in range(32):
        val = Reg_file[r]
        if(val < 0):
            val = (1<<32) + val
        print("R%d : %d | %s" % (r,Reg_file[r],'{0:032b}'.format(val)))
    print(memory)
    #output_file.write("%d\n"%(Reg_file[1]))
    cmd = input("Enter to continue:")
    if(cmd == 's'):
        break
    instr = instr_list[pc]
    instr = instr[31:-2]
print("Execution Completed")
