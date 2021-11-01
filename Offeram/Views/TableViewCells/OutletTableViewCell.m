//
//  OutletTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "OutletTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 100

@implementation OutletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [self setSelectedBackgroundView:bgColorView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float cellHeight = CellHeight;
        float cellWidth = [MySingleton sharedManager].floatOutletTableViewWidth;//[MySingleton sharedManager].screenWidth;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];
        
        UIView *shadowContainerView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, cellWidth-10, cellHeight-10)];
        // border radius
        [shadowContainerView.layer setCornerRadius:5.0f];
        // drop shadow
        [shadowContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
        [shadowContainerView.layer setShadowOpacity:0.6];
        [shadowContainerView.layer setShadowRadius:3.0];
        [shadowContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        //======= ADD INNER CONTAINER VIEW =======//
        self.innerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth-10, cellHeight-10)];
        self.innerContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        // border radius
        [self.innerContainer.layer setCornerRadius:5.0f];
        self.innerContainer.clipsToBounds = true;
        
        //======= ADD LABLE AREA NAME INTO INNER CONTAINER VIEW =======//
        self.lblAreaName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.innerContainer.frame.size.width - 70, 15)];
        self.lblAreaName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblAreaName.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        self.lblAreaName.textAlignment = NSTextAlignmentLeft;
        self.lblAreaName.numberOfLines = 1;
        [self.innerContainer addSubview:self.lblAreaName];
        
        //======= ADD LABLE ADDRESS INTO INNER CONTAINER VIEW =======//
        self.lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, self.innerContainer.frame.size.width - 70, self.innerContainer.frame.size.height - 45)];
        self.lblAddress.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblAddress.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        self.lblAddress.textAlignment = NSTextAlignmentJustified;
        self.lblAddress.numberOfLines = 0;
        [self.innerContainer addSubview:self.lblAddress];
        
        //======= ADD LABLE ADDRESS INTO INNER CONTAINER VIEW =======//
        self.lblTimings = [[UILabel alloc] initWithFrame:CGRectMake(5, self.innerContainer.frame.size.height - 20, self.innerContainer.frame.size.width - 70, 10)];
        self.lblTimings.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblTimings.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblTimings.textAlignment = NSTextAlignmentLeft;
        self.lblTimings.numberOfLines = 1;
        [self.innerContainer addSubview:self.lblTimings];
        
        //======= ADD CALL CONTAINER VIEW INTO INNER CONTAINER VIEW =======//
        self.callContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 65, 10, 30, 60)];
        [self.innerContainer addSubview:self.callContainerView];
        
        //======= ADD IMAGE VIEW STAR INTO STAR CONTAINER VIEW =======//
        self.imageViewCall = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        self.imageViewCall.image = [UIImage imageNamed:@"call.png"];
        self.imageViewCall.contentMode = UIViewContentModeScaleAspectFit;
        [self.callContainerView addSubview:self.imageViewCall];
        
        //======= ADD LABLE STAR INTO STAR CONTAINER VIEW =======//
        self.lblCall = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.callContainerView.frame.size.width, 10)];
        self.lblCall.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblCall.font = [MySingleton sharedManager].themeFontEightSizeRegular;
        self.lblCall.textAlignment = NSTextAlignmentCenter;
        self.lblCall.text = @"Call";
        [self.callContainerView addSubview:self.lblCall];
        
        //======= ADD BTN STAR INTO STAR CONTAINER VIEW =======//
        self.btnCall = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.callContainerView.frame.size.width, self.callContainerView.frame.size.height)];
        [self.btnCall setTitle:@"" forState:UIControlStateNormal];
        [self.callContainerView addSubview:self.btnCall];
        
        //======= ADD PING CONTAINER VIEW INTO INNER CONTAINER VIEW =======//
        self.mapContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 35, 10, 30, 60)];
        [self.innerContainer addSubview:self.mapContainerView];
        
        //======= ADD PING VIEW STAR INTO STAR CONTAINER VIEW =======//
        self.imageViewMap = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        self.imageViewMap.image = [UIImage imageNamed:@"map.png"];
        self.imageViewMap.contentMode = UIViewContentModeScaleAspectFit;
        [self.mapContainerView addSubview:self.imageViewMap];
        
        //======= ADD LABLE PING INTO STAR CONTAINER VIEW =======//
        self.lblMap = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.mapContainerView.frame.size.width, 10)];
        self.lblMap.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblMap.font = [MySingleton sharedManager].themeFontEightSizeRegular;
        self.lblMap.textAlignment = NSTextAlignmentCenter;
        self.lblMap.text = @"Map";
        [self.mapContainerView addSubview:self.lblMap];
        
        //======= ADD BTN STAR INTO STAR CONTAINER VIEW =======//
        self.btnMap = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.mapContainerView.frame.size.width, self.mapContainerView.frame.size.height)];
        [self.btnMap setTitle:@"" forState:UIControlStateNormal];
        [self.mapContainerView addSubview:self.btnMap];
        
        [shadowContainerView addSubview:self.innerContainer];
        [self.mainContainer addSubview:shadowContainerView];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
