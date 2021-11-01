//
//  User_FavouritesViewController.m
//  Offeram
//
//  Created by Dipen Lad on 12/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_FavouritesViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"
#import "User_TambolaTicketsListViewController.h"
#import "User_MyAccountViewController.h"
#import "User_NotificationsViewController.h"

#import "BrandTableViewCell.h"
#import "PingedOfferTableViewCell.h"

#import "User_ViewOffersViewController.h"
#import "User_OfferDetailsViewController.h"
#import "NoDataFountTableViewCell.h"
#import "UsedCouponTableViewCell.h"

@interface User_FavouritesViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_FavouritesViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize navigationTitle;

@synthesize mainScrollView;

@synthesize segmentContainerView;
@synthesize mainTableView;

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
@synthesize segmentedControl;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self setupSegmentContainerView];
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllFevoriteOffersEvent) name:@"user_gotAllFevoriteOffersEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllMyPingedOffersEvent) name:@"user_gotAllMyPingedOffersEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllPingedOffersEvent) name:@"user_gotAllPingedOffersEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_updatedPingedOfferEvent) name:@"user_updatedPingedOfferEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllUsedOffersEvent) name:@"user_gotAllUsedOffersEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_reActivatedOfferEvent) name:@"user_reActivatedOfferEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotAllFevoriteOffersEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllFevoriteOffers;
    mainTableView.hidden = false;
    [mainTableView reloadData];
}

-(void)user_gotAllMyPingedOffersEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllMyPingedOffers;
    mainTableView.hidden = false;
    [mainTableView reloadData];
}

-(void)user_gotAllPingedOffersEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllPingedOffers;
    mainTableView.hidden = false;
    [mainTableView reloadData];
}

-(void)user_updatedPingedOfferEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllPingedOffers;
    mainTableView.hidden = false;
    [mainTableView reloadData];
}

-(void)user_gotAllUsedOffersEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllUsedOffers;
    mainTableView.hidden = false;
    [mainTableView reloadData];
}

-(void)user_reActivatedOfferEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllUsedOffers;
    mainTableView.hidden = false;
    [mainTableView reloadData];
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
    
    navigationTitle.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    navigationTitle.font = lblFont;
    navigationTitle.textAlignment = NSTextAlignmentCenter;
}

-(IBAction)btnFilterClicked:(id)sender
{
    [self.view endEditing:YES];
    
}

-(IBAction)btnSearchClicked:(id)sender
{
    [self.view endEditing:YES];
    
}

#pragma mark - Segment Setup Methods
-(void)setupSegmentContainerView
{
    UIImage *image1 = [self imageWithImage:[UIImage imageNamed:@"favourites.png"] convertToSize:CGSizeMake(25, 25)];
    UIImage *image2 = [self imageWithImage:[UIImage imageNamed:@"recieved pings.png"] convertToSize:CGSizeMake(25, 25)];
    UIImage *image3 = [self imageWithImage:[UIImage imageNamed:@"sent pings.png"] convertToSize:CGSizeMake(25, 25)];
    UIImage *image4 = [self imageWithImage:[UIImage imageNamed:@"used offers.png"] convertToSize:CGSizeMake(25, 25)];
    
    
    NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] initWithObjects: image1, image2, image3, image4, nil];
    NSMutableArray<UIImage *> *selectedImages = [[NSMutableArray alloc] initWithObjects: image1, image2, image3, image4, nil];
    NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithObjects: @"Favourites", @"Received Pings", @"Pinged Offers", @"Used Offers", nil];
    
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
    
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
        
        self.dataRows = [[NSMutableArray alloc] init];
        [mainTableView reloadData];
        
        if (index == 0)
        {
            if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == false)
            {
                // CALL WEBSERVICE
                NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                
                [dictParameters setObject:@"0" forKey:@"latitude"];
                [dictParameters setObject:@"0" forKey:@"longitude"];
                
                [[MySingleton sharedManager].dataManager user_getAllFevoriteOffers:dictParameters];
            }
            else
            {
                // CALL WEBSERVICE
                NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                
                [dictParameters setObject:self.strLatitude forKey:@"latitude"];
                [dictParameters setObject:self.strLongitude forKey:@"longitude"];
                
                [[MySingleton sharedManager].dataManager user_getAllFevoriteOffers:dictParameters];
            }
        }
        else if (index == 1)
        {
            if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == false)
            {
                NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                
                [dictParameters setObject:@"0" forKey:@"latitude"];
                [dictParameters setObject:@"0" forKey:@"longitude"];
                
                [[MySingleton sharedManager].dataManager user_getAllPingedOffer:dictParameters];
            }
            else
            {
                NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                
                [dictParameters setObject:self.strLatitude forKey:@"latitude"];
                [dictParameters setObject:self.strLongitude forKey:@"longitude"];
                
                [[MySingleton sharedManager].dataManager user_getAllPingedOffer:dictParameters];
            }
        }
        else if (index == 2)
        {
            if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == false)
            {
                NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                
                [dictParameters setObject:@"0" forKey:@"latitude"];
                [dictParameters setObject:@"0" forKey:@"longitude"];
                
                [[MySingleton sharedManager].dataManager user_getAllMyPingedOffer:dictParameters];
            }
            else
            {
                NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                
                [dictParameters setObject:self.strLatitude forKey:@"latitude"];
                [dictParameters setObject:self.strLongitude forKey:@"longitude"];
                
                [[MySingleton sharedManager].dataManager user_getAllMyPingedOffer:dictParameters];
            }
        }
        else if (index == 3)
        {
            [[MySingleton sharedManager].dataManager user_getAllUsedOffers];
        }
    }];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    [mainTableView reloadData];
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = true;
    mainTableView.hidden = false;
    
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
    
    [[MySingleton sharedManager].dataManager user_getAllFevoriteOffers:dictParameters];
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
        
        [MySingleton sharedManager].dataManager.strUserLocationLatitude = self.strLatitude;
        [MySingleton sharedManager].dataManager.strUserLocationLongitude = self.strLongitude;
        
        [locationManager stopUpdatingLocation];
        
        // CALL WEBSERVICE
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:self.strLatitude forKey:@"latitude"];
        [dictParameters setObject:self.strLongitude forKey:@"longitude"];
        
        [[MySingleton sharedManager].dataManager user_getAllFevoriteOffers:dictParameters];
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
        mainTableView.userInteractionEnabled = true;
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        if (segmentedControl.selectedSegmentIndex == 3)
        {
            return 150;
        }
        else
        {
            return 115;
        }
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
        if (segmentedControl.selectedSegmentIndex == 0)
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
            cell.lblItems.text = objMerchant.strCouponTitle;
            cell.lblOffer.text = objMerchant.strCategoryName;
            cell.lblRedeemedCount.text = [NSString stringWithFormat:@"%@ redeemed",objMerchant.strNumberOfRedeems];
            
            if (objMerchant.arrayOutlets.count > 1)
            {
                Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
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
                    cell.lblLocation.text = objOutlet.strAreaName;
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
        else if (segmentedControl.selectedSegmentIndex == 1)
        {
            Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
            
            PingedOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell = [[PingedOfferTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            
            cell.imageViewBrand.imageURL = [NSURL URLWithString:objMerchant.strCompanyBannerImageUrl];
            
            cell.imageviewTag.image = [UIImage imageNamed:@"ping_selected.png"];
            
            if ([objMerchant.strAverageRatings floatValue]> 0)
            {
                cell.lblRatings.text = objMerchant.strAverageRatings;
            }
            else
            {
                cell.lblRatings.text = @"-";
            }
            
            cell.lblBrandName.text = objMerchant.strCompanyName;
            
            if (objMerchant.arrayOutlets.count > 1)
            {
                Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                //            cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
                cell.lblLocation.text = [NSString stringWithFormat:@"%@, +%lu Outlets", objOutlet.strAreaName, objMerchant.arrayOutlets.count-1];
            }
            else
            {
                // DIPEN LAD
                if (objMerchant.arrayOutlets.count > 0)
                {
                    Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                    //                cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
                    cell.lblLocation.text = objOutlet.strAreaName;
                }
            }
            
            if (objMerchant.arrayCoupons.count > 0)
            {
                Coupon *objCoupon = [objMerchant.arrayCoupons objectAtIndex:0];
                
                cell.lblOffer.text = objCoupon.strCouponTitle;
                cell.lblPingFromValue.text = objCoupon.strPingedUserName;
                
                if ([objCoupon.strPingedStatus integerValue] == 0)
                {
                    cell.btnAcceptContainerView.hidden = false;
                    cell.btnDeclineContainerView.hidden = false;
                    
                    cell.btnAccept.tag = indexPath.row;
                    cell.btnDecline.tag = indexPath.row;
                    
                    [cell.btnAccept addTarget:self action:@selector(btnAcceptClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btnDecline addTarget:self action:@selector(btnDeclineClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.btnAcceptContainerView.hidden = true;
                    cell.btnDeclineContainerView.hidden = true;
                }
            }
            
            cell.lblPingFrom.text = @"From:";
            
            cell.imageviewTag.hidden = true;
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else if (segmentedControl.selectedSegmentIndex == 2)
        {
            Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
            
            PingedOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell = [[PingedOfferTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            
            cell.imageViewBrand.imageURL = [NSURL URLWithString:objMerchant.strCompanyBannerImageUrl];
            
            cell.imageviewTag.image = [UIImage imageNamed:@"ping_selected.png"];
            
            if ([objMerchant.strAverageRatings floatValue]> 0)
            {
                cell.lblRatings.text = objMerchant.strAverageRatings;
            }
            else
            {
                cell.lblRatings.text = @"-";
            }
            
            cell.lblBrandName.text = objMerchant.strCompanyName;
            
            if (objMerchant.arrayOutlets.count > 1)
            {
                Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                //            cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
                cell.lblLocation.text = [NSString stringWithFormat:@"%@, +%lu Outlets", objOutlet.strAreaName, objMerchant.arrayOutlets.count-1];
            }
            else
            {
                // DIPEN LAD
                if (objMerchant.arrayOutlets.count > 0)
                {
                    Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                    //                cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
                    cell.lblLocation.text = objOutlet.strAreaName;
                }
            }
            
            if (objMerchant.arrayCoupons.count > 0)
            {
                Coupon *objCoupon = [objMerchant.arrayCoupons objectAtIndex:0];
                
                cell.lblOffer.text = objCoupon.strCouponTitle;
                cell.lblPingFromValue.text = objCoupon.strPingedUserName;
                
                cell.btnDeclineContainerView.hidden = true;
                
                if ([objCoupon.strPingedStatus integerValue] == 1)
                {
                    cell.btnAcceptContainerView.center = cell.btnDeclineContainerView.center;
                    cell.btnAcceptContainerView.hidden = false;
                    
                    cell.lblAccept.text = @"Accepted";
                    cell.lblAccept.adjustsFontSizeToFitWidth = true;
                    
//                    cell.btnDeclineContainerView.hidden = false;
//
//                    cell.btnAccept.tag = indexPath.row;
//                    cell.btnDecline.tag = indexPath.row;
//
//                    [cell.btnAccept addTarget:self action:@selector(btnAcceptClicked:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.btnDecline addTarget:self action:@selector(btnDeclineClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.btnAcceptContainerView.hidden = true;
                }
            }

            cell.lblPingFrom.text = @"To:";
            
            cell.imageviewTag.hidden = true;
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else
        {
            Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
            
            UsedCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell = [[UsedCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            
            cell.imageViewBrand.imageURL = [NSURL URLWithString:objMerchant.strCompanyBannerImageUrl];
            
            cell.lblOffersCount.hidden = true;
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
            cell.lblItems.text = objMerchant.strCouponTitle;
            cell.lblOffer.text = [NSString stringWithFormat:@"%@",objMerchant.strDateUsed];;
            cell.lblRedeemedCount.hidden = true;
            
            cell.lblLocation.text = [NSString stringWithFormat:@"%@",objMerchant.strAreaName];
            
            cell.lblDistance.hidden = true;
            
            //REUSE
            NSTextAttachment *icon = [[NSTextAttachment alloc] init];
            UIImage *iconImage = [self imageWithImage:[UIImage imageNamed:@"offeram_coin.png"] convertToSize:CGSizeMake(40, 40)];
            [icon setBounds:CGRectMake(0, roundf(cell.lblReuseAmount.font.capHeight - (iconImage.size.height/2))/2.f, (iconImage.size.width)/2, (iconImage.size.height)/2)];
            [icon setImage:iconImage];
            
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:icon];
            
            NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
            [myString appendAttributedString:attachmentString];
            [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ To Reactivate this Coupon",objMerchant.strReuseAmount]]];
            
            cell.lblReuseAmount.attributedText = myString;
            cell.lblReuseAmount.textAlignment = NSTextAlignmentLeft;
            cell.lblReuseAmount.adjustsFontSizeToFitWidth = true;
                        
            if ([objMerchant.strIsReused integerValue] == 1)
            {
                cell.reuseContainer.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
                cell.lblIsCouponReused.hidden = false;
                cell.lblReuseAmount.hidden = true;
                cell.btnReuse.hidden = true;
            }
            else
            {
                cell.reuseContainer.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
                cell.lblIsCouponReused.hidden = true;
                cell.lblReuseAmount.hidden = false;
                cell.btnReuse.hidden = false;
                cell.btnReuse.tag = indexPath.row;
                
                [cell.btnReuse addTarget:self action:@selector(btnReuseClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            cell.lblNoData.text = @"No Favourites added.";
            [cell.btnAction setTitle:@"Explore Offers" forState:UIControlStateNormal];
        }
        else if (segmentedControl.selectedSegmentIndex == 1)
        {
            cell.lblNoData.text = @"Oops! You have not been pinged by anyone yet. Start sharing offers by Ping An Offer now!";
            [cell.btnAction setTitle:@"PING Now" forState:UIControlStateNormal];
        }
        else if (segmentedControl.selectedSegmentIndex == 2)
        {
            cell.lblNoData.text = @"Oops! You have not pinged any offers yet. Start sharing offers by Ping An Offer now!";
            [cell.btnAction setTitle:@"PING Now" forState:UIControlStateNormal];
        }
        else
        {
            cell.lblNoData.text = @"You have not used any offers yet, use offers today.";
            [cell.btnAction setTitle:@"Use Now" forState:UIControlStateNormal];
        }
        
//        cell.btnAction.hidden = true;
        cell.btnAction.tag = segmentedControl.selectedSegmentIndex;
        [cell.btnAction addTarget:self action:@selector(btnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(IBAction)btnReuseClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    Merchant *objMerchant = [self.dataRows objectAtIndex:btnSender.tag];
    
    if ([[MySingleton sharedManager].dataManager.objLoggedInUser.strOfferamCoinsBalance integerValue] >= [objMerchant.strReuseAmount integerValue])
    {
        // REUSE
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = @"";
        alertViewController.message = [NSString stringWithFormat: @"Are you sure you want to Re-activate this coupon for %@ Offeram Coins?", objMerchant.strReuseAmount];
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
            //REUSE COUPON API CALL
            [[MySingleton sharedManager].dataManager user_reActivateOffer:objMerchant.strCouponID withRedemptionId:objMerchant.strRedemptionID];
        }]];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertViewController animated:YES completion:nil];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:nil withDetails:@"You are not having suficient Offeram Coins to reuse this Coupon."];
        });
    }
}

-(IBAction)btnActionClicked:(id)sender
{
    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        if(self.dataRows.count > 0)
        {
            Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
            
            User_ViewOffersViewController *viewController = [[User_ViewOffersViewController alloc] init];
            viewController.strMerchantID = objMerchant.strMerchantID;
            [self.navigationController pushViewController:viewController animated:true];
        }
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        //RECEIVED PINGS
        if(self.dataRows.count > 0)
        {
            Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
            
            [MySingleton sharedManager].dataManager.objSelectedMerchant = objMerchant;
            
            if (objMerchant.arrayCoupons.count > 0)
            {
                Coupon *objCoupon = [objMerchant.arrayCoupons objectAtIndex:0];
                
                if ([objCoupon.strPingedStatus integerValue] == 1)
                {
                    [MySingleton sharedManager].dataManager.objSelectedMerchant = objMerchant;
                    
                    [self.view endEditing:true];
                    User_OfferDetailsViewController *viewController = [[User_OfferDetailsViewController alloc] init];
                    viewController.strOfferNumber = [NSString stringWithFormat:@"%d", 1];
                    viewController.objMerchant = objMerchant;
                    viewController.objSelectedCoupon = objCoupon;
                    viewController.isPingedOffer = true;
                    [self.navigationController pushViewController:viewController animated:true];
                }
            }
        }
        else
        {
            //            User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
            //            [self.navigationController pushViewController:viewController animated:false];
        }
    }
    else if (segmentedControl.selectedSegmentIndex == 2)
    {
        //PINGED OFFERS
        if(self.dataRows.count > 0)
        {
            Merchant *objMerchant = [self.dataRows objectAtIndex:indexPath.row];
            
            [MySingleton sharedManager].dataManager.objSelectedMerchant = objMerchant;
            
            if (objMerchant.arrayCoupons.count > 0)
            {
                if (objMerchant.arrayCoupons.count > 0)
                {
                    Coupon *objCoupon = [objMerchant.arrayCoupons objectAtIndex:0];
                    
                    [MySingleton sharedManager].dataManager.objSelectedMerchant = objMerchant;
                    
                    [self.view endEditing:true];
                    User_OfferDetailsViewController *viewController = [[User_OfferDetailsViewController alloc] init];
                    viewController.strOfferNumber = [NSString stringWithFormat:@"%d", 1];
                    viewController.objMerchant = objMerchant;
                    viewController.objSelectedCoupon = objCoupon;
                    viewController.isPingedOffer = true;
                    [self.navigationController pushViewController:viewController animated:true];
                }
            }
        }
        else
        {
//            User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
//            [self.navigationController pushViewController:viewController animated:false];
        }
    }
    else
    {
        //USED OFFERS
        if(self.dataRows.count > 0)
        {
        }
        else
        {
            //            User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
            //            [self.navigationController pushViewController:viewController animated:false];
        }
    }
}

#pragma mark - OTHER METHODS

-(IBAction)btnAcceptClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    Merchant *objMerchant = [self.dataRows objectAtIndex:btnSender.tag];
    
    if (objMerchant.arrayCoupons.count > 0)
    {
        Coupon *objCoupon = [objMerchant.arrayCoupons objectAtIndex:0];
        
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        [dictParameters setObject:objCoupon.strPingedID forKey:@"ping_id"];
        [dictParameters setObject:objCoupon.strCouponID forKey:@"coupon_id"];
        [dictParameters setObject:@"1" forKey:@"status"];
        
        if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == false)
        {
            [dictParameters setObject:@"0" forKey:@"latitude"];
            [dictParameters setObject:@"0" forKey:@"longitude"];
        }
        else
        {
            [dictParameters setObject:self.strLatitude forKey:@"latitude"];
            [dictParameters setObject:self.strLongitude forKey:@"longitude"];
        }
        
        // CALL WEBSERVICE
        [[MySingleton sharedManager].dataManager user_updatePingedOffer:dictParameters];
    }
}

-(IBAction)btnDeclineClicked:(id)sender
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"Are you sure you want to decline this offer?";
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
        UIButton *btnSender = (UIButton *)sender;
        
        Merchant *objMerchant = [self.dataRows objectAtIndex:btnSender.tag];
        
        if (objMerchant.arrayCoupons.count > 0)
        {
            Coupon *objCoupon = [objMerchant.arrayCoupons objectAtIndex:0];
            
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            [dictParameters setObject:objCoupon.strPingedID forKey:@"ping_id"];
            [dictParameters setObject:objCoupon.strCouponID forKey:@"coupon_id"];
            [dictParameters setObject:@"2" forKey:@"status"];
            
            if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == false)
            {
                [dictParameters setObject:@"0" forKey:@"latitude"];
                [dictParameters setObject:@"0" forKey:@"longitude"];
            }
            else
            {
                [dictParameters setObject:self.strLatitude forKey:@"latitude"];
                [dictParameters setObject:self.strLongitude forKey:@"longitude"];
            }
            
            // CALL WEBSERVICE
            [[MySingleton sharedManager].dataManager user_updatePingedOffer:dictParameters];
        }
        
    }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
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
    
    if ([[MySingleton sharedManager].dataManager.strNotificationCount integerValue] > 0)
    {
        imageViewNotifications.image = [UIImage imageNamed:@"notifications_unread.png"];
    }
}

-(IBAction)btnOffersClicked:(id)sender
{
    [self.view endEditing:true];
    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
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

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
