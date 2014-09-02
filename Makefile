all: run

kissp:
	iverilog *.v -s processor_tb -o  kissp 
run: kissp
	./kissp 
