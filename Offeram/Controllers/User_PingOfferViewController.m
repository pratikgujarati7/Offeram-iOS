//
//  User_PingOfferViewController.m
//  Offeram
//
//  Created by Dipen Lad on 16/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_PingOfferViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"

@interface User_PingOfferViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_PingOfferViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize mobileNumberContainerView;
@synthesize lblPingOfferDescription;
@synthesize txtMobileNumber;
@synthesize txtMobileNumberBottomSeparatorView;
@synthesize btnPing;

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
    
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_pingOfferEvent) name:@"user_pingOfferEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_pingOfferEvent
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"Offer has been pinged successfully.";
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
        User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:false];
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
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
    
    UIFont *txtFieldFont, *btnFont, *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    lblPingOfferDescription.font = lblTitleFont;
    lblPingOfferDescription.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblPingOfferDescription.textAlignment = NSTextAlignmentLeft;
    
    // TXT MOBILE NUMBER
    txtMobileNumber.font = txtFieldFont;
    txtMobileNumber.delegate = self;
    txtMobileNumber.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Mobile Number"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtMobileNumber.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtMobileNumber.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtMobileNumber.floatingLabelFont = txtFieldFont;
    txtMobileNumber.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMobileNumber.keepBaseline = NO;
    [txtMobileNumber setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtMobileNumber.keyboardType = UIKeyboardTypePhonePad;
    
    txtMobileNumberBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // BTN PING
    btnPing.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnPing.titleLabel.font = btnFont;
    [btnPing setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnPing.clipsToBounds = true;
    [btnPing addTarget:self action:@selector(btnPingClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnPingClicked:(id)sender
{
    if (txtMobileNumber.text.length <= 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter mobile number."];
        });
    }
    else
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        [dictParameters setObject:self.strCouponID forKey:@"coupon_id"];
        [dictParameters setObject:txtMobileNumber.text forKey:@"mobile_number"];
        
        // CALL WEBSERVICE
        [[MySingleton sharedManager].dataManager user_pingOffer:dictParameters];
    }
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
