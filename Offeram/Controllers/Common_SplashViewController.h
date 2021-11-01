//
//  Common_SplashViewController.h
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface Common_SplashViewController : UIViewController<UIScrollViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinates;
}

//========== IBOUTLETS ==========//

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewBackground;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewLogo;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *arrayAllContacts;

@property (nonatomic,strong) NSString *strLatitude;
@property (nonatomic,strong) NSString *strLongitude;

@end
