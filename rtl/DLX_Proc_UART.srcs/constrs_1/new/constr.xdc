## This file is a general .xdc for the Basys3 rev B board

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} -add [get_ports clk]

# Switches
#set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
#set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
#set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
#set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
#set_property PACKAGE_PIN T3 [get_ports {sw[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
#set_property PACKAGE_PIN R3 [get_ports {sw[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
#set_property PACKAGE_PIN T1 [get_ports {sw[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
#set_property PACKAGE_PIN R2 [get_ports {sw[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]


# LEDs
set_property PACKAGE_PIN U16 [get_ports {state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]
set_property PACKAGE_PIN E19 [get_ports {state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]
set_property PACKAGE_PIN U19 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[2]}]
set_property PACKAGE_PIN V19 [get_ports {index[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {index[0]}]
set_property PACKAGE_PIN W18 [get_ports {index[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {index[1]}]
set_property PACKAGE_PIN U15 [get_ports {index[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {index[2]}]
set_property PACKAGE_PIN U14 [get_ports {index[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {index[3]}]
set_property PACKAGE_PIN V14 [get_ports {index[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {index[4]}]
set_property PACKAGE_PIN V13 [get_ports {index[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {index[5]}]
set_property PACKAGE_PIN V3 [get_ports {index[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {index[6]}]
set_property PACKAGE_PIN W3 [get_ports {index[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {index[7]}]
set_property PACKAGE_PIN U3 [get_ports {index[8]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {index[8]}]
set_property PACKAGE_PIN P3 [get_ports {index[9]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {index[9]}]
set_property PACKAGE_PIN N3 [get_ports {index[10]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {index[10]}]
set_property PACKAGE_PIN P1 [get_ports {index[11]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {index[11]}]
#set_property PACKAGE_PIN L1 [get_ports rst]
#set_property IOSTANDARD LVCMOS33 [get_ports rst]


##7 segment display
#set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
#set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
#set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
#set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
#set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
#set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
#set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

#set_property PACKAGE_PIN V7 [get_ports dp]
#	set_property IOSTANDARD LVCMOS33 [get_ports dp]

#set_property PACKAGE_PIN U2 [get_ports {an0}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {an0}]
#set_property PACKAGE_PIN U4 [get_ports {an1}]
#	set_property IOSTANDARD LVCMOS33 [get_ports {an1}]
##set_property PACKAGE_PIN V4 [get_ports {an[2]}]
##	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
##set_property PACKAGE_PIN W4 [get_ports {an[3]}]
##	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


###Buttons
#set_property PACKAGE_PIN U18 [get_ports rst]
#	set_property IOSTANDARD LVCMOS33 [get_ports rst]
##set_property PACKAGE_PIN T18 [get_ports btnU]
#	#set_property IOSTANDARD LVCMOS33 [get_ports btnU]
##set_property PACKAGE_PIN W19 [get_ports btnL]
#	#set_property IOSTANDARD LVCMOS33 [get_ports btnL]
##set_property PACKAGE_PIN T17 [get_ports btnR]
#	#set_property IOSTANDARD LVCMOS33 [get_ports btnR]
##set_property PACKAGE_PIN U17 [get_ports btnD]
#	#set_property IOSTANDARD LVCMOS33 [get_ports btnD]

#USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
#Transmitter with reference to the computer

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]






