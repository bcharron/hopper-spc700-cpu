/*
 SPC700CPU - Copyright (C) 2014 Benjamin Charron
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
    SPC_ACCESS_ABSOLUTE_INDIRECT_X,
    SPC_ACCESS_INDIRECT_ZERO_PAGE_Y
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
