//
//  User_AboutUsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 19/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User_AboutUsViewController : UIViewController <UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet UIView *topSeparatorView;
@property (nonatomic,retain) IBOutlet UILabel *lblDescription;
@property (nonatomic,retain) IBOutlet UIView *bottomSeparatorView;

@property (nonatomic,retain) IBOutlet UILabel *lblCompanyName;
@property (nonatomic,retain) IBOutlet UILabel *lblAddress;
@property (nonatomic,retain) IBOutlet UILabel *lblAddressValue;
@property (nonatomic,retain) IBOutlet UILabel *lblContact;
@property (nonatomic,retain) IBOutlet UILabel *lblEmail;

//========== OTHER VARIABLES ==========//

@end
