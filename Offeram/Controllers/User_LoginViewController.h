//
//  User_LoginViewController.h
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "City.h"

@interface User_LoginViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *logoBackgroundView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet UILabel *lblReadyFor;
@property (nonatomic,retain) IBOutlet UIImageView *imageviewDiscount;

@property (nonatomic,retain) IBOutlet UILabel *lblSignIn;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewMobile;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMobileNumber;
@property (nonatomic,retain) IBOutlet UIView *txtMobileNumberBottomSeparatorView;
@property (nonatomic,retain) IBOutlet UILabel *lblMobileNumberDescription;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewCity;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtCity;
@property (nonatomic,retain) IBOutlet UIView *txtCityBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIButton *btnSignIn;

@property (nonatomic,retain) IBOutlet UILabel *lblTermsAndConditions;

@property (nonatomic,retain) IBOutlet UIButton *btnSignUp;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) UIPickerView *cityPickerView;
@property (nonatomic,retain) NSMutableArray *arrayAllCity;
@property (nonatomic,retain) City *objSelectedCity;

@end
