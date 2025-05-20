#!/bin/bash

#Below are the paths for source & destination
#Change the paths to your own directories before running the script 
Backup_SRC=~/Company_XYZ/Processed
Backup_DST=~/Company_XYZ/Archived

#move to the source directory
cd $Backup_SRC

#show the files within source directory
echo "Select a file:"
mapfile -d '' options < <(find . -maxdepth 1 -print0)

select opt in "${options[@]}" "Quit"; do
	#exit the menu
	if (( REPLY == ${#options[@]} + 1 )); then
		exit
	#select the file, compress the file & move to destination directory
	elif (( REPLY > 1 && REPLY <= ${#options[@]} )); then
		opt=$(basename $opt)
		echo "Your file is $opt"
		tar -czf "$opt.tar.gz" "$opt"
		mv "$opt.tar.gz" $Backup_DST
		break
	#if invalid option
	else
		echo "Not a valid option. Please try again."
	fi
done

#if exit status is 0, it is successful
if [ $? -eq 0 ]; then
	echo "Backup completed successfully!"
	echo "$opt has been archived successfully"
	echo "$opt has been moved to Archived Directory"
else
	#if exit status not 0, it it unsuccessful
	echo "Error occurred during backup."
	exit 1
fi



