//
//  User_SearchViewController.h
//  Offeram
//
//  Created by Dipen Lad on 06/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@interface User_SearchViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtSearch;
@property (nonatomic,retain) IBOutlet UIView *txtSearchBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *arrayAllMerchantsLocal;
@property (nonatomic,retain) NSMutableArray *dataRows;

@end
