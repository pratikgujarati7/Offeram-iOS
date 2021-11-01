//
//  User_EditProfileViewController.h
//  Offeram
//
//  Created by Dipen Lad on 06/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "AsyncImageView.h"

@interface User_EditProfileViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewProfilePicture;

@property (nonatomic,retain) IBOutlet UIView *ProfileDetilsContainerView;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtUserName;
@property (nonatomic,retain) IBOutlet UIView *txtUserNameBottomSeparatorView;
@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) UIImage *imageSelectedPicture;
@property (nonatomic,retain) NSData *imageSelectedPictureData;

// NOTIFICATION ADJUSTMENTS
@property(nonatomic, assign) BOOL isImageChanged;

@end
