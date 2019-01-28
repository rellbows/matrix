#!/bin/bash
# sum function for the matrix script

function sum(){

	# check to ensure 2 args passed
	[ $# -ne 2 ] && echo "invalid number of arguments" >&2 && exit 1

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

	# testing
	# printf 'matrix 1 dims: %d %d\n' "$rowNum1" "$colNum1"
	# printf 'matrix 2 dims: %d %d\n' "$rowNum2" "$colNum2"

	exit 0
}

"$@"
"$?"
