//
//  User_RegisterViewController.m
//  Offeram
//
//  Created by Dipen Lad on 10/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_RegisterViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_LoginViewController.h"
#import "User_VerifyOtpViewController.h"

@interface User_RegisterViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_RegisterViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize logoBackgroundView;
@synthesize imageViewLogo;

@synthesize lblCreateAccount;

@synthesize imageViewFullName;
@synthesize txtFullName;
@synthesize txtFullNameBottomSeparatorView;

@synthesize imageViewMobile;
@synthesize txtMobileNumber;
@synthesize txtMobileNumberBottomSeparatorView;
@synthesize lblMobileNumberDescription;

@synthesize btnRegister;

@synthesize lblTermsAndConditions;

@synthesize btnSignIn;

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
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
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_getAllCountriesEvent) name:@"user_getAllCountriesEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    UIFont *lblReadyForFont, *txtFieldFont, *btnFont, *lblTitleFont, *lblDescriptionFont, *btnSignUpFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblReadyForFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentySizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        btnSignUpFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblReadyForFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyOneSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblDescriptionFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        btnSignUpFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
    }
    else
    {
        lblReadyForFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyTwoSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        btnSignUpFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    
    logoBackgroundView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    lblCreateAccount.font = lblTitleFont;
    lblCreateAccount.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblCreateAccount.textAlignment = NSTextAlignmentCenter;
    
    // TXT FULL NAME
    imageViewFullName.layer.masksToBounds = true;
    imageViewFullName.contentMode = UIViewContentModeScaleAspectFit;
    
    txtFullName.font = txtFieldFont;
    txtFullName.delegate = self;
    txtFullName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Full Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtFullName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtFullName.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtFullName.floatingLabelFont = txtFieldFont;
    txtFullName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtFullName.keepBaseline = NO;
    [txtFullName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtMobileNumberBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // TXT MOBILE NUMBER
    imageViewMobile.layer.masksToBounds = true;
    imageViewMobile.contentMode = UIViewContentModeScaleAspectFit;
    
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
    txtMobileNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    txtMobileNumberBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    lblMobileNumberDescription.font = lblDescriptionFont;
    lblMobileNumberDescription.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
    lblMobileNumberDescription.textAlignment = NSTextAlignmentLeft;
    
    // BTN LOGIN
    btnRegister.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnRegister.titleLabel.font = btnFont;
    [btnRegister setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnRegister.clipsToBounds = true;
    btnRegister.layer.cornerRadius = 5;
    [btnRegister addTarget:self action:@selector(btnRegisterClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //LBL TERMS & CONDITIONS
    lblTermsAndConditions.font = btnSignUpFont;
    NSString *lblTermsAndConditionsString1 = [NSString stringWithFormat:@"By clicking continue you are accepting to Offeram's\n"];
    NSString *lblTermsAndConditionsString2 = [NSString stringWithFormat:@"Terms & Conditions"];
    NSMutableAttributedString *lblTermsAndConditionsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",lblTermsAndConditionsString1,  lblTermsAndConditionsString2]];
    [lblTermsAndConditionsString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([lblTermsAndConditionsString1 length], [lblTermsAndConditionsString2 length])];
    [lblTermsAndConditionsString addAttribute:NSFontAttributeName value:btnFont range:NSMakeRange([lblTermsAndConditionsString1 length], [lblTermsAndConditionsString2 length])];
    [lblTermsAndConditionsString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlueColor range:NSMakeRange([lblTermsAndConditionsString1 length], [lblTermsAndConditionsString2 length])];
    lblTermsAndConditions.attributedText = lblTermsAndConditionsString;
    lblTermsAndConditions.textAlignment = NSTextAlignmentCenter;
    
    
    // BTN SIGNIN
    btnSignIn.titleLabel.font = btnSignUpFont;
    NSString *btnSignInTitleString1 = [NSString stringWithFormat:@"Already have an account? "];
    NSString *btnSignInTitleString2 = [NSString stringWithFormat:@"Sign In"];
    NSMutableAttributedString *btnSignInTitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",btnSignInTitleString1,  btnSignInTitleString2]];
    [btnSignInTitleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([btnSignInTitleString1 length], [btnSignInTitleString2 length])];
    [btnSignInTitleString addAttribute:NSFontAttributeName value:btnFont range:NSMakeRange([btnSignInTitleString1 length], [btnSignInTitleString2 length])];
    [btnSignInTitleString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlueColor range:NSMakeRange([btnSignInTitleString1 length], [btnSignInTitleString2 length])];
    [btnSignIn setAttributedTitle:btnSignInTitleString forState:UIControlStateNormal];
    [btnSignIn addTarget:self action:@selector(btnSignInClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnRegisterClicked:(id)sender
{
    User_VerifyOtpViewController *viewController = [[User_VerifyOtpViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnSignInClicked:(id)sender
{
    User_LoginViewController *viewController = [[User_LoginViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
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
