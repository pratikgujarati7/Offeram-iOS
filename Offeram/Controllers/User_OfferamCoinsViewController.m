//
//  User_OfferamCoinsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_OfferamCoinsViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_FavouritesViewController.h"
#import "User_ReferAndEarnViewController.h"
#import "User_ShareCouponDescriptionViewController.h"

@interface User_OfferamCoinsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_OfferamCoinsViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize imageViewOfferamCoinBackground;
@synthesize imageViewOfferamCoin;
@synthesize lblOfferamCoinsEarned;
@synthesize lblOfferamCoinsEarnedValue;

@synthesize earnOfferamCoinsContainerView;
@synthesize lblHowToEarnCoins;
@synthesize lblHowToEarnCoinsAndwer;

//1
@synthesize oneContainerView;
@synthesize oneTitleContainerView;
@synthesize lblOneCount;
@synthesize lblOneTitle;
@synthesize lblOneEarning;
@synthesize lblOneDescription;

//2
@synthesize twoContainerView;
@synthesize twoTitleContainerView;
@synthesize lblTwoCount;
@synthesize lblTwoTitle;
@synthesize lblTwoEarning;
@synthesize lblTwoDescription;
@synthesize btnTwo;

//3
@synthesize threeContainerView;
@synthesize threeTitleContainerView;
@synthesize lblThreeCount;
@synthesize lblThreeTitle;
@synthesize lblThreeEarning;
@synthesize lblThreeDescription;
@synthesize btnThree;

//4
@synthesize fourContainerView;
@synthesize fourTitleContainerView;
@synthesize lblFourCount;
@synthesize lblFourTitle;
@synthesize lblFourEarning;
@synthesize lblFourDescription;
@synthesize btnFour;

@synthesize coinChartContainerView;
@synthesize lblCoinChart;
@synthesize lblCoinChartParams;
@synthesize lblCoinChartValues;

@synthesize useOfferamCoinsContainerView;
@synthesize lblHowToUseCoins;
@synthesize lblHowToUseCoinsAndwer;

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
    
    btnTwo.clipsToBounds = true;
    btnTwo.layer.cornerRadius = btnTwo.frame.size.height/2;
    
    btnThree.clipsToBounds = true;
    btnThree.layer.cornerRadius = btnTwo.frame.size.height/2;
    
    btnFour.clipsToBounds = true;
    btnFour.layer.cornerRadius = btnTwo.frame.size.height/2;
    
//    self.mainScrollView.autoresizesSubviews = false;
//
    lblHowToEarnCoins.autoresizingMask = true;
    lblHowToEarnCoinsAndwer.autoresizingMask = true;
    
//    [lblHowToEarnCoinsAndwer sizeToFit];
    
    CGRect earnOfferamCoinsContainerViewFrame = earnOfferamCoinsContainerView.frame;
    earnOfferamCoinsContainerViewFrame.origin.y = imageViewOfferamCoinBackground.frame.origin.y + imageViewOfferamCoinBackground.frame.size.height + 10;
//    earnOfferamCoinsContainerViewFrame.size.height = lblHowToEarnCoinsAndwer.frame.origin.y + lblHowToEarnCoinsAndwer.frame.size.height + 10;
    earnOfferamCoinsContainerView.frame = earnOfferamCoinsContainerViewFrame;
    
//    lblCoinChart.autoresizingMask = true;
//    lblCoinChartParams.autoresizingMask = true;
//    lblCoinChartValues.autoresizingMask = true;
//
//    [lblCoinChartParams sizeToFit];
//    [lblCoinChartValues sizeToFit];
//
//    CGRect coinChartContainerViewFrame = coinChartContainerView.frame;
//    coinChartContainerViewFrame.origin.y = earnOfferamCoinsContainerView.frame.origin.y + earnOfferamCoinsContainerView.frame.size.height + 10;
//    coinChartContainerViewFrame.size.height = lblCoinChartParams.frame.origin.y + lblCoinChartParams.frame.size.height + 10;
//    coinChartContainerView.frame = coinChartContainerViewFrame;
    
    coinChartContainerView.hidden = true;
    
    lblHowToUseCoins.autoresizingMask = true;
    lblHowToUseCoinsAndwer.autoresizingMask = true;
    
    [lblHowToUseCoinsAndwer sizeToFit];
    
    CGRect useOfferamCoinsContainerViewFrame = useOfferamCoinsContainerView.frame;
    useOfferamCoinsContainerViewFrame.origin.y = earnOfferamCoinsContainerView.frame.origin.y + earnOfferamCoinsContainerView.frame.size.height + 10;
    useOfferamCoinsContainerViewFrame.size.height = lblHowToUseCoinsAndwer.frame.origin.y + lblHowToUseCoinsAndwer.frame.size.height + 10;
    useOfferamCoinsContainerView.frame = useOfferamCoinsContainerViewFrame;
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, useOfferamCoinsContainerView.frame.origin.y + useOfferamCoinsContainerView.frame.size.height + 20);
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
    
    imageViewOfferamCoinBackground.contentMode = UIViewContentModeScaleToFill;
    imageViewOfferamCoin.contentMode = UIViewContentModeScaleAspectFit;
    
    lblOfferamCoinsEarned.font = lblValueFont;
    lblOfferamCoinsEarned.textAlignment = NSTextAlignmentLeft;
    lblOfferamCoinsEarned.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    lblOfferamCoinsEarnedValue.font = lblCoinValueFont;
    lblOfferamCoinsEarnedValue.textAlignment = NSTextAlignmentLeft;
    lblOfferamCoinsEarnedValue.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblOfferamCoinsEarnedValue.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strOfferamCoinsBalance;
    
    // border radius
    [imageViewOfferamCoinBackground.layer setCornerRadius:5.0f];
    // drop shadow
    [imageViewOfferamCoinBackground.layer setShadowColor:[UIColor blackColor].CGColor];
    [imageViewOfferamCoinBackground.layer setShadowOpacity:0.6];
    [imageViewOfferamCoinBackground.layer setShadowRadius:3.0];
    [imageViewOfferamCoinBackground.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // HOW TO EARN OFFERAM COINS
    lblHowToEarnCoins.font = lblTitleFont;
    lblHowToEarnCoins.textAlignment = NSTextAlignmentLeft;
    lblHowToEarnCoins.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    

    // HOW TO EARN OFFERAM COINS ANSWER
    lblHowToEarnCoinsAndwer.font = lblValueFont;
    lblHowToEarnCoinsAndwer.textAlignment = NSTextAlignmentLeft;
    lblHowToEarnCoinsAndwer.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    //1
    oneContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    oneContainerView.clipsToBounds = true;
    oneContainerView.layer.cornerRadius = 5.0f;
    oneTitleContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblOneCount.font = lblTitleFont;
    lblOneCount.textAlignment = NSTextAlignmentCenter;
    lblOneCount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblOneCount.backgroundColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    lblOneCount.clipsToBounds = true;
    lblOneCount.layer.cornerRadius = lblOneCount.frame.size.width/2;
    
    lblOneTitle.font = lblTitleFont;
    lblOneTitle.textAlignment = NSTextAlignmentLeft;
    lblOneTitle.textColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    
    lblOneEarning.font = lblValueFont;
    lblOneEarning.textAlignment = NSTextAlignmentRight;
    lblOneEarning.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblOneEarning.hidden = true;
    
    lblOneDescription.font = lblValueFont;
    lblOneDescription.textAlignment = NSTextAlignmentJustified;
    lblOneDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    //2
    twoContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    twoContainerView.clipsToBounds = true;
    twoContainerView.layer.cornerRadius = 5.0f;
    twoTitleContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblTwoCount.font = lblTitleFont;
    lblTwoCount.textAlignment = NSTextAlignmentCenter;
    lblTwoCount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTwoCount.backgroundColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    lblTwoCount.clipsToBounds = true;
    lblTwoCount.layer.cornerRadius = lblTwoCount.frame.size.width/2;
    
    lblTwoTitle.font = lblTitleFont;
    lblTwoTitle.textAlignment = NSTextAlignmentLeft;
    lblTwoTitle.textColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    
    lblTwoEarning.font = lblValueFont;
    lblTwoEarning.textAlignment = NSTextAlignmentRight;
    lblTwoEarning.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblTwoEarning.hidden = true;
    
    lblTwoDescription.font = lblValueFont;
    lblTwoDescription.textAlignment = NSTextAlignmentJustified;
    lblTwoDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    btnTwo.titleLabel.font = lblValueFont;
    btnTwo.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    [btnTwo setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnTwo addTarget:self action:@selector(btnTwoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //3
    threeContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    threeContainerView.clipsToBounds = true;
    threeContainerView.layer.cornerRadius = 5.0f;
    threeTitleContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblThreeCount.font = lblTitleFont;
    lblThreeCount.textAlignment = NSTextAlignmentCenter;
    lblThreeCount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblThreeCount.backgroundColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    lblThreeCount.clipsToBounds = true;
    lblThreeCount.layer.cornerRadius = lblThreeCount.frame.size.width/2;
    
    lblThreeTitle.font = lblTitleFont;
    lblThreeTitle.textAlignment = NSTextAlignmentLeft;
    lblThreeTitle.textColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    
    lblThreeEarning.font = lblValueFont;
    lblThreeEarning.textAlignment = NSTextAlignmentRight;
    lblThreeEarning.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblThreeEarning.hidden = true;
    
    lblThreeDescription.font = lblValueFont;
    lblThreeDescription.textAlignment = NSTextAlignmentJustified;
    lblThreeDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    btnThree.titleLabel.font = lblValueFont;
    btnThree.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    [btnThree setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnThree addTarget:self action:@selector(btnThreeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //4
    fourContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    fourContainerView.clipsToBounds = true;
    fourContainerView.layer.cornerRadius = 5.0f;
    fourTitleContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblFourCount.font = lblTitleFont;
    lblFourCount.textAlignment = NSTextAlignmentCenter;
    lblFourCount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblFourCount.backgroundColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    lblFourCount.clipsToBounds = true;
    lblFourCount.layer.cornerRadius = lblFourCount.frame.size.width/2;
    
    lblFourTitle.font = lblTitleFont;
    lblFourTitle.textAlignment = NSTextAlignmentLeft;
    lblFourTitle.textColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    
    lblFourEarning.font = lblValueFont;
    lblFourEarning.textAlignment = NSTextAlignmentRight;
    lblFourEarning.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblFourEarning.hidden = true;
    
    lblFourDescription.font = lblValueFont;
    lblFourDescription.textAlignment = NSTextAlignmentJustified;
    lblFourDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    btnFour.titleLabel.font = lblValueFont;
    btnFour.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    [btnFour setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnFour addTarget:self action:@selector(btnFourClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    // border radius
    [earnOfferamCoinsContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [earnOfferamCoinsContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [earnOfferamCoinsContainerView.layer setShadowOpacity:0.6];
    [earnOfferamCoinsContainerView.layer setShadowRadius:3.0];
    [earnOfferamCoinsContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // COIN CHART
    lblCoinChart.font = lblTitleFont;
    lblCoinChart.textAlignment = NSTextAlignmentLeft;
    lblCoinChart.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    lblCoinChartParams.font = lblValueFont;
    lblCoinChartParams.textAlignment = NSTextAlignmentLeft;
    lblCoinChartParams.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCoinChartParams.numberOfLines = 0;
    
    lblCoinChartParams.text = [NSString stringWithFormat:@"Add a review -\nAdd Exact Savings -\nAdd a Review -"];
    
    lblCoinChartValues.font = lblValueFont;
    lblCoinChartValues.textAlignment = NSTextAlignmentLeft;
    lblCoinChartValues.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCoinChartValues.numberOfLines = 0;
    
    lblCoinChartValues.text = [NSString stringWithFormat:@"50 coins\n20 coins\n50 coins"];
    
    // border radius
    [coinChartContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [coinChartContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [coinChartContainerView.layer setShadowOpacity:0.6];
    [coinChartContainerView.layer setShadowRadius:3.0];
    [coinChartContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    // HOW TO USE OFFERAM COINS
    lblHowToUseCoins.font = lblTitleFont;
    lblHowToUseCoins.textAlignment = NSTextAlignmentLeft;
    lblHowToUseCoins.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    lblHowToUseCoinsAndwer.font = lblValueFont;
    lblHowToUseCoinsAndwer.textAlignment = NSTextAlignmentJustified;
    lblHowToUseCoinsAndwer.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblHowToUseCoinsAndwer.numberOfLines = 0;
    lblHowToUseCoinsAndwer.text = [NSString stringWithFormat:@"Offeram coins can be used for:\n\n1) Reactivation of used offers\n\n2) Extension of Validity of their subscription (Coming Soon)\n\n3) Buying Offeram Gift Cards (Coming Soon)\n\n4) Converting to cash in their PayTM wallet (Coming Soon)"];
    
    // border radius
    [useOfferamCoinsContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [useOfferamCoinsContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [useOfferamCoinsContainerView.layer setShadowOpacity:0.6];
    [useOfferamCoinsContainerView.layer setShadowRadius:3.0];
    [useOfferamCoinsContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    lblOneDescription.text = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strOfferamCoinsLabel1Text];
    lblTwoDescription.text = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strOfferamCoinsLabel2Text];
    lblThreeDescription.text = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strOfferamCoinsLabel3Text];
    lblFourDescription.text = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strOfferamCoinsLabel4Text];
}

-(IBAction)btnTwoClicked:(id)sender
{
    User_ReferAndEarnViewController *viewController = [[User_ReferAndEarnViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnThreeClicked:(id)sender
{
    User_FavouritesViewController *viewController = [[User_FavouritesViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnFourClicked:(id)sender
{
    User_ShareCouponDescriptionViewController *viewController = [[User_ShareCouponDescriptionViewController alloc] init];
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
