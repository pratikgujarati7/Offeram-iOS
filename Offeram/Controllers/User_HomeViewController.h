//
//  User_HomeViewController.h
//  Offeram
//
//  Created by Dipen Lad on 11/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "User_FilterOutletsViewController.h"

#import "AsyncImageView.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface User_HomeViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinates;
}

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewLogo;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewTextLogo;
@property (nonatomic,retain) IBOutlet UILabel *lblCityName;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewFilter;
@property (nonatomic,retain) IBOutlet UIButton *btnFilter;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewSearch;
@property (nonatomic,retain) IBOutlet UIButton *btnSearch;

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *tambolaMainContainerView;
@property (nonatomic,retain) IBOutlet UIView *tambolaMainContainerBackgroundView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewTambolaInBanner;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewTambolaClose;
@property (nonatomic,retain) IBOutlet UIButton *btnTambolaClose;
@property (nonatomic,retain) IBOutlet UILabel *lblTambolaTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblTambolaDescription;
@property (nonatomic,retain) IBOutlet UILabel *lblTambolaTotalRegisteredCount;
@property (nonatomic,retain) IBOutlet UIButton *btnTambolaRegister;
@property (nonatomic,retain) IBOutlet UIButton *btnTambolaKnowMore;

@property (nonatomic,retain) IBOutlet UIView *segmentContainerView;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

@property (nonatomic,retain) IBOutlet UIButton *btnBuyNow;

@property (nonatomic,retain) IBOutlet UIView *alertMessageMainContainerView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewAlertMessage;
@property (nonatomic,retain) IBOutlet UILabel *lblAlertMessage;

// BOTTOM BAR VIEW
@property (nonatomic,retain) IBOutlet UIView *bottomBarView;

@property (nonatomic,retain) IBOutlet UIView *offersContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewOffers;
@property (nonatomic,retain) IBOutlet UILabel *lblOffers;
@property (nonatomic,retain) IBOutlet UIButton *btnOffers;

@property (nonatomic,retain) IBOutlet UIView *tambolaContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewTambola;
@property (nonatomic,retain) IBOutlet UILabel *lblTambola;
@property (nonatomic,retain) IBOutlet UIButton *btnTambola;

@property (nonatomic,retain) IBOutlet UIView *favouritesContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewFavourites;
@property (nonatomic,retain) IBOutlet UILabel *lblFavourites;
@property (nonatomic,retain) IBOutlet UIButton *btnFavourites;

@property (nonatomic,retain) IBOutlet UIView *notificationsContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewNotifications;
@property (nonatomic,retain) IBOutlet UILabel *lblNotifications;
@property (nonatomic,retain) IBOutlet UIButton *btnNotifications;

@property (nonatomic,retain) IBOutlet UIView *myAccountContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewMyAccount;
@property (nonatomic,retain) IBOutlet UILabel *lblMyAccount;
@property (nonatomic,retain) IBOutlet UIButton *btnMyAccount;

//========== OTHER VARIABLES ==========//

@property (nonatomic,strong) NSString *strLatitude;
@property (nonatomic,strong) NSString *strLongitude;

@property (nonatomic,retain) NSMutableArray *arrayAllMerchantsLocal;
@property (nonatomic,retain) NSMutableArray *dataRows;

@property (nonatomic,retain) NSMutableArray *arrayAllCategories;

@property (nonatomic,retain) NSMutableArray *arraySelectedAreasIds;

@property (nonatomic,retain) User_FilterOutletsViewController *filterViewController;

@end
