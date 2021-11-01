//
//  FriendsAndFamilyTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "FriendsAndFamilyTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 60

@implementation FriendsAndFamilyTableViewCell

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
        float cellWidth = [MySingleton sharedManager].screenWidth - 20;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        
        //======= ADD LABEL INDEX INTO MAIN CONTAINER VIEW =======//
        self.lblIndex = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 20, 20)];
        self.lblIndex.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblIndex.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblIndex.textAlignment = NSTextAlignmentCenter;
        self.lblIndex.numberOfLines = 1;
        self.lblIndex.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblIndex];
        
        //======= ADD IMAGE VIEW PROFILE INTO MAIN CONTAINER VIEW =======//
        self.imageViewProfile = [[AsyncImageView alloc] initWithFrame:CGRectMake(30, 15, 30, 30)];
        self.imageViewProfile.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewProfile.clipsToBounds = true;
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.size.height/2;
        [self.mainContainer addSubview:self.imageViewProfile];
        
        //======= ADD LABEL NAME COUNT INTO MAIN CONTAINER VIEW =======//
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, cellWidth - 70 - 105, 20)];
        self.lblName.font = [MySingleton sharedManager].themeFontTwelveSizeMedium;
        self.lblName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblName.textAlignment = NSTextAlignmentLeft;
        self.lblName.numberOfLines = 1;
        self.lblName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblName];
        
        //======= ADD LABEL REDEEMED COUNT INTO MAIN CONTAINER VIEW =======//
        self.lblRedeemed = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - 100 , 20, 100, 20)];
        self.lblRedeemed.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
        self.lblRedeemed.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblRedeemed.textAlignment = NSTextAlignmentLeft;
        self.lblRedeemed.numberOfLines = 1;
        self.lblRedeemed.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblRedeemed];
        
        //======= ADD BOTTOM SEPARATOR INTO MAIN CONTAINER VIEW =======//
        self.bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight-1, cellWidth - 40, 1)];
        self.bottomSeparatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
        [self.mainContainer addSubview:self.bottomSeparatorView];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
