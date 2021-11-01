//
//  User_TambolaTicketsListViewController.h
//  Offeram
//
//  Created by Innovative Iteration on 27/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PaymentsSDK.h"

@interface User_TambolaTicketsListViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, PGTransactionDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UILabel *navigationTitle;

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, retain) IBOutlet UITableView *mainTableView;

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

@property (nonatomic,retain) NSMutableArray *dataRowsActiveTambolaTickets;
@property (nonatomic,retain) NSMutableArray *dataRowsCompletedTambolaTickets;

@end
