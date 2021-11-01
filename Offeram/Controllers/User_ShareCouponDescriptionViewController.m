//
//  User_ShareCouponDescriptionViewController.m
//  Offeram
//
//  Created by Dipen Lad on 19/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_ShareCouponDescriptionViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"

@interface User_ShareCouponDescriptionViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_ShareCouponDescriptionViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize imageViewPingBanner;
@synthesize lblHowToPingBanner;

@synthesize useHowToPingContainerView;
@synthesize lblHowToPingAndwer;

@synthesize whyToPingContainerView;
@synthesize whyToPingTitleContainerView;
@synthesize imageViewPing;
@synthesize lblWhyToPing;
@synthesize lblWhyToPingAndwer;

@synthesize lblStartPing;

@synthesize btnPingNow;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

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
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, btnPingNow.frame.origin.y + btnPingNow.frame.size.height + 10);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_appliedPromoCodeEvent) name:@"user_appliedPromoCodeEvent" object:nil];
        
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_appliedPromoCodeEvent
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
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UIFont *lblTitleFont, *lblValueFont, *lblCoinValueFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        lblValueFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentySizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSeventeenSizeMedium;
        lblValueFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontEighteenSizeMedium;
        lblValueFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
    }

    // HOW TO PING
    lblHowToPingBanner.font = lblValueFont;
    lblHowToPingBanner.textAlignment = NSTextAlignmentJustified;
    lblHowToPingBanner.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    lblHowToPingAndwer.font = lblValueFont;
    lblHowToPingAndwer.textAlignment = NSTextAlignmentJustified;
    lblHowToPingAndwer.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblHowToPingAndwer.numberOfLines = 0;
    
    // border radius
    [useHowToPingContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [useHowToPingContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [useHowToPingContainerView.layer setShadowOpacity:0.6];
    [useHowToPingContainerView.layer setShadowRadius:3.0];
    [useHowToPingContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // WHY TO PING
    whyToPingContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    whyToPingContainerView.clipsToBounds = true;
    whyToPingContainerView.layer.cornerRadius = 5.0f;
    whyToPingTitleContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblWhyToPing.font = lblTitleFont;
    lblWhyToPing.textAlignment = NSTextAlignmentLeft;
    lblWhyToPing.textColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    
    lblWhyToPingAndwer.font = lblValueFont;
    lblWhyToPingAndwer.textAlignment = NSTextAlignmentJustified;
    lblWhyToPingAndwer.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblWhyToPingAndwer.numberOfLines = 0;
    
    lblStartPing.font = lblTitleFont;
    lblStartPing.textAlignment = NSTextAlignmentCenter;
    lblStartPing.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    btnPingNow.titleLabel.font = lblTitleFont;
    btnPingNow.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    [btnPingNow setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnPingNow.clipsToBounds = true;
    btnPingNow.layer.cornerRadius = 5;
    [btnPingNow addTarget:self action:@selector(btnPingNowClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnPingNowClicked:(id)sender
{
    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

@end
