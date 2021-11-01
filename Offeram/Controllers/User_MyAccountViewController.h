//
//  User_MyAccountViewController.h
//  Offeram
//
//  Created by Dipen Lad on 14/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface User_MyAccountViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UILabel *navigationTitle;

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewProfilePicture;
@property (nonatomic,retain) IBOutlet UIButton *btnEditProfile;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;
@property (nonatomic,retain) IBOutlet UILabel *lblMobileNumber;
@property (nonatomic,retain) IBOutlet UILabel *lblValidity;

@property (nonatomic,retain) IBOutlet UIView *sectionHeaderContainerView;

@property (nonatomic,retain) IBOutlet UIView *btnOfferamCoinsContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewOfferamCoins;
@property (nonatomic,retain) IBOutlet UIButton *btnOfferamCoins;
@property (nonatomic,retain) IBOutlet UIView *btnOfferamCoinsBottomBorderView;
//OFFERAM COINS CONTAINER
@property (nonatomic,retain) IBOutlet UIView *offeramCoinsContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferamCoins;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferamCoinsBalance;
@property (nonatomic,retain) IBOutlet UILabel *lblEarned;
@property (nonatomic,retain) IBOutlet UIButton *btnKnowMoreAboutOfferamCoins;
@property (nonatomic,retain) IBOutlet UIView *btnTransactionHistoryContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewTransactionHistory;
@property (nonatomic,retain) IBOutlet UIButton *btnTransactionHistory;

@property (nonatomic,retain) IBOutlet UIView *btnFemilyAndFriendsContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewFemilyAndFriends;
@property (nonatomic,retain) IBOutlet UIButton *btnFemilyAndFriends;
@property (nonatomic,retain) IBOutlet UIView *btnFemilyAndFriendsBottomBorderView;
//FAMILY AND FRIENDS CONTAINER
@property (nonatomic,retain) IBOutlet UIView *femilyAndFriendsContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblFemilyAndFriends;
@property (nonatomic,retain) IBOutlet UIButton *btnSeeTopRedeemers;
@property (nonatomic,retain) IBOutlet UILabel *lblIndex;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewIndexProfile;
@property (nonatomic,retain) IBOutlet UILabel *lblIndexName;
@property (nonatomic,retain) IBOutlet UILabel *lblIndexRedeemed;

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

@end
