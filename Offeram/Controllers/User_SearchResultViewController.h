//
//  User_SearchResultViewController.h
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface User_SearchResultViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinates;
}

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,strong) NSString *strLatitude;
@property (nonatomic,strong) NSString *strLongitude;

@property (nonatomic,retain) NSString *strSearchString;
@property (nonatomic,retain) NSMutableArray *dataRows;

@end
