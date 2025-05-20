#!/bin/bash

Timestamp=$(date +"%Y%m%d_%H%M%S")
Output_File="System_report_$Timestamp.txt"

Host_Name=$(hostname)
C_Date=$(date +"%Y-%m-%d_%H:%M:%S")
System_Uptime=$(uptime -p)
Operating_System=$(uname -o)
Kernel_Vs=$(uname -r)

Root_Usage=$(df -h |  grep  -w '/' | awk '{print$5}')
Root_Used=$(printf %s "$Root_Usage" | tr -d [="%"=])
Root_Avail=$(( 100 - $Root_Used))

Disk_Usage=$(df -h |  grep  -w '/home' | awk '{print$5}')
Disk_Used=$(printf %s "$Disk_Usage" | tr -d [="%"=])
Disk_Avail=$(( 100 - $Disk_Used))

Mem_Total=$(free -m | awk '/Mem:/ {print$2}')
Mem_Used=$(free -m | awk '/Mem:/ {print$3}')
Mem_Free=$(free -m | awk '/Mem:/ {print$4}')

C_core=$(nproc)
C_load1=$(uptime | awk '{print $9, $10, $11}')
C_idle=$(top -b -n2 | awk  '/Cpu/ {print$8}' | tail -1)
Top_Proc=$(ps -eo pid,comm,%cpu --sort=-%cpu| head -6)

{
	echo " "
	echo "----------------------------------------------------------------------------------"
	echo "------------------------------System Information----------------------------------"
	echo "----------------------------------------------------------------------------------"
	echo " "

	echo "Hostname                    : $Host_Name"
	echo "Current Time                : $C_Date"
	echo "System Uptime               : $System_Uptime"
	echo "Operating System            : $Operating_System"
	echo "Kernel Version              : $Kernel_Vs"
	echo " "

	echo "CPU Utilization"
	echo "----------------------------------------------------------------------------------"
	echo "Available CPU(s)            : $C_core"
	echo "CPU Load (1, 5, 15 min)     : $C_load1"
	echo "Top 5 processes by CPU Usage: "
	echo "$Top_Proc"
	echo "----------------------------------------------------------------------------------"
	echo " "

	echo "Disk Utilization"
	echo "----------------------------------------------------------------------------------"
	echo "Root(/) Used                : $Root_Usage"
	echo "Root(/) Available           : $Root_Avail%"
	echo "Disk(/home) Used            : $Disk_Usage"
	echo "Disk(/home) Available       : $Disk_Avail%"
	echo "----------------------------------------------------------------------------------"
	echo "Details" 
	echo " "

	df -h

	echo "----------------------------------------------------------------------------------"

	if [ $Root_Used -ge 95 -o $Disk_Used -ge 95 ]; then
		echo "Disk is almost full!"
	else
 		echo -e "Disk is OK!"
	fi

	echo " "
	echo "Memory Utilization"
	echo "----------------------------------------------------------------------------------"
	echo "Total Memory (MB)          : $Mem_Total"
	echo "Used Memory (MB)           : $Mem_Used"
	echo "Free Memory (MB)           : $Mem_Free"
	echo "----------------------------------------------------------------------------------"
	echo "Details"

	free -m

	echo "----------------------------------------------------------------------------------"
} > "$Output_File"

echo "System Report Generated: $Output_File"
