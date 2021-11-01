//
//  User_RegisterViewController.h
//  Offeram
//
//  Created by Dipen Lad on 10/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@interface User_RegisterViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *logoBackgroundView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet UILabel *lblCreateAccount;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewFullName;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtFullName;
@property (nonatomic,retain) IBOutlet UIView *txtFullNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewMobile;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMobileNumber;
@property (nonatomic,retain) IBOutlet UIView *txtMobileNumberBottomSeparatorView;
@property (nonatomic,retain) IBOutlet UILabel *lblMobileNumberDescription;

@property (nonatomic,retain) IBOutlet UIButton *btnRegister;

@property (nonatomic,retain) IBOutlet UILabel *lblTermsAndConditions;

@property (nonatomic,retain) IBOutlet UIButton *btnSignIn;

//========== OTHER VARIABLES ==========//

@end
