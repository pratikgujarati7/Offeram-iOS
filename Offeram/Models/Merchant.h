//
//  Merchant.h
//  Offeram
//
//  Created by Dipen Lad on 22/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Merchant : NSObject

@property(nonatomic,retain) NSString *strMerchantID;
@property(nonatomic,retain) NSString *strCompanyName;
@property(nonatomic,retain) NSString *strUserName;
@property(nonatomic,retain) NSString *strMobileNumber;
@property(nonatomic,retain) NSString *strCompanyLogoImageUrl;
@property(nonatomic,retain) NSString *strCompanyBannerImageUrl;

@property(nonatomic,retain) NSString *strAverageRatings;
@property(nonatomic,retain) NSString *strCategoryID;
@property(nonatomic,retain) NSString *strCategoryName;

@property(nonatomic,retain) NSString *strCouponID;
@property(nonatomic,retain) NSString *strCouponTitle;
@property(nonatomic,retain) NSString *strCuisines;

@property(nonatomic,retain) NSString *strIsStarred;
@property(nonatomic,retain) NSString *strNumberOfRedeems;
@property(nonatomic,retain) NSString *strOfferText;

@property(nonatomic,retain) NSString *strType;
@property(nonatomic,retain) NSString *strStatus;

@property(nonatomic,retain) NSString *strTotalRating;
@property(nonatomic,retain) NSString *strUserCoupons;

@property(nonatomic,retain) NSMutableArray *arrayInfrastructurePhotos;
@property(nonatomic,retain) NSMutableArray *arrayMenuPhotos;

@property(nonatomic,retain) NSMutableArray *arrayOutlets;
@property(nonatomic,retain) NSMutableArray *arrayCoupons;
@property(nonatomic,retain) NSMutableArray *arrayRatings;

@property(nonatomic,retain) NSString *strAreaName;
@property(nonatomic,retain) NSString *strDateUsed;

@property(nonatomic,retain) NSString *strIsReused;
@property(nonatomic,retain) NSString *strReuseAmount;

@property(nonatomic,retain) NSString *strRedemptionID;

@end
