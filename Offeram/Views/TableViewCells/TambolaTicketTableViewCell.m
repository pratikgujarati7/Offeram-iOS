//
//  TambolaTicketTableViewCell.m
//  Offeram
//
//  Created by Innovative Iteration on 27/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import "TambolaTicketTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 150

@implementation TambolaTicketTableViewCell

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
        
        //======= ADD IMAGE VIEW TAMBOLA INTO MAIN CONTAINER VIEW =======//
        self.imageViewTambola = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        self.imageViewTambola.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewTambola.layer.masksToBounds = YES;
        [self.imageViewTambola.layer setCornerRadius:self.imageViewTambola.frame.size.height/2];
        [self.innerContainer addSubview:self.imageViewTambola];
        
        //======= ADD LABEL TAMBOLA TITLE INTO MAIN CONTAINER VIEW =======//
        self.lblTambolaTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, (self.innerContainer.frame.size.width - 155), 35)];
        self.lblTambolaTitle.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
        self.lblTambolaTitle.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblTambolaTitle.textAlignment = NSTextAlignmentLeft;
        self.lblTambolaTitle.numberOfLines = 2;
        self.lblTambolaTitle.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblTambolaTitle];
        
        //======= ADD LABEL TAMBOLA PRICE TAGE INTO MAIN CONTAINER VIEW =======//
        self.lblPriceTag = [[UILabel alloc] initWithFrame:CGRectMake((self.innerContainer.frame.size.width - 45), 5, 40, 20)];
        self.lblPriceTag.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        self.lblPriceTag.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        self.lblPriceTag.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.lblPriceTag.textAlignment = NSTextAlignmentCenter;
        self.lblPriceTag.numberOfLines = 1;
        self.lblPriceTag.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblPriceTag];
        
        //======= ADD LABEL TAMBOLA TITLE INTO MAIN CONTAINER VIEW =======//
        self.lblTambolaDescription = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, (self.innerContainer.frame.size.width - 110), 35)];
        self.lblTambolaDescription.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        self.lblTambolaDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblTambolaDescription.textAlignment = NSTextAlignmentJustified;
        self.lblTambolaDescription.numberOfLines = 2;
        self.lblTambolaDescription.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblTambolaDescription];
        
        //======= ADD BUTTON REGISTER INTO MAIN CONTAINER VIEW =======//
        self.btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, (self.innerContainer.frame.size.width - 20), 30)];
        self.btnRegister.titleLabel.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
        self.btnRegister.backgroundColor = MySingleton.sharedManager.themeGlobalBlueColor;
        [self.btnRegister setTitle:@"Click here to register for Tambola" forState:UIControlStateNormal];
        [self.btnRegister setTitleColor:MySingleton.sharedManager.themeGlobalWhiteColor forState:UIControlStateNormal];
        self.btnRegister.clipsToBounds = true;
//        self.btnRegister.layer.cornerRadius = 5;
        [self.innerContainer addSubview:self.btnRegister];
        
        
        [self.mainContainer addSubview:self.innerContainer];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
            
    return self;
}

@end
