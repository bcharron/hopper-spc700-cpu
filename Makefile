SPC700CPU/opcodes.c: instructions.csv generate-opcodes.py
	./generate-opcodes.py  < instructions.csv > SPC700CPU/opcodes.c

access_types:
	cat instructions.csv  | awk -F'	' '{print $$1}' | cut -d' ' -f2- | tr ',' '\n' | sed 's/^ *//' | sort -u
