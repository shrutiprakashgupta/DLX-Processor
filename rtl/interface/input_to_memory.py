import re

memory = {}
data_file = open("data_in.txt","r")
mem_file = open("data_mem.txt","w")

data = data_file.readlines()
for d in data:
    d = d.strip()
    d = re.split(' +', d)
    memory[int(d[0],10)] = int(d[1],10)

print(memory)
for i in range(1<<10):
    if(i in memory.keys()):
        val = memory[i]
        if(val < 0):
            val = (1<<32) + val
        val = '{0:032b}'.format(val)
        print(val)
        val_list = [int(val[24:],2), int(val[16:24],2), int(val[8:16],2), int(val[0:8],2)]
        print(val_list)        
    else:
        val_list = [0, 0, 0, 0]
    mem_file.write("%d %d %d %d \n" % (val_list[0], val_list[1], val_list[2], val_list[3]))
mem_file.close()
print("Memory file generated")