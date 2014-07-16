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

- (BOOL)haveProcedurePrologAt:(Address)address {
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
    
    if (strlen(inst->operand1) > 0) {
        strcpy(disasm->operand1.mnemonic, inst->operand1);
        disasm->operand1.type = DISASM_OPERAND_REGISTER_TYPE;
    }

    if (strlen(inst->operand2) > 0) {
        strcpy(disasm->operand2.mnemonic, inst->operand2);
        disasm->operand2.type = DISASM_OPERAND_REGISTER_TYPE;
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
        disasm->operand1.immediatValue = disasm->instruction.addressValue;
        disasm->operand1.type = DISASM_OPERAND_CONSTANT_TYPE | DISASM_OPERAND_RELATIVE;
        
        snprintf(disasm->operand1.mnemonic, DISASM_OPERAND_MNEMONIC_MAX_LENGTH, "$%04X", (uint16_t) disasm->instruction.addressValue);
    }

    // Special cases
    switch(opcode) {
        case 0x1F:  // JMP [!a+X]
            disasm->instruction.branchType = DISASM_BRANCH_JMP;
            break;
            
        case 0x5F:  // JMP [!a]s
            disasm->instruction.branchType = DISASM_BRANCH_JMP;
            disasm->instruction.addressValue = ((uint16_t) disasm->bytes[2] << 8) | disasm->bytes[1];
            break;
            
        case 0x6F:  // RET
        case 0x7F:  // RETI
            disasm->instruction.branchType = DISASM_BRANCH_RET;
            break;
            
        case 0x3F:  // CALL
            disasm->instruction.branchType = DISASM_BRANCH_CALL;
            disasm->instruction.addressValue = disasm->bytes[2] << 8 | disasm->bytes[1];
            break;
            
        case 0x4F:  // PCALL u
            disasm->instruction.branchType = DISASM_BRANCH_CALL;
            uint8_t l = [_file readInt8AtVirtualAddress:(0xFF00 + disasm->bytes[1])];
            uint8_t h = [_file readInt8AtVirtualAddress:(0xFF00 + disasm->bytes[1] + 1)];
            disasm->instruction.addressValue = ((uint16_t) h << 8) | l;
            break;
            
        default:
            break;
    }
    
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
- (void)performBranchesAnalysis:(DisasmStruct *)disasm computingNextAddress:(Address *)next andBranches:(NSMutableArray *)branches forProcedure:(NSObject<HPProcedure> *)procedure basicBlock:(NSObject<HPBasicBlock> *)basicBlock ofSegment:(NSObject<HPSegment> *)segment callsites:(NSMutableArray *)callSitesAddresses {
    
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

/// The method should return a default name for a local variable at a given displacement on stack.
- (NSString *)formattedVariableNameForDisplacement:(int64_t)displacement inProcedure:(NSObject<HPProcedure> *)procedure {
    return [NSString stringWithFormat:@"var%lld", displacement];
}

/// Build the complete instruction string in the DisasmStruct structure.
/// This is the string to be displayed in Hopper.
- (void)buildInstructionString:(DisasmStruct *)disasm forSegment:(NSObject<HPSegment> *)segment populatingInfo:(NSObject<HPFormattedInstructionInfo> *)formattedInstructionInfo {
    
    const char *spaces = "       ";
    strcpy(disasm->completeInstructionString, disasm->instruction.mnemonic);
    
    strcat(disasm->completeInstructionString, spaces);
    
    for (int i=0; i<DISASM_MAX_OPERANDS; i++) {
        if (disasm->operand[i].type == DISASM_OPERAND_NO_OPERAND) break;
        if (i) {
            if (disasm->operand[i].type == DISASM_OPERAND_REGISTER_TYPE)
                strcat(disasm->completeInstructionString, ",");
            else
                strcat(disasm->completeInstructionString, " ");
        }
        
        if (disasm->operand[i].type == DISASM_OPERAND_ABSOLUTE) {
            // Find the variable name here. Shouldn't Hopper do that?
            //            [formattedInstructionInfo ]
        }
        strcat(disasm->completeInstructionString, disasm->operand[i].mnemonic);
    }
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

@end