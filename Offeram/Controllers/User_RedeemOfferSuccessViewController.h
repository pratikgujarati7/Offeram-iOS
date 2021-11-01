//
//  User_RedeemOfferSuccessViewController.h
//  Offeram
//
//  Created by Dipen Lad on 05/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User_RedeemOfferSuccessViewController : UIViewController <UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewSuccess;

@property (nonatomic,retain) IBOutlet UILabel *lblTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblDescription;

@property (nonatomic,retain) IBOutlet UIButton *btnOk;



@property (nonatomic,retain) IBOutlet UIView *rateUsContainerView;
@property (nonatomic,retain) IBOutlet UIView *rateUsInnerContainerView;

@property (nonatomic,retain) IBOutlet UILabel *lblRateUsTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblRateUSDescription;

@property (nonatomic,retain) IBOutlet UIView *checkboxContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewCheckbox;
@property (nonatomic,retain) IBOutlet UILabel *lblNeverShowAgain;
@property (nonatomic,retain) IBOutlet UIButton *btnCheckbox;

@property (nonatomic,retain) IBOutlet UIButton *btnRateNow;
@property (nonatomic,retain) IBOutlet UIButton *btnRateLater;

@property (nonatomic,assign) BOOL boolIsRateViewOpened;

@end
