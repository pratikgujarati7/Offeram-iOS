//
//  AppDelegate.m
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "AppDelegate.h"
#import "MySingleton.h"

#import "SSKeychain.h"
#import <GoogleMaps/GoogleMaps.h>

@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // FIREBASE CRASHLYTICS CONFIGURATION
    [FIRApp configure];
    
    // GOOGLE MAPS KEY
    [GMSServices provideAPIKey:@"AIzaSyCg1eQ7RffNpAw9c8mx9e3E37PzYnWXwDk"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSUUID *deviceId;
#if !TARGET_IPHONE_SIMULATOR
    deviceId = [UIDevice currentDevice].identifierForVendor;
#else
    deviceId = [[NSUUID alloc] initWithUUIDString:@"A5D59C2F-FE68-4BE7-B318-95029619C759"];
#endif
    
    NSString *strUUID = [deviceId UUIDString];
    [prefs setObject:strUUID forKey:@"UUID"];
    [prefs setObject:@"0" forKey:@"IsClosedTambolaAlert"];
    [prefs synchronize];
    
    NSError *error = nil;
    NSString *strStoredUUID = [SSKeychain passwordForService:@"UUID" account:@"UUID" error:&error];
    
    if ([error code] == SSKeychainErrorNotFound)
    {
        NSLog(@"UUID not stored");
        NSLog(@"UUID : %@", strUUID);
        
        [SSKeychain setPassword:strUUID forService:@"UUID" account:@"UUID"];
    }
    else
    {
        NSLog(@"UUID already stored");
        NSLog(@"UUID : %@", strStoredUUID);
        
        [prefs setObject:strStoredUUID forKey:@"UUID"];
        [prefs synchronize];
    }
    
    //#if !(TARGET_IPHONE_SIMULATOR)
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0"))
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if(!error && granted)
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
                 
                 NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                 [prefs setObject:@"" forKey:@"device_id"];
                 [prefs synchronize];
             }
         }];
    }
    else
    {
        //-- Set Notification
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        }
    }
    //#endif
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(notification)
    {
        [MySingleton sharedManager].dataManager.boolIsAppOpenedFromNotification = true;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.splashVC = [[Common_SplashViewController alloc] init];
    self.navC = [[UINavigationController alloc]initWithRootViewController:self.splashVC];
    self.window.rootViewController = self.navC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.window endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackgroundEvent" object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForegroundEvent" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification Methods

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    NSDictionary *dictParameters = [notification.request.content.userInfo objectForKey:@"aps"];
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
    
    NSDictionary *dictParameters = [response.notification.request.content.userInfo objectForKey:@"aps"];
    
    [MySingleton sharedManager].dataManager.strNotificationMerchantId = [dictParameters valueForKey:@"merchant_id"];
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive || [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground || [[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive)
    {
        if ([MySingleton sharedManager].dataManager.boolIsAppOpenedFromNotification == false)
        {
            if ([dictParameters valueForKey:@"merchant_id"] != nil && [[dictParameters valueForKey:@"merchant_id"] integerValue] > 0)
            {
                User_ViewOffersViewController *viewController = [[User_ViewOffersViewController alloc] init];
                viewController.strMerchantID = [dictParameters valueForKey:@"merchant_id"];
                [self.navC pushViewController:viewController animated:true];
            }
            else
            {
//                User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
                User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
                [self.navC pushViewController:viewController animated:true];
            }
            
//            if ([MySingleton sharedManager].dataManager.boolIsNotificationScreenOpened == false)
//            {
//                if ([dictParameters valueForKey:@"merchant_id"] != nil && [[dictParameters valueForKey:@"merchant_id"] integerValue] > 0)
//                {
//                    User_ViewOffersViewController *viewController = [[User_ViewOffersViewController alloc] init];
//                    viewController.strMerchantID = [dictParameters valueForKey:@"merchant_id"];
//                    [self.navC pushViewController:viewController animated:true];
//                }
//                else
//                {
//                    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
//                    [self.navC pushViewController:viewController animated:true];
//                }
//            }
//            else
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotificationReceivedWhenNotificationScreenOpened" object:nil];
//            }
        }
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *strDeviceToken = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" "
                                withString:@""];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:strDeviceToken forKey:@"device_id"];
    [prefs synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceTokenGeneratedEvent" object:nil];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError, error  : %@",error);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"" forKey:@"device_id"];
    [prefs synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceTokenGeneratedEvent" object:nil];
}

// will be called when in foreground
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification called.");
    
    // iOS 10 will handle notifications through other methods
    
    if( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"10.0" ) )
    {
        NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
        // set a member variable to tell the new delegate that this is background
        return;
    }
    NSLog( @"HANDLE PUSH, didReceiveRemoteNotification: %@", userInfo );
    
    // custom code to handle notification content
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = @"Notification";
        alertViewController.message = message;
        
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
        });
    }
    else
    {
        //Do stuff that you would do if the application was not active
    }
}

#pragma mark - Other Methods

-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    [self dismissGlobalHUD];
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    hud.dimBackground = YES;
    return hud;
}

-(void)dismissGlobalHUD
{
    UIWindow *window = [(AppDelegate* )[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

//=========================FUNCTION TO SHOW THE NYAlertViewController ========================//

-(void)showAlertViewWithTitle:(NSString *)title withDetails:(NSString *)detail
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = title;
    alertViewController.message = detail;
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
    });
}

-(BOOL)isClock24Hour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
    return is24h;
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}


@end
