SPC700CPU/opcodes.c: instructions.csv generate-opcodes.py
	./generate-opcodes.py  < instructions.csv > SPC700CPU/opcodes.c
