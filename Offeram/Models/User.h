//
//  User.h
//  Offeram
//
//  Created by Dipen Lad on 21/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,retain) NSString *strValidationMessage;

@property(nonatomic,retain) NSString *strUserID;
@property(nonatomic,retain) NSString *strEmail;
@property(nonatomic,retain) NSString *strPhoneNumber;
@property(nonatomic,retain) NSString *strDeviceToken;
@property(nonatomic,retain) NSString *strVersionID;
@property(nonatomic,retain) NSString *strPaymentID;

@property(nonatomic,retain) NSString *strCityID;
@property(nonatomic,retain) NSString *strCityName;

@property(nonatomic,retain) NSString *strProfileImageURL;
@property(nonatomic,retain) NSString *strUserName;
@property(nonatomic,retain) NSString *strValidityDate;

@property(nonatomic,retain) NSString *strOfferamCoinsBalance;
@property(nonatomic,retain) NSString *strReferralCode;
@property(nonatomic,retain) NSString *strReferralUrl;

-(BOOL)isValidateUserToSendOTP;

@end
