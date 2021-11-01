//
//  User_ShareCouponDescriptionViewController.h
//  Offeram
//
//  Created by Dipen Lad on 19/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface User_ShareCouponDescriptionViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewPingBanner;
@property (nonatomic,retain) IBOutlet UILabel *lblHowToPingBanner;

@property (nonatomic,retain) IBOutlet UIView *useHowToPingContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblHowToPingAndwer;

@property (nonatomic,retain) IBOutlet UIView *whyToPingContainerView;
@property (nonatomic,retain) IBOutlet UIView *whyToPingTitleContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewPing;
@property (nonatomic,retain) IBOutlet UILabel *lblWhyToPing;
@property (nonatomic,retain) IBOutlet UILabel *lblWhyToPingAndwer;

@property (nonatomic,retain) IBOutlet UILabel *lblStartPing;

@property (nonatomic,retain) IBOutlet UIButton *btnPingNow;

@end

NS_ASSUME_NONNULL_END
