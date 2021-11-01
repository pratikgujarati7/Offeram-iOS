//
//  User_BuyNowViewController.h
//  Offeram
//
//  Created by Dipen Lad on 11/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

#import "PaymentsSDK.h"

@interface User_BuyNowViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, PGTransactionDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *billViewWithbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMRPWithbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMRPValueWithbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UIButton *btnHaveCode;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalWithbtnHaveCodeContainer;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalValueWithbtnHaveCodeContainer;

@property (nonatomic,retain) IBOutlet UIView *enterCodeContainerView;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtEnterCode;
@property (nonatomic,retain) IBOutlet UIView *txtEnterCodeBottomSeparatorView;
@property (nonatomic,retain) IBOutlet UIButton *btnApply;

@property (nonatomic,retain) IBOutlet UIView *billViewWithoutbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMRPWithoutbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMRPValueWithoutbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalWithoutbtnHaveCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalValueWithoutbtnHaveCodeContainerView;

@property (nonatomic,retain) IBOutlet UIView *billViewWithAppliedCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMRPWithAppliedCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblMRPValueWithAppliedCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblDiscountAmount;
@property (nonatomic,retain) IBOutlet UILabel *lblDiscountAmountValue;
@property (nonatomic,retain) IBOutlet UILabel *lblCouponDescriptin;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalWithAppliedCodeContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalValueWithAppliedCodeContainerView;

@property (nonatomic,retain) IBOutlet UIButton *btnBuyNow;

//========== OTHER VARIABLES ==========//

@end
