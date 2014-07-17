#!/usr/bin/python

# SPC700CPU - Copyright (C) 2014 Benjamin Charron
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys

# Note: "!a" seems to mean "absolute address"

STRUCT_FMT = """\t/* {opcode} */ {{ "{mnemonic}", {{ {operand1}, {operand2} }}, 0x{opcode}, {len} }}"""

OPERAND_FMT = """{{ "{mnemonic}", {access_type}, {register_name} }}"""

ACCESS_TYPES = {
	"A" : "SPC_ACCESS_REGISTER",
	"X" : "SPC_ACCESS_REGISTER",
	"Y" : "SPC_ACCESS_REGISTER",
	"PSW" : "SPC_ACCESS_REGISTER",
	"#i" : "SPC_ACCESS_IMMEDIATE",
	"d" : "SPC_ACCESS_ZERO_PAGE",
	"dd" : "SPC_ACCESS_ZERO_PAGE",
	"ds" : "SPC_ACCESS_ZERO_PAGE",
	"d+X" : "SPC_ACCESS_ZERO_PAGE_X",
	"[d]+Y" : "SPC_ACCESS_INDIRECT_ZERO_PAGE_Y",
	"(X)" : "SPC_ACCESS_INDIRECT_X",
	"(Y)" : "SPC_ACCESS_INDIRECT_Y",
	"!a" : "SPC_ACCESS_ABSOLUTE",
	"!a+X" : "SPC_ACCESS_ABSOLUTE_X",
	"!a+Y" : "SPC_ACCESS_ABSOLUTE_Y",
	"[!a+X]" : "SPC_ACCESS_ABSOLUTE_INDIRECT_X"
}

REGISTER_NAMES = {
	"A" : "SPC_REGISTER_A",
	"X" : "SPC_REGISTER_X",
	"Y" : "SPC_REGISTER_Y",
	"(X)" : "SPC_REGISTER_X",
	"(Y)" : "SPC_REGISTER_Y",
	"PSW" : "SPC_REGISTER_PSW"
}

class Instruction(object):
	def __init__(self, mnemonic, operands, opcode, inst_len):
		self.opcode = opcode
		self.mnemonic = mnemonic
		self.len = inst_len
		self.operands = []

		for index, operand in enumerate(operands):
			op = self.createOperand(operand)
			self.operands.append(op)

		while len(self.operands) < 2:
			self.operands.append(Operand(None, None, None))

	def createOperand(self, operand):
		op = Operand(None, None, None)

		if not operand == "":
			access_type = "SPC_ACCESS_REGISTER"
			register_name = "SPC_REGISTER_A"

			if operand in ACCESS_TYPES:
				access_type = ACCESS_TYPES[operand]

			if operand in REGISTER_NAMES:
				register_name = REGISTER_NAMES[operand]

			op = Operand(operand, access_type, register_name)

		return(op)

	def dump_struct(self):
		string = STRUCT_FMT.format(mnemonic = self.mnemonic,
					opcode = "%02X" % self.opcode,
					len = self.len,
					operand1 = self.operands[0],
					operand2 = self.operands[1])

		return(string)

class Operand(object):
	def __init__(self, mnemonic, access_type, register_name):
		self.mnemonic = mnemonic
		self.access_type = access_type
		self.register_name = register_name

		if access_type is None:
			self.access_type = "SPC_ACCESS_NO_OPERAND"
			self.register_name = "SPC_REGISTER_A"
			self.mnemonic = ""

	def __str__(self):
		ret = OPERAND_FMT.format(mnemonic = self.mnemonic,
					access_type = self.access_type,
					register_name = self.register_name)

		return(ret)

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

