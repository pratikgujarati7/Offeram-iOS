//
//  PingedOfferTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 12/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "PingedOfferTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 115

@implementation PingedOfferTableViewCell

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
        
        //======= ADD IMAGE VIEW BRAND INTO MAIN CONTAINER VIEW =======//
        self.imageViewBrand = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 120, self.innerContainer.frame.size.height)];
        self.imageViewBrand.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewBrand.layer.masksToBounds = YES;
        
        UIBezierPath *maskPath = [UIBezierPath
                                  bezierPathWithRoundedRect:self.imageViewBrand.bounds
                                  byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                  cornerRadii:CGSizeMake(5, 5)
                                  ];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        
        self.imageViewBrand.layer.mask = maskLayer;
        
        [self.innerContainer addSubview:self.imageViewBrand];
        
        //======= ADD LABEL BRAND NAME INTO MAIN CONTAINER VIEW =======//
        self.lblBrandName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 5, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-70), 20)];
        self.lblBrandName.font = [MySingleton sharedManager].themeFontFourteenSizeMedium;
        self.lblBrandName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblBrandName.textAlignment = NSTextAlignmentLeft;
        self.lblBrandName.numberOfLines = 1;
        self.lblBrandName.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblBrandName];
        
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
        
        //======= ADD LABEL LOCATION INTO MAIN CONTAINER VIEW =======//
        self.lblLocation = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 25, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-10), 10)];
        self.lblLocation.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblLocation.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblLocation.textAlignment = NSTextAlignmentLeft;
        self.lblLocation.numberOfLines = 1;
        self.lblLocation.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblLocation];
        
        //======= ADD LABEL OFFER INTO MAIN CONTAINER VIEW =======//
        self.lblOffer = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 40, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-10), 30)];
        self.lblOffer.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblOffer.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblOffer.textAlignment = NSTextAlignmentLeft;
        self.lblOffer.numberOfLines = 0;
        self.lblOffer.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblOffer];
        
        //======= ADD LABEL PING FROM INTO MAIN CONTAINER VIEW =======//
        self.lblPingFrom = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 70, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-130), 10)];
        self.lblPingFrom.font = [MySingleton sharedManager].themeFontEightSizeMedium;
        self.lblPingFrom.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblPingFrom.textAlignment = NSTextAlignmentLeft;
        self.lblPingFrom.numberOfLines = 1;
        self.lblPingFrom.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblPingFrom];
        
        //======= ADD LABEL PING FROM VALUE INTO MAIN CONTAINER VIEW =======//
        self.lblPingFromValue = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 5), 85, (self.innerContainer.frame.size.width - (self.imageViewBrand.frame.origin.x + self.imageViewBrand.frame.size.width + 10)-150), 15)];
        self.lblPingFromValue.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblPingFromValue.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblPingFromValue.textAlignment = NSTextAlignmentLeft;
        self.lblPingFromValue.numberOfLines = 1;
        self.lblPingFromValue.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblPingFromValue];
        
        //======= ADD BTN DECLINE CONTAINER VIEW INTO MAIN CONTAINER VIEW =======//
        self.btnDeclineContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 75, 75, 70, 25)];
        self.btnDeclineContainerView.layer.borderColor = [UIColor redColor].CGColor;
        self.btnDeclineContainerView.layer.borderWidth = 1.0f;
        
        self.imageviewDecline = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 20, 20)];
        self.imageviewDecline.contentMode = UIViewContentModeScaleAspectFit;
        self.imageviewDecline.image = [UIImage imageNamed:@"decline.png"];
        [self.btnDeclineContainerView addSubview:self.imageviewDecline];
        
        self.lblDecline = [[UILabel alloc] initWithFrame:CGRectMake(25, 2, 45, 20)];
        self.lblDecline.text = @"Decline";
        self.lblDecline.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblDecline.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblDecline.textAlignment = NSTextAlignmentCenter;
        self.lblDecline.numberOfLines = 1;
        self.lblDecline.layer.masksToBounds = YES;
        [self.btnDeclineContainerView addSubview:self.lblDecline];
        
        self.btnDecline = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
        [self.btnDecline setTitle:@"" forState:UIControlStateNormal];
        self.btnDecline.backgroundColor = [UIColor clearColor];
        [self.btnDeclineContainerView addSubview:self.btnDecline];
        
        // border radius
        [self.btnDeclineContainerView.layer setCornerRadius:2.5f];
        [self.innerContainer addSubview:self.btnDeclineContainerView];
        
        //======= ADD BTN ACCEPT CONTAINER VIEW INTO MAIN CONTAINER VIEW =======//
        self.btnAcceptContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 150, 75, 70, 25)];
        self.btnAcceptContainerView.layer.borderColor = [UIColor greenColor].CGColor;
        self.btnAcceptContainerView.layer.borderWidth = 1.0f;
        
        self.imageviewAccept = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 20, 20)];
        self.imageviewAccept.contentMode = UIViewContentModeScaleAspectFit;
        self.imageviewAccept.image = [UIImage imageNamed:@"accept.png"];
        [self.btnAcceptContainerView addSubview:self.imageviewAccept];
        
        self.lblAccept = [[UILabel alloc] initWithFrame:CGRectMake(25, 2, 45, 20)];
        self.lblAccept.text = @"Accept";
        self.lblAccept.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        self.lblAccept.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblAccept.textAlignment = NSTextAlignmentCenter;
        self.lblAccept.numberOfLines = 1;
        self.lblAccept.layer.masksToBounds = YES;
        [self.btnAcceptContainerView addSubview:self.lblAccept];
        
        self.btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
        [self.btnAccept setTitle:@"" forState:UIControlStateNormal];
        self.btnAccept.backgroundColor = [UIColor clearColor];
        [self.btnAcceptContainerView addSubview:self.btnAccept];
        
        // border radius
        [self.btnAcceptContainerView.layer setCornerRadius:2.5f];
        [self.innerContainer addSubview:self.btnAcceptContainerView];
        
        [self.mainContainer addSubview:self.innerContainer];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
