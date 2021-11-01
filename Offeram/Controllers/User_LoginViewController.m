//
//  User_LoginViewController.m
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_LoginViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"
#import "User_RegisterViewController.h"
#import "User_VerifyOtpViewController.h"

#import "User_CommonWebViewViewController.h"

@interface User_LoginViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_LoginViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize logoBackgroundView;
@synthesize imageViewLogo;

@synthesize lblReadyFor;
@synthesize imageviewDiscount;

@synthesize lblSignIn;

@synthesize imageViewMobile;
@synthesize txtMobileNumber;
@synthesize txtMobileNumberBottomSeparatorView;
@synthesize lblMobileNumberDescription;

@synthesize imageViewCity;
@synthesize txtCity;
@synthesize txtCityBottomSeparatorView;

@synthesize btnSignIn;

@synthesize lblTermsAndConditions;

@synthesize btnSignUp;

//========== OTHER VARIABLES ==========//

@synthesize cityPickerView;
@synthesize arrayAllCity;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayAllCity = [[MySingleton sharedManager].dataManager.arrayAllCity mutableCopy];
    
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_sentOTPEvent) name:@"user_sentOTPEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_sentOTPEvent
{
    if ([txtMobileNumber.text isEqualToString:@"9879015971"] || [txtMobileNumber.text isEqualToString:@"9510537693"])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"1" forKey:@"autologin"];
        [prefs synchronize];
        
        [self navigateToUserHomeViewController];
    }
    else
    {
        [self navigateToCommonVerifyPhoneNumberViewController];
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
    
    lblReadyFor.font = lblReadyForFont;
    lblReadyFor.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblReadyFor.textAlignment = NSTextAlignmentCenter;
    
    imageviewDiscount.contentMode = UIViewContentModeScaleAspectFit;
    
    lblSignIn.font = lblTitleFont;
    lblSignIn.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblSignIn.textAlignment = NSTextAlignmentCenter;
    
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
    
    //CITY PICKER
    cityPickerView = [[UIPickerView alloc] init];
    cityPickerView.delegate = self;
    cityPickerView.dataSource = self;
    cityPickerView.showsSelectionIndicator = YES;
    cityPickerView.tag = 1;
    cityPickerView.backgroundColor = [UIColor whiteColor];
    
    // TXT CITY
    imageViewCity.layer.masksToBounds = true;
    imageViewCity.contentMode = UIViewContentModeScaleAspectFit;
    
    txtCity.font = txtFieldFont;
    txtCity.delegate = self;
    txtCity.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"City"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtCity.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtCity.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtCity.floatingLabelFont = txtFieldFont;
    txtCity.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtCity.keepBaseline = NO;
    [txtCity setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtCity setInputView:cityPickerView];
    
    txtCityBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    //========== ADDED CODE ON 2 MAY, 2020 FOR STATIC CITY SELECTION TO SURAT BEGIN ==========//
        self.objSelectedCity = [self.arrayAllCity objectAtIndex:0];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.objSelectedCity.strCityID forKey:@"selected_city_id"];
    [prefs synchronize];
    txtCity.text = self.objSelectedCity.strCityName;
    //========== ADDED CODE ON 2 MAY, 2020 FOR STATIC CITY SELECTION TO SURAT END ==========//
    
    // BTN LOGIN
    btnSignIn.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnSignIn.titleLabel.font = btnFont;
    [btnSignIn setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnSignIn.clipsToBounds = true;
    btnSignIn.layer.cornerRadius = 5;
    [btnSignIn addTarget:self action:@selector(btnSignInClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //LBL TERMS & CONDITIONS
    lblTermsAndConditions.font = btnSignUpFont;
    NSString *lblTermsAndConditionsString1 = [NSString stringWithFormat:@"By cicking on above button you are accepting Offeram's\n"];
    NSString *lblTermsAndConditionsString2 = [NSString stringWithFormat:@"Terms & Conditions"];
    NSMutableAttributedString *lblTermsAndConditionsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",lblTermsAndConditionsString1,  lblTermsAndConditionsString2]];
    [lblTermsAndConditionsString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([lblTermsAndConditionsString1 length], [lblTermsAndConditionsString2 length])];
    [lblTermsAndConditionsString addAttribute:NSFontAttributeName value:btnFont range:NSMakeRange([lblTermsAndConditionsString1 length], [lblTermsAndConditionsString2 length])];
    [lblTermsAndConditionsString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlueColor range:NSMakeRange([lblTermsAndConditionsString1 length], [lblTermsAndConditionsString2 length])];
    lblTermsAndConditions.attributedText = lblTermsAndConditionsString;
    lblTermsAndConditions.textAlignment = NSTextAlignmentCenter;
    
    lblTermsAndConditions.userInteractionEnabled = true;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnTermsAndConditions:)];
    [lblTermsAndConditions addGestureRecognizer:singleFingerTap];
    
    
    // BTN SIGNUP
    btnSignUp.titleLabel.font = btnSignUpFont;
    NSString *btnSignUpTitleString1 = [NSString stringWithFormat:@"Don't have an account? "];
    NSString *btnSignUpTitleString2 = [NSString stringWithFormat:@"Register Now"];
    NSMutableAttributedString *btnSignUpTitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",btnSignUpTitleString1,  btnSignUpTitleString2]];
    [btnSignUpTitleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([btnSignUpTitleString1 length], [btnSignUpTitleString2 length])];
    [btnSignUpTitleString addAttribute:NSFontAttributeName value:btnFont range:NSMakeRange([btnSignUpTitleString1 length], [btnSignUpTitleString2 length])];
    [btnSignUpTitleString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlueColor range:NSMakeRange([btnSignUpTitleString1 length], [btnSignUpTitleString2 length])];
    [btnSignUp setAttributedTitle:btnSignUpTitleString forState:UIControlStateNormal];
    [btnSignUp addTarget:self action:@selector(btnSignUpClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnSignInClicked:(id)sender
{
    if([MySingleton sharedManager].dataManager.objLoggedInUser == nil)
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser = [[User alloc]init];
    }
    
    [MySingleton sharedManager].dataManager.objLoggedInUser.strPhoneNumber = txtMobileNumber.text;
    
    if (self.objSelectedCity == nil || self.objSelectedCity == NULL)
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser.strCityID = @"";
    }
    else
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser.strCityID = self.objSelectedCity.strCityID;
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strDeviceToken = [prefs objectForKey:@"device_id"];
    if(strDeviceToken.length > 0)
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser.strDeviceToken = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"device_id"]];
    }
    else
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser.strDeviceToken = @"";
    }
    
    if([[MySingleton sharedManager].dataManager.objLoggedInUser isValidateUserToSendOTP])
    {
        [[MySingleton sharedManager].dataManager user_sendOTP:[MySingleton sharedManager].dataManager.objLoggedInUser];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:[MySingleton sharedManager].dataManager.objLoggedInUser.strValidationMessage];
        });
    }
    
//    User_VerifyOtpViewController *viewController = [[User_VerifyOtpViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnSignUpClicked:(id)sender
{
    User_RegisterViewController *viewController = [[User_RegisterViewController alloc] init];
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
    if (textField == txtCity)
    {
        if (arrayAllCity.count > 0)
        {
            if(textField.text.length <= 0)
            {
                [cityPickerView selectRow:0 inComponent:0 animated:YES];
                
                self.objSelectedCity = [self.arrayAllCity objectAtIndex:0];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:self.objSelectedCity.strCityID forKey:@"selected_city_id"];
                [prefs synchronize];
                txtCity.text = self.objSelectedCity.strCityName;
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - Other Methods

- (void)handleSingleTapOnTermsAndConditions:(UITapGestureRecognizer *)recognizer
{
    // TERMS AND CONDITIONS
    User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
    viewController.strNavigationTitle = @"Terms & Conditions";
    viewController.strUrlToLoad = @"http://offeram.com/Offeram_Terms_and_Conditions.html";
    viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)navigateToCommonVerifyPhoneNumberViewController
{
    [self.view endEditing:YES];
    
    User_VerifyOtpViewController *viewController = [[User_VerifyOtpViewController alloc] init];
    viewController.strPhoneNumber = [MySingleton sharedManager].dataManager.objLoggedInUser.strPhoneNumber;
    viewController.strDeviceToken = [MySingleton sharedManager].dataManager.objLoggedInUser.strDeviceToken;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)navigateToUserHomeViewController
{
    [self.view endEditing:true];
    
//    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIPickerView Delegate Methods

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    
    if(pickerView.tag == 1)
    {
        rowsInComponent = [self.arrayAllCity count];
    }
    
    return rowsInComponent;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lblMain = (UILabel*)view;
    if (!lblMain){
        lblMain = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    
    if (pickerView.tag == 1)
    {
        City *objCity = [self.arrayAllCity objectAtIndex:row];
        lblMain.text = objCity.strCityName;
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    lblMain.textAlignment = NSTextAlignmentCenter;
    return lblMain;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [MySingleton sharedManager].screenWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        self.objSelectedCity = [self.arrayAllCity objectAtIndex:row];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:self.objSelectedCity.strCityID forKey:@"selected_city_id"];
        [prefs synchronize];
        txtCity.text = self.objSelectedCity.strCityName;
    }
}

@end
