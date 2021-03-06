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
//  SPC700CPU.m
//  SPC700CPU
//
//  Created by bcharron on 2014-07-15.
//  Copyright (c) 2014 Benjamin Charron. All rights reserved.
//

#import "SPC700CPU.h"
#import "SPC700Ctx.h"

@implementation SPC700CPU {
    NSObject<HPHopperServices> *_services;
}

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
    if (self = [super init]) {
        _services = services;
    }
    return self;
}

- (HopperUUID *)pluginUUID {
    return [_services UUIDWithString:@"316efc80-0c7d-11e4-9191-0800200c9a66"];
}
- (HopperPluginType)pluginType {
    return(Plugin_CPU);
}

- (NSString *)pluginName {
    return(@"Sony SPC700");
}

- (NSString *)pluginDescription {
    return(@"Sony SPC700 CPU Support (SNES APU)");
}

- (NSString *)pluginAuthor {
    return(@"Benjamin Charron");
}
- (NSString *)pluginCopyright {
    return(@"(C) 2014 Benjamin Charron");
}

- (NSString *)pluginVersion {
    return(@"0.1.1");
}

- (NSObject<CPUContext> *)buildCPUContextForFile:(NSObject<HPDisassembledFile> *)file {
    return [[SPC700Ctx alloc] initWithCPU:self andFile:file];
}

/// Returns an array of NSString of CPU families handled by the plugin.
- (NSArray *)cpuFamilies {
    return@[@"sony"];
}

/// Returns an array of NSString of CPU subfamilies handled by the plugin for a given CPU family.
- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
    if ([family isEqualToString:@"sony"])
        return(@[@"SPC700"]);
    
    return(nil);
}

/// Returns 32 or 64, according to the family and subFamily arguments.
- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    if ([family isEqualToString:@"sony"] && [subFamily isEqualToString:@"SPC700"]) return 32;
    return(0);
}

/// Default endianess of the CPU.
- (CPUEndianess)endianess {
    return(CPUEndianess_Little);
}

/// Usually, returns 1, but for the Intel processor, it'll return 2 because we have the Intel and the AT&T syntaxes.
- (NSUInteger)syntaxVariantCount{
    return(1);
}

/// The number of CPU modes. For instance, 2 for the ARM CPU family: ARM and Thumb modes.
- (NSUInteger)cpuModeCount {
    return(1);
}

- (NSArray *)syntaxVariantNames {
    return @[@"generic"];
}

- (NSArray *)cpuModeNames {
    return @[@"generic"];
}

- (NSUInteger)registerClassCount {
    return(RegClass_SPC700_Cnt);
}

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
    switch (reg_class) {
        case RegClass_CPUState: return 1;
        case RegClass_PseudoRegisterSTACK: return 32;
        case RegClass_GeneralPurposeRegister: return 4;
        case RegClass_AddressRegister: return 3;
        default: break;
    }
    return 0;
}

- (BOOL)registerIndexIsStackPointer:(uint32_t)reg ofClass:(RegClass)reg_class {
    return NO;
}

- (BOOL)registerIndexIsFrameBasePointer:(uint32_t)reg ofClass:(RegClass)reg_class {
    return NO;
}

- (BOOL)registerIndexIsProgramCounter:(uint32_t)reg {
    return NO;
}

// Not quite sure what this function should return for GP and Address registers
- (NSString *)registerIndexToString:(int)reg ofClass:(RegClass)reg_class withBitSize:(int)size andPosition:(DisasmPosition)position {
    switch (reg_class) {
        case RegClass_CPUState: return @"CCR";
        case RegClass_PseudoRegisterSTACK: return [NSString stringWithFormat:@"STK%d", reg];
        case RegClass_GeneralPurposeRegister: {
            switch(reg) {
                case 0x00: return @"A";
                    break;
                    
                case 0x01: return @"X";
                    break;
                    
                case 0x02: return @"Y";
                    break;
                    
                case 0x03: return(@"SP");
                    break;
                    
                default:
                    return(@"NA");
                    break;
            }
        }
        case RegClass_AddressRegister: {
            switch(reg) {
                case 0x00:
                    return(@"X");
                    break;
                    
                case 0x01:
                    return(@"Y");
                    break;
                    
                default:
                    return(@"NA");
                    break;
            }
        }
            
        default: break;
    }
    
    return nil;
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
    return @"";
}

/// A weirdness of the Hopper internals. You'll usually simply need to return the "index" argument.
/// This is used by Hopper to handle the fact that operands in Intel and AT&T syntaxes are inverted.
- (NSUInteger)translateOperandIndex:(NSUInteger)index operandCount:(NSUInteger)count accordingToSyntax:(uint8_t)syntaxIndex {
    return index;
}

/// Returns a colorized string to be displayed.
/// HPHopperServices protocol provides a very simple colorizer, based on predicates.
- (NSAttributedString *)colorizeInstructionString:(NSAttributedString *)string {
    NSMutableAttributedString *colorized = [string mutableCopy];
    [_services colorizeASMString:colorized
               operatorPredicate:^BOOL(unichar c) {
                   return (c == '#' || c == '$');
               }
           languageWordPredicate:^BOOL(NSString *s) {
               return(NO);
           }
        subLanguageWordPredicate:^BOOL(NSString *s) {
            return(NO);
        }];
    return colorized;
}

/// Returns a array of bytes that represents a NOP instruction of a given size.
- (NSData *)nopWithSize:(NSUInteger)size andMode:(NSUInteger)cpuMode forFile:(NSObject<HPDisassembledFile> *)file {
    NSMutableData *nopArray = [[NSMutableData alloc] initWithCapacity:size];
    [nopArray setLength:size];
    uint16_t *ptr = (uint16_t *)[nopArray mutableBytes];
    memset(ptr, 0xEA, size);
    
    return [NSData dataWithData:nopArray];
}

/// Return YES if the plugin embed an assembler.
- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    return(NO);
}

/// Return YES if the plugin embed a decompiler.
/// Note: you cannot create a decompiler yet, because the main class (ASTNode) is not
/// publicly exposed yet.
- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    return(NO);
}

// Returns the name of the frame pointer register, ie, "bp" for x86, or "r7" for ARM.
- (NSString *)framePointerRegisterNameForFile:(NSObject<HPDisassembledFile>*)file {
    return(nil);
}

@end
