//
//  OfferTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 17/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "OfferTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 100

@implementation OfferTableViewCell

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
        
        //======= ADD OFFER NUMBER CONTAINER VIEW =======//
        self.offerNumberContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.innerContainer.frame.size.height)];
        self.offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        [self.innerContainer addSubview:self.offerNumberContainerView];
        
        //======= ADD LABLE OFFER NUMBER INTO OFFER NUMBER CONTAINER VIEW =======//
        self.lblOfferNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.offerNumberContainerView.frame.size.width, self.offerNumberContainerView.frame.size.width)];
        self.lblOfferNumber.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
        self.lblOfferNumber.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.lblOfferNumber.numberOfLines = 1;
        self.lblOfferNumber.textAlignment = NSTextAlignmentCenter;
        [self.offerNumberContainerView addSubview:self.lblOfferNumber];
        
        //======= ADD IS OFFER USED CONTAINER VIEW =======//
        self.lblIsOfferUsed = [[UILabel alloc] initWithFrame:CGRectMake(0, self.offerNumberContainerView.frame.size.height - 25, self.offerNumberContainerView.frame.size.width , 10)];
        self.lblIsOfferUsed.font = [MySingleton sharedManager].themeFontTenSizeBold;
        self.lblIsOfferUsed.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.lblIsOfferUsed.numberOfLines = 1;
        self.lblIsOfferUsed.textAlignment = NSTextAlignmentCenter;
        self.lblIsOfferUsed.text = @"USED";
        [self.offerNumberContainerView addSubview:self.lblIsOfferUsed];
        
        //======= ADD LABLE OFFER TITLE INTO INNER CONTAINER VIEW =======//
        self.lblOfferTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.offerNumberContainerView.frame.size.width + 5, 5, self.innerContainer.frame.size.width - self.offerNumberContainerView.frame.size.width - 70, self.innerContainer.frame.size.height - 20)];
        self.lblOfferTitle.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblOfferTitle.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        self.lblOfferTitle.textAlignment = NSTextAlignmentJustified;
        self.lblOfferTitle.numberOfLines = 0;
        [self.innerContainer addSubview:self.lblOfferTitle];
        
        //======= ADD LABLE REDEEMED COUNT INTO INNER CONTAINER VIEW =======//
        self.lblRedeemedCount = [[UILabel alloc] initWithFrame:CGRectMake(self.offerNumberContainerView.frame.size.width + 5, self.innerContainer.frame.size.height - 15, self.innerContainer.frame.size.width - self.offerNumberContainerView.frame.size.width - 70, 10)];
        self.lblRedeemedCount.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblRedeemedCount.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblRedeemedCount.textAlignment = NSTextAlignmentLeft;
        [self.innerContainer addSubview:self.lblRedeemedCount];
        
        //======= ADD STAR CONTAINER VIEW INTO INNER CONTAINER VIEW =======//
        self.starContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 65, 10, 30, 60)];
        [self.innerContainer addSubview:self.starContainerView];
        
        //======= ADD IMAGE VIEW STAR INTO STAR CONTAINER VIEW =======//
        self.imageViewStar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        self.imageViewStar.contentMode = UIViewContentModeScaleAspectFit;
        [self.starContainerView addSubview:self.imageViewStar];
        
        //======= ADD LABLE STAR INTO STAR CONTAINER VIEW =======//
        self.lblStar = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.starContainerView.frame.size.width, 10)];
        self.lblStar.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblStar.font = [MySingleton sharedManager].themeFontEightSizeRegular;
        self.lblStar.textAlignment = NSTextAlignmentCenter;
        self.lblStar.text = @"Star";
        [self.starContainerView addSubview:self.lblStar];
        
        //======= ADD BTN STAR INTO STAR CONTAINER VIEW =======//
        self.btnStar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.starContainerView.frame.size.width, self.starContainerView.frame.size.height)];
        [self.btnStar setTitle:@"" forState:UIControlStateNormal];
        [self.starContainerView addSubview:self.btnStar];
        
        //======= ADD PING CONTAINER VIEW INTO INNER CONTAINER VIEW =======//
        self.pingContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 35, 10, 30, 60)];
        [self.innerContainer addSubview:self.pingContainerView];
        
        //======= ADD PING VIEW STAR INTO STAR CONTAINER VIEW =======//
        self.imageViewPing = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
        self.imageViewPing.contentMode = UIViewContentModeScaleAspectFit;
        [self.pingContainerView addSubview:self.imageViewPing];
        
        //======= ADD LABLE PING INTO STAR CONTAINER VIEW =======//
        self.lblPing = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.pingContainerView.frame.size.width, 10)];
        self.lblPing.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPing.font = [MySingleton sharedManager].themeFontEightSizeRegular;
        self.lblPing.textAlignment = NSTextAlignmentCenter;
        self.lblPing.text = @"Ping";
        [self.pingContainerView addSubview:self.lblPing];
        
        //======= ADD BTN STAR INTO STAR CONTAINER VIEW =======//
        self.btnPing = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.pingContainerView.frame.size.width, self.pingContainerView.frame.size.height)];
        [self.btnPing setTitle:@"" forState:UIControlStateNormal];
        [self.pingContainerView addSubview:self.btnPing];
        
        [shadowContainerView addSubview:self.innerContainer];
        [self.mainContainer addSubview:shadowContainerView];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
