//
//  BrandTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 11/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "BrandTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 115

@implementation BrandTableViewCell

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
        
        
        
        //======= ADD IMAGE VIEW BRAND INTO MAIN CONTAINER VIEW =======//
        self.imageViewBrand = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 120, self.innerContainer.frame.size.height)];
        self.imageViewBrand.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewBrand.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.imageViewBrand];
        
        //======= ADD LABEL OFFER COUNT INTO MAIN CONTAINER VIEW =======//
        self.lblOffersCount = [[UILabel alloc] initWithFrame:CGRectMake(5, self.imageViewBrand.frame.size.height - 20, 50, 15)];
        self.lblOffersCount.font = [MySingleton sharedManager].themeFontEightSizeBold;
        self.lblOffersCount.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.lblOffersCount.backgroundColor = [MySingleton sharedManager].themeGlobalTransperentBlackBackgroundColor;
        self.lblOffersCount.textAlignment = NSTextAlignmentCenter;
        self.lblOffersCount.numberOfLines = 1;
        self.lblOffersCount.layer.masksToBounds = YES;
        self.lblOffersCount.layer.cornerRadius = 3;
        self.lblOffersCount.clipsToBounds = true;
        [self.innerContainer addSubview:self.lblOffersCount];
        
        //======= ADD LABEL OFFER COUNT INTO MAIN CONTAINER VIEW =======//
        self.lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(65, self.imageViewBrand.frame.size.height - 20, 50, 15)];
        self.lblDistance.font = [MySingleton sharedManager].themeFontEightSizeBold;
        self.lblDistance.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.lblDistance.backgroundColor = [MySingleton sharedManager].themeGlobalTransperentBlackBackgroundColor;
        self.lblDistance.textAlignment = NSTextAlignmentCenter;
        self.lblDistance.numberOfLines = 1;
        self.lblDistance.layer.masksToBounds = YES;
        self.lblDistance.layer.cornerRadius = 3;
        self.lblDistance.clipsToBounds = true;
        [self.innerContainer addSubview:self.lblDistance];
        
        //======= ADD LABEL FEATURED INTO MAIN CONTAINER VIEW =======//
        self.lblFeatured = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 5, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-70), 10)];
        self.lblFeatured.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblFeatured.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblFeatured.textAlignment = NSTextAlignmentLeft;
        self.lblFeatured.numberOfLines = 1;
        self.lblFeatured.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblFeatured];
        
        //======= ADD LABEL RATINGS INTO MAIN CONTAINER VIEW =======//
        self.lblRatings = [[UILabel alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 50, 5, 30, 20)];
        self.lblRatings.font = [MySingleton sharedManager].themeFontTenSizeBold;
        self.lblRatings.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        self.lblRatings.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.lblRatings.textAlignment = NSTextAlignmentCenter;
        self.lblRatings.numberOfLines = 1;
        self.lblRatings.layer.masksToBounds = YES;
        // border radius
        [self.lblRatings.layer setCornerRadius:2.5f];
        [self.innerContainer addSubview:self.lblRatings];
        
        //======= ADD IMAGE VIEW TAG INTO MAIN CONTAINER VIEW =======//
        self.imageviewTag = [[UIImageView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 70, 7, 16, 16)];
        self.imageviewTag.contentMode = UIViewContentModeScaleAspectFit;
        self.imageviewTag.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.imageviewTag];
        
        //======= ADD LABEL BRAND NAME INTO MAIN CONTAINER VIEW =======//
        self.lblBrandName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 15, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-20), 20)];
        self.lblBrandName.font = [MySingleton sharedManager].themeFontFourteenSizeMedium;
        self.lblBrandName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblBrandName.textAlignment = NSTextAlignmentLeft;
        self.lblBrandName.numberOfLines = 1;
        self.lblBrandName.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblBrandName];
        
        //======= ADD LABEL LOCATION INTO MAIN CONTAINER VIEW =======//
        self.lblLocation = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 40, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-10), 10)];
        self.lblLocation.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblLocation.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblLocation.textAlignment = NSTextAlignmentLeft;
        self.lblLocation.numberOfLines = 1;
        self.lblLocation.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblLocation];
        
        //======= ADD LABEL ITEMS INTO MAIN CONTAINER VIEW =======//
        self.lblItems = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 55, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-10), 25)];
        self.lblItems.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblItems.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblItems.textAlignment = NSTextAlignmentLeft;
        self.lblItems.numberOfLines = 1;
        self.lblItems.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblItems];
        
        //======= ADD LABEL ITEMS INTO MAIN CONTAINER VIEW =======//
        self.lblOffer = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 85, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-80), 15)];
        self.lblOffer.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblOffer.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblOffer.textAlignment = NSTextAlignmentLeft;
        self.lblOffer.numberOfLines = 1;
        self.lblOffer.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblOffer];
        
        //======= ADD LABEL REDEMED COUNT INTO MAIN CONTAINER VIEW =======//
        self.lblRedeemedCount = [[UILabel alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 80, 85, 70, 15)];
        self.lblRedeemedCount.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblRedeemedCount.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblRedeemedCount.textAlignment = NSTextAlignmentRight;
        self.lblRedeemedCount.numberOfLines = 1;
        self.lblRedeemedCount.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblRedeemedCount];
        
        [shadowContainerView addSubview:self.innerContainer];
        [self.mainContainer addSubview:shadowContainerView];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
