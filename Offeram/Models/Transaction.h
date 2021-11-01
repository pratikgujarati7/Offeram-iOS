//
//  Transaction.h
//  Offeram
//
//  Created by Dipen Lad on 01/12/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transaction : NSObject

@property(nonatomic,retain) NSString *strTransactionID;
@property(nonatomic,retain) NSString *strTransactionType;
@property(nonatomic,retain) NSString *strTransactionMessage;
@property(nonatomic,retain) NSString *strTransactionAmount;
@property(nonatomic,retain) NSString *strTransactionDateTime;

@end

NS_ASSUME_NONNULL_END
