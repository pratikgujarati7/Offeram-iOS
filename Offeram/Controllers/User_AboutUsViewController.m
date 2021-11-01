//
//  User_AboutUsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 19/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_AboutUsViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

@interface User_AboutUsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_AboutUsViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize imageViewLogo;

@synthesize topSeparatorView;
@synthesize lblDescription;
@synthesize bottomSeparatorView;

@synthesize lblCompanyName;
@synthesize lblAddress;
@synthesize lblAddressValue;
@synthesize lblContact;
@synthesize lblEmail;

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
    
    [lblDescription sizeToFit];
    
    bottomSeparatorView.frame = CGRectMake(bottomSeparatorView.frame.origin.x, lblDescription.frame.origin.y + lblDescription.frame.size.height + 8, bottomSeparatorView.frame.size.width, bottomSeparatorView.frame.size.height);
    
    lblCompanyName.frame = CGRectMake(lblCompanyName.frame.origin.x, bottomSeparatorView.frame.origin.y + bottomSeparatorView.frame.size.height + 8, lblCompanyName.frame.size.width, lblCompanyName.frame.size.height);
    
    lblAddress.frame = CGRectMake(lblAddress.frame.origin.x, lblCompanyName.frame.origin.y + lblCompanyName.frame.size.height + 8, lblAddress.frame.size.width, lblAddress.frame.size.height);
    
    // OUTLET COUNT RESIZE
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, lblAddress.frame.size.height);
    CGSize expectedLabelSize = [lblAddress.text sizeWithFont:lblAddress.font constrainedToSize:maximumLabelSize lineBreakMode:lblAddress.lineBreakMode];
    //adjust the label the the new height.
    CGRect newFrame = lblAddress.frame;
    newFrame.size.width = expectedLabelSize.width + 10;
    lblAddress.frame = newFrame;
    
    lblAddressValue.frame = CGRectMake(lblAddress.frame.origin.x + lblAddress.frame.size.width, lblCompanyName.frame.origin.y + lblCompanyName.frame.size.height + 8, lblCompanyName.frame.size.width - lblAddress.frame.size.width + 5, lblAddressValue.frame.size.height);
    
    [lblAddressValue sizeToFit];
    
    lblContact.frame = CGRectMake(lblContact.frame.origin.x, lblAddressValue.frame.origin.y + lblAddressValue.frame.size.height + 8, lblContact.frame.size.width, lblContact.frame.size.height);
    
    lblEmail.frame = CGRectMake(lblEmail.frame.origin.x, lblContact.frame.origin.y + lblContact.frame.size.height + 8, lblEmail.frame.size.width, lblEmail.frame.size.height);
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    UIFont *lblDescriptionFont, *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
    }
    else
    {
        lblDescriptionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
    }
    
    // IMAGE VIEW LOGO
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFill;
    imageViewLogo.clipsToBounds = true;
    imageViewLogo.layer.cornerRadius = imageViewLogo.frame.size.width/2;
    imageViewLogo.layer.borderColor = [MySingleton sharedManager].themeGlobalLightGreyColor.CGColor;
    imageViewLogo.layer.borderWidth = 3.0f;
    
    topSeparatorView.backgroundColor = [MySingleton sharedManager]. textfieldBottomSeparatorColor;
    
    // DESCRIPTION
    lblDescription.font = lblDescriptionFont;
    lblDescription.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblDescription.textAlignment = NSTextAlignmentJustified;
    lblDescription.numberOfLines = 0;
    lblDescription.text = @"Offeram.com - Dil Kholke Discounts is a concept by MagnADism wherein we provide discount offers of various brands covering various segments like Food & Beverages, Health & Beauty, Shopping & Fashion, Automobile Services, Broadband Internet Services and many more to our customers via mobile app, discount coupon booklet and gift cards";
    
    bottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // COMPANY NAME
    lblCompanyName.font = lblFont;
    lblCompanyName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCompanyName.textAlignment = NSTextAlignmentLeft;
    lblCompanyName.numberOfLines = 1;
    lblCompanyName.text = @"Company Name : MagnADism";
    
    // Address
    lblAddress.font = lblFont;
    lblAddress.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblAddress.textAlignment = NSTextAlignmentLeft;
    lblAddress.numberOfLines = 1;
    lblAddress.text = @"Address :";
    
    // ADDRESS VALUE
    lblAddressValue.font = lblFont;
    lblAddressValue.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblAddressValue.textAlignment = NSTextAlignmentLeft;
    lblAddressValue.numberOfLines = 0;
    lblAddressValue.text = @"U/20, Amizara Complex, Above Klassic Restaurant, opp. Jilla Seva Sadan - 2, Athwalines, Surat - 395001";
    
    // CONTACT
    lblContact.font = lblFont;
    lblContact.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblContact.textAlignment = NSTextAlignmentLeft;
    lblContact.numberOfLines = 1;
    lblContact.text = @"Contact : +917055540333";
    
    // EMAIL
    lblEmail.font = lblFont;
    lblEmail.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblEmail.textAlignment = NSTextAlignmentLeft;
    lblEmail.numberOfLines = 1;
    lblEmail.text = @"Email : contact@offeram.com";
}

@end
