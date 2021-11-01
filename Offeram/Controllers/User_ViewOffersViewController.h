//
//  User_ViewOffersViewController.h
//  Offeram
//
//  Created by Dipen Lad on 16/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AsyncImageView.h"
#import "HCSStarRatingView.h"

#import "Merchant.h"

#import "User_OutletsViewController.h"
#import "User_ViewRatingsViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface User_ViewOffersViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextViewDelegate>

{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinates;
}

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *backContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIScrollView *imageSliderScrollView;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferCount;
@property (nonatomic,retain) IBOutlet UIPageControl *pageControlSliderImages;

@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewBrandLogo;

@property (nonatomic,retain) IBOutlet UIView *BrandDetilsContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewFoodType;
@property (nonatomic,retain) IBOutlet UILabel *lblBrandName;
@property (nonatomic,retain) IBOutlet UILabel *lblLocation;
@property (nonatomic,retain) IBOutlet UILabel *lblOutletCount;
@property (nonatomic,retain) IBOutlet UILabel *lblRatings;
@property (nonatomic,retain) IBOutlet UILabel *lblReviewCount;
@property (nonatomic,retain) IBOutlet UIView *viewVerticalSeparatorView;
@property (nonatomic,retain) IBOutlet UILabel *lblTimings;
@property (nonatomic,retain) IBOutlet UILabel *lblOpenOrClose;

@property (nonatomic,retain) IBOutlet UIView *callNowContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewCallNow;
@property (nonatomic,retain) IBOutlet UILabel *lblCallNow;
@property (nonatomic,retain) IBOutlet UIButton *btnCallNow;

@property (nonatomic,retain) IBOutlet UIView *mapContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewMap;
@property (nonatomic,retain) IBOutlet UILabel *lblMap;
@property (nonatomic,retain) IBOutlet UIButton *btnMap;

@property (nonatomic,retain) IBOutlet UIView *addReviewContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewAddReview;
@property (nonatomic,retain) IBOutlet UILabel *lblAddReview;
@property (nonatomic,retain) IBOutlet UIButton *btnAddReview;


@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

@property (nonatomic,retain) IBOutlet UIButton *btnBuyNow;

//MENU
@property (nonatomic,retain) IBOutlet UIView *menuImagesContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMenu;
@property (nonatomic,retain) IBOutlet UIScrollView *menuImagesScrollView;

//PHOTOS
@property (nonatomic,retain) IBOutlet UIView *photoImagesContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblPhoto;
@property (nonatomic,retain) IBOutlet UIScrollView *photoImagesScrollView;

// REVIEW POPUP
@property (nonatomic,retain) IBOutlet UIView *reviewContainerView;
@property (nonatomic,retain) IBOutlet UIView *reviewTransperentContainerView;

@property (nonatomic,retain) IBOutlet UIView *innerContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblWriteTeview;
@property (nonatomic,retain) IBOutlet UILabel *lblCompanyName;

@property (nonatomic,retain) IBOutlet HCSStarRatingView *starContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTapToAddStar;

@property (nonatomic,retain) IBOutlet UIView *bottomSeparatorView;

@property (nonatomic,retain) IBOutlet UITextView *txtViewReview;

@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic,retain) IBOutlet UIButton *btnCancel;

//========== OTHER VARIABLES ==========//

@property(nonatomic,assign) BOOL boolIsOpenedFromSplash;

@property (nonatomic,strong) NSString *strMerchantID;

@property (nonatomic,strong) Merchant *objMerchant;

@property (nonatomic,strong) NSString *strLatitude;
@property (nonatomic,strong) NSString *strLongitude;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic,retain) User_OutletsViewController *showOutletsViewControllers;
@property (nonatomic,retain) User_ViewRatingsViewController *showRatingsViewControllers;

@end
