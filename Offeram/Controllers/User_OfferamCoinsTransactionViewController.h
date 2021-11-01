//
//  User_OfferamCoinsTransactionViewController.h
//  Offeram
//
//  Created by Dipen Lad on 01/12/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface User_OfferamCoinsTransactionViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

@property (nonatomic,retain) IBOutlet UIView *balanceContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTransactions;
@property (nonatomic,retain) IBOutlet UILabel *lblCurrentBalance;
@property (nonatomic,retain) IBOutlet UILabel *lblCurrentBalanceValue;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *dataRows;

@end

NS_ASSUME_NONNULL_END
