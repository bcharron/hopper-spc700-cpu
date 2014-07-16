enum spc_access_type {
    SPC_ACCESS_REGISTER,
    SPC_ACCESS_ZERO_PAGE,
    SPC_ACCESS_ABSOLUTE,
    SPC_ACCESS_ABSOLUTE_X,
    SPC_ACCESS_ABSOLUTE_Y,
    SPC_ACCESS_RELATIVE,
};

struct spc700_opcode_struct {
	char mnemonic[10];
    char operand1[10];
    char operand2[10];
	int opcode;
	int len;
};

struct spc700_operand_struct {
    char mnemonic[10];
    enum spc_access_type access_type;
};

typedef struct spc700_opcode_struct spc700_opcode_t;
