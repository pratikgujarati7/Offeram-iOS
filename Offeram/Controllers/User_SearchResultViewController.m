//
//  User_SearchResultViewController.m
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_SearchResultViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "BrandTableViewCell.h"
#import "User_ViewOffersViewController.h"
#import "NoDataFountTableViewCell.h"

@interface User_SearchResultViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_SearchResultViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize mainTableView;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotSearchResultEvent) name:@"user_gotSearchResultEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotSearchResultEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllSearchResults;
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
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.font = lblFont;
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:NO];
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
    
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = true;
    
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
    
    [dictParameters setObject:self.strSearchString forKey:@"value"];
    
    [dictParameters setObject:@"0" forKey:@"latitude"];
    [dictParameters setObject:@"0" forKey:@"longitude"];
    
    [[MySingleton sharedManager].dataManager user_getSearchResult:dictParameters];
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
        
        [dictParameters setObject:self.strSearchString forKey:@"value"];
        
        [dictParameters setObject:self.strLatitude forKey:@"latitude"];
        [dictParameters setObject:self.strLongitude forKey:@"longitude"];
        
        [[MySingleton sharedManager].dataManager user_getSearchResult:dictParameters];
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
//        cell.lblOffer.text = objMerchant.strCategoryName;
        cell.lblOffer.text = [NSString stringWithFormat:@"%@ redeemed",objMerchant.strNumberOfRedeems];
        
        if (objMerchant.arrayOutlets.count > 1)
        {
            Outlet *objOutlet;
            if ([MySingleton sharedManager].dataManager.boolIsLocationAvailable == true)
            {
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
            if (objMerchant.arrayOutlets.count > 0)
            {
                Outlet *objOutlet = [objMerchant.arrayOutlets objectAtIndex:0];
                cell.lblDistance.text = [NSString stringWithFormat:@"%@ km",objOutlet.strDistance];
                cell.lblLocation.text = [NSString stringWithFormat:@"%@", objOutlet.strAreaName];
            }
        }
        
        cell.lblRedeemedCount.hidden = true;
        
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

@end
