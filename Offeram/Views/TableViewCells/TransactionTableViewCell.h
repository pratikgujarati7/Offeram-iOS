//
//  TransactionTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 01/12/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) AsyncImageView *imageViewTransaction;

@property (nonatomic,retain) UILabel *lblTransactionText;
@property (nonatomic,retain) UILabel *lblTransactionDateTime;

@property (nonatomic,retain) UILabel *lblTransactionAmount;

@property (nonatomic,retain) UIView *bottomSeparatorView;

@end

NS_ASSUME_NONNULL_END
