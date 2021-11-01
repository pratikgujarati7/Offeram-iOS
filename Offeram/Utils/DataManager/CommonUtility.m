//
//  CommonUtility.m
//  Reward Cards
//
//  Created by Pratik Gujarati on 04/12/17.
//  Copyright © 2017 Innovative Iteration. All rights reserved.
//

#import "CommonUtility.h"

@implementation CommonUtility

-(BOOL) isValidEmailAddress:(NSString *)strEmail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool result =[emailTest evaluateWithObject:strEmail];
    return result;
}

@end
