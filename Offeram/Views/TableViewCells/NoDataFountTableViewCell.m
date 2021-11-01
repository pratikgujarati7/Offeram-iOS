//
//  NoDataFountTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 23/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "NoDataFountTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 270
//#define CellHeight 220

@implementation NoDataFountTableViewCell

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
        float cellWidth = [MySingleton sharedManager].screenWidth;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];

        //======= ADD INNER CONTAINER VIEW =======//
        self.innerContainer = [[UIView alloc]initWithFrame:CGRectMake(5, 5, cellWidth-10, cellHeight-10)];
        self.innerContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        // border radius
        [self.innerContainer.layer setCornerRadius:5.0f];
        // drop shadow
        [self.innerContainer.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.innerContainer.layer setShadowOpacity:0.6];
        [self.innerContainer.layer setShadowRadius:2.0];
        [self.innerContainer.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        // IMAGE VIEW
        self.imageViewOfferam = [[AsyncImageView alloc]initWithFrame:CGRectMake((self.innerContainer.frame.size.width - 140)/2, 20, 140, 140)];
        self.imageViewOfferam.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewOfferam.clipsToBounds = true;
        self.imageViewOfferam.image = [UIImage imageNamed:@"offeram_grey.png"];
        [self.innerContainer addSubview:self.imageViewOfferam];
        
        //LABLE
        self.lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, self.innerContainer.frame.size.width - 20, 40)];
        self.lblNoData.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        self.lblNoData.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblNoData.textAlignment = NSTextAlignmentCenter;
        self.lblNoData.numberOfLines = 2;
        [self.innerContainer addSubview:self.lblNoData];
        
        //BUTTON
        self.btnAction = [[UIButton alloc] initWithFrame:CGRectMake((self.innerContainer.frame.size.width - 130)/2, 220, 130, 30)];
        self.btnAction.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        self.btnAction.clipsToBounds = true;
        self.btnAction.layer.cornerRadius = 5;
        self.btnAction.titleLabel.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
        [self.btnAction setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
        [self.innerContainer addSubview:self.btnAction];
        
        [self.mainContainer addSubview:self.innerContainer];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
@end
