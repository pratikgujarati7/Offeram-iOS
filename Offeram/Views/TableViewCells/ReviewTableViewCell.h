//
//  ReviewTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 09/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ReviewTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *shadowContainerView;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) UILabel *lblUserName;
@property (nonatomic,retain) HCSStarRatingView *starRatingView;
@property (nonatomic,retain) UILabel *lblComment;

@end
