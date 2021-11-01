//
//  User_OutletsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"
#import "Outlet.h"

@interface User_OutletsViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIButton *btnClose;

@property (nonatomic,retain) IBOutlet UIView *innerContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblCompanName;
@property (nonatomic,retain) IBOutlet UILabel *lblOutletsCount;

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,strong) Merchant *objMerchant;
@property (nonatomic,retain) NSMutableArray *dataRows;

@property (nonatomic,strong) Outlet *objSelectedOutlet;

// METHODS
-(void)setupInitialView;
-(void)showOutlets;

@end
