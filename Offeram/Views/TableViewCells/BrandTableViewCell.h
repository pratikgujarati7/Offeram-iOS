//
//  BrandTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 11/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BrandTableViewCell : UITableViewCell

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

@end
