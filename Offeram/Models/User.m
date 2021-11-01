//
//  User.m
//  Offeram
//
//  Created by Dipen Lad on 21/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User.h"

@implementation User

-(BOOL)isValidateUserToSendOTP
{
    //================BLANK FIELD VALIDATION===========//
    if(self.strPhoneNumber.length <=  0)
    {
        self.strValidationMessage = @"Please enter phone number";
        return false;
    }
    else if(self.strCityID.length <=  0)
    {
        self.strValidationMessage = @"Please enter select your city";
        return false;
    }
    else
    {
        return true;
    }
    
    return true;
}

@end
