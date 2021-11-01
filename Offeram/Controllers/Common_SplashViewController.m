//
//  Common_SplashViewController.m
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "Common_SplashViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "Common_IntroductionViewController.h"
#import "User_LoginViewController.h"
#import "User_HomeViewController.h"
#import "User_ViewOffersViewController.h"

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@interface Common_SplashViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsRedirected;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
    
    BOOL boolIsExecuteRedirectionCalledOnce;
    
    BOOL boolIsExecuteRedirectionCalledOnceAfterLocation;
}
@end

@implementation Common_SplashViewController

//========== IBOUTLETS ==========//
@synthesize mainScrollView;
@synthesize imageViewBackground;
@synthesize imageViewLogo;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    
    [MySingleton sharedManager].dataManager.isSplashScreenOpen = true;
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    [MySingleton sharedManager].dataManager.isSplashScreenOpen = true;
    
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
    [MySingleton sharedManager].dataManager.isSplashScreenOpen = false;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_collectedDataOnSplashScreenEvent) name:@"user_collectedDataOnSplashScreenEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_uploadedContactsEvent) name:@"user_uploadedContactsEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_collectedDataOnSplashScreenEvent
{
    // CHECK IF CITY ID SAVED EARLIER OR CALL LOCATION WEB SERVICE
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
    if (strCityID != nil && strCityID.length > 0)
    {
        [self executeRedirection];
    }
    else
    {
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
}

-(void)user_uploadedContactsEvent
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"YES" forKey:@"boolIsContactUploadedEarlier"];
    
    boolIsRedirected = TRUE;
    
    if ([MySingleton sharedManager].dataManager.boolIsAppOpenedFromNotification)
    {
        if ([MySingleton sharedManager].dataManager.strNotificationMerchantId != nil && [[MySingleton sharedManager].dataManager.strNotificationMerchantId integerValue] > 0)
        {
            [self performSelector:@selector(navigateToUserViewOffersViewController) withObject:self afterDelay:1.0];
        }
        else
        {
            [self performSelector:@selector(navigateToUserHomeViewController) withObject:self afterDelay:1.0];
        }
    }
    else
    {
        [self performSelector:@selector(navigateToUserHomeViewController) withObject:self afterDelay:1.0];
    }
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError Called.");
    
    [appDelegate dismissGlobalHUD];
    
    [MySingleton sharedManager].dataManager.boolIsLocationAvailable = false;
    
    [self executeRedirection];
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
        
        [self getAddressFromLatLon:currentLocation];
    }
    else
    {
        [appDelegate dismissGlobalHUD];
    }
}

- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    NSLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);

         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
         
         for (int i = 0; i < [MySingleton sharedManager].dataManager.arrayAllCity.count; i++)
         {
             City *objCity = [[MySingleton sharedManager].dataManager.arrayAllCity objectAtIndex:i];
             
             if ([[objCity.strCityName lowercaseString] isEqualToString:[placemark.locality lowercaseString]])
             {
                 [prefs setObject:objCity.strCityID forKey:@"selected_city_id"];
                 [prefs synchronize];
             }
         }
         if (boolIsExecuteRedirectionCalledOnceAfterLocation == false)
         {
             [self executeRedirection];
             boolIsExecuteRedirectionCalledOnceAfterLocation = true;
         }
         

     }];

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
    
    imageViewLogo.layer.masksToBounds = true;
    
    [[MySingleton sharedManager].dataManager user_collectDataOnSplashScreen];
}

#pragma mark - Other Method
-(void)navigateToCommonIntroductionScreen
{
    Common_IntroductionViewController *viewController = [[Common_IntroductionViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)navigateToUserHomeViewController
{
//    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)navigateToUserViewOffersViewController
{
    User_ViewOffersViewController *viewController = [[User_ViewOffersViewController alloc] init];
    viewController.boolIsOpenedFromSplash = true;
    viewController.strMerchantID = [MySingleton sharedManager].dataManager.strNotificationMerchantId;
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)navigateToLoginScreen
{
    User_LoginViewController *viewController = [[User_LoginViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)executeRedirection
{
    boolIsRedirected = TRUE;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *strAppOpened = [prefs objectForKey:@"boolIsAppOpenedEarlier"];

    if (strAppOpened != nil && strAppOpened.length > 0)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

        NSString *strUserId = [prefs objectForKey:@"userid"];
        NSString *strAutoLogin = [prefs objectForKey:@"autologin"];

        if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
        {
//            [prefs removeObjectForKey:@"boolIsContactUploadedEarlier"];

            NSString *strContactsUploaded = [prefs objectForKey:@"boolIsContactUploadedEarlier"];

            if (strContactsUploaded != nil && strContactsUploaded.length > 0)
            {
                boolIsRedirected = TRUE;

                if ([MySingleton sharedManager].dataManager.boolIsAppOpenedFromNotification)
                {
                    if ([MySingleton sharedManager].dataManager.strNotificationMerchantId != nil && [[MySingleton sharedManager].dataManager.strNotificationMerchantId integerValue] > 0)
                    {
                        [self performSelector:@selector(navigateToUserViewOffersViewController) withObject:self afterDelay:1.0];
                    }
                    else
                    {
                        [self performSelector:@selector(navigateToUserHomeViewController) withObject:self afterDelay:1.0];
                    }
                }
                else
                {
                    [self performSelector:@selector(navigateToUserHomeViewController) withObject:self afterDelay:1.0];
                }


            }
            else
            {
                // CALL CONTACT WEBSERVICE
                [self getAllContact];
            }

        }
        else
        {
            boolIsRedirected = TRUE;

            [self performSelector:@selector(navigateToLoginScreen) withObject:self afterDelay:1.0];
        }
    }
    else
    {
        [prefs setObject:@"YES" forKey:@"boolIsAppOpenedEarlier"];
        [self performSelector: @selector(navigateToCommonIntroductionScreen) withObject:self afterDelay:1.0];
    }
}

#pragma mark - GET CONTACTS

-(void)getAllContact
{
    self.arrayAllContacts = [[NSMutableArray alloc] init];
    
    if([CNContactStore class])
    {
        CNContactStore *addressBook =[[CNContactStore alloc]init];
        
        NSArray *keysToFetch =@[CNContactEmailAddressesKey,CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactJobTitleKey,CNContactNamePrefixKey,CNContactNameSuffixKey ];
        
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
        
        __block int i = 0;
        
        [addressBook enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop)
         {
             NSString *strFullName, *strContactNumber;
             
             if((contact.givenName != nil && contact.givenName.length > 0) && (contact.familyName != nil && contact.familyName.length > 0))
             {
                 strFullName = [NSString stringWithFormat:@"%@ %@",contact.givenName,contact.familyName];
             }
             else if((contact.givenName != nil && contact.givenName.length > 0))
             {
                 strFullName = [NSString stringWithFormat:@"%@",contact.givenName];
             }
             else if((contact.familyName != nil && contact.familyName.length > 0))
             {
                 strFullName = [NSString stringWithFormat:@"%@",contact.familyName];
             }
             
             
             if(contact.phoneNumbers.count > 0)
             {
                 CNLabeledValue<CNPhoneNumber *> *firstPhone = [contact.phoneNumbers objectAtIndex:0];
                 CNPhoneNumber *number = firstPhone.value;
                 NSString *digits = number.stringValue; // 1234567890
                 NSString *label = firstPhone.label;
                 
                 //                 objContactModel.strContactNumber = [NSString stringWithFormat:@"%@ : %@", label, digits];
                 strContactNumber = [NSString stringWithFormat:@"%@", digits];
             }
             else
             {
                 strContactNumber = @"";
             }
             
             i++;
             
             NSMutableDictionary *dictContact = [[NSMutableDictionary alloc] init];
             [dictContact setObject:strFullName forKey:@"name"];
             [dictContact setObject:strContactNumber forKey:@"number"];
             
             [self.arrayAllContacts addObject:dictContact];
             
        }];
    }
    
    [[MySingleton sharedManager].dataManager user_uploadContacts:self.arrayAllContacts];
}

@end
