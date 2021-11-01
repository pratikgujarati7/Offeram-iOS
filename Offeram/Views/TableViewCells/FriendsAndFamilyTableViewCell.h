//
//  FriendsAndFamilyTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsAndFamilyTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;

@property (nonatomic,retain) UILabel *lblIndex;
@property (nonatomic,retain) AsyncImageView *imageViewProfile;
@property (nonatomic,retain) UILabel *lblName;
@property (nonatomic,retain) UILabel *lblRedeemed;

@property (nonatomic,retain) UIView *bottomSeparatorView;

@end

NS_ASSUME_NONNULL_END
