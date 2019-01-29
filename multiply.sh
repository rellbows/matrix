#!/bin/bash
# Multiply function for the matrix script

function multiply(){

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
	if [ "$colNum1" -ne "$rowNum2" ]; then
		echo "Matrices dims. do not match!">&2
		exit 1
	fi	

	# transpose cols from matrix 2 and load into a temp file
	transMatrix2="transMatrix2$$"
	transpose $dataFilePath2 > $transMatrix2 

	# testing
	while read -a line1<&3; do
		j=1 # counter for printing \t \n 
		while read -a line2<&4; do

			i=0 # traveler for multiplicaton/summation
			sum=0 # keeps running total of sum of the products for each matrix 1 / matrix 2 row/line

			while [ $i -lt $colNum1 ]; do
				product=$(( ${line1[$i]} * ${line2[$i]} ))
				sum=$(( $sum + $product ))
				i=$(( $i + 1 ))
			done

			# print out product/summation
			printf '%d' "$sum"
	
			# output \t if more #'s in matrix 1 row to go
			if [ $j -lt $colNum2 ]; then
				printf '\t'
			# output \n if end of matrix 1 row
			elif [ $j -eq $colNum2 ]; then
				printf '\n'
			fi
			
			# increase print counter
			j=$(( $j + 1 ))
			
		done 4<$transMatrix2	
	done 3<$dataFilePath1
	
	# cleanup temp file
	rm -f $transMatrix2

	return 0
}

function transpose(){

	# declare vars
	dataFilePath="dataFile$$" # filename
	i=1 # iterator for cut loop
	colNum=0 # num of columns in matrix	

	# get filename either thru piping or arg
	if [ "$#" = "0" ]
	then
		cat > "$dataFilePath"
	elif [ "$#" = "1" ]
	then
		dataFilePath=$1
	else
		echo "Argument count cannot be greater than 1." >&2 && exit 1
	fi

	read -r line<$dataFilePath 

	# get amount of columns	
	for data in $line;
	do
		# increase column counter
		colNum=$(expr "$colNum" + 1)
	done
		
	# iterate over the columns and flip them
	while [ $i -lt $(expr "$colNum" + 1) ]; do
		myvar=$(cut -f $i $dataFilePath | tr '\n' '\t')
		echo "${myvar%?}"
		i=$(expr "$i" + 1) # increase counter
	done

	# remove temp file if piped in
	if [ "$#" = 0 ]
	then
		rm -f "$dataFilePath"
	fi

	# successful!
	return 0
}

"$@"
exit 0
