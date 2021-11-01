//
//  AppDelegate.h
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "Common_SplashViewController.h"
#import "User_HomeViewController.h"
#import "User_TambolaTicketsListViewController.h"
#import "User_ViewOffersViewController.h"
#import "MBProgressHUD.h"
#import "NYAlertViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Common_SplashViewController *splashVC;
@property (strong, nonatomic) UINavigationController *navC;

-(void)showAlertViewWithTitle:(NSString *)title withDetails:(NSString *)detail;

-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
-(void)dismissGlobalHUD;

-(BOOL)isClock24Hour;
-(NSString *)getUTCFormateDate:(NSDate *)localDate;

@end

