//
//  Common_IntroductionViewController.m
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "Common_IntroductionViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_LoginViewController.h"
#import "User_RegisterViewController.h"

@interface Common_IntroductionViewController ()
{
    AppDelegate *appDelegate;
        
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation Common_IntroductionViewController

//========== IBOUTLETS ==========//
@synthesize mainScrollView;

@synthesize btnSkip;
@synthesize btnNext;
@synthesize pageControlCount;

// PAGE 1
@synthesize page1ContainerView;
@synthesize imageViewPage1Background;
@synthesize imageViewPage1Logo;

// PAGE 2
@synthesize page2ContainerView;
@synthesize imageViewPage2Background;
@synthesize imageViewPage2Logo;
@synthesize lblPage2Title;
@synthesize lblPage2Description;

// PAGE 3
@synthesize page3ContainerView;
@synthesize imageViewPage3Background;
@synthesize imageViewPage3Logo;
@synthesize lblPage3Title;
@synthesize lblPage3Description;

// PAGE 4
@synthesize page4ContainerView;
@synthesize imageViewPage4Background;
@synthesize imageViewPage4Logo;
@synthesize lblPage4Title;
@synthesize lblPage4Description;

// PAGE 5
@synthesize page5ContainerView;
@synthesize imageViewPage5Background;
@synthesize imageViewPage5Logo;
@synthesize lblPage5Title;
@synthesize lblPage5Description;

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
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
    [[IQKeyboardManager sharedManager] setEnable:false];
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
    
    page1ContainerView.frame = CGRectMake(0* [MySingleton sharedManager].screenWidth, 0 ,self.view.frame.size.width, self.view.frame.size.height);
    page2ContainerView.frame = CGRectMake(1* [MySingleton sharedManager].screenWidth, 0 ,self.view.frame.size.width, self.view.frame.size.height);
    page3ContainerView.frame = CGRectMake(2* [MySingleton sharedManager].screenWidth, 0 ,self.view.frame.size.width, self.view.frame.size.height);
    page4ContainerView.frame = CGRectMake(3* [MySingleton sharedManager].screenWidth, 0 ,self.view.frame.size.width, self.view.frame.size.height);
    page5ContainerView.frame = CGRectMake(4* [MySingleton sharedManager].screenWidth, 0 ,self.view.frame.size.width, self.view.frame.size.height);
    
    [mainScrollView addSubview:page1ContainerView];
    [mainScrollView addSubview:page2ContainerView];
    [mainScrollView addSubview:page3ContainerView];
    [mainScrollView addSubview:page4ContainerView];
    [mainScrollView addSubview:page5ContainerView];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width*5, mainScrollView.frame.size.height)];
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
    
    UIFont *btnFont, *lblTitleFont, *lblDescriptionFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentySizeMedium;
        lblDescriptionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyOneSizeMedium;
        lblDescriptionFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
    }
    else
    {
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblTitleFont = [MySingleton sharedManager].themeFontTwentyTwoSizeMedium;
        lblDescriptionFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    btnSkip.backgroundColor = [UIColor clearColor];//[MySingleton sharedManager].themeGlobalLightGreenColor;
    btnSkip.titleLabel.font = btnFont;
    [btnSkip setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(btnSkipClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btnNext.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnNext.titleLabel.font = btnFont;
    [btnNext setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnNext.clipsToBounds = true;
    btnNext.layer.cornerRadius = 5;
    [btnNext addTarget:self action:@selector(btnNextClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // SCROLL AND PAGINATION SETTINGS
    mainScrollView.tag = 1;
    mainScrollView.pagingEnabled = YES;
    mainScrollView.delegate = self;
    
    
    [pageControlCount setTag:12];
    pageControlCount.numberOfPages=5;
    pageControlCount.pageIndicatorTintColor = [MySingleton sharedManager].pageIndicatorTintColor;
    pageControlCount.currentPageIndicatorTintColor = [MySingleton sharedManager].currentPageIndicatorTintColorPage1;
    
    
    // PAGE 2
    lblPage2Title.font = lblTitleFont;
    lblPage2Title.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblPage2Description.font = lblDescriptionFont;
    lblPage2Description.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    // PAGE 3
    lblPage3Title.font = lblTitleFont;
    lblPage3Title.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblPage3Description.font = lblDescriptionFont;
    lblPage3Description.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    // PAGE 4
    lblPage4Title.font = lblTitleFont;
    lblPage4Title.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblPage4Description.font = lblDescriptionFont;
    lblPage4Description.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    // PAGE 5
    lblPage5Title.font = lblTitleFont;
    lblPage5Title.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblPage5Description.font = lblDescriptionFont;
    lblPage5Description.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
}

-(IBAction)btnSkipClicked:(id)sender
{
    // NAVIGATE TO REGISTER
    NSLog(@"NAVIGATE TO LOGIN");
    User_LoginViewController *viewController = [[User_LoginViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnNextClicked:(id)sender
{
    if (pageControlCount.currentPage < 4)
    {
        [mainScrollView scrollRectToVisible:CGRectMake((pageControlCount.currentPage + 1) * [MySingleton sharedManager].screenWidth, 0, [MySingleton sharedManager].screenWidth, [MySingleton sharedManager].screenHeight) animated:YES];
    }
    else
    {
        // NAVIGATE TO REGISTER
        NSLog(@"NAVIGATE TO LOGIN");
        User_LoginViewController *viewController = [[User_LoginViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:false];
    }
}

#pragma mark - Scroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    //  Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = mainScrollView.frame.size.width;
    int page = floor((mainScrollView.contentOffset.x) / pageWidth);
    pageControlCount.currentPage = page;
    if (page == 0)
    {
        pageControlCount.pageIndicatorTintColor = [MySingleton sharedManager].pageIndicatorTintColor;
        pageControlCount.currentPageIndicatorTintColor = [MySingleton sharedManager].currentPageIndicatorTintColorPage1;
        
        [btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
        [btnSkip setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
        
        [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    }
    else if (page == 4)
    {
        pageControlCount.pageIndicatorTintColor = [MySingleton sharedManager].pageIndicatorTintColor;
        pageControlCount.currentPageIndicatorTintColor = [MySingleton sharedManager].currentPageIndicatorTintColor;
        
        [btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
        [btnSkip setTitleColor:[MySingleton sharedManager].themeGlobalBlackColor forState:UIControlStateNormal];
        
        [btnNext setTitle:@"Login" forState:UIControlStateNormal];
    }
    else
    {
        pageControlCount.pageIndicatorTintColor = [MySingleton sharedManager].pageIndicatorTintColor;
        pageControlCount.currentPageIndicatorTintColor = [MySingleton sharedManager].currentPageIndicatorTintColor;
        
        [btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
        [btnSkip setTitleColor:[MySingleton sharedManager].themeGlobalBlackColor forState:UIControlStateNormal];
        
        [btnNext setTitle:@"Next" forState:UIControlStateNormal];
    }
}

@end
