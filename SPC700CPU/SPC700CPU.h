//
//  SPC700CPU.h
//  SPC700CPU
//
//  Created by bcharron on 2014-07-15.
//  Copyright (c) 2014 Benjamin Charron. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Hopper/Hopper.h>

typedef NS_ENUM(NSUInteger, SPC700RegClass) {
    RegClass_AddressRegister = RegClass_FirstUserClass,
    RegClass_SPC700_Cnt
};

@interface SPC700CPU : NSObject<CPUDefinition>

@end
