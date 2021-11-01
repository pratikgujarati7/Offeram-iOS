//
//  User_OfferDetailsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 18/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "TTGTextTagCollectionView.h"

#import "User_OutletsViewController.h"

#import "Merchant.h"
#import "Coupon.h"

@interface User_OfferDetailsViewController : UIViewController<UIScrollViewDelegate, TTGTextTagCollectionViewDelegate, TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblBrandName;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIScrollView *imageSliderScrollView;
@property (nonatomic,retain) IBOutlet UIPageControl *pageControlSliderImages;

@property (nonatomic,retain) IBOutlet UILabel *lblOutlets;
@property (nonatomic,retain) IBOutlet UIView *tagsContainerView;

@property (nonatomic,retain) IBOutlet UILabel *lblValidTill;

// OFFER CONTAINER
@property (nonatomic,retain) IBOutlet UIView *offerMainContainer;
@property (nonatomic,retain) IBOutlet UIView *offerInnerContainer;

@property (nonatomic,retain) IBOutlet UIView *offerNumberContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferNumber;
@property (nonatomic,retain) IBOutlet UILabel *lblIsOfferUsed;

@property (nonatomic,retain) IBOutlet UILabel *lblOfferTitle;

@property (nonatomic,retain) IBOutlet UIView *starContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewStar;
@property (nonatomic,retain) IBOutlet UILabel *lblStar;
@property (nonatomic,retain) IBOutlet UIButton *btnStar;

@property (nonatomic,retain) IBOutlet UIView *pingContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewPing;
@property (nonatomic,retain) IBOutlet UILabel *lblPing;
@property (nonatomic,retain) IBOutlet UIButton *btnPing;

@property (nonatomic,retain) IBOutlet UILabel *lblRedeemedCount;

//TERMS AND CONDITIONS
@property (nonatomic,retain) IBOutlet UIView *termsAndConditionsContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTermsAndConditions;

@property (nonatomic,retain) IBOutlet UIButton *btnRedeemThisOffer;

@property (nonatomic,retain) IBOutlet UIButton *btnBuyNow;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *bannerImagesDataRows;

@property (nonatomic,retain) TTGTextTagCollectionView *tagCollectionView;

@property (nonatomic,strong) NSString *strOfferNumber;
@property (nonatomic,strong) Merchant *objMerchant;
@property (nonatomic,strong) Coupon *objSelectedCoupon;

@property(nonatomic, assign) BOOL isPingedOffer;

@property (nonatomic,retain) User_OutletsViewController *showOutletsViewControllers;

@end
