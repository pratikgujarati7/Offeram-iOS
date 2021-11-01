//
//  User_HomeViewController.m
//  Offeram
//
//  Created by Dipen Lad on 11/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_HomeViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"
#import "HMSegmentedControl.h"

#import "User_TambolaTicketsListViewController.h"
#import "User_FavouritesViewController.h"
#import "User_MyAccountViewController.h"
#import "User_NotificationsViewController.h"

#import "User_ViewOffersViewController.h"

#import "BrandTableViewCell.h"
#import "User_SearchViewController.h"

#import "User_BuyNowViewController.h"
#import "NoDataFountTableViewCell.h"
#import "User_CommonWebViewViewController.h"

@interface User_HomeViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_HomeViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewLogo;
@synthesize imageViewTextLogo;
@synthesize lblCityName;
@synthesize imageViewFilter;
@synthesize btnFilter;
@synthesize imageViewSearch;
@synthesize btnSearch;

@synthesize mainScrollView;

@synthesize tambolaMainContainerView;
@synthesize tambolaMainContainerBackgroundView;
@synthesize imageViewTambolaInBanner;
@synthesize imageViewTambolaClose;
@synthesize btnTambolaClose;
@synthesize lblTambolaTitle;
@synthesize lblTambolaDescription;
@synthesize lblTambolaTotalRegisteredCount;
@synthesize btnTambolaRegister;
@synthesize btnTambolaKnowMore;

@synthesize segmentContainerView;
@synthesize mainTableView;
@synthesize btnBuyNow;

@synthesize alertMessageMainContainerView;
@synthesize imageViewAlertMessage;
@synthesize lblAlertMessage;

// BOTTOM BAR VIEW
@synthesize bottomBarView;

@synthesize offersContainerView;
@synthesize imageViewOffers;
@synthesize lblOffers;
@synthesize btnOffers;

@synthesize tambolaContainerView;
@synthesize imageViewTambola;
@synthesize lblTambola;
@synthesize btnTambola;

@synthesize favouritesContainerView;
@synthesize imageViewFavourites;
@synthesize lblFavourites;
@synthesize btnFavourites;

@synthesize notificationsContainerView;
@synthesize imageViewNotifications;
@synthesize lblNotifications;
@synthesize btnNotifications;

@synthesize myAccountContainerView;
@synthesize imageViewMyAccount;
@synthesize lblMyAccount;
@synthesize btnMyAccount;

//========== OTHER VARIABLES ==========//

HMSegmentedControl *segmentedControl;

@synthesize filterViewController;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.strLatitude = @"";
    self.strLongitude = @"";
    
    self.arrayAllCategories = [MySingleton sharedManager].dataManager.arrayAllCategoryList;
    NSLog(@"%@ :: %@",self.arrayAllCategories, [MySingleton sharedManager].dataManager.arrayAllCategoryList);
    
    filterViewController = [[User_FilterOutletsViewController alloc] init];
    [filterViewController setupInitialView];
    filterViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self setupNotificationEvent];
    [self setupInitialView];
    
    [self setNavigationBar];
    [self setupBottomBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    
    [self performSelectorInBackground:@selector(setupSegmentContainerView) withObject:nil];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllMerchantsEvent) name:@"user_gotAllMerchantsEvent" object:nil];
        
        // FILTER EVENT
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterButtonEvent) name:@"filterButtonEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_registeredForTambola) name:@"user_registeredForTambola" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)filterButtonEvent
{
    lblCityName.text = filterViewController.objSelectedCity.strCityName;
    
    self.arraySelectedAreasIds = [filterViewController.arraySelectedArea mutableCopy];
    
    // CALL WEBSERVICE
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:self.strLatitude forKey:@"latitude"];
    [dictParameters setObject:self.strLongitude forKey:@"longitude"];
    
    if(self.arraySelectedAreasIds == nil)
    {
        self.arraySelectedAreasIds = [[NSMutableArray alloc] init];
    }
//    [dictParameters setObject:[self.arraySelectedAreasIds componentsJoinedByString:@","] forKey:@"array_area_ids"];
    [dictParameters setObject:self.arraySelectedAreasIds forKey:@"array_area_ids"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
    [dictParameters setObject:strCityID forKey:@"city_id"];
    
    [[MySingleton sharedManager].dataManager user_getAllMerchants:dictParameters];
}

-(void)user_gotAllMerchantsEvent
{
    self.arrayAllMerchantsLocal = [MySingleton sharedManager].dataManager.arrayAllMerchants;
    
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        self.dataRows = [[MySingleton sharedManager].dataManager.arrayAllMerchants mutableCopy];
    }
    else
    {
        Category *objCategory = [self.arrayAllCategories objectAtIndex:segmentedControl.selectedSegmentIndex];
        
        self.dataRows = [[NSMutableArray alloc] init];
        
        for(Merchant *objMerchant in self.arrayAllMerchantsLocal)
        {
            if ([[objMerchant.strCategoryID lowercaseString] containsString:[objCategory.strCategoryID lowercaseString]])
            {
                [self.dataRows addObject:objMerchant];
            }
        }
    }
    
//    mainTableView.hidden = false;
//    [mainTableView reloadData];
    
    if ([MySingleton sharedManager].dataManager.intGetAllMerchantsAPIResponseCode == 101)
    {
        mainTableView.hidden = true;
        alertMessageMainContainerView.hidden = false;
        
        imageViewAlertMessage.image = [UIImage imageNamed:@"offeram_grey.png"];
        lblAlertMessage.text = [MySingleton sharedManager].dataManager.strGetAllMerchantsAPIErrorMessage;
    }
    else
    {
        mainTableView.hidden = false;
        [mainTableView reloadData];
//        alertMessageMainContainerView.hidden = false;
    }
    
    imageViewTambolaInBanner.imageURL = [NSURL URLWithString:[MySingleton sharedManager].dataManager.strTambolaImageURL];
    imageViewTambolaInBanner.layer.masksToBounds = true;
    
    lblTambolaTitle.text = [MySingleton sharedManager].dataManager.strTambolaTitle;
    lblTambolaTitle.layer.masksToBounds = true;
    
    lblTambolaDescription.text = [MySingleton sharedManager].dataManager.strTambolaDescription;
    lblTambolaDescription.layer.masksToBounds = true;
    lblTambolaDescription.adjustsFontSizeToFitWidth = true;
    
    if ([MySingleton sharedManager].dataManager.boolIsUserRegisteredForTambola)
    {
        [btnTambolaRegister setTitle:@"View your ticket" forState:UIControlStateNormal];
    }
    else
    {
        [btnTambolaRegister setTitle:@"Click here to register for Tambola" forState:UIControlStateNormal];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strIsClosedTambolaAlert = [NSString stringWithFormat:@"%@", [prefs objectForKey:@"IsClosedTambolaAlert"]];
    
    NSString *strSelectedCityID = filterViewController.objSelectedCity.strCityID;
    
    if ([strIsClosedTambolaAlert isEqualToString:@"0"] && [MySingleton sharedManager].dataManager.boolIsTambolaActive && [strSelectedCityID integerValue] == 1)
    {
        //PRATIK GUJARATI COMMENTED FOLLOWING LINE OF CODE ON 29 APRIL, 2020 TO HIDE TAMBOLA BANNER FROM HOME SCREEN AS WE HAVE A SEPARATE SCREEN FOR TAMBOLA TICKETS NOW
//        tambolaMainContainerView.hidden = false;
//        
//        CGRect segmentContainerViewFrame = segmentContainerView.frame;
//        segmentContainerViewFrame.origin.y = tambolaMainContainerView.frame.origin.y + tambolaMainContainerView.frame.size.height;
//        segmentContainerView.frame = segmentContainerViewFrame;
//
//        CGRect mainTableViewFrame = mainTableView.frame;
//        mainTableViewFrame.origin.y = segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height;
//        mainTableViewFrame.size.height = mainScrollView.frame.size.height - (segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height);
//        mainTableView.frame = mainTableViewFrame;
    }
    else if ([MySingleton sharedManager].dataManager.boolIsIPLActive)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // DIPEN LAD
        NSString *strUserPaymentId = [prefs objectForKey:@"userpaymentid"];//[NSString stringWithFormat:@"%@", [prefs objectForKey:@"userpaymentid"]];
        if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"userpaymentid"]
            || strUserPaymentId == nil
            || [strUserPaymentId integerValue] == 0
            || [strUserPaymentId isEqualToString:@""])
        {
            //PRATIK GUJARATI COMMENTED FOLLOWING LINE OF CODE ON 29 APRIL, 2020 TO HIDE TAMBOLA BANNER FROM HOME SCREEN AS WE HAVE A SEPARATE SCREEN FOR TAMBOLA TICKETS NOW
//            tambolaMainContainerView.hidden = false;
            
            CGRect segmentContainerViewFrame = segmentContainerView.frame;
            segmentContainerViewFrame.origin.y = tambolaMainContainerView.frame.origin.y + tambolaMainContainerView.frame.size.height;
            segmentContainerView.frame = segmentContainerViewFrame;
            
            btnTambolaKnowMore.hidden = true;
            
            CGRect btnTambolaRegisterFrame = btnTambolaRegister.frame;
            btnTambolaRegisterFrame.size.width = tambolaMainContainerView.frame.size.width - (btnTambolaRegister.frame.origin.x * 2);
            btnTambolaRegister.frame = btnTambolaRegisterFrame;
            
            [btnTambolaRegister setTitle:@"Buy Now" forState:UIControlStateNormal];
            
            CGRect mainTableViewFrame = mainTableView.frame;
            mainTableViewFrame.origin.y = segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height;
            mainTableViewFrame.size.height = mainScrollView.frame.size.height - (segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height);
            mainTableView.frame = mainTableViewFrame;
        }
    }
    else
    {
        tambolaMainContainerView.hidden = true;
        
        CGRect segmentContainerViewFrame = segmentContainerView.frame;
        segmentContainerViewFrame.origin.y = 0;
        segmentContainerView.frame = segmentContainerViewFrame;
        
        CGRect mainTableViewFrame = mainTableView.frame;
        mainTableViewFrame.origin.y = segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height;
        mainTableViewFrame.size.height = mainScrollView.frame.size.height - (segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height);
        mainTableView.frame = mainTableViewFrame;
    }
}

-(void)user_registeredForTambola
{
    [btnTambolaRegister setTitle:@"View your ticket" forState:UIControlStateNormal];
    
    User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
    viewController.strNavigationTitle = @"Tambola Ticket";
    viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
    viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    UIFont *lblCityNameFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblCityNameFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblCityNameFont = [MySingleton sharedManager].themeFontNineteenSizeBold;
    }
    else
    {
        lblCityNameFont = [MySingleton sharedManager].themeFontTwentySizeBold;
    }
    
    navigationBarView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    imageViewLogo.layer.masksToBounds = YES;
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    imageViewTextLogo.layer.masksToBounds = YES;
    imageViewTextLogo.contentMode = UIViewContentModeScaleAspectFit;
    
//    lblCityName
    lblCityName.font = lblCityNameFont;
    lblCityName.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblCityName.text = filterViewController.objSelectedCity.strCityName;
    
    imageViewFilter.layer.masksToBounds = YES;
    imageViewFilter.contentMode = UIViewContentModeScaleAspectFit;
    [btnFilter addTarget:self action:@selector(btnFilterClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewSearch.layer.masksToBounds = YES;
    imageViewSearch.contentMode = UIViewContentModeScaleAspectFit;
    [btnSearch addTarget:self action:@selector(btnSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnFilterClicked:(id)sender
{
    [self.view endEditing:YES];
    
    [filterViewController showFilter];
}

-(IBAction)btnSearchClicked:(id)sender
{
    [self.view endEditing:YES];
    
    User_SearchViewController *viewController = [[User_SearchViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

#pragma mark - Segment Setup Methods
-(void)setupSegmentContainerView
{
    NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
    NSMutableArray<UIImage *> *selectedImages = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.arrayAllCategories.count; i++)
    {
        Category *objCategory = [self.arrayAllCategories objectAtIndex:i];
        
        [titles insertObject:objCategory.strCategoryName atIndex:i];
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:objCategory.strCategoryImage]];
        
        CGRect rect = CGRectMake(0,0,25,25);
        
        if (data == nil)
        {
            rect = CGRectMake(0,0,25,1);
            UIGraphicsBeginImageContext( rect.size );
            [[UIImage imageNamed:@"blank.png"] drawInRect:rect];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *imageData = UIImagePNGRepresentation(picture1);
            UIImage *img=[UIImage imageWithData:imageData];
            
            [images insertObject:img atIndex:i];
            [selectedImages insertObject:img atIndex:i];
        }
        else
        {
            UIGraphicsBeginImageContext( rect.size );
            [[UIImage imageWithData:data] drawInRect:rect];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *imageData = UIImagePNGRepresentation(picture1);
            UIImage *img=[UIImage imageWithData:imageData];
            
            [images insertObject:img atIndex:i];
            [selectedImages insertObject:img atIndex:i];
        }
        
    }
    
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages titlesForSections:titles];
    segmentedControl.selectionIndicatorColor = [MySingleton sharedManager].themeGlobalBlueColor;
    segmentedControl.titleTextAttributes = @{
                                              NSForegroundColorAttributeName :[UIColor blackColor], NSFontAttributeName :[MySingleton sharedManager].themeFontFourteenSizeMedium
                                              };
    segmentedControl.imagePosition = HMSegmentedControlImagePositionLeftOfText;
    segmentedControl.frame = CGRectMake(0, 0, segmentContainerView.frame.size.width, segmentContainerView.frame.size.height);
    segmentedControl.selectionIndicatorHeight = 4.0f;
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    segmentedControl.selectedSegmentIndex = 0;//HMSegmentedControlNoSegment;
    segmentedControl.textImageSpacing = 5.0f;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentContainerView addSubview:segmentedControl];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    if ([MySingleton sharedManager].dataManager.intGetAllMerchantsAPIResponseCode != 101)
    {
        NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            self.dataRows = [[MySingleton sharedManager].dataManager.arrayAllMerchants mutableCopy];
        }
        else
        {
            Category *objCategory = [self.arrayAllCategories objectAtIndex:segmentedControl.selectedSegmentIndex];
            
            self.dataRows = [[NSMutableArray alloc] init];
            
            for(Merchant *objMerchant in self.arrayAllMerchantsLocal)
            {
                NSLog(@"%@", [objMerchant.strCategoryID lowercaseString]);
                NSLog(@"%@", [objCategory.strCategoryID lowercaseString]);
                
                if ([[objMerchant.strCategoryID lowercaseString] containsString:[objCategory.strCategoryID lowercaseString]])
                {
                    [self.dataRows addObject:objMerchant];
                }
            }
        }
        mainTableView.hidden = false;
        [mainTableView reloadData];
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
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIFont *lblTambolaTitleFont, *lblTambolaDescriptionFont, *btnTambolaRegisterFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTambolaTitleFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        lblTambolaDescriptionFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnTambolaRegisterFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTambolaTitleFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        lblTambolaDescriptionFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnTambolaRegisterFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
    }
    else
    {
        lblTambolaTitleFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        lblTambolaDescriptionFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnTambolaRegisterFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    alertMessageMainContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    [alertMessageMainContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [alertMessageMainContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [alertMessageMainContainerView.layer setShadowOpacity:0.6];
    [alertMessageMainContainerView.layer setShadowRadius:2.0];
    [alertMessageMainContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    imageViewAlertMessage.layer.masksToBounds = true;
    
    lblAlertMessage.font = lblTambolaDescriptionFont;
    lblAlertMessage.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblAlertMessage.textAlignment = NSTextAlignmentCenter;
    lblAlertMessage.numberOfLines = 0;
    lblAlertMessage.layer.masksToBounds = true;
    
    tambolaMainContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    tambolaMainContainerBackgroundView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    
    lblTambolaTitle.font = lblTambolaTitleFont;
    lblTambolaTitle.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTambolaTitle.textAlignment = NSTextAlignmentLeft;
    lblTambolaTitle.numberOfLines = 2;
    
    lblTambolaDescription.font = lblTambolaDescriptionFont;
    lblTambolaDescription.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTambolaDescription.textAlignment = NSTextAlignmentLeft;
    lblTambolaDescription.numberOfLines = 0;
    
    imageViewTambolaInBanner.layer.masksToBounds = true;
    imageViewTambolaInBanner.contentMode = UIViewContentModeScaleAspectFit;
    
    imageViewTambolaClose.layer.masksToBounds = true;
    imageViewTambolaClose.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnTambolaClose addTarget:self action:@selector(btnTambolaCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btnTambolaRegister.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnTambolaRegister.titleLabel.font = btnTambolaRegisterFont;
    [btnTambolaRegister setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnTambolaRegister.clipsToBounds = true;
    btnTambolaRegister.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnTambolaRegister.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnTambolaRegister.titleLabel.numberOfLines = 2;
    btnTambolaRegister.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnTambolaRegister.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnTambolaRegister addTarget:self action:@selector(btnViewTambolaTicketClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnTambolaClose addTarget:self action:@selector(btnTambolaCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([MySingleton sharedManager].dataManager.boolIsUserRegisteredForTambola)
    {
        [btnTambolaRegister setTitle:@"View your ticket" forState:UIControlStateNormal];
    }
    else
    {
        [btnTambolaRegister setTitle:@"Click here to register for Tambola" forState:UIControlStateNormal];
    }
    
    btnTambolaKnowMore.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnTambolaKnowMore.titleLabel.font = btnTambolaRegisterFont;
    [btnTambolaKnowMore setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnTambolaKnowMore.clipsToBounds = true;
    btnTambolaKnowMore.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnTambolaKnowMore.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnTambolaKnowMore addTarget:self action:@selector(btnTambolaKnowMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = true;
    
    // BTN BUY NOW
    btnBuyNow.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnBuyNow.titleLabel.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    [btnBuyNow setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnBuyNow.clipsToBounds = true;
    btnBuyNow.layer.cornerRadius =  btnBuyNow.frame.size.width/2;
    btnBuyNow.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    btnBuyNow.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btnBuyNow setTitle: @"BUY\nNOW" forState: UIControlStateNormal];
    [btnBuyNow addTarget:self action:@selector(btnBuyNowClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    // DIPEN LAD
    NSString *strUserPaymentId = [prefs objectForKey:@"userpaymentid"];//[NSString stringWithFormat:@"%@", [prefs objectForKey:@"userpaymentid"]];
    if (![[[prefs dictionaryRepresentation] allKeys] containsObject:@"userpaymentid"]
        || strUserPaymentId == nil
        || [strUserPaymentId integerValue] == 0
        || [strUserPaymentId isEqualToString:@""])
    {
        btnBuyNow.hidden = false;
    }
    else
    {
        btnBuyNow.hidden = true;
    }
    
    
    /// GET CURRENT LOCATION
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startMonitoringSignificantLocationChanges];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER)
    {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
    }
#endif
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            [appDelegate dismissGlobalHUD];
        }
    }
    else
    {
        [appDelegate dismissGlobalHUD];
    }
}

-(IBAction)btnBuyNowClicked:(id)sender
{
    User_BuyNowViewController *viewController = [[User_BuyNowViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError Called.");
    
    //    [locationManager startUpdatingLocation];
    
    [appDelegate dismissGlobalHUD];
    
    [MySingleton sharedManager].dataManager.boolIsLocationAvailable = false;
    
    // CALL WEBSERVICE
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:@"0" forKey:@"latitude"];
    [dictParameters setObject:@"0" forKey:@"longitude"];
    
    if(self.arraySelectedAreasIds == nil)
    {
        self.arraySelectedAreasIds = [[NSMutableArray alloc] init];
    }
//    [dictParameters setObject:[self.arraySelectedAreasIds componentsJoinedByString:@","] forKey:@"array_area_ids"];
    [dictParameters setObject:self.arraySelectedAreasIds forKey:@"array_area_ids"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
    [dictParameters setObject:strCityID forKey:@"city_id"];
    
    [[MySingleton sharedManager].dataManager user_getAllMerchants:dictParameters];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations Called.");
    
    currentLocation = [locations objectAtIndex:0];
    
    if (currentLocation != nil)
    {
        [MySingleton sharedManager].dataManager.boolIsLocationAvailable = true;
        
        self.strLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.strLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
//        [self getAddressFromLatLon:currentLocation];
        
        
        [MySingleton sharedManager].dataManager.strUserLocationLatitude = self.strLatitude;
        [MySingleton sharedManager].dataManager.strUserLocationLongitude = self.strLongitude;
        
        [locationManager stopUpdatingLocation];
        
        // CALL WEBSERVICE
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:self.strLatitude forKey:@"latitude"];
        [dictParameters setObject:self.strLongitude forKey:@"longitude"];
        
        if(self.arraySelectedAreasIds == nil)
        {
            self.arraySelectedAreasIds = [[NSMutableArray alloc] init];
        }
//        [dictParameters setObject:[self.arraySelectedAreasIds componentsJoinedByString:@","] forKey:@"array_area_ids"];
        [dictParameters setObject:self.arraySelectedAreasIds forKey:@"array_area_ids"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        [dictParameters setObject:strCityID forKey:@"city_id"];
        
        [[MySingleton sharedManager].dataManager user_getAllMerchants:dictParameters];
    }
    else
    {
        [appDelegate dismissGlobalHUD];
    }
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataRows.count > 0)
    {
        mainTableView.userInteractionEnabled = true;
        
        return self.dataRows.count;
    }
    else
    {
        mainTableView.userInteractionEnabled = false;
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        return 115;
    }
    else
    {
        return 270;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.dataRows.count > 0)
    {
        Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
        
        BrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[BrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.imageViewBrand.imageURL = [NSURL URLWithString:objMerchant.strCompanyBannerImageUrl];
        
        cell.lblOffersCount.text = [NSString stringWithFormat:@"%@ Offers",objMerchant.strUserCoupons];
        
        cell.lblFeatured.text = @"Featured";
        cell.lblFeatured.hidden = true;
        
        cell.imageviewTag.image = [UIImage imageNamed:@"star_filled.png"];
        if ([objMerchant.strIsStarred integerValue] == 0)
        {
            cell.imageviewTag.hidden = true;
        }
        else
        {
            cell.imageviewTag.hidden = false;
        }
        
        if ([objMerchant.strAverageRatings floatValue]> 0)
        {
            cell.lblRatings.text = objMerchant.strAverageRatings;
        }
        else
        {
            cell.lblRatings.text = @"-";
        }
        
        
        cell.lblBrandName.text = objMerchant.strCompanyName;
        cell.lblItems.text = objMerchant.strCuisines;
        cell.lblOffer.text = objMerchant.strOfferText;
        cell.lblRedeemedCount.text = [NSString stringWithFormat:@"%@ redeemed",objMerchant.strNumberOfRedeems];
        
        if (objMerchant.arrayOutlets.count > 1)
        {
            Outlet *objOutlet;
            if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == true)
            {
                // DIPEN LAD
                if (objMerchant.arrayOutlets.count > 0)
                {
                    objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                    for (int i = 0; i < objMerchant.arrayOutlets.count; i++)
                    {
                        Outlet *objOutletTemp = [objMerchant.arrayOutlets objectAtIndex:i];
                        if ([objOutlet.strDistance floatValue] > [objOutletTemp.strDistance floatValue])
                        {
                            objOutlet = objOutletTemp;
                        }
                    }
                }
            }
            else
            {
                // DIPEN LAD
                if (objMerchant.arrayOutlets.count > 0)
                {
                    objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                }
            }
            
            cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
            cell.lblLocation.text = [NSString stringWithFormat:@"%@, +%lu Outlets", objOutlet.strAreaName, objMerchant.arrayOutlets.count-1];
        }
        else
        {
            // DIPEN LAD
            if (objMerchant.arrayOutlets.count > 0)
            {
                Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
                cell.lblLocation.text = [NSString stringWithFormat:@"%@", objOutlet.strAreaName];
            }
        }
        
        if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == true)
        {
            cell.lblDistance.hidden = false;
        }
        else
        {
            cell.lblDistance.hidden = true;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.lblNoData.text = @"No offers found.";
        cell.btnAction.hidden = true;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        [self.view endEditing:true];
        
        Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
        
        User_ViewOffersViewController *viewController = [[User_ViewOffersViewController alloc] init];
        viewController.strMerchantID = objMerchant.strMerchantID;
        [self.navigationController pushViewController:viewController animated:true];
        
    }
}

#pragma mark - Bottom Bar Methods

-(void)setupBottomBar
{
    bottomBarView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblFont = [MySingleton sharedManager].themeFontTenSizeMedium;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblFont = [MySingleton sharedManager].themeFontElevenSizeMedium;
    }
    else
    {
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeMedium;
    }
    
    imageViewOffers.layer.masksToBounds = true;
    
    lblOffers.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblOffers.font = lblFont;
    lblOffers.textAlignment = NSTextAlignmentCenter;
    
    [btnOffers addTarget:self action:@selector(btnOffersClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewTambola.layer.masksToBounds = true;
    
    lblTambola.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblTambola.font = lblFont;
    lblTambola.textAlignment = NSTextAlignmentCenter;
    
    [btnTambola addTarget:self action:@selector(btnTambolaClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewFavourites.layer.masksToBounds = true;
    
    lblFavourites.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblFavourites.font = lblFont;
    lblFavourites.textAlignment = NSTextAlignmentCenter;
    
    [btnFavourites addTarget:self action:@selector(btnFavouritesClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewNotifications.layer.masksToBounds = true;
    
    lblNotifications.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblNotifications.font = lblFont;
    lblNotifications.textAlignment = NSTextAlignmentCenter;
    
    [btnNotifications addTarget:self action:@selector(btnNotificationsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewMyAccount.layer.masksToBounds = true;
    
    lblMyAccount.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblMyAccount.font = lblFont;
    lblMyAccount.textAlignment = NSTextAlignmentCenter;
    
    [btnMyAccount addTarget:self action:@selector(btnMyAccountClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//
//    NSString *strLoginId = [prefs objectForKey:@"login_id"];
//    NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
//
//    if((strLoginId != nil && strLoginId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
//    {
//        lblMyAccount.text = @"My Account";
//    }
//    else
//    {
//        lblMyAccount.text = @"Login";
//    }
    
    if ([[MySingleton sharedManager].dataManager.strNotificationCount integerValue] > 0)
    {
        imageViewNotifications.image = [UIImage imageNamed:@"notifications_unread.png"];
    }
}

-(IBAction)btnOffersClicked:(id)sender
{
    [self.view endEditing:true];
}

-(IBAction)btnTambolaClicked:(id)sender
{
    [self.view endEditing:true];
    
    User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
       [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnFavouritesClicked:(id)sender
{
    [self.view endEditing:true];
    User_FavouritesViewController *viewController = [[User_FavouritesViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnNotificationsClicked:(id)sender
{
    [self.view endEditing:true];
    User_NotificationsViewController *viewController = [[User_NotificationsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnMyAccountClicked:(id)sender
{
    [self.view endEditing:true];
    User_MyAccountViewController *viewController = [[User_MyAccountViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

#pragma mark - Other Methods

-(IBAction)btnTambolaCloseClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"1" forKey:@"IsClosedTambolaAlert"];
    [prefs synchronize];
    
    tambolaMainContainerView.hidden = true;
    
    CGRect segmentContainerViewFrame = segmentContainerView.frame;
    segmentContainerViewFrame.origin.y = 0;
    segmentContainerView.frame = segmentContainerViewFrame;
    
    CGRect mainTableViewFrame = mainTableView.frame;
    mainTableViewFrame.origin.y = segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height;
    mainTableViewFrame.size.height = mainScrollView.frame.size.height - (segmentContainerView.frame.origin.y + segmentContainerView.frame.size.height);
    mainTableView.frame = mainTableViewFrame;
}

-(IBAction)btnViewTambolaTicketClicked:(id)sender
{
    [self.view endEditing:true];
    
    UIButton *btnTambolaRegister = (UIButton *)sender;
    
    if([btnTambolaRegister.titleLabel.text isEqualToString:@"Buy Now"])
    {
        User_BuyNowViewController *viewController = [[User_BuyNowViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:true];
    }
    else
    {
        if ([MySingleton sharedManager].dataManager.boolIsUserRegisteredForTambola)
        {
            User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
            viewController.strNavigationTitle = @"Tambola Ticket";
            viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
            viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
            [self.navigationController pushViewController:viewController animated:true];
        }
        else
        {
            [[MySingleton sharedManager].dataManager user_registerForTambola];
        }
    }
}
-(IBAction)btnTambolaKnowMoreClicked:(id)sender
{
    [self.view endEditing:true];
    
    NSURL *appStoreUrl = [NSURL URLWithString:[MySingleton sharedManager].dataManager.strTambolaKnowMoreURL];
    
    if ([[UIApplication sharedApplication] canOpenURL:appStoreUrl]) {
        [[UIApplication sharedApplication] openURL:appStoreUrl];
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Something went wrong!!!"];
        });
    }
}

@end
