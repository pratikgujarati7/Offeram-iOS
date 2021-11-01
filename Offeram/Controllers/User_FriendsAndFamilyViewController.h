//
//  User_FriendsAndFamilyViewController.h
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface User_FriendsAndFamilyViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *sectionContainerView;

@property (nonatomic,retain) IBOutlet UIView *myContactsView;
@property (nonatomic,retain) IBOutlet UILabel *lblMyContacts;
@property (nonatomic,retain) IBOutlet UIButton *btnMyContacts;
@property (nonatomic,retain) IBOutlet UIView *btnMyContactsBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIView *topTenView;
@property (nonatomic,retain) IBOutlet UILabel *lblTopTen;
@property (nonatomic,retain) IBOutlet UIButton *btnTopTen;
@property (nonatomic,retain) IBOutlet UIView *btnTopTenBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property(nonatomic, assign) BOOL isMyContactSegmentSelected;

@property (nonatomic,retain) NSMutableArray *dataRows;

@end

NS_ASSUME_NONNULL_END
