enum spc_access_type {
    SPC_ACCESS_REGISTER,
    SPC_ACCESS_ZERO_PAGE,
    SPC_ACCESS_ZERO_PAGE_X,
    SPC_ACCESS_ABSOLUTE,
    SPC_ACCESS_ABSOLUTE_X,
    SPC_ACCESS_ABSOLUTE_Y,
    SPC_ACCESS_RELATIVE,
    SPC_ACCESS_IMMEDIATE,
    SPC_ACCESS_INDIRECT_X,
    SPC_ACCESS_INDIRECT_Y,
    SPC_ACCESS_NO_OPERAND,
    SPC_ACCESS_ABSOLUTE_INDIRECT_X
};

enum spc_registers {
    SPC_REGISTER_A,
    SPC_REGISTER_X,
    SPC_REGISTER_Y,
    SPC_REGISTER_PSW
};

struct spc700_operand_struct {
    char mnemonic[10];
    enum spc_access_type access_type;
    enum spc_registers register_name;
};

typedef struct spc700_operand_struct spc_operand_t;

struct spc700_opcode_struct {
	char mnemonic[10];
    spc_operand_t operand[2];
	int opcode;
	int len;
};

typedef struct spc700_opcode_struct spc700_opcode_t;
