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

//
//  SPC700Ctx.m
//  SPC700CPU
//
//  Created by bcharron on 2014-07-15.
//  Copyright (c) 2014 Benjamin Charron. All rights reserved.
//

#import "SPC700Ctx.h"
#import "SPC700CPU.h"
#import "opcodes.h"

extern spc700_opcode_t SPC700_OPCODES[];

@implementation SPC700Ctx {
    SPC700CPU *_cpu;
    NSObject<HPDisassembledFile> *_file;
}

- (instancetype)initWithCPU:(SPC700CPU *)cpu andFile:(NSObject<HPDisassembledFile> *)file {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
    }
    
//    NSLog(@"Len: %lu", sizeof(SPC700_OPCODES));

    return self;
}

- (NSObject<CPUContext> *)cloneContext {
    return [[SPC700Ctx alloc] initWithCPU:_cpu andFile:_file];
}

- (NSObject<CPUDefinition> *)cpuDefinition {
    return _cpu;
}

- (void)initDisasmStructure:(DisasmStruct *)disasm withSyntaxIndex:(NSUInteger)syntaxIndex {
    bzero(disasm, sizeof(DisasmStruct));
}

// Analysis

- (BOOL)displacementIsAnArgument:(int64_t)displacement forProcedure:(NSObject<HPProcedure> *)procedure {
    return NO;
}

- (NSUInteger)stackArgumentSlotForDisplacement:(int64_t)displacement inProcedure:(NSObject<HPProcedure> *)procedure {
    return -1;
}

- (int64_t)displacementForStackSlotIndex:(NSUInteger)slot inProcedure:(NSObject<HPProcedure> *)procedure {
    return 0;
}

/// Adjust address to the lowest possible address acceptable by the CPU. Example: M68000 instruction must be word aligned, so this method would clear bit 0.
- (Address)adjustCodeAddress:(Address)address {
    // Nothing to do? 6502 doesn't care..
    return address;
}

/// Returns a guessed CPU mode for a given address. Example, ARM processors knows that an instruction is in Thumb mode if bit 0 is 1.
- (uint8_t)cpuModeFromAddress:(Address)address {
    // Might be able to do something here for the bank switching!
    return 0;
}

/// Returns YES if we know that a given address forces the CPU to use a specific mode. Thumb mode of comment above.
- (BOOL)addressForcesACPUMode:(Address)address {
    return NO;
}

/// An heuristic to estimate the CPU mode at a given address, not based on the value of the
/// address itself (this is the purpose of the "cpuModeFromAddress:" method), but rather
/// by trying to disassemble a few instruction and see which mode seems to be the best guess.
- (uint8_t)estimateCPUModeAtVirtualAddress:(Address)address {
    return(0);
}

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address forCPUMode:(uint8_t)mode {
    return (address + 1);
}

- (BOOL)hasProcedurePrologAt:(Address)address {
    // There isn't usually much prolog to a function in NES games.
    return(FALSE);
}

/// Notify the plugin that an analysis bgan from an entry point.
/// This could be either a simple disassembling, or a procedure creation.
/// In the latter case, another method will be called to notify the plugin (see below).
- (void)analysisBeginsAt:(Address)entryPoint {
    
}

/// Notify the plugin that analysis has ended.
- (void)analysisEnded {
    
}

/// A Procedure object is about to be created.
- (void)procedureAnalysisBeginsForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

/// The prolog of the created procedure is being analyzed.
/// Warning: this method is not called at the begining of the procedure creation, but once all basic blocks
/// have been created.
- (void)procedureAnalysisOfPrologForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

- (void)procedureAnalysisEndedForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

/// A new basic bloc is created
- (void)procedureAnalysisContinuesOnBasicBlock:(NSObject<HPBasicBlock> *)basicBlock {
    
}

- (Address)getThunkDestinationForInstructionAt:(Address)address {
    return BAD_ADDRESS;
}

/// This method may be called when the internal state of the disassembler should be reseted.
/// For instance, the ARM plugin maintains a state during the disassembly process to
/// track the state of IT blocks. When this method is called, this state is reseted.
- (void)resetDisassembler {
    
}

- (BOOL)isBranch:(uint8_t)opcode {
    BOOL ret;
    
    switch(opcode) {
        case 0x10:
        case 0x2F:
        case 0xF0:
        case 0xD0:
        case 0xB0:
        case 0x90:
        case 0x70:
        case 0x50:
        case 0x30:
        case 0xFE:
            ret = TRUE;
            break;
            
        default:
            ret = FALSE;
            break;
    }
    
    return(ret);
}

/*
void do_a_zp(uint8_t opcode, DisasmStruct *disasm) {
    strcpy(disasm->operand[0].mnemonic, "A");
    disasm->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
    
    disasm->operand[1].type = DISASM_OPERAND_ABSOLUTE;
    snprintf(disasm->operand[1].mnemonic, 15, "$00%02X", disasm->bytes[1]);
}

void do_a_zp_plus_x(uint8_t opcode, DisasmStruct *disasm) {
    do_zp(opcode, disasm);
    strcat(disasm->operand[1].mnemonic, "+X");
}
*/

/// Disassemble a single instruction, filling the DisasmStruct structure.
/// Only a few fields are set by Hopper (mainly, the syntaxIndex, the "bytes" field and the virtualAddress of the instruction).
/// The CPU should fill as much information as possible.
- (int)disassembleSingleInstruction:(DisasmStruct *)disasm usingProcessorMode:(NSUInteger)mode {
    
    int len = 1;
    
    disasm->instruction.branchType = DISASM_BRANCH_NONE;
    disasm->instruction.addressValue = 0;
    
    for (int i=0; i<DISASM_MAX_OPERANDS; i++)
        disasm->operand[i].type = DISASM_OPERAND_NO_OPERAND;
    
    uint8_t opcode = disasm->bytes[0];
    
    spc700_opcode_t *inst = &SPC700_OPCODES[opcode];
    
    strcpy(disasm->instruction.mnemonic, inst->mnemonic);
    
    int nb_bytes = inst->len - 1;
    
    // XXX: this is currently incorrect. ie, opcode 0x8F (MOV $zero_page, #imm) is translated in reverse.
    // and "MOV X, #imm" is using the wrong immediate value. So in short all this is broken :-/
    for (int op = 0; op < 2; op++) {
        strcpy(disasm->operand[op].mnemonic, inst->operand[op].mnemonic);

        switch(inst->operand[op].access_type) {
            case SPC_ACCESS_ABSOLUTE:
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE;
                disasm->instruction.addressValue = OSReadLittleInt16(disasm->bytes, 0x01);
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "$%04X", (uint16_t) disasm->instruction.addressValue);
                break;
                
            case SPC_ACCESS_ABSOLUTE_X:
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_REGISTER_TYPE;
                disasm->instruction.addressValue = OSReadLittleInt16(disasm->bytes, 0x01);
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "($%04X+X)", (uint16_t) disasm->instruction.addressValue);
                break;

            case SPC_ACCESS_ABSOLUTE_Y:
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_REGISTER_TYPE;
                disasm->instruction.addressValue = OSReadLittleInt16(disasm->bytes, 0x01);
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "($%04X+Y)", (uint16_t) disasm->instruction.addressValue);
                break;
                
            case SPC_ACCESS_ABSOLUTE_INDIRECT_X:
                // Wrong
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_REGISTER_TYPE;
                disasm->instruction.addressValue = OSReadLittleInt16(disasm->bytes, 0x01);
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "($%04X+X)", (uint16_t) disasm->instruction.addressValue);
                break;

            case SPC_ACCESS_REGISTER:
                disasm->operand[op].type = DISASM_OPERAND_REGISTER_TYPE;
                break;
                
            case SPC_ACCESS_IMMEDIATE:
                disasm->operand[op].type = DISASM_OPERAND_CONSTANT_TYPE;
                disasm->operand[op].immediateValue = disasm->bytes[nb_bytes];
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "#$%02X", disasm->bytes[nb_bytes]);
                nb_bytes--;
                break;

            case SPC_ACCESS_ZERO_PAGE:
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE;
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "$00%02X", disasm->bytes[nb_bytes]);
                disasm->instruction.addressValue = disasm->bytes[nb_bytes];
                nb_bytes--;
                break;
                
            case SPC_ACCESS_ZERO_PAGE_X:
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_REGISTER_TYPE;
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "$00%02X+X", disasm->bytes[nb_bytes]);
                nb_bytes--;
                break;
                
            case SPC_ACCESS_NO_OPERAND:
                disasm->operand[op].type = DISASM_OPERAND_NO_OPERAND;
                break;
                
            case SPC_ACCESS_INDIRECT_ZERO_PAGE_Y:
                disasm->operand[op].type = DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_REGISTER_TYPE;
                snprintf(disasm->operand[op].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "($00%02X)+Y", disasm->bytes[nb_bytes]);
                // disasm->instruction.addressValue = [_file readInt16AtVirtualAddress:disasm->bytes[nb_bytes]];
                // disasm->instruction.addressValue = disasm->bytes[nb_bytes];
                nb_bytes--;
                break;
                
            default:
                disasm->operand[op].type = DISASM_OPERAND_REGISTER_TYPE;
                break;
        }
    }
        
    if ([self isBranch:opcode]) {
        // Banches
        switch (opcode) {
            case 0x2F: // BRA
                disasm->instruction.branchType = DISASM_BRANCH_JMP;
                break;
                
            case 0xF0: // BEQ
                disasm->instruction.branchType = DISASM_BRANCH_JE;
                break;

            case 0xD0: // BNE
                disasm->instruction.branchType = DISASM_BRANCH_JNE;
                break;
                
            case 0xB0: // BCS
                disasm->instruction.branchType = DISASM_BRANCH_JC;
                break;

            case 0x90: // BCC
                disasm->instruction.branchType = DISASM_BRANCH_JNC;
                break;

            case 0x70: // BVS
                disasm->instruction.branchType = DISASM_BRANCH_JO;
                break;

            case 0x50: // BVC
                disasm->instruction.branchType = DISASM_BRANCH_JNO;
                break;

            case 0x30: // BMI
                disasm->instruction.branchType = DISASM_BRANCH_JS;
                break;

            case 0x10: // BPL
                disasm->instruction.branchType = DISASM_BRANCH_JNS;
                break;

            case 0xFE: // BPL
                disasm->instruction.branchType = DISASM_BRANCH_JE;
                break;

            default:
                break;
        }
        
        disasm->instruction.addressValue = disasm->virtualAddr + (int8_t) disasm->bytes[1] + 2;
        disasm->operand[0].immediateValue = disasm->instruction.addressValue;
        disasm->operand[0].type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_RELATIVE;
        
        snprintf(disasm->operand[0].mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "$%04X", (uint16_t) disasm->instruction.addressValue);
    }

    // Special cases
    switch(opcode) {
        case 0x1F:  // JMP [!a+X]
            disasm->instruction.branchType = DISASM_BRANCH_JMP;
            break;
            
        case 0x5F:  // JMP [!a]s
            disasm->instruction.branchType = DISASM_BRANCH_JMP;
            disasm->instruction.addressValue = OSReadLittleInt16(disasm->bytes, 0x01);
            break;
            
        case 0x6F:  // RET
        case 0x7F:  // RETI
            disasm->instruction.branchType = DISASM_BRANCH_RET;
            break;
            
        case 0x3F:  // CALL
            disasm->instruction.branchType = DISASM_BRANCH_CALL;
            disasm->instruction.addressValue = OSReadLittleInt16(disasm->bytes, 0x01);
            break;
            
        case 0x4F:  // PCALL u
            disasm->instruction.branchType = DISASM_BRANCH_CALL;
            uint8_t l = [_file readInt8AtVirtualAddress:(0xFF00 + disasm->bytes[1])];
            uint8_t h = [_file readInt8AtVirtualAddress:(0xFF00 + disasm->bytes[1] + 1)];
            disasm->instruction.addressValue = ((uint16_t) h << 8) | l;
            break;
            
        /*
        case 0x8F: // MOV $ZP, #imm
            disasm->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
            strcpy(disasm->operand[0].mnemonic, "X");
            
            disasm->operand[1].type = DISASM_OPERAND_CONSTANT_TYPE;
            snprintf(disasm->operand[1].mnemonic, 10, "#$%02X", disasm->bytes[1]);
            break;
            
        case 0xCD: // MOV X, #imm. Parser is broken :(
            disasm->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
            strcpy(disasm->operand[0].mnemonic, "X");

            disasm->operand[1].type = DISASM_OPERAND_CONSTANT_TYPE;
            snprintf(disasm->operand[1].mnemonic, 10, "#$%02X", disasm->bytes[1]);
            break;
         */
            
        default:
            break;
    }
    
    /*
    switch(opcode) {
        case 0x04:
            do_a_zp(opcode, disasm);
            break;

        case 0x14:
            do_a_zp_plus_x(opcode, disasm);
            break;
            
        case 0x24:
            do_a_zp(opcode, disasm);
            break;
            
        case 0x44:
        case 0x64:
        case 0x84:
        case 0xA4:
        case 0xE4:
            strcpy(disasm->operand[0].mnemonic, "A");
            disasm->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
            
            disasm->operand[1].type = DISASM_OPERAND_ABSOLUTE;
            snprintf(disasm->operand[1].mnemonic, 15, "$00%02X", disasm->bytes[1]);
            break;
            
        case 0xC4:
            
        case 0x14: // OP A, $ZP+X
        case 0x34:
        case 0x54:
        case 0x74:
        case 0x94:
        case 0xB4:
        case 0xD4:
            strcpy(disasm->operand[0].mnemonic, "A");
            disasm->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
            
            disasm->operand[1].type = DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_REGISTER_TYPE;
            snprintf(disasm->operand[1].mnemonic, 15, "$00%02X+X", disasm->bytes[1]);
            break;

    }
    */
    
    /*
    // OP  A, $ZP
    if ((opcode & 0x0E) == 0x04) {
        int zp_operand = 1;
        int a_operand = 0;
        
        // C4 and D4 (MOV) are "STA" (direction inversed)
        if (opcode == 0xC4 || opcode == 0xD4) {
            zp_operand = 0;
            a_operand = 1;
        }
        
        disasm->operand[zp_operand].type = DISASM_OPERAND_ABSOLUTE;
        
        // Bit 0 is memory location:   1:word (absolute)   0:byte (zero-page)
        if (opcode & 0x01)
            snprintf(disasm->operand[zp_operand].mnemonic, 15, "$%04X", OSReadLittleInt16(disasm->bytes, 1));
        else
            snprintf(disasm->operand[zp_operand].mnemonic, 15, "$00%02X", disasm->bytes[1]);
        
        strcpy(disasm->operand[a_operand].mnemonic, "A");
        disasm->operand[a_operand].type = DISASM_OPERAND_REGISTER_TYPE;
        
        if ((opcode & 0x01) == 0x01) {
            strcat(disasm->operand[zp_operand].mnemonic, "+X");
            disasm->operand[zp_operand].type |= DISASM_OPERAND_REGISTER_TYPE;
        }
    } else if ((opcode & 0x08) == 0x08 && (opcode & 0x10) == 0x00) { // OP  A, #i
        strcpy(disasm->operand[0].mnemonic, "A");
        disasm->operand[0].type = DISASM_OPERAND_REGISTER_TYPE;
        
        snprintf(disasm->operand[1].mnemonic, 15, "#$%02X", disasm->bytes[1]);
        disasm->operand[1].type = DISASM_OPERAND_CONSTANT_TYPE;
    }
     */
    
    // TCALL
    if ((opcode & 0x0F) == 0x01) {
        int dest = 0xFFFF - (opcode & 0x0F) * 2;
        disasm->instruction.branchType = DISASM_BRANCH_CALL;
        uint8_t l = [_file readInt8AtVirtualAddress:dest];
        uint8_t h = [_file readInt8AtVirtualAddress:dest + 1];
        disasm->instruction.addressValue = ((uint16_t) h << 8) | l;
    }
    
    len = inst->len;
    
    return(len);
}

/// Returns whether or not an instruction may halt the processor (like the HLT Intel instruction).
- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    if (disasm->bytes[0] == 0xEF || disasm->bytes[0] == 0xFF)
        return(TRUE);
    
    return(NO);
}

/// If a branch instruction is found, Hopper calls this method to compute additional destinations of the instruction.
/// The "*next" value is already set to the address which follows the instruction if the jump does not occurs.
/// The "branches" array is filled by NSNumber objects. The values are the addresses where the instruction can jump. Only the
/// jumps that occur in the same procedure are put here (for instance, CALL instruction targets are not put in this array).
/// The "callSitesAddresses" array is filled by NSNumber objects of addresses that are the target of a "CALL like" instruction, ie
/// all the jumps which go outside of the procedure.
/// The purpose of this method is to compute additional destinations.
/// Most of the time, Hopper already found the destinations, so there is no need to do more.
/// This is used by the Intel CPU plugin to compute the destinations of switch/case constructions when it found a "JMP register" instruction.
- (void)performBranchesAnalysis:(DisasmStruct *)disasm computingNextAddress:(Address *)next andBranches:(NSMutableArray *)branches forProcedure:(NSObject<HPProcedure> *)procedure basicBlock:(NSObject<HPBasicBlock> *)basicBlock ofSegment:(NSObject<HPSegment> *)segment calledAddresses:(NSMutableArray *)calledAddresses callsites:(NSMutableArray *)callSitesAddresses {
    
}

/// If you need a specific analysis, this method will be called once the previous branch analysis is performed.
/// For instance, this is used by the ARM CPU plugin to set the type of the destination of an LDR instruction to
/// an int of the correct size.
- (void)performInstructionSpecificAnalysis:(DisasmStruct *)disasm forProcedure:(NSObject<HPProcedure> *)procedure inSegment:(NSObject<HPSegment> *)segment {
    
}

/// Thess methods are called to let you update your internal plugin state during the analysis.
- (void)performProcedureAnalysis:(NSObject<HPProcedure> *)procedure basicBlock:(NSObject<HPBasicBlock> *)basicBlock disasm:(DisasmStruct *)disasm {
    
}

- (void)updateProcedureAnalysis:(DisasmStruct *)disasm {
    
}

////////////////////////////////////////////////////////////////////////////////
//
// Printing instruction
//
////////////////////////////////////////////////////////////////////////////////

- (NSString *)defaultFormattedVariableNameForDisplacement:(int64_t)displacement inProcedure:(NSObject<HPProcedure> *)procedure {
    return [NSString stringWithFormat:@"var%lld", displacement];
}

/// The method should return a default name for a local variable at a given displacement on stack.
- (NSString *)formattedVariableNameForDisplacement:(int64_t)displacement inProcedure:(NSObject<HPProcedure> *)procedure {
    return [NSString stringWithFormat:@"var%lld", displacement];
}

/// Build the complete instruction string in the DisasmStruct structure.
/// This is the string to be displayed in Hopper.
- (void)buildInstructionString:(DisasmStruct *)disasm forSegment:(NSObject<HPSegment> *)segment populatingInfo:(NSObject<HPFormattedInstructionInfo> *)formattedInstructionInfo {
    NSMutableString *output = [NSMutableString stringWithFormat:@"%-10s", disasm->instruction.mnemonic];
    
    for (int i=0; i<DISASM_MAX_OPERANDS; i++) {
        if (disasm->operand[i].type == DISASM_OPERAND_NO_OPERAND) break;
        
        if (i >= 1) {
            [output appendString:@", "];
        }
        
        NSString *temp = [[NSString alloc] initWithCString:disasm->operand[i].mnemonic encoding:NSUTF8StringEncoding];
        
        if (disasm->operand[i].type & ( DISASM_OPERAND_ABSOLUTE | DISASM_OPERAND_RELATIVE)) {
            ArgFormat format = [_file formatForArgument:i atVirtualAddress:disasm->instruction.addressValue];
            
            if (format == Format_Address || format == Format_Offset || format == Format_Default) {
                NSString *name = [_file nameForVirtualAddress:disasm->instruction.addressValue];
            
                if (name != NULL) {
                    temp = name;
                }
            }
        }

        [output appendString:temp];
    }
    
    strncpy(disasm->completeInstructionString, [output cStringUsingEncoding:NSUTF8StringEncoding], DISASM_INSTRUCTION_MAX_LENGTH - 1);
}

// Decompiler

- (BOOL)canDecompileProcedure:(NSObject<HPProcedure> *)procedure {
    return NO;
}

/// Return the address of the first instruction of the procedure, after its prolog.
- (Address)skipHeader:(NSObject<HPBasicBlock> *)basicBlock ofProcedure:(NSObject<HPProcedure> *)procedure {
    return basicBlock.from;
}

/// Return the address of the last instruction of the procedure, before its epilog.
- (Address)skipFooter:(NSObject<HPBasicBlock> *)basicBlock ofProcedure:(NSObject<HPProcedure> *)procedure {
    return basicBlock.to;
}

/// Returns an AST representation of an operand of an instruction.
/// Note: ASTNode is not publicly exposed yet. You cannot write a decompiler at the moment.
- (ASTNode *)rawDecodeArgumentIndex:(int)argIndex
                           ofDisasm:(DisasmStruct *)disasm
                  ignoringWriteMode:(BOOL)ignoreWrite
                    usingDecompiler:(Decompiler *)decompiler {
    return nil;
}

/// Decompile an assembly instruction.
/// Note: ASTNode is not publicly exposed yet. You cannot write a decompiler at the moment.
- (ASTNode *)decompileInstructionAtAddress:(Address)a
                                    disasm:(DisasmStruct)d
                                    length:(int)instrLength
                                      arg1:(ASTNode *)arg1
                                      arg2:(ASTNode *)arg2
                                      arg3:(ASTNode *)arg3
                                      dest:(ASTNode *)dest
                                 addNode_p:(BOOL *)addNode_p
                           usingDecompiler:(Decompiler *)decompiler {
    return nil;
}

////////////////////////////////////////////////////////////////////////////////
//
// Assembler
//
////////////////////////////////////////////////////////////////////////////////

- (NSData *)assembleRawInstruction:(NSString *)instr atAddress:(Address)addr forFile:(NSObject<HPDisassembledFile> *)file withCPUMode:(uint8_t)cpuMode usingSyntaxVariant:(NSUInteger)syntax error:(NSError **)error {
    return nil;
}

- (BOOL)instructionCanBeUsedToExtractDirectMemoryReferences:(DisasmStruct *)disasmStruct {
    return YES;
}

- (BOOL)instructionMayBeASwitchStatement:(DisasmStruct *)disasmStruct {
    return NO;
}

@end
