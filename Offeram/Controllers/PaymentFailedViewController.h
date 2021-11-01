//
//  PaymentFailedViewController.h
//  Offeram
//
//  Created by Dipen Lad on 11/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentsSDK.h"

@interface PaymentFailedViewController : UIViewController <UIScrollViewDelegate, PGTransactionDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewMain;

@property (nonatomic,retain) IBOutlet UILabel *lblTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblDescription;

@property (nonatomic,retain) IBOutlet UIButton *btnTryAgain;

//========== OTHER VARIABLES ==========//
@property (nonatomic,retain) NSString *strAmount;
@property (nonatomic,retain) NSString *strPromotionCode;

@property (nonatomic,assign) int intLoadedFor;//1 - for Package/Buy now from HomeController, 2 - Tambola Ticket

@end
