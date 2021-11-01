//
//  User_VerifyOtpViewController.m
//  Offeram
//
//  Created by Dipen Lad on 10/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_VerifyOtpViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"

@interface User_VerifyOtpViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
    
    NSTimer *resendOTPTimer;
    int seconds;
}
@end

@implementation User_VerifyOtpViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize logoBackgroundView;
@synthesize imageViewLogo;

@synthesize lblAlmostDone;
@synthesize imageviewDiscount;

@synthesize lblOtpVerificationTitle;
@synthesize lblOtpSent;

@synthesize otp1ContainerView;
@synthesize txtOtp1;
@synthesize otp2ContainerView;
@synthesize txtOtp2;
@synthesize otp3ContainerView;
@synthesize txtOtp3;
@synthesize otp4ContainerView;
@synthesize txtOtp4;

@synthesize btnResendOtp;

@synthesize btnVerify;

@synthesize backContainerView;
@synthesize imageViewBack;
@synthesize lblBack;
@synthesize btnBack;

@synthesize referralCodeContainerView;
@synthesize imageViewProfilePicture;
@synthesize txtUserName;
@synthesize txtUserNameBottomSeparatorView;

@synthesize btnHavePromoCode;
@synthesize txtReferralCode;
@synthesize txtReferralCodeBottomSeparatorView;
@synthesize btnSubmit;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    [self setupInitialView];
    [self setupReferralCodeView];
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
    
//    txtOtp1.userInteractionEnabled = true;
//    txtOtp2.userInteractionEnabled = false;
//    txtOtp3.userInteractionEnabled = false;
//    txtOtp4.userInteractionEnabled = false;
    [txtOtp1 becomeFirstResponder];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_resentOTPEvent) name:@"user_resentOTPEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_verifiedPhoneNumberEvent) name:@"user_verifiedPhoneNumberEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_updatedProfileDetailsEvent) name:@"user_updatedProfileDetailsEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_resentOTPEvent
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"OTP has been sent successfully on your phone number.";
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
        
        seconds = 60;
        
        resendOTPTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resendOTPTimerMethod:) userInfo:nil repeats:YES];
        
        btnResendOtp.userInteractionEnabled = false;
        [btnResendOtp setTitleColor:[MySingleton sharedManager].themeGlobalLightGreyColor forState:UIControlStateNormal];
        [btnResendOtp setTitle:@"resend OTP in 01:00 secs" forState:UIControlStateNormal];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
}

-(void)user_verifiedPhoneNumberEvent
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"You have successfully verified your phone number.";
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
        
        if ([MySingleton sharedManager].dataManager.isFreshUser == true)
        {
            [self.view addSubview:referralCodeContainerView];
        }
        else
        {
//            User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
            User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:true];
        }
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
}

-(void)user_updatedProfileDetailsEvent
{
//    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
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
    
    UIFont *lblAlmostDoneFont, *txtFieldFont, *btnFont, *lblTitleFont, *lblDescriptionFont, *btnSignUpFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblAlmostDoneFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentySizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontEighteenSizeRegular;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        btnSignUpFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblAlmostDoneFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyOneSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontNineteenSizeRegular;
        lblDescriptionFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        btnSignUpFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
    }
    else
    {
        lblAlmostDoneFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyTwoSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontTwentySizeRegular;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        btnSignUpFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    
    logoBackgroundView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    lblAlmostDone.font = lblAlmostDoneFont;
    lblAlmostDone.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblAlmostDone.textAlignment = NSTextAlignmentCenter;
    
    imageviewDiscount.contentMode = UIViewContentModeScaleAspectFit;
    
    lblOtpVerificationTitle.font = lblTitleFont;
    lblOtpVerificationTitle.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblOtpVerificationTitle.textAlignment = NSTextAlignmentCenter;
    
    lblOtpSent.font = lblDescriptionFont;
    lblOtpSent.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblOtpSent.textAlignment = NSTextAlignmentCenter;
    lblOtpSent.text = [NSString stringWithFormat:@"OTP has been sent to mobile number\n%@", self.strPhoneNumber];
    
    // TXT OTP 1
    otp1ContainerView.layer.masksToBounds = true;
    otp1ContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    
    txtOtp1.font = txtFieldFont;
    txtOtp1.delegate = self;
    txtOtp1.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"_"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtOtp1.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtOtp1.tintColor = [MySingleton sharedManager].textfieldTintColor;
    [txtOtp1 setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtOtp1.keyboardType = UIKeyboardTypeNumberPad;
    
    // TXT OTP 2
    otp2ContainerView.layer.masksToBounds = true;
    otp2ContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    
    txtOtp2.font = txtFieldFont;
    txtOtp2.delegate = self;
    txtOtp2.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"_"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtOtp2.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtOtp2.tintColor = [MySingleton sharedManager].textfieldTintColor;
    [txtOtp2 setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtOtp2.keyboardType = UIKeyboardTypeNumberPad;
    
    // TXT OTP 3
    otp3ContainerView.layer.masksToBounds = true;
    otp3ContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    
    txtOtp3.font = txtFieldFont;
    txtOtp3.delegate = self;
    txtOtp3.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"_"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtOtp3.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtOtp3.tintColor = [MySingleton sharedManager].textfieldTintColor;
    [txtOtp3 setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtOtp3.keyboardType = UIKeyboardTypeNumberPad;
    
    // TXT OTP 4
    otp4ContainerView.layer.masksToBounds = true;
    otp4ContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    
    txtOtp4.font = txtFieldFont;
    txtOtp4.delegate = self;
    txtOtp4.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"_"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtOtp4.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtOtp4.tintColor = [MySingleton sharedManager].textfieldTintColor;
    [txtOtp4 setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtOtp4.keyboardType = UIKeyboardTypeNumberPad;
    
    // RESEND OTP
    btnResendOtp.titleLabel.font = lblDescriptionFont;
    [btnResendOtp setTitleColor:[MySingleton sharedManager].themeGlobalLightGreyColor forState:UIControlStateNormal];
    [btnResendOtp setTitle:@"resend OTP in 01:00 secs" forState:UIControlStateNormal];
    [btnResendOtp addTarget:self action:@selector(btnResendOtpClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnResendOtp.userInteractionEnabled = false;
    
    seconds = 60;
    
    resendOTPTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resendOTPTimerMethod:) userInfo:nil repeats:YES];
    
    // BTN VERIFY
    btnVerify.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnVerify.titleLabel.font = btnFont;
    [btnVerify setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnVerify.clipsToBounds = true;
    btnVerify.layer.cornerRadius = 5;
    [btnVerify addTarget:self action:@selector(btnVerifyClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // BTN BACK
    imageViewBack.layer.masksToBounds = true;
    imageViewBack.contentMode = UIViewContentModeScaleAspectFit;
    
    lblBack.font = lblDescriptionFont;
    lblBack.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblBack.textAlignment = NSTextAlignmentLeft;

    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // TXT CHANEG
    [txtOtp1 addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [txtOtp2 addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [txtOtp3 addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [txtOtp4 addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
}

- (void)setupReferralCodeView
{
    UIFont *txtFieldFont, *btnFont, *lblTitleFont, *lblDescriptionFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentySizeMedium;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyOneSizeMedium;
        lblDescriptionFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        lblDescriptionFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
    }
    else
    {
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyTwoSizeMedium;
        lblDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblDescriptionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    
//    lblEnterReferralCode.font = lblTitleFont;
//    lblEnterReferralCode.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
//    lblEnterReferralCode.textAlignment = NSTextAlignmentCenter;
//
//    lblReferralCodeDescription.font = lblDescriptionFont;
//    lblReferralCodeDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
//    lblReferralCodeDescription.textAlignment = NSTextAlignmentCenter;
    
    // TXT REFERRAL CODE
//    imageViewMobile.layer.masksToBounds = true;
//    imageViewMobile.contentMode = UIViewContentModeScaleAspectFit;
    
    // BTN HAVE PROMOCODE
    btnHavePromoCode.backgroundColor = UIColor.clearColor;
    btnHavePromoCode.titleLabel.font = lblDescriptionFont;
    [btnHavePromoCode setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnHavePromoCode addTarget:self action:@selector(btnHavePromoCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // PROFILE PICTURE
    // border radius
    [imageViewProfilePicture.layer setCornerRadius:imageViewProfilePicture.frame.size.height/2];
    imageViewProfilePicture.clipsToBounds = true;
    imageViewProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
    imageViewProfilePicture.userInteractionEnabled = true;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnProfileImage:)];
    [imageViewProfilePicture addGestureRecognizer:singleFingerTap];
    
    // TXT USER NAME
    txtUserName.font = txtFieldFont;
    txtUserName.delegate = self;
    txtUserName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"User Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtUserName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtUserName.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtUserName.floatingLabelFont = txtFieldFont;
    txtUserName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtUserName.keepBaseline = NO;
    [txtUserName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtUserNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // TXT REFERRALCODE
    txtReferralCode.font = txtFieldFont;
    txtReferralCode.delegate = self;
    txtReferralCode.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Referral Code"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtReferralCode.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtReferralCode.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtReferralCode.floatingLabelFont = txtFieldFont;
    txtReferralCode.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtReferralCode.keepBaseline = NO;
    [txtReferralCode setAutocorrectionType:UITextAutocorrectionTypeNo];
//    txtReferralCode.keyboardType = UIKeyboardTypeNumberPad;
    
    txtReferralCodeBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    txtReferralCode.hidden = true;
    txtReferralCodeBottomSeparatorView.hidden = true;
    
    // BTN SUBMIT
    btnSubmit.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnSubmit.titleLabel.font = btnFont;
    [btnSubmit setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = true;
    btnSubmit.layer.cornerRadius = 5;
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)resendOTPTimerMethod:(NSTimer *)timer
{
    seconds--;
    
    if(seconds == 0)
    {
        NSLog(@"60 Seconds done.");
        [resendOTPTimer invalidate];
        btnResendOtp.userInteractionEnabled = true;
        [btnResendOtp setTitleColor:[MySingleton sharedManager].themeGlobalBlueColor forState:UIControlStateNormal];
        [btnResendOtp setTitle:@"You can now resend OTP" forState:UIControlStateNormal];
    }
    else
    {
        [btnResendOtp setTitleColor:[MySingleton sharedManager].themeGlobalLightGreyColor forState:UIControlStateNormal];
        if (seconds > 9)
        {
            [btnResendOtp setTitle:[NSString stringWithFormat:@"resend OTP in 00:%d", seconds] forState:UIControlStateNormal];
        }
        else
        {
            [btnResendOtp setTitle:[NSString stringWithFormat:@"resend OTP in 00:0%d", seconds] forState:UIControlStateNormal];
        }
    }
}

-(IBAction)btnResendOtpClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSLog(@"%@ === %@", self.strPhoneNumber, self.strDeviceToken);
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strUserId = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"userid"]];
    [dictParameters setObject:strUserId forKey:@"user_id"];
    [dictParameters setObject:[prefs objectForKey:@"userphonenumber"] forKey:@"phone_number"];
    [dictParameters setObject:[prefs objectForKey:@"selected_city_id"] forKey:@"city_id"];
    NSString *strDeviceToken = [prefs objectForKey:@"device_id"];
    if(strDeviceToken.length > 0)
    {
        [dictParameters setObject:[prefs objectForKey:@"device_id"] forKey:@"device_id"];
    }
    else
    {
        [dictParameters setObject:@"" forKey:@"device_id"];
    }
    
    
    [[MySingleton sharedManager].dataManager user_resendOTP:dictParameters];
}

-(IBAction)btnVerifyClicked:(id)sender
{
    if (txtOtp1.text.length > 0 && txtOtp2.text.length > 0 && txtOtp3.text.length > 0 && txtOtp4.text.length > 0)
    {
        NSString *strEnteredOTP = [NSString stringWithFormat:@"%@%@%@%@", txtOtp1.text, txtOtp2.text, txtOtp3.text, txtOtp4.text];
        NSLog(@"OTP:%@",strEnteredOTP);
        
//        if([strEnteredOTP isEqualToString:[MySingleton sharedManager].dataManager.strOTP])
//        {
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *strUserId = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"userid"]];
            [dictParameters setObject:strUserId forKey:@"user_id"];
            [dictParameters setObject:strEnteredOTP forKey:@"otp"];
            
            [[MySingleton sharedManager].dataManager user_verifyPhoneNumber:dictParameters];
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [appDelegate showAlertViewWithTitle:nil withDetails:@"Verification code does not match. Please enter correct verification code"];
//            });
//        }
    }
    else
    {
        // INVALID OTP
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter valid OTP"];
        });
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

-(IBAction)btnHavePromoCodeClicked:(id)sender
{
    txtReferralCode.hidden = false;
    txtReferralCodeBottomSeparatorView.hidden = false;
    
    CGRect btnSubmitFrame = btnSubmit.frame;
    btnSubmitFrame.origin.y = txtReferralCodeBottomSeparatorView.frame.origin.y + 20;
    btnSubmit.frame = btnSubmitFrame;
}

-(IBAction)btnSubmitClicked:(id)sender
{
    if (txtUserName.text.length <= 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter user name."];
        });
    }
    else
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:txtUserName.text forKey:@"user_name"];
        [dictParameters setObject:txtReferralCode.text forKey:@"referral_code"];
        
        if (self.isImageChanged == true)
        {
            [dictParameters setObject:@"1" forKey:@"is_image_uploaded"];
            [dictParameters setObject:self.imageSelectedPictureData forKey:@"profile_image"];
        }
        else
        {
            [dictParameters setObject:@"0" forKey:@"is_image_uploaded"];
        }
        
        [[MySingleton sharedManager].dataManager user_updateProfileDetails:dictParameters];
    }
    
}

#pragma mark - MENU IMAGES

- (void)handleSingleTapOnProfileImage:(UITapGestureRecognizer *)recognizer
{
    [self showActionsheetForImagePicker];
}

#pragma mark - UIImagePickerController Delegate Method

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try
    {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        
        UIImage* smaller = [self imageWithImage:image scaledToWidth:320];
        
        self.imageSelectedPicture = smaller;
        self.imageSelectedPictureData = UIImagePNGRepresentation(smaller);
        
        imageViewProfilePicture.image = smaller;
        
        self.isImageChanged = true;
        
        UIGraphicsEndImageContext();
        
        [picker dismissViewControllerAnimated:NO completion:NULL];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in imagePickerController's didFinishPickingMediaWithInfo Method, %@",exception);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Custom Methods

-(void)showActionsheetForImagePicker
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Take a Photo
        [self dismissViewControllerAnimated:YES completion:nil];
        [self takeAPhoto];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Choose from Gallery
        [self dismissViewControllerAnimated:YES completion:nil];
        [self chooseFromGallery];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
}

-(void)takeAPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
        }
        else
        {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable" message:@"Unable to find a camera on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

-(void)chooseFromGallery
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
        }
        else
        {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Photo library Unavailable" message:@"Unable to find photo library on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
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

-(IBAction)textFieldDidChange:(id)sender
{
    UITextField *txtSender = (UITextField *)sender;
    
    if (txtSender == txtOtp1)
    {
        if(txtOtp1.text.length > 0)
        {
            [txtOtp2 becomeFirstResponder];
        }
    }
    if (txtSender == txtOtp2)
    {
        if(txtOtp2.text.length > 0)
        {
            [txtOtp3 becomeFirstResponder];
        }
    }
    if (txtSender == txtOtp3)
    {
        if(txtOtp3.text.length > 0)
        {
            [txtOtp4 becomeFirstResponder];
        }
    }
    if (txtSender == txtOtp4)
    {
        if(txtOtp4.text.length > 0)
        {
            [txtOtp4 resignFirstResponder];
        }
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (textField == txtOtp1 || textField == txtOtp2 || textField == txtOtp3 || textField == txtOtp4)
    {
        NSLog(@"%@::%@",textField.text, string);
        if(textField.text.length > 0)
        {
            textField.text = @"";
            
        }
    }
    
    return YES;
}

@end
