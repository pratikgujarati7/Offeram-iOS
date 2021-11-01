//
//  UsedCouponTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 04/12/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UsedCouponTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) AsyncImageView *imageViewBrand;
@property (nonatomic,retain) UILabel *lblOffersCount;
@property (nonatomic,retain) UILabel *lblDistance;

@property (nonatomic,retain) UILabel *lblFeatured;
@property (nonatomic,retain) UIImageView *imageviewTag;
@property (nonatomic,retain) UILabel *lblRatings;

@property (nonatomic,retain) UILabel *lblBrandName;
@property (nonatomic,retain) UILabel *lblLocation;

@property (nonatomic,retain) UILabel *lblItems;
@property (nonatomic,retain) UILabel *lblOffer;
@property (nonatomic,retain) UILabel *lblRedeemedCount;

@property (nonatomic,retain) UIView *reuseContainer;
@property (nonatomic,retain) UILabel *lblIsCouponReused;
@property (nonatomic,retain) UILabel *lblReuseAmount;
@property (nonatomic,retain) UIButton *btnReuse;

@end

NS_ASSUME_NONNULL_END
