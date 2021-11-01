//
//  User_ReferAndEarnViewController.h
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface User_ReferAndEarnViewController : UIViewController <UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UILabel *lblOfferamCoinsEarned;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferamCoinsEarnedValue;
@property (nonatomic,retain) IBOutlet UIButton *btnLearnMoreAboutCoins;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewOfferamCoin;

@property (nonatomic,retain) IBOutlet UIView *referContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblReferAFriend;

@property (nonatomic,retain) IBOutlet UIView *qrCodeContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewQrCode;

@property (nonatomic,retain) IBOutlet UILabel *lblShareThisQrCode;
@property (nonatomic,retain) IBOutlet UILabel *lblQrCodeText;

@property (nonatomic,retain) IBOutlet UILabel *lblInviteFriendOnSocialMedia;

@property (nonatomic,retain) IBOutlet UIView *socialMediaContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewSocialMedia;
@property (nonatomic,retain) IBOutlet UIButton *btnSocialMedia;

//========== OTHER VARIABLES ==========//

@end

NS_ASSUME_NONNULL_END
