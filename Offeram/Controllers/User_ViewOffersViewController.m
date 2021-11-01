//
//  User_ViewOffersViewController.m
//  Offeram
//
//  Created by Dipen Lad on 16/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_ViewOffersViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

#import "User_OfferDetailsViewController.h"
#import "OfferTableViewCell.h"
#import "User_OutletDetailsViewController.h"

#import "User_BuyNowViewController.h"
#import "User_PingOfferViewController.h"
#import "NoDataFountTableViewCell.h"

@interface User_ViewOffersViewController ()<MWPhotoBrowserDelegate>
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_ViewOffersViewController

//========== IBOUTLETS ==========//

@synthesize backContainerView;
@synthesize imageViewBack;
@synthesize btnBack;

@synthesize mainScrollView;

@synthesize imageSliderScrollView;
@synthesize lblOfferCount;
@synthesize pageControlSliderImages;

@synthesize imageViewBrandLogo;

@synthesize BrandDetilsContainerView;
@synthesize imageViewFoodType;
@synthesize lblBrandName;
@synthesize lblLocation;
@synthesize lblOutletCount;
@synthesize lblRatings;
@synthesize lblReviewCount;
@synthesize viewVerticalSeparatorView;
@synthesize lblTimings;
@synthesize lblOpenOrClose;

@synthesize callNowContainerView;
@synthesize imageViewCallNow;
@synthesize lblCallNow;
@synthesize btnCallNow;

@synthesize mapContainerView;
@synthesize imageViewMap;
@synthesize lblMap;
@synthesize btnMap;

@synthesize addReviewContainerView;
@synthesize imageViewAddReview;
@synthesize lblAddReview;
@synthesize btnAddReview;

@synthesize mainTableView;

@synthesize btnBuyNow;

//MENU
@synthesize menuImagesContainerView;
@synthesize lblMenu;
@synthesize menuImagesScrollView;

//PHOTOS
@synthesize photoImagesContainerView;
@synthesize lblPhoto;
@synthesize photoImagesScrollView;

// REVIEW POPUP
@synthesize reviewContainerView;
@synthesize reviewTransperentContainerView;

@synthesize innerContainerView;
@synthesize lblWriteTeview;
@synthesize lblCompanyName;

@synthesize starContainerView;
@synthesize lblTapToAddStar;

@synthesize bottomSeparatorView;

@synthesize txtViewReview;

@synthesize btnSubmit;
@synthesize btnCancel;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    [self setupInitialView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeNotificationEventObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotMerchantDetailsEvent) name:@"user_gotMerchantDetailsEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_addedRemovedFromFavoriteOffersEvent) name:@"user_addedRemovedFromFavoriteOffersEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_submitRatingEvent) name:@"user_submitRatingEvent" object:nil];
        
        // POPUP METHODS
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mapButtonEvent) name:@"mapButtonEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)mapButtonEvent
{
    User_OutletDetailsViewController *viewController = [[User_OutletDetailsViewController alloc] init];
    viewController.objMerchant = self.objMerchant;
    viewController.objSelectedOutlet = self.showOutletsViewControllers.objSelectedOutlet;
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)user_submitRatingEvent
{
    [reviewContainerView removeFromSuperview];
    // CALL WEBSERVICE
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:self.strLatitude forKey:@"latitude"];
    [dictParameters setObject:self.strLongitude forKey:@"longitude"];
    
    [dictParameters setObject:self.strMerchantID forKey:@"merchant_id"];
    
    [[MySingleton sharedManager].dataManager user_getMerchantDetails:dictParameters];
}

-(void)user_addedRemovedFromFavoriteOffersEvent
{
    // CALL WEBSERVICE
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:self.strLatitude forKey:@"latitude"];
    [dictParameters setObject:self.strLongitude forKey:@"longitude"];
    
    [dictParameters setObject:self.strMerchantID forKey:@"merchant_id"];
    
    [[MySingleton sharedManager].dataManager user_getMerchantDetails:dictParameters];
}

-(void)user_gotMerchantDetailsEvent
{
    mainScrollView.hidden = false;
    
    self.objMerchant = [MySingleton sharedManager].dataManager.objSelectedMerchant;
    NSLog(@"%@ :: %@", [MySingleton sharedManager].dataManager.objSelectedMerchant, self.objMerchant);
    
    imageSliderScrollView.delegate = self;
    imageSliderScrollView.pagingEnabled = true;
    
    for (int i = 0; i < self.objMerchant.arrayCoupons.count; i++)
    {
        Coupon *objCoupon = [self.objMerchant.arrayCoupons objectAtIndex:i];
        
        AsyncImageView *imageViewBanner = [[AsyncImageView alloc] initWithFrame:CGRectMake(i * imageSliderScrollView.frame.size.width, 0, imageSliderScrollView.frame.size.width, imageSliderScrollView.frame.size.height)];
        
        imageViewBanner.clipsToBounds = true;
        imageViewBanner.contentMode = UIViewContentModeScaleAspectFill;
        imageViewBanner.imageURL = [NSURL URLWithString:objCoupon.strCouponImageURL];
        
        [imageSliderScrollView addSubview:imageViewBanner];
    }
    
    pageControlSliderImages.numberOfPages = self.objMerchant.arrayCoupons.count;
    pageControlSliderImages.currentPage = 0;
    
    [imageSliderScrollView setContentSize:CGSizeMake(imageSliderScrollView.frame.size.width * self.objMerchant.arrayCoupons.count, imageSliderScrollView.frame.size.height)];
    
    imageViewBrandLogo.imageURL = [NSURL URLWithString: self.objMerchant.strCompanyLogoImageUrl];
    
    lblOfferCount.text = [NSString stringWithFormat:@"%lu Offers", (unsigned long)self.objMerchant.arrayCoupons.count];
    
    imageViewFoodType.hidden = true;
    
    NSLog(@"TYPE : %@",self.objMerchant.strType);
    if (![self.objMerchant.strType isEqualToString:@""])
    {
        NSArray *arrayFoodType = [self.objMerchant.strType componentsSeparatedByString:@","];
        arrayFoodType = [[arrayFoodType reverseObjectEnumerator] allObjects];
        
        for (int i = 0; i < arrayFoodType.count; i ++)
        {
            UIImageView *imageFoodType = [[UIImageView alloc] initWithFrame:CGRectMake(BrandDetilsContainerView.frame.size.width - 5 - (30*(i+1)), 5, 30, 30)];
            imageFoodType.contentMode = UIViewContentModeScaleAspectFit;
            
            if ([[[arrayFoodType objectAtIndex:i] lowercaseString] isEqualToString:@"veg"])
            {
                imageFoodType.image = [UIImage imageNamed:@"veg.png"];
            }
            else if ([[[arrayFoodType objectAtIndex:i] lowercaseString] isEqualToString:@"non-veg"])
            {
                imageFoodType.image = [UIImage imageNamed:@"non_veg.png"];
            }
            else
            {
                imageFoodType.image = [UIImage imageNamed:@"egg.png"];
            }
            
            [BrandDetilsContainerView addSubview:imageFoodType];
        }
    }
    
    lblBrandName.text = self.objMerchant.strCompanyName;
    
    if (self.objMerchant.arrayCoupons.count > 0)
    {
        Coupon *objCoupon = [self.objMerchant.arrayCoupons objectAtIndex:0];
        Outlet *objOutlet;
        if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == true)
        {
            if (objCoupon.arrayOutlets.count > 0)
            {
                objOutlet = [objCoupon.arrayOutlets objectAtIndex:0];
                for (int i = 0; i < objCoupon.arrayOutlets.count; i++)
                {
                    Outlet *objOutletTemp = [objCoupon.arrayOutlets objectAtIndex:i];
                    if ([objOutlet.strDistance floatValue] > [objOutletTemp.strDistance floatValue])
                    {
                        objOutlet = objOutletTemp;
                    }
                }
            }
        }
        else
        {
            if (objCoupon.arrayOutlets.count > 0)
            {
                objOutlet = [objCoupon.arrayOutlets objectAtIndex:0];
            }
        }
        
        lblLocation.text = [NSString stringWithFormat:@"%@", objOutlet.strAreaName];
        lblOutletCount.text = [NSString stringWithFormat:@"+%lu Outlets", (unsigned long)objCoupon.arrayOutlets.count - 1];
        
        // OUTLET COUNT RESIZE
        CGSize maximumLabelSize = CGSizeMake(FLT_MAX, lblOutletCount.frame.size.height);
        CGSize expectedLabelSize = [lblOutletCount.text sizeWithFont:lblOutletCount.font constrainedToSize:maximumLabelSize lineBreakMode:lblOutletCount.lineBreakMode];
        //adjust the label the the new height.
        CGRect newFrame = lblOutletCount.frame;
        newFrame.size.width = expectedLabelSize.width + 10;
        lblOutletCount.frame = newFrame;
        
        if(objCoupon.arrayOutlets.count - 1 > 0)
        {
            lblOutletCount.hidden = false;
            lblOutletCount.userInteractionEnabled = true;
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTapOnOutletCount:)];
            [lblOutletCount addGestureRecognizer:singleFingerTap];
        }
        else
        {
            lblOutletCount.hidden = true;
        }
        
        if ([self.objMerchant.strAverageRatings floatValue] > 0)
        {
            lblRatings.text = self.objMerchant.strAverageRatings;
        }
        else
        {
            lblRatings.text = @"-";
        }
        
        lblReviewCount.text = [NSString stringWithFormat:@"%@ Reviews", self.objMerchant.strTotalRating];
        lblReviewCount.userInteractionEnabled = true;
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTapOnReviewCount:)];
        [lblReviewCount addGestureRecognizer:singleFingerTap];
        
        lblTimings.text = [NSString stringWithFormat:@"%@ - %@",objOutlet.strStartTime, objOutlet.strEndTime];
        
        if ([objOutlet.strStatus integerValue] == 1)
        {
            lblOpenOrClose.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
            lblOpenOrClose.text = @"Open Now";
        }
        else
        {
            lblOpenOrClose.backgroundColor = [MySingleton sharedManager].themeGlobalRedColor;
            lblOpenOrClose.text = @"Close";
        }
    }
    
    [mainTableView reloadData];
    if (self.objMerchant.arrayCoupons.count > 0)
    {
        mainTableView.frame = CGRectMake(mainTableView.frame.origin.x, mainTableView.frame.origin.y, mainTableView.frame.size.width, self.objMerchant.arrayCoupons.count * 100);
    }
    else
    {
        mainTableView.frame = CGRectMake(mainTableView.frame.origin.x, mainTableView.frame.origin.y, mainTableView.frame.size.width, 220);
    }
    
    
    
    // MENU
    if(self.objMerchant.arrayMenuPhotos.count > 0)
    {
        menuImagesContainerView.frame = CGRectMake(0, mainTableView.frame.origin.y + mainTableView.frame.size.height + 10 , [MySingleton sharedManager].screenWidth, menuImagesContainerView.frame.size.height);
        
        for (int i = 0; i < self.objMerchant.arrayMenuPhotos.count; i++)
        {
            AsyncImageView *imageViewMenu = [[AsyncImageView alloc] initWithFrame:CGRectMake(i * 100, 0, 100, menuImagesScrollView.frame.size.height)];
            
            imageViewMenu.clipsToBounds = true;
            imageViewMenu.contentMode = UIViewContentModeScaleAspectFit;
            imageViewMenu.imageURL = [NSURL URLWithString:[self.objMerchant.arrayMenuPhotos objectAtIndex:i]];
            imageViewMenu.tag = i;
            imageViewMenu.userInteractionEnabled = true;
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTapOnMenuImage:)];
            [imageViewMenu addGestureRecognizer:singleFingerTap];
            
            [menuImagesScrollView addSubview:imageViewMenu];
        }
        
        [menuImagesScrollView setContentSize:CGSizeMake(100 * self.objMerchant.arrayMenuPhotos.count, menuImagesScrollView.frame.size.height)];
    }
    else
    {
        menuImagesContainerView.frame = CGRectMake(0, mainTableView.frame.origin.y + mainTableView.frame.size.height + 10 , [MySingleton sharedManager].screenWidth, 0);
    }
    [mainScrollView addSubview:menuImagesContainerView];
    
    // PHOTOS
    if(self.objMerchant.arrayInfrastructurePhotos.count > 0)
    {
        photoImagesContainerView.frame = CGRectMake(0, menuImagesContainerView.frame.origin.y + menuImagesContainerView.frame.size.height + 10 , [MySingleton sharedManager].screenWidth, photoImagesContainerView.frame.size.height);
        
        for (int i = 0; i < self.objMerchant.arrayInfrastructurePhotos.count; i++)
        {
            AsyncImageView *imageViewPhoto = [[AsyncImageView alloc] initWithFrame:CGRectMake(i * 100, 0, 100, photoImagesScrollView.frame.size.height)];
            
            imageViewPhoto.clipsToBounds = true;
            imageViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
            imageViewPhoto.imageURL = [NSURL URLWithString:[self.objMerchant.arrayInfrastructurePhotos objectAtIndex:i]];
            imageViewPhoto.tag = i;
            imageViewPhoto.userInteractionEnabled = true;
            
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTapOnPhotoImage:)];
            [imageViewPhoto addGestureRecognizer:singleFingerTap];
            
            [photoImagesScrollView addSubview:imageViewPhoto];
        }
        
        [photoImagesScrollView setContentSize:CGSizeMake(100 * self.objMerchant.arrayInfrastructurePhotos.count, photoImagesScrollView.frame.size.height)];
    }
    else
    {
        photoImagesContainerView.frame = CGRectMake(0, menuImagesContainerView.frame.origin.y + menuImagesContainerView.frame.size.height + 10 , [MySingleton sharedManager].screenWidth, 0);
    }
    [mainScrollView addSubview:photoImagesContainerView];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width ,photoImagesContainerView.frame.origin.y + photoImagesContainerView.frame.size.height)];
    
    
    // OUTLETS CONTROLLER
    self.showOutletsViewControllers = [[User_OutletsViewController alloc] init];
    self.showOutletsViewControllers.objMerchant = self.objMerchant;
    
    if (self.objMerchant.arrayCoupons.count > 0)
    {
        Coupon *objCouponForPopup = [self.objMerchant.arrayCoupons objectAtIndex:0];
        self.showOutletsViewControllers.dataRows = objCouponForPopup.arrayOutlets;
        [self.showOutletsViewControllers setupInitialView];
        self.showOutletsViewControllers.lblCompanName.text = self.objMerchant.strCompanyName;
        self.showOutletsViewControllers.lblOutletsCount.text = [NSString stringWithFormat:@"TOTAL %lu Outlets", (unsigned long)self.showOutletsViewControllers.dataRows.count];
        [self.showOutletsViewControllers.mainTableView reloadData];
        self.showOutletsViewControllers.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    // SETUP REVIEW POPUP
    [self setupReviewPopup];
    
    // VIEW RATINGS CONTROLLER
    self.showRatingsViewControllers = [[User_ViewRatingsViewController alloc] init];
    self.showRatingsViewControllers.objMerchant = self.objMerchant;
    [self.showRatingsViewControllers setupInitialView];
    self.showRatingsViewControllers.lblCompanyName.text = self.objMerchant.strCompanyName;
    self.showRatingsViewControllers.lblReviewCount.text = [NSString stringWithFormat:@"TOTAL %lu Review", (unsigned long)self.showRatingsViewControllers.objMerchant.arrayRatings.count];
    [self.showRatingsViewControllers.mainTableView reloadData];
    self.showRatingsViewControllers.modalPresentationStyle = UIModalPresentationOverCurrentContext;
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    UIFont *lblOfferCountFont, *lblBrandNameFont, *lblRatingsFont, *btnTitleFont, *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblOfferCountFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        lblBrandNameFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        lblRatingsFont = [MySingleton sharedManager].themeFontNineSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontTenSizeMedium;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblOfferCountFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        lblBrandNameFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        lblRatingsFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontElevenSizeMedium;
    }
    else
    {
        lblOfferCountFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblBrandNameFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblRatingsFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeMedium;
    }
    
    // BACK
    backContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalTransperentBlackBackgroundColor;
    imageViewBack.contentMode = UIViewContentModeScaleAspectFit;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // OFFERS COUNT
    lblOfferCount.font = lblOfferCountFont;
    lblOfferCount.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblOfferCount.backgroundColor = [MySingleton sharedManager]. themeGlobalTransperentBlackBackgroundColor;
    lblOfferCount.textAlignment = NSTextAlignmentCenter;
    
    // IMAGE VIEW LOGO
    imageViewBrandLogo.contentMode = UIViewContentModeScaleAspectFill;
    imageViewBrandLogo.clipsToBounds = true;
    imageViewBrandLogo.layer.cornerRadius = imageViewBrandLogo.frame.size.width/2;
    imageViewBrandLogo.layer.borderColor = [MySingleton sharedManager].themeGlobalWhiteColor.CGColor;
    imageViewBrandLogo.layer.borderWidth = 3.0f;
    
    // BRAND NAME
    lblBrandName.font = lblBrandNameFont;
    lblBrandName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblBrandName.textAlignment = NSTextAlignmentCenter;
    
    // LOCATION
    lblLocation.font = lblOfferCountFont;
    lblLocation.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblLocation.textAlignment = NSTextAlignmentRight;
    
    // OUTLET COUNT
    lblOutletCount.font = lblOfferCountFont;
    lblOutletCount.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblOutletCount.textAlignment = NSTextAlignmentCenter;
    lblOutletCount.clipsToBounds = true;
    lblOutletCount.layer.cornerRadius = 2;
    lblOutletCount.layer.borderColor = [MySingleton sharedManager].themeGlobalBlueColor.CGColor;
    lblOutletCount.layer.borderWidth = 1.0f;
    
    // RATINGS
    lblRatings.font = lblRatingsFont;
    lblRatings.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblRatings.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblRatings.textAlignment = NSTextAlignmentCenter;
    lblRatings.clipsToBounds = true;
    lblRatings.layer.cornerRadius = 2;
    
    // REVIEW COUNT
    lblReviewCount.font = lblOfferCountFont;
    lblReviewCount.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblReviewCount.textAlignment = NSTextAlignmentRight;
    
    // VERICAL SEPARATOR VIEW
    viewVerticalSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // TIMINGS
    lblTimings.font = lblOfferCountFont;
    lblTimings.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblTimings.textAlignment = NSTextAlignmentLeft;
    
    // OPEN OR CLOSE
    lblOpenOrClose.font = lblRatingsFont;
    lblOpenOrClose.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblOpenOrClose.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    lblOpenOrClose.textAlignment = NSTextAlignmentCenter;
    lblOpenOrClose.clipsToBounds = true;
    lblOpenOrClose.layer.cornerRadius = 2;
    
    // CALL NOW
    callNowContainerView.backgroundColor = [UIColor clearColor];
    imageViewCallNow.contentMode = UIViewContentModeScaleAspectFit;
    lblCallNow.font = btnTitleFont;
    lblCallNow.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCallNow.textAlignment = NSTextAlignmentCenter;
    [btnCallNow addTarget:self action:@selector(btnCallNowClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // MAP
    mapContainerView.backgroundColor = [UIColor clearColor];
    imageViewMap.contentMode = UIViewContentModeScaleAspectFit;
    lblMap.font = btnTitleFont;
    lblMap.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMap.textAlignment = NSTextAlignmentCenter;
    [btnMap addTarget:self action:@selector(btnMapClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // ADD REVIEW
    addReviewContainerView.backgroundColor = [UIColor clearColor];
    imageViewAddReview.contentMode = UIViewContentModeScaleAspectFit;
    lblAddReview.font = btnTitleFont;
    lblAddReview.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblAddReview.textAlignment = NSTextAlignmentCenter;
    [btnAddReview addTarget:self action:@selector(btnAddReviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = true;
    mainTableView.hidden = false;
    
    mainScrollView.hidden = true;
    
    // MENU
    lblMenu.font = lblOfferCountFont;
    lblMenu.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMenu.textAlignment = NSTextAlignmentLeft;
    
    menuImagesScrollView.delegate = self;
    
    // PHOTOS
    lblPhoto.font = lblOfferCountFont;
    lblPhoto.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblPhoto.textAlignment = NSTextAlignmentLeft;
    
    photoImagesScrollView.delegate = self;
    
    // BTN BUY NOW
    btnBuyNow.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnBuyNow.titleLabel.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    [btnBuyNow setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnBuyNow.clipsToBounds = true;
    btnBuyNow.layer.cornerRadius =  btnBuyNow.frame.size.width/2;
    btnBuyNow.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnBuyNow.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnBuyNow setTitle: @"BUY\nNOW" forState: UIControlStateNormal];
    [btnBuyNow addTarget:self action:@selector(btnBuyNowClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strUserPaymentId = [prefs objectForKey:@"userpaymentid"];
    if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"userpaymentid"]
        || strUserPaymentId == nil
        || [strUserPaymentId integerValue] == 0
        || [strUserPaymentId isEqualToString:@""])
    {
        btnBuyNow.hidden = false;
    }
    else
    {
        btnBuyNow.hidden = true;
    }
    
    /// GET CURRENT LOCATION
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startMonitoringSignificantLocationChanges];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
    }
#endif
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            [appDelegate dismissGlobalHUD];
        }
    }
    else
    {
        [appDelegate dismissGlobalHUD];
    }
}

-(IBAction)btnBuyNowClicked:(id)sender
{
    User_BuyNowViewController *viewController = [[User_BuyNowViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)handleSingleTapOnOutletCount:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    [self.showOutletsViewControllers showOutlets];
}

- (void)handleSingleTapOnReviewCount:(UITapGestureRecognizer *)recognizer
{
    if (self.objMerchant.arrayRatings.count > 0)
    {
        [self.showRatingsViewControllers showReview];
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.boolIsOpenedFromSplash)
    {
//        User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
        User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:false];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:true];
    }
}

-(IBAction)btnCallNowClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.showOutletsViewControllers showOutlets];
}

-(IBAction)btnMapClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.showOutletsViewControllers showOutlets];
}

-(IBAction)btnAddReviewClicked:(id)sender
{
    [self.view endEditing:YES];
    [self.view addSubview:reviewContainerView];
}

#pragma mark - Review POPUP
-(void)setupReviewPopup
{
    reviewContainerView.frame = CGRectMake(0, 0, [MySingleton sharedManager].screenWidth, [MySingleton sharedManager].screenHeight);
    innerContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    UIFont *lblWriteReviewFont, *lblBrandNameFont, *lblTapToAddStarFont, *btnTitleFont, *txtViewFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblWriteReviewFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblBrandNameFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblTapToAddStarFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        txtViewFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblWriteReviewFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblBrandNameFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        lblTapToAddStarFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        txtViewFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
    }
    else
    {
        lblWriteReviewFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblBrandNameFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblTapToAddStarFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        txtViewFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    
    // WHITE REVIW
    lblWriteTeview.font = lblWriteReviewFont;
    lblWriteTeview.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblWriteTeview.textAlignment = NSTextAlignmentCenter;
    
    // WHITE REVIW
    lblCompanyName.font = lblBrandNameFont;
    lblCompanyName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCompanyName.textAlignment = NSTextAlignmentCenter;
    
    // STAR VIEW
    starContainerView.maximumValue = 5;
    starContainerView.minimumValue = 0;
    starContainerView.value = 0;
    starContainerView.allowsHalfStars = NO;
    starContainerView.tintColor = [MySingleton sharedManager].themeGlobalBlueColor;
    [starContainerView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    // TAP TO ADD STAR
    lblTapToAddStar.font = lblTapToAddStarFont;
    lblTapToAddStar.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTapToAddStar.textAlignment = NSTextAlignmentCenter;
    
    bottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // TXTVIEW REVIEW
    txtViewReview.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    txtViewReview.font = txtViewFont;
    txtViewReview.delegate = self;
    txtViewReview.textColor = [MySingleton sharedManager].textfieldPlaceholderColor;
    txtViewReview.tintColor = [MySingleton sharedManager].textfieldTextColor;
    [txtViewReview setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    // BTN SUBMIT
    btnSubmit.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnSubmit.titleLabel.font = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    [btnSubmit setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = true;
    btnSubmit.layer.cornerRadius = 5;
    [btnSubmit addTarget:self action:@selector(btnSubmitReviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // BTN CANCEL
    btnCancel.backgroundColor = [UIColor clearColor];
    btnCancel.titleLabel.font = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    [btnCancel setTitleColor:[MySingleton sharedManager].themeGlobalDarkGreyColor forState:UIControlStateNormal];
    btnCancel.clipsToBounds = true;
    btnCancel.layer.cornerRadius = 5;
    [btnCancel addTarget:self action:@selector(btnCancelReviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // SET VALUES
    lblCompanyName.text = self.objMerchant.strCompanyName;
    txtViewReview.text = @"Write a Review here...";
    
    
    // SET VALUES
    for (int i = 0; i < self.objMerchant.arrayRatings.count; i++)
    {
        Rating *objRating = [self.objMerchant.arrayRatings objectAtIndex:i];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if([objRating.strUserID isEqualToString:[prefs objectForKey:@"userid"]])
        {
            starContainerView.value = [objRating.strRating floatValue];
            txtViewReview.text = objRating.strComment;
            txtViewReview.textColor = [MySingleton sharedManager].textfieldTextColor;
        }
    }
}

-(IBAction)didChangeValue:(id)sender
{
    
}

-(IBAction)btnSubmitReviewClicked:(id)sender
{
    if (starContainerView.value <= 0)
    {
        if (starContainerView.value <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please select star you want to give."];
            });
        }
    }
    else
    {
        // WEBSERVICE
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        [dictParameters setObject:self.objMerchant.strMerchantID forKey:@"merchant_id"];
        [dictParameters setObject:[NSString stringWithFormat:@"%f", starContainerView.value] forKey:@"rating"];
        if ([txtViewReview.text isEqualToString:@""] || [txtViewReview.text isEqualToString:@"Write a Review here..."])
        {
            [dictParameters setObject:@"" forKey:@"comment"];
        }
        else
        {
            [dictParameters setObject:txtViewReview.text forKey:@"comment"];
        }
        [dictParameters setObject:txtViewReview.text forKey:@"comment"];
        
        [[MySingleton sharedManager].dataManager user_submitRating:dictParameters];
    }
}

-(IBAction)btnCancelReviewClicked:(id)sender
{
    [reviewContainerView removeFromSuperview];
}

#pragma mark - UITextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == txtViewReview)
    {
        if ([textView.text isEqualToString:@"Write a Review here..."]) {
            textView.text = @"";
            textView.textColor = [MySingleton sharedManager].textfieldTextColor;
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView == txtViewReview)
    {
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Write a Review here...";
            textView.textColor = [MySingleton sharedManager].textfieldPlaceholderColor;
        }
    }
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError Called.");
    
    //    [locationManager startUpdatingLocation];
    
    self.strLatitude = @"0";
    self.strLongitude = @"0";
    
    [appDelegate dismissGlobalHUD];
    
    [MySingleton sharedManager].dataManager.boolIsLocationAvailable = false;
    
    // CALL WEBSERVICE
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:self.strLatitude forKey:@"latitude"];
    [dictParameters setObject:self.strLongitude forKey:@"longitude"];
    
    [dictParameters setObject:self.strMerchantID forKey:@"merchant_id"];
    
    [[MySingleton sharedManager].dataManager user_getMerchantDetails:dictParameters];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations Called.");
    
    currentLocation = [locations objectAtIndex:0];
    
    if (currentLocation != nil)
    {
        [MySingleton sharedManager].dataManager.boolIsLocationAvailable = true;
        
        self.strLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.strLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        [MySingleton sharedManager].dataManager.strUserLocationLatitude = self.strLatitude;
        [MySingleton sharedManager].dataManager.strUserLocationLongitude = self.strLongitude;
        
        [locationManager stopUpdatingLocation];
        
        // CALL WEBSERVICE
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:self.strLatitude forKey:@"latitude"];
        [dictParameters setObject:self.strLongitude forKey:@"longitude"];
        
        [dictParameters setObject:self.strMerchantID forKey:@"merchant_id"];
        
        [[MySingleton sharedManager].dataManager user_getMerchantDetails:dictParameters];
    }
    else
    {
        [appDelegate dismissGlobalHUD];
    }
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.objMerchant.arrayCoupons.count > 0)
    {
        mainTableView.userInteractionEnabled = true;
        
        return self.objMerchant.arrayCoupons.count;
    }
    else
    {
        mainTableView.userInteractionEnabled = false;
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.objMerchant.arrayCoupons.count > 0)
    {
        return 100;
    }
    else
    {
        return 270;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.objMerchant.arrayCoupons.count > 0)
    {
        Coupon *objCoupon = [self.objMerchant.arrayCoupons objectAtIndex:indexPath.row];
        
        OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[OfferTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.lblOfferNumber.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        
        cell.lblOfferTitle.text = objCoupon.strCouponTitle;
        
        cell.lblRedeemedCount.text = [NSString stringWithFormat:@"%@ Redeemed", objCoupon.strNumberOfRedeem];
        
        if ([objCoupon.strIsUsed integerValue] == 1)
        {
            cell.lblIsOfferUsed.hidden = false;
            cell.offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
            
            cell.imageViewStar.image = [UIImage imageNamed:@"star_grey.png"];
            cell.imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
            
            if ([objCoupon.strIsPinged integerValue] == 1)
            {
                cell.lblIsOfferUsed.text = @"PINGED";
                cell.lblIsOfferUsed.adjustsFontSizeToFitWidth = true;
            }
        }
        else
        {
            cell.lblIsOfferUsed.hidden = true;
            cell.offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
            
            if ([objCoupon.strIsStareed integerValue] == 1)
            {
                cell.btnStar.selected = true;
                cell.imageViewStar.image = [UIImage imageNamed:@"star_filled.png"];
            }
            else
            {
                cell.btnStar.selected = false;
                cell.imageViewStar.image = [UIImage imageNamed:@"star.png"];
            }
            
            cell.btnStar.tag = indexPath.row;
            [cell.btnStar addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
            //        cell.pingContainerView.hidden = true;
            if ([objCoupon.strIsPinged integerValue] == 1)
            {
                cell.lblIsOfferUsed.hidden = false;
                cell.offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
                
                cell.imageViewStar.image = [UIImage imageNamed:@"star_grey.png"];
                cell.imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
                
                if ([objCoupon.strIsPinged integerValue] == 1)
                {
                    cell.lblIsOfferUsed.text = @"PINGED";
                    cell.lblIsOfferUsed.adjustsFontSizeToFitWidth = true;
                }
            }
            else
            {
                cell.imageViewPing.image = [UIImage imageNamed:@"ping_selected.png"];
                cell.btnPing.tag = indexPath.row;
                [cell.btnPing addTarget:self action:@selector(btnPingClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *strUserPaymentId = [prefs objectForKey:@"userpaymentid"];
        if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"userpaymentid"]
            || strUserPaymentId == nil
            || [strUserPaymentId integerValue] == 0
            || [strUserPaymentId isEqualToString:@""])
        {
            //NOT PURCHASED
            cell.pingContainerView.hidden = true;
            cell.starContainerView.frame = CGRectMake(cell.starContainerView.frame.origin.x + 15, cell.starContainerView.frame.origin.y, cell.starContainerView.frame.size.width, cell.starContainerView.frame.size.height);
        }
        else
        {
            //PERCHASED
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.lblNoData.text = @"No offers found.";
        
        cell.btnAction.hidden = true;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(IBAction)btnStarClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    Coupon *objCoupon = [self.objMerchant.arrayCoupons objectAtIndex:btnSender.tag];
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    [dictParameters setObject:objCoupon.strCouponID forKey:@"coupon_id"];
    
    if (btnSender.selected == false)
    {
        btnSender.selected = true;
        [dictParameters setObject:@"1" forKey:@"is_favorite"];
    }
    else
    {
        btnSender.selected = false;
        [dictParameters setObject:@"0" forKey:@"is_favorite"];
    }
    
    // CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_addRemoveFromFavoriteOffers:dictParameters];
}

-(IBAction)btnPingClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    Coupon *objCoupon = [self.objMerchant.arrayCoupons objectAtIndex:btnSender.tag];
    
    User_PingOfferViewController *viewController = [[User_PingOfferViewController alloc] init];
    viewController.strCouponID = objCoupon.strCouponID;
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.objMerchant.arrayCoupons.count > 0)
    {
        Coupon *objCoupon = [self.objMerchant.arrayCoupons objectAtIndex:indexPath.row];
        
        [self.view endEditing:true];
        User_OfferDetailsViewController *viewController = [[User_OfferDetailsViewController alloc] init];
        viewController.strOfferNumber = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        viewController.objMerchant = self.objMerchant;
        viewController.objSelectedCoupon = objCoupon;
        [self.navigationController pushViewController:viewController animated:true];
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if ((UIScrollView *)sender == imageSliderScrollView)
    {
        //  Update the page when more than 50% of the previous/next page is visible
        CGFloat pageWidth = imageSliderScrollView.frame.size.width;
        int page = floor((imageSliderScrollView.contentOffset.x) / pageWidth);
        pageControlSliderImages.currentPage = page;
    }
}

#pragma mark - MENU IMAGES

- (void)handleSingleTapOnMenuImage:(UITapGestureRecognizer *)recognizer
{
    AsyncImageView *imageView = (AsyncImageView *)recognizer.view;
    
    NSLog(@"%ld",(long)imageView.tag);
    
    _photos = [[NSMutableArray alloc]init];
    
    MWPhoto *photo;
    
    for (int i = 0; i < self.objMerchant.arrayMenuPhotos.count; i++)
    {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:[self.objMerchant.arrayMenuPhotos objectAtIndex:i]]];
        [_photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:imageView.tag];
    
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MENU IMAGES

- (void)handleSingleTapOnPhotoImage:(UITapGestureRecognizer *)recognizer
{
    AsyncImageView *imageView = (AsyncImageView *)recognizer.view;
    
    NSLog(@"%ld",(long)imageView.tag);
    
    self.photos = [[NSMutableArray alloc]init];
    
    MWPhoto *photo;
    
    for (int i = 0; i < self.objMerchant.arrayInfrastructurePhotos.count; i++)
    {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:[self.objMerchant.arrayInfrastructurePhotos objectAtIndex:i]]];
        [self.photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:imageView.tag];
    
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
    return [self.photos objectAtIndex:index];
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
