//
//  User_ReferAndEarnViewController.m
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_ReferAndEarnViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_OfferamCoinsViewController.h"

@interface User_ReferAndEarnViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_ReferAndEarnViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize lblOfferamCoinsEarned;
@synthesize lblOfferamCoinsEarnedValue;
@synthesize btnLearnMoreAboutCoins;
@synthesize imageViewOfferamCoin;

@synthesize referContainerView;
@synthesize lblReferAFriend;

@synthesize qrCodeContainerView;
@synthesize imageViewQrCode;

@synthesize lblShareThisQrCode;
@synthesize lblQrCodeText;

@synthesize lblInviteFriendOnSocialMedia;

@synthesize socialMediaContainerView;
@synthesize imageViewSocialMedia;
@synthesize btnSocialMedia;

//========== OTHER VARIABLES ==========//

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
    
    UIFont *lblCoinesEarnedFont, *lblCoinValueFont, *lblReferFriendFont, *lblFont, *btnFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblCoinesEarnedFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        lblReferFriendFont = [MySingleton sharedManager].themeFontEighteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblCoinesEarnedFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
        lblReferFriendFont = [MySingleton sharedManager].themeFontNineteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblCoinesEarnedFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
        lblReferFriendFont = [MySingleton sharedManager].themeFontTwentySizeRegular;
        lblFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    lblOfferamCoinsEarned.font = lblCoinesEarnedFont;
    lblOfferamCoinsEarned.textAlignment = NSTextAlignmentLeft;
    lblOfferamCoinsEarned.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    lblOfferamCoinsEarnedValue.font = lblCoinValueFont;
    lblOfferamCoinsEarnedValue.textAlignment = NSTextAlignmentLeft;
    lblOfferamCoinsEarnedValue.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblOfferamCoinsEarnedValue.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strOfferamCoinsBalance;
    
    NSMutableAttributedString *btnLearnMoreAboutOfferamCoinsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Learn more About Offeram coins"]];
    [btnLearnMoreAboutOfferamCoinsString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnLearnMoreAboutOfferamCoinsString length])];
    [btnLearnMoreAboutOfferamCoinsString addAttribute:NSFontAttributeName value:lblCoinesEarnedFont range:NSMakeRange(0, [btnLearnMoreAboutOfferamCoinsString length])];
    [btnLearnMoreAboutOfferamCoinsString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlackColor range:NSMakeRange(0, [btnLearnMoreAboutOfferamCoinsString length])];
    [btnLearnMoreAboutCoins setAttributedTitle:btnLearnMoreAboutOfferamCoinsString forState:UIControlStateNormal];
    [btnLearnMoreAboutCoins addTarget:self action:@selector(btnLearnMoreAboutCoinsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewOfferamCoin.contentMode = UIViewContentModeScaleAspectFit;
    
    // REFER CONTAINER VIEW
    
    // border radius
    [referContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [referContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [referContainerView.layer setShadowOpacity:0.6];
    [referContainerView.layer setShadowRadius:3.0];
    [referContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    imageViewQrCode.image = [self generateQRcode:[MySingleton sharedManager].dataManager.objLoggedInUser.strReferralCode];
    
    lblShareThisQrCode.font = lblFont;
    lblShareThisQrCode.textAlignment = NSTextAlignmentCenter;
    lblShareThisQrCode.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblShareThisQrCode.text = [MySingleton sharedManager].dataManager.strReferAndEarnText;
    
    lblQrCodeText.font = btnFont;
    lblQrCodeText.textAlignment = NSTextAlignmentCenter;
    lblQrCodeText.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblQrCodeText.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strReferralCode;
    
    lblInviteFriendOnSocialMedia.font = lblFont;
    lblInviteFriendOnSocialMedia.textAlignment = NSTextAlignmentCenter;
    lblInviteFriendOnSocialMedia.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    
    
    btnSocialMedia.titleLabel.font = btnFont;
    btnSocialMedia.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    [btnSocialMedia setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSocialMedia addTarget:self action:@selector(btnSocialMediaClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // ADD TAP GESTER ON CARD NUMBER
    UITapGestureRecognizer *singleFingerTapOnsocialMediaContainerView =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnsocialMediaContainerView:)];
    [socialMediaContainerView addGestureRecognizer:singleFingerTapOnsocialMediaContainerView];
    
    socialMediaContainerView.userInteractionEnabled = true;
}

- (void)handleSingleTapOnsocialMediaContainerView:(UITapGestureRecognizer *)recognizer
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [MySingleton sharedManager].dataManager.objLoggedInUser.strReferralCode;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Referral code is copied.";
    hud.labelFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    
    hud.removeFromSuperViewOnHide = YES;
    hud.margin = 10.f;
    [hud hide:YES afterDelay:2];
}

-(IBAction)btnLearnMoreAboutCoinsClicked:(id)sender
{
    User_OfferamCoinsViewController *viewController = [[User_OfferamCoinsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnSocialMediaClicked:(id)sender
{
    NSString *textToShare = [NSString stringWithFormat:@"Woohoo!!! I am using Offeram and gonna save over ₹1,00,000+ Use my referral code - %@ to sign up and activate your subscription to Dil Kholke Discounts. Download now: Offeram.com/app", [MySingleton sharedManager].dataManager.objLoggedInUser.strReferralCode];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:textToShare, nil] applicationActivities:nil];
//    [activityVC setValue:[NSString stringWithFormat:@"%@", [MySingleton sharedManager].strInviteFriendsSubject] forKey:@"subject"];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
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

#pragma mark - Other Methods

-(UIImage *)generateQRcode:(NSString*)dataString
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    CGFloat scaleRate = imageViewQrCode.frame.size.width / image.size.width;
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:scaleRate];
    
    return resized;
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

@end
