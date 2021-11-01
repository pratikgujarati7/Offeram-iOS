//
//  User_PingOfferViewController.h
//  Offeram
//
//  Created by Dipen Lad on 16/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface User_PingOfferViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mobileNumberContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblPingOfferDescription;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMobileNumber;
@property (nonatomic,retain) IBOutlet UIView *txtMobileNumberBottomSeparatorView;
@property (nonatomic,retain) IBOutlet UIButton *btnPing;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSString *strCouponID;

@end

NS_ASSUME_NONNULL_END
