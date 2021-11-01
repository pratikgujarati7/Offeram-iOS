//
//  User_VerifyOtpViewController.h
//  Offeram
//
//  Created by Dipen Lad on 10/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "AsyncImageView.h"

@interface User_VerifyOtpViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *logoBackgroundView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet UILabel *lblAlmostDone;
@property (nonatomic,retain) IBOutlet UIImageView *imageviewDiscount;

@property (nonatomic,retain) IBOutlet UILabel *lblOtpVerificationTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblOtpSent;

@property (nonatomic,retain) IBOutlet UIView *otp1ContainerView;
@property (nonatomic,retain) IBOutlet UITextField *txtOtp1;
@property (nonatomic,retain) IBOutlet UIView *otp2ContainerView;
@property (nonatomic,retain) IBOutlet UITextField *txtOtp2;
@property (nonatomic,retain) IBOutlet UIView *otp3ContainerView;
@property (nonatomic,retain) IBOutlet UITextField *txtOtp3;
@property (nonatomic,retain) IBOutlet UIView *otp4ContainerView;
@property (nonatomic,retain) IBOutlet UITextField *txtOtp4;

@property (nonatomic,retain) IBOutlet UIButton *btnResendOtp;

@property (nonatomic,retain) IBOutlet UIButton *btnVerify;

@property (nonatomic,retain) IBOutlet UIView *backContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UILabel *lblBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;

@property (nonatomic,retain) IBOutlet UIView *referralCodeContainerView;

@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewProfilePicture;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtUserName;
@property (nonatomic,retain) IBOutlet UIView *txtUserNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIButton *btnHavePromoCode;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtReferralCode;
@property (nonatomic,retain) IBOutlet UIView *txtReferralCodeBottomSeparatorView;
@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;


//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSString *strPhoneNumber;
@property (nonatomic,retain) NSString *strCityId;
@property (nonatomic,retain) NSString *strDeviceToken;

@property (nonatomic,retain) UIImage *imageSelectedPicture;
@property (nonatomic,retain) NSData *imageSelectedPictureData;

// NOTIFICATION ADJUSTMENTS
@property(nonatomic, assign) BOOL isImageChanged;

@end
