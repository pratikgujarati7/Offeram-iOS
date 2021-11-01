//
//  NSNull+JSON.m
//  Reward Cards
//
//  Created by Pratik Gujarati on 13/10/18.
//  Copyright © 2018 Innovative Iteration. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
    NSRange nullRange = {NSNotFound, 0};
    return nullRange;
}

//add methods of NSString if needed

@end
