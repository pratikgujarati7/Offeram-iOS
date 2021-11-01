//
//  ReviewTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 09/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 100

@implementation ReviewTableViewCell

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
        
        self.shadowContainerView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, cellWidth-10, cellHeight-10)];
        // border radius
        [self.shadowContainerView.layer setCornerRadius:5.0f];
        // drop shadow
        [self.shadowContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.shadowContainerView.layer setShadowOpacity:0.6];
        [self.shadowContainerView.layer setShadowRadius:3.0];
        [self.shadowContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        //======= ADD INNER CONTAINER VIEW =======//
        self.innerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth-10, cellHeight-10)];
        self.innerContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        // border radius
        [self.innerContainer.layer setCornerRadius:5.0f];
        self.innerContainer.clipsToBounds = true;
        
        //======= ADD LABLE USER NAME INTO INNER CONTAINER VIEW =======//
        self.lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.innerContainer.frame.size.width - 20, 15)];
        self.lblUserName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblUserName.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        self.lblUserName.textAlignment = NSTextAlignmentLeft;
        self.lblUserName.numberOfLines = 1;
        [self.innerContainer addSubview:self.lblUserName];
        
        //======= ADD STAR RATING VIEW INTO INNER CONTAINER VIEW =======//
        self.starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(10, 25, 100, 15)];
        self.starRatingView.maximumValue = 5;
        self.starRatingView.minimumValue = 0;
        self.starRatingView.value = 0;
        self.starRatingView.allowsHalfStars = NO;
        self.starRatingView.tintColor = [MySingleton sharedManager].themeGlobalBlueColor;
        [self.innerContainer addSubview:self.starRatingView];
        
        //======= ADD LABLE USER NAME INTO INNER CONTAINER VIEW =======//
        self.lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, self.innerContainer.frame.size.width - 20, 15)];
        self.lblComment.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblComment.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        self.lblComment.textAlignment = NSTextAlignmentJustified;
        self.lblComment.numberOfLines = 0;
        [self.innerContainer addSubview:self.lblComment];
        
        
        [self.shadowContainerView addSubview:self.innerContainer];
        [self.mainContainer addSubview:self.shadowContainerView];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
