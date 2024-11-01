#!/bin/bash

scan_dir=""
failed=0
cnt=0
total=$(ls "$scan_dir" | wc -l)
cd $scan_dir
if [[ $? -ne 0 ]]
then
	echo -e "$(tput setaf 1)Failed to change directory to scan dir"
 	exit 1
fi

for x in *
do 
	tput setaf 7
	echo "$(tput setaf 4)File : "$(tput setaf 7)$x""; 
	file_extension=${x#*.}
	extension=$(exiftool "$x" | awk '/File Type Extension/ {print $5}')
	echo "$(tput setaf 4)File Extension   : $(tput setaf 7)$file_extension"
	echo "$(tput setaf 4)Actual Extension : $(tput setaf 7)$extension"
	
	if [[ "$extension" != "$file_extension" ]]; 
	then 	
		echo "$(tput setaf 3)Renaming to ${x%.$file_extension}.$extension...";
		mv "$x" "${x%.$file_extension}.$extension"
		if [[ $? -eq 0 ]]
		then
			echo -e "$(tput setaf 2)Done.\n";
			((cnt++))
		else
			echo -e "$(tput setaf 1)Failed to rename!!\n";
			((failed++))
		fi
		 
	else
		echo -e "Nothing to do!\n"
	fi; 
done

echo "$(tput setaf 3)Statistics"
echo "$(tput setaf 7)Total files : $(tput setaf 2)$total"
echo "$(tput setaf 7)Modified    : $(tput setaf 2)$cnt"
echo "$(tput setaf 7)Failed      : $(tput setaf 1)$failed"
tput setaf 7
