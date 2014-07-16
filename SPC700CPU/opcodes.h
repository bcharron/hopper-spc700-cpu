struct spc700_opcode_struct {
	char mnemonic[10];
    char operand1[10];
    char operand2[10];
	int opcode;
	int len;
};

typedef struct spc700_opcode_struct spc700_opcode_t;
