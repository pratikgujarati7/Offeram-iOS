//
//  User_RegisterForTambolaViewController.h
//  Offeram
//
//  Created by Innovative Iteration on 29/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "AsyncImageView.h"

#import "City.h"
#import "TambolaTicket.h"

#import "PaymentsSDK.h"

@interface User_RegisterForTambolaViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, PGTransactionDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtName;
@property (nonatomic,retain) IBOutlet UIView *txtNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMobileNumber;
@property (nonatomic,retain) IBOutlet UIView *txtMobileNumberBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtEmail;
@property (nonatomic,retain) IBOutlet UIView *txtEmailBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtArea;
@property (nonatomic,retain) IBOutlet UIView *txtAreaBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtCity;
@property (nonatomic,retain) IBOutlet UIView *txtCityBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIView *ticketChargesContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTicket;

@property (nonatomic,retain) IBOutlet UIButton *btnRegister;

//========== OTHER VARIABLES ==========//
@property (nonatomic,retain) UIPickerView *cityPickerView;
@property (nonatomic,retain) NSMutableArray *arrayAllCity;
@property (nonatomic,retain) City *objSelectedCity;

@property (nonatomic,retain) TambolaTicket *objSelectedTambolaTicket;

@end
