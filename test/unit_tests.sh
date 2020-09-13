#!/bin/bash

if [ "$1" = "" ];then
    echo "usage: $0 <output file>"
    echo "   output file - the file to save output in"
    echo "   if output file exists, this script will append to it"
    exit 0;
fi

total = 0
maxpts = 0
dest="$1"
TESTFILES=./test/testFiles
OUTPUTFILES=./test/testOutput

addPoint() {
    let "total=total+1"
    let "maxpts=maxpts+1"
}

removePoint() {
    if [ "$total" == 0 ]; then
        let "total=0"
        let "maxpts=maxpts+1"
    else 
        let "total=total-1"
        let "maxpts=maxpts+1"
    fi
}

displayFinal() {
    echo
    echo "-----$total out of $maxpts tests PASSED-----"
    if [ "$total" != "$maxpts" ]; then
        echo "Errors can be found in ./test/testOutput/grader.txt"
    else 
        echo "Full Log can be found in ./test/testOutput/grader.txt"
    fi
    echo "$total out of $maxpts tests PASSED" >> $dest
}

if [ -f $dest ];
then
    removePoint
	echo >> $dest
	echo "unit_tests.sh: output file $dest exists, appending to it" >> $dest
	echo >> $dest
else
    addPoint
fi

echo
echo "***unit_tests.sh -- running tests***"
echo

make
if [ ! $? -eq 0 ];then
    removePoint
    echo "unit_tests: FAIL - make returned non-zero"  >> $dest
    exit 1
else 
    addPoint
fi

if [ ! -x "./bin/piLeib" ];then
    removePoint
    echo "MAKE: FAIL - no exe named piLeib in ./bin/" >> $dest
    exit 1
else
    addPoint
fi

if [ ! -x "./bin/fibonacci" ];then
    removePoint
    echo "MAKE: FAIL - no exe named fibonacci in ./bin/" >> $dest
    exit 1
else    
    addPoint
fi

if [ ! -x "./bin/mm" ];then
    removePoint
    echo "MAKE: FAIL - no exe named mm in ./bin/" >> $dest
    exit 1
else
    addPoint
fi

if [ ! -x "./bin/mv" ];then
    removePoint
    echo "MAKE: FAIL - no exe named mv in ./bin/" >> $dest
    exit 1
else
    addPoint
fi

if [ ! -x "./bin/piMonte" ];then
    removePoint
    echo "MAKE: FAIL - no exe named piMonte in ./bin/" >> $dest
    exit 1
else  
    addPoint
fi

echo "START: Testing Leibniz's Pi Estimation" >> $dest
./bin/piLeib hi >> ./output/output.txt
if [ "$?" == 0 ]
then   
    removePoint
    echo "ERROR: piLeib accepts invalid arguments" >> $dest
else 
    addPoint
    echo "---SUCCESS: piLeib rejects invalid arguments" >> $dest
fi

rm -f ./output/output.txt

./bin/piLeib 100 >> ./output/output.txt
diff -i -w -B ./output/output.txt $TESTFILES/piLeib100.txt >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: piLeib 100" >> $dest
else
    removePoint
    echo "ERROR: piLeib did not calculate with value 100 correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

rm -f ./output/output.txt

./bin/piLeib 1000 >> ./output/output.txt
diff -i -w -B ./output/output.txt $TESTFILES/piLeib1000.txt >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: piLeib 1000" >> $dest
else
    removePoint
    echo "ERROR: piLeib did not calculate with value 1000 correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

rm -f ./output/output.txt

echo >> $dest
echo "START: Testing Monte Carlo's Pi Estimation" >> $dest
./bin/piMonte >> ./output/output.txt
if [ "$?" == 0 ]; then
    addPoint
    echo "---SUCCESS: piMonte runs with default value of 10" >> $dest
else
    removePoint
    echo "ERROR: piMonte did not run correctly"
fi

rm -f ./output/output.txt

echo >> $dest
echo "START: Testing Fibonacci" >> $dest

./bin/fibonacci hi >> ./output/output.txt
if [ "$?" == 0 ]; then
    removePoint
    echo "ERROR: fibonacci accepts invalid arguments" >> $dest
else 
    addPoint
    echo "---SUCCESS: fibonacci rejects invalid arguments" >> $dest
fi

rm -f ./output/output.txt

./bin/fibonacci 1 >> ./output/output.txt
diff -i -w -B ./output/output.txt $TESTFILES/fib1.txt >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: fibonacci(1) = 1" >> $dest
else
    removePoint
    echo "ERROR: fibonacci is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

rm -f ./output/output.txt

./bin/fibonacci 3 >> ./output/output.txt
diff -i -w -B ./output/output.txt $TESTFILES/fib3.txt >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: fibonacci(3) = 2" >> $dest
else
    removePoint
    echo "ERROR: fibonacci is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

rm -f ./output/output.txt

./bin/fibonacci 10 >> ./output/output.txt
diff -i -w -B ./output/output.txt $TESTFILES/fib10.txt >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: fibonacci(10) = 55" >> $dest
else
    removePoint
    echo "ERROR: fibonacci is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

rm -f ./output/output.txt

echo >> $dest
echo "START: Testing Matrix-Vector Multiply" >> $dest
./bin/mv ./input/matrix1.m ./input/matrix3.m ./output/outputVector.m
if [ "$?" == 0 ]; then
    removePoint
    echo "ERROR: mv accepts invalid arguments" >> $dest
else
    addPoint
    echo "---SUCCESS: mv rejects invalid matrices" >> $dest
fi

./bin/mv ./input/matrix1.m hello ./output/outputVector.m
if [ "$?" == 0 ]; then
    removePoint 
    echo "ERROR: mv accepts invalid arguments" >> $dest
else
    addPoint
    echo "---SUCCESS: mv rejects invalid matrices" >> $dest
fi

./bin/mv ./input/matrix1.m ./input/vector1.m ./output/outputVector.m
diff -i -w -B ./output/outputVector.m $TESTFILES/m1v1output.m >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: mv correctly multiplies matrix x vector" >> $dest
else
    removePoint
    echo "ERROR: mv is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

./bin/mv ./input/matrix3.m ./input/vector2.m ./output/outputVector.m
diff -i -w -B ./output/outputVector.m $TESTFILES/m3v2output.m >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: mv correctly multiplies matrix x vector" >> $dest
else
    removePoint
    echo "ERROR: mv is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

echo >> $dest
echo "START: Testing Matrix-Matrix Multiply" >> $dest
./bin/mm ./input/matrix1.m ./input/matrix3.m ./output/outputMatrix.m
if [ "$?" == 0 ]; then
    removePoint
    echo "ERROR: mm accepts invalid matrices" >> $dest
else
    addPoint
    echo "---SUCCESS: mm rejects invalid matrices" >> $dest
fi

./bin/mm ./input/matrix1.m hello ./output/outputMatrix.m
if [ "$?" == 0 ]; then
    removePoint 
    echo "ERROR: mm accepts invalid arguments" >> $dest
else
    addPoint
    echo "---SUCCESS: mm rejects invalid arguments" >> $dest
fi

./bin/mm ./input/matrix1.m ./input/matrix2.m ./output/outputMatrix.m
diff -i -w -B ./output/outputMatrix.m $TESTFILES/m1m2output.m >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: mm correctly multiplies matrix x matrix" >> $dest
else
    removePoint
    echo "ERROR: mm is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
    exit 1
fi

./bin/mm ./input/matrix3.m ./input/matrix4.m ./output/outputMatrix.m
diff -i -w -B ./output/outputMatrix.m $TESTFILES/m3m4output.m >>diff.out
if [ "$?" == 0 ]; then 
    addPoint
    rm diff.out
    echo "---SUCCESS: mm correctly multiplies matrix x matrix" >> $dest
else
    removePoint
    echo "ERROR: mm is not calculating correctly" >> $dest
    echo "Note: The diff result is in ./diff.out" >> $dest
fi

echo >> $dest
echo "CLEANING: ---" >> $dest
make clean
if [ "$?" == 0 ]; then 
    addPoint
    echo "---SUCCESS: make clean" >> $dest
else
    removePoint
    echo "ERROR: make clean did not work" >> $dest
fi

displayFinal