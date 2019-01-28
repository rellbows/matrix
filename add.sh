#!/bin/bash
# sum function for the matrix script

function add(){

	# check to ensure 2 args passed
	[ $# -ne 2 ] && echo "Arugment count must be 2." >&2 && exit 1

	# get the filenames
	dataFilePath1=$1
	dataFilePath2=$2

	# vars to hold size of both matrices
	rowNum1=0
	rowNum2=0
	colNum1=0
	colNum2=0

	# check dims of both matrices
	# first, reset internal field separator var (IFS)
	while IFS=$'\n' read -r line;
	do
		# increase row counter
		rowNum1=$(expr "$rowNum1" + 1)

		# iterate across the first row
		# don't need to check additional rows bc
		# we have already verified matrix is valid
		if [ "$rowNum1" = "1"  ]
		then
			for data in $line;
			do
				
				# increase column counter
				colNum1=$(expr "$colNum1" + 1)

			done
		fi

	done < "$dataFilePath1"
	
	# second matrix
	while IFS=$'\n' read -r line;
	do
		# increase row counter
		rowNum2=$(expr "$rowNum2" + 1)

		# iterate across the first row
		# don't need to check additional rows bc
		# we have already verified matrix is valid
		if [ "$rowNum2" = "1"  ]
		then
			for data in $line;
			do
				
				# increase column counter
				colNum2=$(expr "$colNum2" + 1)

			done
		fi

	done < "$dataFilePath2"
	
	#evaluate matrice dims
	if [ "$rowNum1" -ne "$rowNum2" ] || [ "$colNum1" -ne "$colNum2" ] ; then
		echo "Matrices dims. do not match!">&2
		exit 1
	fi	

	# testing
	# printf 'matrix 1 dims: %d %d\n' "$rowNum1" "$colNum1"
	# printf 'matrix 2 dims: %d %d\n' "$rowNum2" "$colNum2"

	# open up both files and iterate over them to get sums
	# used below links for ref. about using multiple file
	# descriptors to read two files in one loop
	#https://unix.stackexchange.com/questions/26601/how-to-read-from-two-input-files-using-while-loop 	
	# https://en.wikipedia.org/wiki/File_descriptor
	while read -a line1<&3 && read -a line2<&4; do
		#echo $line1
		#echo $line2
		i=0
		while [ $i -lt $colNum1 ]; do
			# testing
			#printf 'line1[%d]: %d\n' "$i" "${line1[$i]}"
			sum=$( expr ${line1[$i]} + ${line2[$i]} )
			printf '%d' "$sum"
			if [ $i -lt $(expr $colNum1 - 1) ]; then
				printf '\t' 
			elif [ $i -eq $(expr $colNum1 - 1 ) ]; then
				printf '\n'
			fi
			i=$( expr $i + 1 )
			sum=0
		done
	done 3<$dataFilePath1 4<$dataFilePath2
	
	# cleanup the temp files
	rm -f temp1 temp2

	exit 0
}

"$@"
"$?"
