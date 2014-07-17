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
