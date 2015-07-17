#include "opcodes2.h"

opcode_t OPCODE_BY_NUMBER[] = {
	/* 0x00 */  { "NOP", 0x00, 1 },
	/* 0x01 */  { "TCALL 0 [$FFDE]", 0x01, 1 },
	/* 0x02 */  { "SET0 $%02X", 0x02, 2 },
	/* 0x03 */  { "BBS0 $%02X,#$%02X", 0x03, 3 },
	/* 0x04 */  { "ORZ A,$%02X", 0x04, 2 },
	/* 0x05 */  { "OR A,$%02X%02X", 0x05, 3 },
	/* 0x06 */  { "OR A,(X)", 0x06, 1 },
	/* 0x07 */  { "OR A,[$%02X+X]", 0x07, 2 },
	/* 0x08 */  { "OR A,#$%02X", 0x08, 2 },
	/* 0x09 */  { "OR $%02X,$%02X", 0x09, 3 },
	/* 0x0A */  { "OR1 C,$%02X", 0x0A, 3 },
	/* 0x0B */  { "ASLZ $%02X", 0x0B, 2 },
	/* 0x0C */  { "ASL $%02X%02X", 0x0C, 3 },
	/* 0x0D */  { "PUSH PSW", 0x0D, 1 },
	/* 0x0E */  { "TSET1 $%02X%02X", 0x0E, 3 },
	/* 0x0F */  { "BRK ", 0x0F, 1 },
	/* 0x10 */  { "BPL $%04X", 0x10, 2 },
	/* 0x11 */  { "TCALL 1 [$FFDC]", 0x11, 1 },
	/* 0x12 */  { "CLR0 $%02X", 0x12, 2 },
	/* 0x13 */  { "BBC0 $%02X,#$%02X", 0x13, 3 },
	/* 0x14 */  { "ORZ A,$%02X+X", 0x14, 2 },
	/* 0x15 */  { "OR A,$%02X+X", 0x15, 3 },
	/* 0x16 */  { "OR A,$%02X+Y", 0x16, 3 },
	/* 0x17 */  { "OR A,[$%02X]+Y", 0x17, 2 },
	/* 0x18 */  { "OR $%02X,#$%02X", 0x18, 3 },
	/* 0x19 */  { "OR (X),(Y)", 0x19, 1 },
	/* 0x1A */  { "DECW $%02X", 0x1A, 2 },
	/* 0x1B */  { "ASL $%02X,X", 0x1B, 2 },
	/* 0x1C */  { "ASL A", 0x1C, 1 },
	/* 0x1D */  { "DEC X", 0x1D, 1 },
	/* 0x1E */  { "CMP X,$%02X", 0x1E, 3 },
	/* 0x1F */  { "JMP [$%02X%02X+X]", 0x1F, 3 },
	/* 0x20 */  { "CLRP ", 0x20, 1 },
	/* 0x21 */  { "TCALL 2 [$FFDA]", 0x21, 1 },
	/* 0x22 */  { "SET1 $%02X", 0x22, 2 },
	/* 0x23 */  { "BBS1 $%02X,#$%02X", 0x23, 3 },
	/* 0x24 */  { "ANDZ A,$%02X", 0x24, 2 },
	/* 0x25 */  { "AND A,$%02X%02X", 0x25, 3 },
	/* 0x26 */  { "AND A,(X)", 0x26, 1 },
	/* 0x27 */  { "AND A,[$%02X+X]", 0x27, 2 },
	/* 0x28 */  { "AND A,#$%02X", 0x28, 2 },
	/* 0x29 */  { "AND $%02X,$%02X", 0x29, 3 },
	/* 0x2A */  { "OR1 C,/$%02X", 0x2A, 3 },
	/* 0x2B */  { "ROLZ $%02X", 0x2B, 2 },
	/* 0x2C */  { "ROL $%02X", 0x2C, 3 },
	/* 0x2D */  { "PUSH A", 0x2D, 1 },
	/* 0x2E */  { "CBNE $%02X,$%02X", 0x2E, 3 },
	/* 0x2F */  { "BRA $%04X", 0x2F, 2 },
	/* 0x30 */  { "BMI $%04X", 0x30, 2 },
	/* 0x31 */  { "TCALL 3 [$FFD8]", 0x31, 1 },
	/* 0x32 */  { "CLR1 $%02X", 0x32, 2 },
	/* 0x33 */  { "BBC1 $%02X,#$%02X", 0x33, 3 },
	/* 0x34 */  { "ANDZ A,$%02X+X", 0x34, 2 },
	/* 0x35 */  { "AND A,$%02X%02X+X", 0x35, 3 },
	/* 0x36 */  { "AND A,$%02X%02X+Y", 0x36, 3 },
	/* 0x37 */  { "AND A,[$%02X]+Y", 0x37, 2 },
	/* 0x38 */  { "AND $%02X,#$%02X", 0x38, 3 },
	/* 0x39 */  { "AND (X),(Y)", 0x39, 1 },
	/* 0x3A */  { "INCW $%02X", 0x3A, 2 },
	/* 0x3B */  { "ROL $%02X,X", 0x3B, 2 },
	/* 0x3C */  { "ROL A", 0x3C, 1 },
	/* 0x3D */  { "INC X", 0x3D, 1 },
	/* 0x3E */  { "CMP X,$%02X", 0x3E, 2 },
	/* 0x3F */  { "CALL $%02X%02X", 0x3F, 3 },
	/* 0x40 */  { "SETP ", 0x40, 1 },
	/* 0x41 */  { "TCALL 4 [$FFD6]", 0x41, 1 },
	/* 0x42 */  { "SET2 $%02X", 0x42, 2 },
	/* 0x43 */  { "BBS2 $%02X,#$%02X", 0x43, 3 },
	/* 0x44 */  { "EORZ A,$%02X", 0x44, 2 },
	/* 0x45 */  { "EOR A,$%02X", 0x45, 3 },
	/* 0x46 */  { "EOR A,(X)", 0x46, 1 },
	/* 0x47 */  { "EOR A,[$%02X+X]", 0x47, 2 },
	/* 0x48 */  { "EOR A,#$%02X", 0x48, 2 },
	/* 0x49 */  { "EOR $%02X,$%02X", 0x49, 3 },
	/* 0x4A */  { "AND1 C,$%02X", 0x4A, 3 },
	/* 0x4B */  { "LSRZ $%02X", 0x4B, 2 },
	/* 0x4C */  { "LSR $%02X", 0x4C, 3 },
	/* 0x4D */  { "PUSH X", 0x4D, 1 },
	/* 0x4E */  { "TCLR1 $%02X", 0x4E, 3 },
	/* 0x4F */  { "PCALL $%02X", 0x4F, 2 },
	/* 0x50 */  { "BVC $%04X", 0x50, 2 },
	/* 0x51 */  { "TCALL 5 [$FFD4]", 0x51, 1 },
	/* 0x52 */  { "CLR2 $%02X", 0x52, 2 },
	/* 0x53 */  { "BBC2 $%02X,#$%02X", 0x53, 3 },
	/* 0x54 */  { "EORZ A,$%02X+X", 0x54, 2 },
	/* 0x55 */  { "EOR A,$%02X+X", 0x55, 3 },
	/* 0x56 */  { "EOR A,$%02X+Y", 0x56, 3 },
	/* 0x57 */  { "EOR A,[$%02X]+Y", 0x57, 2 },
	/* 0x58 */  { "EOR $%02X,#$%02X", 0x58, 3 },
	/* 0x59 */  { "EOR (X),(Y)", 0x59, 1 },
	/* 0x5A */  { "CLRW $%02X", 0x5A, 2 },
	/* 0x5B */  { "LSR $%02X,X", 0x5B, 2 },
	/* 0x5C */  { "LSR A", 0x5C, 1 },
	/* 0x5D */  { "MOV X,A", 0x5D, 1 },
	/* 0x5E */  { "CMP Y,$%02X%02X", 0x5E, 3 },
	/* 0x5F */  { "JMP $%02X%02X", 0x5F, 3 },
	/* 0x60 */  { "CLRC ", 0x60, 1 },
	/* 0x61 */  { "TCALL 6 [$FFD2]", 0x61, 1 },
	/* 0x62 */  { "SET3 $%02X", 0x62, 2 },
	/* 0x63 */  { "BBS3 $%02X,#$%02X", 0x63, 3 },
	/* 0x64 */  { "CMPZ A,$%02X", 0x64, 2 },
	/* 0x65 */  { "CMP A,$%02X%02X", 0x65, 3 },
	/* 0x66 */  { "CMP A,(X)", 0x66, 1 },
	/* 0x67 */  { "CMP A,[$%02X+X]", 0x67, 2 },
	/* 0x68 */  { "CMP A,#$%02X", 0x68, 2 },
	/* 0x69 */  { "CMP $%02X,$%02X", 0x69, 3 },
	/* 0x6A */  { "AND1 C,/$%02X", 0x6A, 3 },
	/* 0x6B */  { "RORZ $%02X", 0x6B, 2 },
	/* 0x6C */  { "ROR $%02X", 0x6C, 3 },
	/* 0x6D */  { "PUSH Y", 0x6D, 1 },
	/* 0x6E */  { "DBNZ $%02X, #$%02X", 0x6E, 3 },
	/* 0x6F */  { "RET ", 0x6F, 1 },
	/* 0x70 */  { "BVS $%04X", 0x70, 2 },
	/* 0x71 */  { "TCALL 7 [$FFD0]", 0x71, 1 },
	/* 0x72 */  { "CLR3 $%02X", 0x72, 2 },
	/* 0x73 */  { "BBC3 $%02X,#$%02X", 0x73, 3 },
	/* 0x74 */  { "CMPZ A,$%02X+X", 0x74, 2 },
	/* 0x75 */  { "CMP A,$%02X+X", 0x75, 3 },
	/* 0x76 */  { "CMP A,$%02X+Y", 0x76, 3 },
	/* 0x77 */  { "CMP A,[$%02X]+Y", 0x77, 2 },
	/* 0x78 */  { "CMP $%02X,#$%02X", 0x78, 3 },
	/* 0x79 */  { "CMP (X),(Y)", 0x79, 1 },
	/* 0x7A */  { "ADDW YA,$%02X", 0x7A, 2 },
	/* 0x7B */  { "ROR $%02X,X", 0x7B, 2 },
	/* 0x7C */  { "ROR A", 0x7C, 1 },
	/* 0x7D */  { "MOV A,X", 0x7D, 1 },
	/* 0x7E */  { "CMP Y,$%02X", 0x7E, 2 },
	/* 0x7F */  { "RETI ", 0x7F, 1 },
	/* 0x80 */  { "SETC ", 0x80, 1 },
	/* 0x81 */  { "TCALL 8 [$FFCE]", 0x81, 1 },
	/* 0x82 */  { "SET4 $%02X", 0x82, 2 },
	/* 0x83 */  { "BBS4 $%02X,#$%02X", 0x83, 3 },
	/* 0x84 */  { "ADCZ A,$%02X", 0x84, 2 },
	/* 0x85 */  { "ADC A,$%02X%02X", 0x85, 3 },
	/* 0x86 */  { "ADC A,(X)", 0x86, 1 },
	/* 0x87 */  { "ADC A,[$%02X+X]", 0x87, 2 },
	/* 0x88 */  { "ADC A,#$%02X", 0x88, 2 },
	/* 0x89 */  { "ADC $%02X,$%02X", 0x89, 3 },
	/* 0x8A */  { "EOR1 C,$%02X", 0x8A, 3 },
	/* 0x8B */  { "DECZ $%02X", 0x8B, 2 },
	/* 0x8C */  { "DEC $%02X", 0x8C, 3 },
	/* 0x8D */  { "MOV Y,#$%02X", 0x8D, 2 },
	/* 0x8E */  { "POP PSW", 0x8E, 1 },
	/* 0x8F */  { "MOV $%02X,#$%02X", 0x8F, 3 },
	/* 0x90 */  { "BCC $%04X", 0x90, 2 },
	/* 0x91 */  { "TCALL 9 [$FFCC]", 0x91, 1 },
	/* 0x92 */  { "CLR4 $%02X", 0x92, 2 },
	/* 0x93 */  { "BBC4 $%02X,#$%02X", 0x93, 3 },
	/* 0x94 */  { "ADCZ A,$%02X+X", 0x94, 2 },
	/* 0x95 */  { "ADC A,$%02X+X", 0x95, 3 },
	/* 0x96 */  { "ADC A,$%02X%02X+Y", 0x96, 3 },
	/* 0x97 */  { "ADC A,[$%02X]+Y", 0x97, 2 },
	/* 0x98 */  { "ADC $%02X,#$%02X", 0x98, 3 },
	/* 0x99 */  { "MOV (X),(Y)", 0x99, 1 },
	/* 0x9A */  { "SUBW YA,$%02X", 0x9A, 2 },
	/* 0x9B */  { "DEC $%02X+X", 0x9B, 2 },
	/* 0x9C */  { "DEC A", 0x9C, 1 },
	/* 0x9D */  { "MOV X,SP", 0x9D, 1 },
	/* 0x9E */  { "DIV YA,X", 0x9E, 1 },
	/* 0x9F */  { "XCN A", 0x9F, 1 },
	/* 0xA0 */  { "EI ", 0xA0, 1 },
	/* 0xA1 */  { "TCALL 10 [$FFCA]", 0xA1, 1 },
	/* 0xA2 */  { "SET5 $%02X", 0xA2, 2 },
	/* 0xA3 */  { "BBS5 $%02X,#$%02X", 0xA3, 3 },
	/* 0xA4 */  { "SBCZ A,$%02X", 0xA4, 2 },
	/* 0xA5 */  { "SBC A,$%02X%02X", 0xA5, 3 },
	/* 0xA6 */  { "SBC A,(X)", 0xA6, 1 },
	/* 0xA7 */  { "SBC A,[$%02X+X]", 0xA7, 2 },
	/* 0xA8 */  { "SBC A,#$%02X", 0xA8, 2 },
	/* 0xA9 */  { "SBC $%02X,$%02X", 0xA9, 3 },
	/* 0xAA */  { "MOV1 C,$%02X", 0xAA, 3 },
	/* 0xAB */  { "INCZ $%02X", 0xAB, 2 },
	/* 0xAC */  { "INC $%02X%02X", 0xAC, 3 },
	/* 0xAD */  { "CMP Y,#$%02X", 0xAD, 2 },
	/* 0xAE */  { "POP A", 0xAE, 1 },
	/* 0xAF */  { "MOV (X)+,A", 0xAF, 1 },
	/* 0xB0 */  { "BCS $%04X", 0xB0, 2 },
	/* 0xB1 */  { "TCALL 11 [$FFC8]", 0xB1, 1 },
	/* 0xB2 */  { "CLR5 $%02X", 0xB2, 2 },
	/* 0xB3 */  { "BBC5 $%02X,#$%02X", 0xB3, 3 },
	/* 0xB4 */  { "SBCZ A,$%02X+X", 0xB4, 2 },
	/* 0xB5 */  { "SBC A,$%02X+X", 0xB5, 3 },
	/* 0xB6 */  { "SBC A,$%02X+Y", 0xB6, 3 },
	/* 0xB7 */  { "SBC A,[$%02X]+Y", 0xB7, 2 },
	/* 0xB8 */  { "SBC $%02X,#$%02X", 0xB8, 3 },
	/* 0xB9 */  { "SBC (X),(Y)", 0xB9, 1 },
	/* 0xBA */  { "MOVW YA,$%02X", 0xBA, 2 },
	/* 0xBB */  { "INC $%02X+X", 0xBB, 2 },
	/* 0xBC */  { "INC A", 0xBC, 1 },
	/* 0xBD */  { "MOV SP,X", 0xBD, 1 },
	/* 0xBE */  { "DAS YA", 0xBE, 1 },
	/* 0xBF */  { "MOV A,(X)+", 0xBF, 1 },
	/* 0xC0 */  { "DI ", 0xC0, 1 },
	/* 0xC1 */  { "TCALL 12 [$FFC6]", 0xC1, 1 },
	/* 0xC2 */  { "SET6 $%02X", 0xC2, 2 },
	/* 0xC3 */  { "BBS6 $%02X,#$%02X", 0xC3, 3 },
	/* 0xC4 */  { "MOVZ $%02X,A", 0xC4, 2 },
	/* 0xC5 */  { "MOV $%02X%02X,A", 0xC5, 3 },
	/* 0xC6 */  { "MOV (X),A", 0xC6, 1 },
	/* 0xC7 */  { "MOV [$%02X+X],A", 0xC7, 2 },
	/* 0xC8 */  { "CMP X,#$%02X", 0xC8, 2 },
	/* 0xC9 */  { "MOV $%02X%02X,X", 0xC9, 3 },
	/* 0xCA */  { "MOV1 $%02X,C", 0xCA, 3 },
	/* 0xCB */  { "MOV $%02X,Y", 0xCB, 2 },
	/* 0xCC */  { "MOV $%02X%02X,Y", 0xCC, 3 },
	/* 0xCD */  { "MOV X,#$%02X", 0xCD, 2 },
	/* 0xCE */  { "POP X", 0xCE, 1 },
	/* 0xCF */  { "MUL YA", 0xCF, 1 },
	/* 0xD0 */  { "BNE $%04X", 0xD0, 2 },
	/* 0xD1 */  { "TCALL 13 [$FFC4]", 0xD1, 1 },
	/* 0xD2 */  { "CLR6 $%02X", 0xD2, 2 },
	/* 0xD3 */  { "BBC6 $%02X,#$%02X", 0xD3, 3 },
	/* 0xD4 */  { "MOVZ $%02X+X,A", 0xD4, 2 },
	/* 0xD5 */  { "MOV $%02X%02X+X,A", 0xD5, 3 },
	/* 0xD6 */  { "MOV $%02X+Y,A", 0xD6, 3 },
	/* 0xD7 */  { "MOV [$%02X]+Y,A", 0xD7, 2 },
	/* 0xD8 */  { "MOV $%02X,X", 0xD8, 2 },
	/* 0xD9 */  { "MOV $%02X+Y,X", 0xD9, 2 },
	/* 0xDA */  { "MOVW $%02X,YA", 0xDA, 2 },
	/* 0xDB */  { "MOV $%02X+X,Y", 0xDB, 2 },
	/* 0xDC */  { "DEC Y", 0xDC, 1 },
	/* 0xDD */  { "MOV A,Y", 0xDD, 1 },
	/* 0xDE */  { "CBNE $%02X+X,$%02X", 0xDE, 3 },
	/* 0xDF */  { "DAA YA", 0xDF, 1 },
	/* 0xE0 */  { "CLRV ", 0xE0, 1 },
	/* 0xE1 */  { "TCALL 14 [$FFC2]", 0xE1, 1 },
	/* 0xE2 */  { "SET7 $%02X", 0xE2, 2 },
	/* 0xE3 */  { "BBS7 $%02X,#$%02X", 0xE3, 3 },
	/* 0xE4 */  { "MOVZ A,$%02X", 0xE4, 2 },
	/* 0xE5 */  { "MOV A,$%02X%02X", 0xE5, 3 },
	/* 0xE6 */  { "MOV A,(X)", 0xE6, 1 },
	/* 0xE7 */  { "MOV A,[$%02X+X]", 0xE7, 2 },
	/* 0xE8 */  { "MOV A,#$%02X", 0xE8, 2 },
	/* 0xE9 */  { "MOV X,$%02X%02X", 0xE9, 3 },
	/* 0xEA */  { "NOT1 $%02X", 0xEA, 3 },
	/* 0xEB */  { "MOV Y,$%02X", 0xEB, 2 },
	/* 0xEC */  { "MOV Y,$%02X%02X", 0xEC, 3 },
	/* 0xED */  { "NOTC ", 0xED, 1 },
	/* 0xEE */  { "POP Y", 0xEE, 1 },
	/* 0xEF */  { "SLEEP ", 0xEF, 1 },
	/* 0xF0 */  { "BEQ $%04X", 0xF0, 2 },
	/* 0xF1 */  { "TCALL 15 [$FFC0]", 0xF1, 1 },
	/* 0xF2 */  { "CLR7 $%02X", 0xF2, 2 },
	/* 0xF3 */  { "BBC7 $%02X,#$%02X", 0xF3, 3 },
	/* 0xF4 */  { "MOVZ A,$%02X+X", 0xF4, 2 },
	/* 0xF5 */  { "MOV A,$%02X%02X+X", 0xF5, 3 },
	/* 0xF6 */  { "MOV A,$%02X%02X+Y", 0xF6, 3 },
	/* 0xF7 */  { "MOV A,[$%02X]+Y", 0xF7, 2 },
	/* 0xF8 */  { "MOV X,$%02X", 0xF8, 2 },
	/* 0xF9 */  { "MOV X,$%02X+Y", 0xF9, 2 },
	/* 0xFA */  { "MOV $%02X,$%02X", 0xFA, 3 },
	/* 0xFB */  { "MOV Y,$%02X+X", 0xFB, 2 },
	/* 0xFC */  { "INC Y", 0xFC, 1 },
	/* 0xFD */  { "MOV Y,A", 0xFD, 1 },
	/* 0xFE */  { "DBNZ Y,$%02X", 0xFE, 2 },
	/* 0xFF */  { "STOP ", 0xFF, 1 }
};

