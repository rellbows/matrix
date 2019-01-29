#!/bin/bash
# description: 'dims' function for matrix prog.

function dims(){
	
	# check to ensure valid number of args.
	# citation: used code from below link for ref
	# https://oregonstate.instructure.com/courses/1706555/pages/1-dot-4-bash-functions
	# [ $# -ne 1 ] && echo "invalid number of arguments" >&2

	# check to ensure only integer numbers passed in for 2nd arg
	# citation: used same site as above snippet
	# [[ $1 =~ [^0-9]+ ]] && echo "argument '$1' is not an integer" >&2

	# get file contents into stdin using this can get either
	# when file is piped in or if passed as argument
	dataFilePath="dataFile$$"

	if [ "$#" = "0" ]
	then
		cat > "$dataFilePath"
	elif [ "$#" = "1" ]
	then
		dataFilePath=$1
	else
		echo "Arugment count cannot be greater than 1." >&2 && exit 1
	fi
	
	# declare vars 
	rowNum=0
	colNum=0	

	# iterate thru whole matrix
	# first, reset internal field separator var (IFS)
	while IFS=$'\n' read -r line;
	do
		# increase row counter
		rowNum=$(expr "$rowNum" + 1)

		# iterate across the first row
		# don't need to check additional rows bc
		# we have already verified matrix is valid
		if [ "$rowNum" = "1"  ]
		then
			for data in $line;
			do
				
				# increase column counter
				colNum=$(expr "$colNum" + 1)

			done
		fi

	done < "$dataFilePath"

	# output row and column numbers
	echo "$rowNum $colNum"

	# clean up temp file if piped in
	if [ "$#" = 0 ]
	then
		rm -f "$dataFilePath"
	fi

	# successful!
	return 0
}

"$@"
exit 0
