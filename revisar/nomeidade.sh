#!/bin/bash
clear
echo "What is you name:"
read NAME
clear
echo "What is you years old:"
read YEARS
echo

if [ "$YEARS" -gt 50 ]
then
	echo "Senior :)"
elif [ "$YEARS" -ge 18 ]
	echo "Adult :)"
else
	echo "Menort the 18"
fi
