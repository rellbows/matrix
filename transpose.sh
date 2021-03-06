#!/bin/bash
# description: transposes the rwos and columns in a matrix over its diagonal
# axis

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
