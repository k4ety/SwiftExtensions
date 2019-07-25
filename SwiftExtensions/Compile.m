//
//  Compile.m
//  SwiftExtensions
//
//  Created by Paul King on 10/20/17.
//

#import <Foundation/Foundation.h>
#import "Compile.h"

@implementation Compile

+ (NSString *) date {
    return [NSString stringWithUTF8String:__DATE__];
  }
  
+ (NSString *) time {
    return [NSString stringWithUTF8String:__TIME__];
  }

@end

