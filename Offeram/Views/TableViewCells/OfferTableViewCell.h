//
//  OfferTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 17/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) UIView *offerNumberContainerView;
@property (nonatomic,retain) UILabel *lblOfferNumber;
@property (nonatomic,retain) UILabel *lblIsOfferUsed;

@property (nonatomic,retain) UILabel *lblOfferTitle;

@property (nonatomic,retain) UIView *starContainerView;
@property (nonatomic,retain) UIImageView *imageViewStar;
@property (nonatomic,retain) UILabel *lblStar;
@property (nonatomic,retain) UIButton *btnStar;

@property (nonatomic,retain) UIView *pingContainerView;
@property (nonatomic,retain) UIImageView *imageViewPing;
@property (nonatomic,retain) UILabel *lblPing;
@property (nonatomic,retain) UIButton *btnPing;

@property (nonatomic,retain) UILabel *lblRedeemedCount;

@end
