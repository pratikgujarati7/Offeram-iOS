//
//  User_RedeemOfferSuccessViewController.m
//  Offeram
//
//  Created by Dipen Lad on 05/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_RedeemOfferSuccessViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"

@interface User_RedeemOfferSuccessViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_RedeemOfferSuccessViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize imageViewSuccess;

@synthesize lblTitle;
@synthesize lblDescription;

@synthesize btnOk;

@synthesize rateUsContainerView;
@synthesize rateUsInnerContainerView;

@synthesize lblRateUsTitle;
@synthesize lblRateUSDescription;

@synthesize checkboxContainerView;
@synthesize imageViewCheckbox;
@synthesize lblNeverShowAgain;
@synthesize btnCheckbox;

@synthesize btnRateNow;
@synthesize btnRateLater;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    
    [self setupInitialView];
    [self setupRateUsView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundEvent) name:@"applicationWillEnterForegroundEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)applicationWillEnterForegroundEvent
{
    if (self.boolIsRateViewOpened == true)
    {
        User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:true];
    }
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
    
    UIFont *lblDescriptionFont, *btnFont, *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    imageViewSuccess.contentMode = UIViewContentModeScaleAspectFit;
    
    lblTitle.font = lblTitleFont;
    lblTitle.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    
    lblDescription.font = lblDescriptionFont;
    lblDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblDescription.textAlignment = NSTextAlignmentCenter;
    
    // BTN PROCEED
    btnOk.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnOk.titleLabel.font = btnFont;
    [btnOk setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnOk.clipsToBounds = true;
    [btnOk addTarget:self action:@selector(btnOkClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnOkClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs valueForKey:@"app_rating_done"] != nil)
    {
        User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:true];
    }
    else
    {
        [self.view addSubview:rateUsContainerView];
    }
    
}

-(void)setupRateUsView
{
    rateUsContainerView.backgroundColor= [MySingleton sharedManager].themeGlobalTransperentBlackBackgroundColor;
    
    UIFont *lblDescriptionFont, *btnFont, *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontSeventeenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    lblRateUsTitle.font = lblTitleFont;
    lblRateUsTitle.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblRateUsTitle.textAlignment = NSTextAlignmentLeft;
    
    lblRateUSDescription.font = lblDescriptionFont;
    lblRateUSDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblRateUSDescription.textAlignment = NSTextAlignmentLeft;
    
    //CHECK BOX
    imageViewCheckbox.contentMode = UIViewContentModeScaleAspectFit;
    imageViewCheckbox.image = [UIImage imageNamed:@"checkbox_normal.png"];
    
    lblNeverShowAgain.font = lblDescriptionFont;
    lblNeverShowAgain.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblNeverShowAgain.textAlignment = NSTextAlignmentLeft;
    
    [btnCheckbox addTarget:self action:@selector(btnCheckboxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // BTN RATE NOW
    btnRateNow.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnRateNow.titleLabel.font = btnFont;
    [btnRateNow setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnRateNow.clipsToBounds = true;
    btnRateNow.layer.cornerRadius = 5;
    [btnRateNow addTarget:self action:@selector(btnRateNowClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // BTN RATE LATER
    btnRateLater.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnRateLater.titleLabel.font = btnFont;
    [btnRateLater setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnRateLater.clipsToBounds = true;
    btnRateLater.layer.cornerRadius = 5;
    [btnRateLater addTarget:self action:@selector(btnRateLaterClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(IBAction)btnCheckboxClicked:(id)sender
{
    if (btnCheckbox.selected == false)
    {
        btnCheckbox.selected = true;
        imageViewCheckbox.image = [UIImage imageNamed:@"checkbox_selected.png"];
    }
    else
    {
        btnCheckbox.selected = false;
        imageViewCheckbox.image = [UIImage imageNamed:@"checkbox_normal.png"];
    }
}

-(IBAction)btnRateNowClicked:(id)sender
{
    NSURL *appStoreUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"https://itunes.apple.com/app/id1313764616?mt=8&action=write-review"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:appStoreUrl]) {
        self.boolIsRateViewOpened = true;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"1" forKey:@"app_rating_done"];
        [prefs synchronize];
        [[UIApplication sharedApplication] openURL:appStoreUrl];
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Rating facility is not available!!!"];
        });
    }
}

-(IBAction)btnRateLaterClicked:(id)sender
{
    if (btnCheckbox.selected == true)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"1" forKey:@"app_rating_done"];
        [prefs synchronize];
    }
    
    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

@end
