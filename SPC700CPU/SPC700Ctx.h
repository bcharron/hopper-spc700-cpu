//
//  SPC700Ctx.h
//  SPC700CPU
//
//  Created by bcharron on 2014-07-15.
//  Copyright (c) 2014 Benjamin Charron. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Hopper/Hopper.h>

@class SPC700CPU;

@interface SPC700Ctx : NSObject<CPUContext>

- (instancetype)initWithCPU:(SPC700CPU *)cpu andFile:(NSObject<HPDisassembledFile> *)file;

@end
