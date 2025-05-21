#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
	echo "Error: Please run this script with root access!"
	exit 1
fi

add_user(){
	read -p "Enter new username: " username
	if id "$username" &>/dev/null; then
		echo "Error: $username already exist"
		exit 1
	fi

	password=$(openssl rand -base64 12)

	useradd -m -s  /bin/bash "$username" && echo "$username:$password" | chpasswd

	if [ $? -eq 0 ]; then
		echo "User: $username | Password: $password" >> user_mgmt.log
	else
		echo "Error: Failed to create user"
	fi
}

delete_user(){
	read -p "Enter the username: " username
	if id "$username" &>/dev/null; then
		userdel -r "$username"
		if [  $? -eq 0 ]; then
			echo "User: $username | Password: $password - DELETED"
		else
			echo "Error: Failed to delete user"
		fi
	else
		echo "Error: User does not exist"
	fi
}

list_user(){

	echo " "
	echo "-------------------------------"
	echo "List of Users!"
	echo "-------------------------------"
	awk -F':' '$3 >= 1000 { print $1 }' /etc/passwd | grep -v "nobody"
	echo "-------------------------------"
}

show_menu(){
        echo "-------------------------------"
        echo "User Management!"
        echo "-------------------------------"
        echo "1. Add New User!"
        echo "2. Delete a User!"
        echo "3. List All Users!"
        echo "4. Exit!"
        read -p  "Choose an Option (1-4): " choice
        case $choice in
                1) add_user ;;
                2) delete_user ;;
                3) list_user ;;
                4) echo "Exit Script!"; exit 0 ;;
        esac

}

show_menu
