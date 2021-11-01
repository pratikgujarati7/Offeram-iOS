//
//  Redeemer.h
//  Offeram
//
//  Created by Dipen Lad on 15/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Redeemer : NSObject

@property(nonatomic,retain) NSString *strRedeemerID;
@property(nonatomic,retain) NSString *strRedeemerProfileImageURL;
@property(nonatomic,retain) NSString *strRedeemerName;
@property(nonatomic,retain) NSString *strRedeemerAmount;

@end

NS_ASSUME_NONNULL_END
