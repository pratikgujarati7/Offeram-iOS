//
//  Coupon.h
//  Offeram
//
//  Created by Dipen Lad on 01/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property(nonatomic,retain) NSString *strCouponID;
@property(nonatomic,retain) NSString *strCouponImageURL;
@property(nonatomic,retain) NSString *strCouponTitle;
@property(nonatomic,retain) NSString *strCouponDescription;

@property(nonatomic,retain) NSString *strAddedDate;
@property(nonatomic,retain) NSString *strEndDate;

@property(nonatomic,retain) NSString *strIsExpired;
@property(nonatomic,retain) NSString *strIsPinged;
@property(nonatomic,retain) NSString *strIsStareed;
@property(nonatomic,retain) NSString *strIsUsed;

@property(nonatomic,retain) NSString *strNumberOfRedeem;

@property(nonatomic,retain) NSString *strTermsAndConditions;

@property(nonatomic,retain) NSMutableArray *arrayOutlets;

@property(nonatomic,retain) NSString *strPingedID;
@property(nonatomic,retain) NSString *strPingedStatus;
@property(nonatomic,retain) NSString *strPingedUserID;
@property(nonatomic,retain) NSString *strPingedUserName;

@end
