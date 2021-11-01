//
//  PingedOfferTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 12/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PingedOfferTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) AsyncImageView *imageViewBrand;

@property (nonatomic,retain) UIImageView *imageviewTag;
@property (nonatomic,retain) UILabel *lblRatings;

@property (nonatomic,retain) UILabel *lblBrandName;
@property (nonatomic,retain) UILabel *lblLocation;

@property (nonatomic,retain) UILabel *lblOffer;
@property (nonatomic,retain) UILabel *lblPingFrom;
@property (nonatomic,retain) UILabel *lblPingFromValue;

@property (nonatomic,retain) UIView *btnAcceptContainerView;
@property (nonatomic,retain) UIImageView *imageviewAccept;
@property (nonatomic,retain) UILabel *lblAccept;
@property (nonatomic,retain) UIButton *btnAccept;

@property (nonatomic,retain) UIView *btnDeclineContainerView;
@property (nonatomic,retain) UIImageView *imageviewDecline;
@property (nonatomic,retain) UILabel *lblDecline;
@property (nonatomic,retain) UIButton *btnDecline;

@end
