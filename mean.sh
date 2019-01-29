#!/bin/bash
# mean function for matrix script

function mean(){
	# declare vars
	dataFilePath="dataFile$$" # filename

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

	# get row and col numbers
	numRow=0
	numCol=0
	while IFS=$'\n' read -r line; do
		numRow=$( expr $numRow + 1 )
		if [ $numRow -eq 1 ]; then
			for data in $line; do
				numCol=$( expr $numCol + 1 )
			done
		fi
	done <"$dataFilePath"

	# testing
	printf 'numRow: %d\n' "$numRow"
	printf 'numCol: %d\n' "$numCol"


	# iterate over the columns and flip them
	i=1 # counter
	sum=0 # tracks sum for columns
	while [ $i -lt $(expr "$numCol" + 1) ]; do
		myvar=$(cut -f $i $dataFilePath | tr '\n' '\t')
		myvar="${myvar%?}"
		for data in $myvar; do
			sum=$( expr $sum + $data )
		done
	
		mean=$(( ( $sum + ( $numRow / 2 ) * ( ( $sum > 0 ) * 2 - 1 ) ) / $numRow ))

		# testing
		echo $mean
	
		sum=0 # reset sum for next column

		i=$(expr "$i" + 1) # increase counter
	done

	# remove temp file if piped in
	if [ "$#" = 0 ]
	then
		rm -f "$dataFilePath"
	fi


	# success!
	exit 0
}

"$@"
"$?"
