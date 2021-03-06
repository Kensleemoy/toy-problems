CC		:= gcc
CFLAGS	:= -std=c99 -Wall -Wextra -g
RANDFLAGS := -std=gnu99 -Wall -Wextra -g
OMPFLAG := -fopenmp

BIN		:= ./bin
SRC		:= ./src
INCL 	:= ./include
LIB		:= ./lib
OUTPUT	:= ./output
TEST	:= ./test/
TESTOUTPUT := ./test/testOutput

all: piLeib piMonte mv mm omp-mm fibonacci mc-openmp mv-openmp piLeib-openmp fib-omp

piLeib: $(SRC)/piLeib.c Makefile
	$(CC) $(CFLAGS) $(SRC)/piLeib.c -o $(BIN)/piLeib

piLeib-openmp: $(SRC)/piLeib-openmp.c Makefile
	$(CC) $(CFLAGS) $(OMPFLAG) $(SRC)/piLeib-openmp.c -o $(BIN)/piLeib-openmp

piMonte: $(SRC)/piMonte.c Makefile
	$(CC) $(CFLAGS) $(SRC)/piMonte.c -o $(BIN)/piMonte

mc-openmp: $(SRC)/mc-openmp.c Makefile
	$(CC) $(RANDFLAGS) $(OMPFLAG) $(SRC)/mc-openmp.c -o $(BIN)/mc-openmp

mv: $(SRC)/mv.c $(LIB)/mmio.c Makefile
	$(CC) $(CFLAGS) $(SRC)/mv.c $(LIB)/mmio.c -o $(BIN)/mv

mv-openmp: $(SRC)/mv-openmp.c $(LIB)/mmio.c Makefile
	$(CC) $(CFLAGS) $(OMPFLAG) $(SRC)/mv-openmp.c $(LIB)/mmio.c -o $(BIN)/mv-openmp
	
mm: $(SRC)/serial-mm.c $(LIB)/mmio.c Makefile
	$(CC) $(CFLAGS) $(SRC)/serial-mm.c $(LIB)/mmio.c -o $(BIN)/mm

omp-mm: $(SRC)/omp-mm.c $(LIB)/mmio.c Makefile
		$(CC) $(CFLAGS) $(OMPFLAG) $(SRC)/omp-mm.c $(LIB)/mmio.c -o $(BIN)/omp-mm        

fibonacci: $(SRC)/fibonacci.c Makefile
	$(CC) $(CFLAGS) $(SRC)/fibonacci.c -o $(BIN)/fibonacci

fib-omp: $(SRC)/fibonacci.c Makefile
	$(CC) $(CFLAGS) $(OMPFLAG) $(SRC)/fib-openmp.c -o $(BIN)/fib-omp

tests:
	-$(TEST)/unit_tests.sh test_logs.txt

clean: 
	-rm -f $(BIN)/*
	-rm -f $(OUTPUT)/*

cleanTests:
	-rm -f $(TESTOUTPUT)/*
	-rm -f diff.out
	-rm -f test_logs.txt
	-rm -f log_slurm.*
