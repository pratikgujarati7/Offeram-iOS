//
//  User_OutletDetailsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import <GoogleMaps/GoogleMaps.h>

#import "Merchant.h"
#import "Outlet.h"

@interface User_OutletDetailsViewController : UIViewController <UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet GMSMapView *mapView;

@property (nonatomic,retain) IBOutlet UIView *outletDetailsContainerView;
@property (nonatomic,retain) IBOutlet UIView *outletDetailsShadowContainerView;
@property (nonatomic,retain) IBOutlet AsyncImageView *companyLogoImage;
@property (nonatomic,retain) IBOutlet UILabel *lblComapnyName;
@property (nonatomic,retain) IBOutlet UILabel *lblRatings;
@property (nonatomic,retain) IBOutlet UILabel *lblLocation;
@property (nonatomic,retain) IBOutlet UILabel *lblAddress;
@property (nonatomic,retain) IBOutlet UILabel *lblAddressValue;
@property (nonatomic,retain) IBOutlet UILabel *lblTimings;

@property (nonatomic,retain) IBOutlet UIView *openInGoogleMapContainerView;
@property (nonatomic,retain) IBOutlet UIView *openInGoogleMapShadowContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *openInGoogleMapImage;
@property (nonatomic,retain) IBOutlet UILabel *lblopenInGoogleMap;
@property (nonatomic,retain) IBOutlet UIButton *btnOpenInGoogleMap;

//========== OTHER VARIABLES ==========//
@property (nonatomic,strong) Merchant *objMerchant;
@property (nonatomic,strong) Outlet *objSelectedOutlet;



@end
