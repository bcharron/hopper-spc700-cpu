#!/usr/bin/python

import sys

# Note: "!a" seems to mean "absolute address"

STRUCT_FMT = """\t/* {opcode} */ {{ "{mnemonic}", "{operand1}", "{operand2}", 0x{opcode}, {len} }}"""

class Instruction(object):
	def __init__(self, mnemonic, operands, opcode, inst_len):
		self.opcode = opcode
		self.mnemonic = mnemonic
		self.operands = operands
		self.len = inst_len

		while len(self.operands) < 2:
			self.operands.append("")

	def dump_struct(self):
		string = STRUCT_FMT.format(mnemonic = self.mnemonic,
					opcode = "%02X" % self.opcode,
					len = self.len,
					operand1 = self.operands[0],
					operand2 = self.operands[1])

		return(string)

instructions = [Instruction("BAD", [], i, 1) for i in range(0, 256)]

for line in sys.stdin:
	line = line.strip()
	fields = line.split("\t")

	for x in range(len(fields)):
		fields[x] = fields[x].strip()

	(inst, operation, opcode, flags, inst_len, cycles) = fields

	opcode = int(opcode, 16)

	mnemonic_fields = fields[0].split(" ", 2)
	mnemonic = mnemonic_fields.pop(0)

	operands = mnemonic_fields

	for i in range(len(operands)):
		operands[i] = operands[i].strip().rstrip(",")

	# print "%s" % mnemonic

	inst = Instruction(mnemonic, operands, opcode, inst_len)
	instructions[opcode] = inst

strings = [inst.dump_struct() for inst in instructions]

print "/* Auto-generated file */\n"
print "#import \"opcodes.h\"\n"
print "spc700_opcode_t SPC700_OPCODES[] = {"
print ",\n".join(strings)
print "};\n"

