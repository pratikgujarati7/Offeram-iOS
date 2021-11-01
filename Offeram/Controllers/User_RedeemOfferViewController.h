//
//  User_RedeemOfferViewController.h
//  Offeram
//
//  Created by Dipen Lad on 05/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "MTBBarcodeScanner.h"

#import "Coupon.h"

@interface User_RedeemOfferViewController : UIViewController  <UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UILabel *lblUsingPin;

@property (nonatomic,retain) IBOutlet UIView *enterPinContainerView;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtEnterPin;
@property (nonatomic,retain) IBOutlet UIView *txtEnterPinBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UILabel *lblOr;

@property (nonatomic,retain) IBOutlet UIView *viewBarcodeScanner;
@property (nonatomic,retain) IBOutlet UIButton *btnReScan;
@property (nonatomic,retain) IBOutlet UILabel *lblScanUserCode;

@property (nonatomic,retain) IBOutlet UIButton *btnProceed;

//========== OTHER VARIABLES ==========//

@property (nonatomic,strong) Coupon *objSelectedCoupon;
@property(nonatomic, assign) BOOL isPingedOffer;

@property (nonatomic,retain) NSString *strScannedBarCode;
@property (nonatomic,assign) BOOL boolScannedCodeIsBarCode;

@property (nonatomic,retain) MTBBarcodeScanner *scanner;
@property (nonatomic,assign) BOOL boolIsTorchOn;

@end
