//
//  User_ViewRatingsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 09/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchant.h"

@interface User_ViewRatingsViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIButton *btnClose;

@property (nonatomic,retain) IBOutlet UIView *innerContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblCompanyName;
@property (nonatomic,retain) IBOutlet UILabel *lblReviewCount;

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,strong) Merchant *objMerchant;

// METHODS
-(void)setupInitialView;
-(void)showReview;

@end
