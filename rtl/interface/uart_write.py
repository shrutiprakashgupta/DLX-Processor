import serial
import time
import re

#Configure Port
ser = serial.Serial()
ser.baudrate = 115200
ser.port = 'COM6'
ser.bytesize = serial.EIGHTBITS
ser.parity   = serial.PARITY_NONE
ser.stopbits = serial.STOPBITS_ONE
ser.xonxoff  = 0

#Open Port
if(ser.is_open == False):
    ser.open()
print("Port Open")

#Start bit - not saved in memory
time.sleep(1)
ser.write(b'\x00')

#Read input file 
data = open("data_mem.txt",'r')
data = data.readlines()
count = 0
for d in data:
    val = d.strip()
    val = list(re.split(' +', d))
    time.sleep(0.001)
#    ser.write(bytes(1))
    ser.write(bytes([int(val[0])]))
    time.sleep(0.001)
#    ser.write(bytes(1))
    ser.write(bytes([int(val[1])]))
    time.sleep(0.001)
#    ser.write(bytes(1))
    ser.write(bytes([int(val[2])]))
    time.sleep(0.001)
#    ser.write(bytes(1))
    ser.write(bytes([int(val[3])]))
print("Write complete")

for i in range(40):
    c = ser.read()
    if len(c) == 0:
        break
    print(c)

while True:
    c = ser.read()
    if len(c) == 0:
        break
    #print(c)

print("Complete")
ser.close()
