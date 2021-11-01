//
//  User_OfferDetailsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 18/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_OfferDetailsViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_RedeemOfferViewController.h"
#import "User_OutletDetailsViewController.h"
#import "User_BuyNowViewController.h"
#import "User_PingOfferViewController.h"

@interface User_OfferDetailsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_OfferDetailsViewController

//========== IBOUTLETS ==========//

@synthesize navigationContainerView;
@synthesize lblBrandName;
@synthesize imageViewBack;
@synthesize btnBack;

@synthesize mainScrollView;

@synthesize imageSliderScrollView;
@synthesize pageControlSliderImages;

@synthesize lblOutlets;
@synthesize tagsContainerView;

@synthesize lblValidTill;

// OFFER CONTAINER
@synthesize offerMainContainer;
@synthesize offerInnerContainer;

@synthesize offerNumberContainerView;
@synthesize lblOfferNumber;
@synthesize lblIsOfferUsed;

@synthesize lblOfferTitle;

@synthesize starContainerView;
@synthesize imageViewStar;
@synthesize lblStar;
@synthesize btnStar;

@synthesize pingContainerView;
@synthesize imageViewPing;
@synthesize lblPing;
@synthesize btnPing;

@synthesize lblRedeemedCount;

@synthesize btnBuyNow;

//TERMS AND CONDITIONS
@synthesize termsAndConditionsContainerView;
@synthesize lblTermsAndConditions;

@synthesize btnRedeemThisOffer;

//========== OTHER VARIABLES ==========//

@synthesize tagCollectionView;

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strUserPaymentId = [prefs objectForKey:@"userpaymentid"];
    if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"userpaymentid"]
        || strUserPaymentId == nil
        || [strUserPaymentId integerValue] == 0
        || [strUserPaymentId isEqualToString:@""])
    {
        CGRect frame = mainScrollView.frame;
        frame.size.height = frame.size.height + btnRedeemThisOffer.frame.size.height;
        mainScrollView.frame = frame;
        
    }
    
    [self getOffersListSuccessEvent];
    //    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_addedRemovedFromFavoriteOffersEvent) name:@"user_addedRemovedFromFavoriteOffersEvent" object:nil];
        
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

-(void)user_addedRemovedFromFavoriteOffersEvent
{
    if (btnStar.selected == false)
    {
        btnStar.selected = true;
        imageViewStar.image = [UIImage imageNamed:@"star_filled.png"];
    }
    else
    {
        btnStar.selected = false;
        imageViewStar.image = [UIImage imageNamed:@"star.png"];
    }
}

-(void)getOffersListSuccessEvent
{
    imageSliderScrollView.delegate = self;
    imageSliderScrollView.pagingEnabled = true;
    
    // IMAGE SCROLL
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
    
    // TAG COLLECTION VIEW
    tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, tagsContainerView.frame.size.width, tagsContainerView.frame.size.height)];
    tagCollectionView.alignment = TTGTagCollectionAlignmentCenter;
    tagCollectionView.backgroundColor = [UIColor clearColor];
    tagCollectionView.defaultConfig.tagTextFont = [MySingleton sharedManager].themeFontTwelveSizeMedium;
    
    tagCollectionView.defaultConfig.tagTextColor = [MySingleton sharedManager].themeGlobalBlueColor;
    tagCollectionView.defaultConfig.tagSelectedTextColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    tagCollectionView.defaultConfig.tagBackgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    tagCollectionView.defaultConfig.tagSelectedBackgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    tagCollectionView.defaultConfig.tagBorderColor = [MySingleton sharedManager].themeGlobalBlueColor;
    tagCollectionView.defaultConfig.tagSelectedTextColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    tagCollectionView.enableTagSelection = true;
    
    [tagsContainerView addSubview:tagCollectionView];
    
    UIView *tagTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tagsContainerView.frame.size.width, tagsContainerView.frame.size.height)];
    tagTagView.backgroundColor = [UIColor clearColor];
    [tagsContainerView addSubview:tagTagView];
    
    tagTagView.userInteractionEnabled = true;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOntagsContainerView:)];
    [tagTagView addGestureRecognizer:singleFingerTap];
    
    NSMutableArray *arrayOutlets = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.objSelectedCoupon.arrayOutlets.count; i++)
    {
        Outlet *objOutlet = [self.objSelectedCoupon.arrayOutlets objectAtIndex:i];
        [arrayOutlets addObject:objOutlet.strAreaName];
    }
    
    [tagCollectionView addTags:arrayOutlets];
    
    // BRAND NAME
    lblBrandName.text = self.objMerchant.strCompanyName;
    
    // VALID TILL
    lblValidTill.text = [NSString stringWithFormat:@"Valud Till: %@", self.objSelectedCoupon.strEndDate];
    
    //OFFER CELL
    lblOfferNumber.text = self.strOfferNumber;
    lblOfferTitle.text = self.objSelectedCoupon.strCouponTitle;
    lblRedeemedCount.text = [NSString stringWithFormat:@"%@ Redeemed",self.objSelectedCoupon.strNumberOfRedeem];
    
    if([self.objSelectedCoupon.strIsUsed integerValue] == 1)
    {
        lblIsOfferUsed.hidden = false;
        offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        imageViewStar.image = [UIImage imageNamed:@"star_grey.png"];
        imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
        
        if ([self.objSelectedCoupon.strIsPinged integerValue] == 1)
        {
            lblIsOfferUsed.text = @"PINGED";
            lblIsOfferUsed.adjustsFontSizeToFitWidth = true;
        }
    }
    else
    {
        lblIsOfferUsed.hidden = true;
        offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        
        if([self.objSelectedCoupon.strIsStareed integerValue] == 1)
        {
            btnStar.selected = true;
            imageViewStar.image = [UIImage imageNamed:@"star_filled.png"];
        }
        else
        {
            btnStar.selected = false;
            imageViewStar.image = [UIImage imageNamed:@"star.png"];
        }
        [btnStar addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if([self.objSelectedCoupon.strIsPinged integerValue] == 1)
        {
            lblIsOfferUsed.hidden = false;
            offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
            imageViewStar.image = [UIImage imageNamed:@"star_grey.png"];
            imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
            
            if ([self.objSelectedCoupon.strIsPinged integerValue] == 1)
            {
                lblIsOfferUsed.text = @"PINGED";
                lblIsOfferUsed.adjustsFontSizeToFitWidth = true;
            }
        }
        else
        {
            imageViewPing.image = [UIImage imageNamed:@"ping_selected.png"];
            [btnPing addTarget:self action:@selector(btnPingClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strUserPaymentId = [prefs objectForKey:@"userpaymentid"];
    if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"userpaymentid"]
        || strUserPaymentId == nil
        || [strUserPaymentId integerValue] == 0
        || [strUserPaymentId isEqualToString:@""])
    {
        imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
        pingContainerView.hidden = true;
        
        //TEMP ADJUSTMENTS
        starContainerView.frame = CGRectMake(starContainerView.frame.origin.x + 15, starContainerView.frame.origin.y, starContainerView.frame.size.width, starContainerView.frame.size.height);
    }
    else
    {
        
    }
    
    if (self.isPingedOffer == true)
    {
        imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
        pingContainerView.hidden = true;
        
        //TEMP ADJUSTMENTS
        starContainerView.frame = CGRectMake(starContainerView.frame.origin.x + 15, starContainerView.frame.origin.y, starContainerView.frame.size.width, starContainerView.frame.size.height);
    }
    
    // TERMS AND CONDITIONS
    
    NSAttributedString * attrStrDescription = [[NSAttributedString alloc] initWithData:[self.objSelectedCoupon.strTermsAndConditions dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    lblTermsAndConditions.attributedText = attrStrDescription;
    lblTermsAndConditions.numberOfLines = 0; //will wrap text in new line
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblFont = [MySingleton sharedManager].themeFontTenSizeMedium;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblFont = [MySingleton sharedManager].themeFontElevenSizeMedium;
    }
    else
    {
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeMedium;
    }
    
    lblTermsAndConditions.font = lblFont;
    lblTermsAndConditions.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTermsAndConditions.textAlignment = NSTextAlignmentJustified;
    
    [lblTermsAndConditions sizeToFit];
    
    termsAndConditionsContainerView.frame = CGRectMake(termsAndConditionsContainerView.frame.origin.x, termsAndConditionsContainerView.frame.origin.y, termsAndConditionsContainerView.frame.size.width, lblTermsAndConditions.frame.origin.y + lblTermsAndConditions.frame.size.height + 10);
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width ,termsAndConditionsContainerView.frame.origin.y + termsAndConditionsContainerView.frame.size.height + 10)];
    
    
    // BTN PROCEED
    if ([self.objSelectedCoupon.strIsUsed integerValue] == 1)
    {
        imageViewPing.image = [UIImage imageNamed:@"ping_normal.png"];
        pingContainerView.hidden = true;
        
        //TEMP ADJUSTMENTS
        starContainerView.frame = CGRectMake(starContainerView.frame.origin.x + 15, starContainerView.frame.origin.y, starContainerView.frame.size.width, starContainerView.frame.size.height);
        
        btnRedeemThisOffer.backgroundColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        
        if ([self.objSelectedCoupon.strIsPinged integerValue] == 1)
        {
            lblIsOfferUsed.text = @"PINGED";
            lblIsOfferUsed.adjustsFontSizeToFitWidth = true;
        }
    }
    else
    {
        if ([self.objSelectedCoupon.strIsPinged integerValue] == 1)
        {
            btnRedeemThisOffer.backgroundColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        }
        else
        {
            btnRedeemThisOffer.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        }
        
    }
    
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
}

- (void)handleSingleTapOntagsContainerView:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    [self.showOutletsViewControllers showOutlets];
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
    
    UIFont *lblBrandNameFont, *lblOutletsFont, *lblValidityFont, *btnTitleFont, *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblBrandNameFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblOutletsFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        lblValidityFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblFont = [MySingleton sharedManager].themeFontTenSizeMedium;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblBrandNameFont = [MySingleton sharedManager].themeFontNineteenSizeBold;
        lblOutletsFont = [MySingleton sharedManager].themeFontSeventeenSizeRegular;
        lblValidityFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        lblFont = [MySingleton sharedManager].themeFontElevenSizeMedium;
    }
    else
    {
        lblBrandNameFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        lblOutletsFont = [MySingleton sharedManager].themeFontEighteenSizeRegular;
        lblValidityFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnTitleFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeMedium;
    }
    
    // BACK
    navigationContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalTransperentBlackBackgroundColor;
    imageViewBack.contentMode = UIViewContentModeScaleAspectFit;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // BRAND NAME
    lblBrandName.font = lblBrandNameFont;
    lblBrandName.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblBrandName.textAlignment = NSTextAlignmentCenter;
    
    // OUTLETS
    lblOutlets.font = lblOutletsFont;
    lblOutlets.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblOutlets.textAlignment = NSTextAlignmentCenter;
    lblOutlets.text = @"Outlets";
    
    // VALIDITY
    lblValidTill.font = lblValidityFont;
    lblValidTill.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblValidTill.textAlignment = NSTextAlignmentCenter;
    
    // OFFER CELL DESIGN
    // border radius
    [offerMainContainer.layer setCornerRadius:5.0f];
    // drop shadow
    [offerMainContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [offerMainContainer.layer setShadowOpacity:0.6];
    [offerMainContainer.layer setShadowRadius:3.0];
    [offerMainContainer.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // INNER CONTAINER
    offerInnerContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
    // border radius
    [offerInnerContainer.layer setCornerRadius:5.0f];
    offerInnerContainer.clipsToBounds = true;
    
    // OFFER NUMBER CONTAINER
    self.offerNumberContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblOfferNumber.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    lblOfferNumber.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblOfferNumber.numberOfLines = 1;
    lblOfferNumber.textAlignment = NSTextAlignmentCenter;
    
    lblIsOfferUsed.font = [MySingleton sharedManager].themeFontTenSizeBold;
    lblIsOfferUsed.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblIsOfferUsed.numberOfLines = 1;
    lblIsOfferUsed.textAlignment = NSTextAlignmentCenter;
    lblIsOfferUsed.text = @"USED";
    
    // OFFER TITLE
    lblOfferTitle.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblOfferTitle.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    lblOfferTitle.textAlignment = NSTextAlignmentJustified;
    lblOfferTitle.numberOfLines = 0;
    
    lblRedeemedCount.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblRedeemedCount.font = [MySingleton sharedManager].themeFontTenSizeRegular;
    lblRedeemedCount.textAlignment = NSTextAlignmentLeft;
    
    // START CONTAINER
    imageViewStar.contentMode = UIViewContentModeScaleAspectFit;
    
    lblStar.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblStar.font = [MySingleton sharedManager].themeFontEightSizeRegular;
    lblStar.textAlignment = NSTextAlignmentCenter;
    lblStar.text = @"Star";
    [btnStar setTitle:@"" forState:UIControlStateNormal];
    btnStar.tintColor = [UIColor clearColor];
    [btnStar addTarget:self action:@selector(btnStarClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // PING CONTAINER
    imageViewPing.contentMode = UIViewContentModeScaleAspectFit;
    
    lblPing.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblPing.font = [MySingleton sharedManager].themeFontEightSizeRegular;
    lblPing.textAlignment = NSTextAlignmentCenter;
    lblPing.text = @"Ping";
    [btnPing setTitle:@"" forState:UIControlStateNormal];
    btnPing.tintColor = [UIColor clearColor];
    [btnPing addTarget:self action:@selector(btnPingClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // TERMS AND CNDITIONS
    // border radius
    [termsAndConditionsContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [termsAndConditionsContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [termsAndConditionsContainerView.layer setShadowOpacity:0.6];
    [termsAndConditionsContainerView.layer setShadowRadius:3.0];
    [termsAndConditionsContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // VALIDITY
    lblTermsAndConditions.font = lblFont;
    lblTermsAndConditions.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTermsAndConditions.textAlignment = NSTextAlignmentJustified;
    
    // BTN REDEEM THIS OFFER
    btnRedeemThisOffer.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnRedeemThisOffer.titleLabel.font = btnTitleFont;
    [btnRedeemThisOffer setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnRedeemThisOffer.clipsToBounds = true;
    [btnRedeemThisOffer addTarget:self action:@selector(btnRedeemThisOfferClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
        btnRedeemThisOffer.hidden = true;
    }
    else
    {
        btnBuyNow.hidden = true;
        btnRedeemThisOffer.hidden = false;
    }
}

-(IBAction)btnBuyNowClicked:(id)sender
{
    User_BuyNowViewController *viewController = [[User_BuyNowViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)btnStarClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    [dictParameters setObject:self.objSelectedCoupon.strCouponID forKey:@"coupon_id"];
    
    if (btnSender.selected == false)
    {
        [dictParameters setObject:@"1" forKey:@"is_favorite"];
    }
    else
    {
        [dictParameters setObject:@"0" forKey:@"is_favorite"];
    }
    
    // CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_addRemoveFromFavoriteOffers:dictParameters];
}

-(IBAction)btnPingClicked:(id)sender
{
    User_PingOfferViewController *viewController = [[User_PingOfferViewController alloc] init];
    viewController.strCouponID = self.objSelectedCoupon.strCouponID;
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnRedeemThisOfferClicked:(id)sender
{
    // BTN PROCEED
    if ([self.objSelectedCoupon.strIsUsed integerValue] == 1)
    {
        if ([self.objSelectedCoupon.strIsPinged integerValue] == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"You have already pinged this coupon earlier."];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"You have already redeemed this coupon earlier."];
            });
        }
    }
    else if ([self.objSelectedCoupon.strIsPinged integerValue] == 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"You have already pinged this coupon earlier."];
        });
    }
    else
    {
        User_RedeemOfferViewController *viewController = [[User_RedeemOfferViewController alloc] init];
        viewController.objSelectedCoupon = self.objSelectedCoupon;
        viewController.isPingedOffer = self.isPingedOffer;
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

@end
