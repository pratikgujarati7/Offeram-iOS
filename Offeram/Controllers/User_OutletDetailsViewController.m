//
//  User_OutletDetailsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_OutletDetailsViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

@interface User_OutletDetailsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_OutletDetailsViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize outletDetailsContainerView;
@synthesize outletDetailsShadowContainerView;
@synthesize companyLogoImage;
@synthesize lblComapnyName;
@synthesize lblRatings;
@synthesize lblLocation;
@synthesize lblAddress;
@synthesize lblAddressValue;
@synthesize lblTimings;

@synthesize openInGoogleMapContainerView;
@synthesize openInGoogleMapShadowContainerView;
@synthesize openInGoogleMapImage;
@synthesize lblopenInGoogleMap;
@synthesize btnOpenInGoogleMap;

//========== OTHER VARIABLES ==========//

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    
    [self setNavigationBar];
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
    
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_redeemedOfferEvent) name:@"user_redeemedOfferEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_redeemedOfferEvent
{
    
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblFont = [MySingleton sharedManager].themeFontTwentySizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
    }
    else
    {
        lblFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
    }
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.font = lblFont;
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
    lblNavigationTitle.text = self.objMerchant.strCompanyName;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:NO];
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
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.objSelectedOutlet.strLatitude floatValue]
                                                            longitude:[self.objSelectedOutlet.strLongitude floatValue]
                                                                 zoom:16];

    mapView.camera = camera;
    mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([self.objSelectedOutlet.strLatitude floatValue], [self.objSelectedOutlet.strLongitude floatValue]);
    marker.title = self.objMerchant.strCompanyName;
    marker.snippet = self.objSelectedOutlet.strAreaName;
    marker.map = mapView;
    
    UIFont *lblBrandNameFont, *lblFont, *lblOpenInMapFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblBrandNameFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
        lblFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        lblOpenInMapFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblBrandNameFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
        lblFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        lblOpenInMapFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
    }
    else
    {
        lblBrandNameFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblOpenInMapFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    // border radius
    [outletDetailsContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [outletDetailsContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [outletDetailsContainerView.layer setShadowOpacity:0.6];
    [outletDetailsContainerView.layer setShadowRadius:3.0];
    [outletDetailsContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.outletDetailsShadowContainerView.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
    // border radius
    [self.outletDetailsShadowContainerView.layer setCornerRadius:5.0f];
    self.outletDetailsShadowContainerView.clipsToBounds = true;
    
    companyLogoImage.contentMode = UIViewContentModeScaleAspectFill;
    
    lblComapnyName.font = lblBrandNameFont;
    lblComapnyName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblComapnyName.textAlignment = NSTextAlignmentLeft;
    
    lblRatings.font = lblFont;
    lblRatings.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblRatings.textAlignment = NSTextAlignmentCenter;
    lblRatings.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblRatings.clipsToBounds = true;
    lblRatings.layer.cornerRadius = 3;
    
    lblLocation.font = lblFont;
    lblLocation.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblLocation.textAlignment = NSTextAlignmentLeft;
    
    lblAddress.font = lblFont;
    lblAddress.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblAddress.textAlignment = NSTextAlignmentLeft;
    
    lblAddressValue.font = lblFont;
    lblAddressValue.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblAddressValue.textAlignment = NSTextAlignmentLeft;
    lblAddressValue.numberOfLines = 0;
    
    lblTimings.font = lblFont;
    lblTimings.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblTimings.textAlignment = NSTextAlignmentLeft;
    
    companyLogoImage.imageURL = [NSURL URLWithString:self.objMerchant.strCompanyLogoImageUrl];
    lblComapnyName.text = self.objMerchant.strCompanyName;
    lblRatings.text = self.objMerchant.strAverageRatings;
    lblLocation.text = [NSString stringWithFormat:@"%@", self.objSelectedOutlet.strAreaName];
    lblAddressValue.text = self.objSelectedOutlet.strAddress;
    lblTimings.text = [NSString stringWithFormat:@"TIMINGS: %@ - %@", self.objSelectedOutlet.strStartTime, self.objSelectedOutlet.strEndTime];
    
    // BUTTON OPEN IN MAP
    
    // border radius
    [openInGoogleMapContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [openInGoogleMapContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [openInGoogleMapContainerView.layer setShadowOpacity:0.6];
    [openInGoogleMapContainerView.layer setShadowRadius:3.0];
    [openInGoogleMapContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    self.outletDetailsShadowContainerView.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
    // border radius
    [self.outletDetailsShadowContainerView.layer setCornerRadius:5.0f];
    self.outletDetailsShadowContainerView.clipsToBounds = true;
    
    lblopenInGoogleMap.font = lblOpenInMapFont;
    lblopenInGoogleMap.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblopenInGoogleMap.textAlignment = NSTextAlignmentLeft;
    lblopenInGoogleMap.text = @"Open in Google Maps";
    
    openInGoogleMapImage.image = [UIImage imageNamed:@"right_arrow_grey.png"];
    openInGoogleMapImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnOpenInGoogleMap addTarget:self action:@selector(btnOpenInGoogleMapClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnOpenInGoogleMapClicked:(id)sender
{
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@,%@", mapView.myLocation.coordinate.latitude, mapView.myLocation.coordinate.longitude, self.objSelectedOutlet.strLatitude, self.objSelectedOutlet.strLongitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}

@end
