//
//  PaymentSucceedViewController.h
//  Offeram
//
//  Created by Dipen Lad on 11/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSucceedViewController : UIViewController <UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewMain;

@property (nonatomic,retain) IBOutlet UILabel *lblTitle;

@property (nonatomic,retain) IBOutlet UIButton *btnProceed;

//========== OTHER VARIABLES ==========//
@property (nonatomic,assign) int intLoadedFor;//1 - for Package/Buy now from HomeController, 2 - Tambola Ticket

@end
