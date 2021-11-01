//
//  OutletTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutletTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) UILabel *lblAreaName;
@property (nonatomic,retain) UILabel *lblAddress;
@property (nonatomic,retain) UILabel *lblTimings;

@property (nonatomic,retain) UIView *callContainerView;
@property (nonatomic,retain) UIImageView *imageViewCall;
@property (nonatomic,retain) UILabel *lblCall;
@property (nonatomic,retain) UIButton *btnCall;

@property (nonatomic,retain) UIView *mapContainerView;
@property (nonatomic,retain) UIImageView *imageViewMap;
@property (nonatomic,retain) UILabel *lblMap;
@property (nonatomic,retain) UIButton *btnMap;

@end
