//
//  Notification.h
//  Offeram
//
//  Created by Dipen Lad on 31/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property(nonatomic,retain) NSString *strNotificationID;
@property(nonatomic,retain) NSString *strFromName;
@property(nonatomic,retain) NSString *strNotificationTitle;
@property(nonatomic,retain) NSString *strNotificationDate;
@property(nonatomic,retain) NSString *strNotificationDateTime;
@property(nonatomic,retain) NSString *strCompanyLogoImageUrl;

@property(nonatomic,retain) NSString *strMerchantID;

@end
