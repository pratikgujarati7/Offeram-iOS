//
//  User_OfferamCoinsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface User_OfferamCoinsViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewOfferamCoinBackground;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewOfferamCoin;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferamCoinsEarned;
@property (nonatomic,retain) IBOutlet UILabel *lblOfferamCoinsEarnedValue;

@property (nonatomic,retain) IBOutlet UIView *earnOfferamCoinsContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblHowToEarnCoins;
@property (nonatomic,retain) IBOutlet UILabel *lblHowToEarnCoinsAndwer;
//1
@property (nonatomic,retain) IBOutlet UIView *oneContainerView;
@property (nonatomic,retain) IBOutlet UIView *oneTitleContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblOneCount;
@property (nonatomic,retain) IBOutlet UILabel *lblOneTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblOneEarning;
@property (nonatomic,retain) IBOutlet UILabel *lblOneDescription;

//2
@property (nonatomic,retain) IBOutlet UIView *twoContainerView;
@property (nonatomic,retain) IBOutlet UIView *twoTitleContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblTwoCount;
@property (nonatomic,retain) IBOutlet UILabel *lblTwoTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblTwoEarning;
@property (nonatomic,retain) IBOutlet UILabel *lblTwoDescription;
@property (nonatomic,retain) IBOutlet UIButton *btnTwo;

//3
@property (nonatomic,retain) IBOutlet UIView *threeContainerView;
@property (nonatomic,retain) IBOutlet UIView *threeTitleContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblThreeCount;
@property (nonatomic,retain) IBOutlet UILabel *lblThreeTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblThreeEarning;
@property (nonatomic,retain) IBOutlet UILabel *lblThreeDescription;
@property (nonatomic,retain) IBOutlet UIButton *btnThree;

//4
@property (nonatomic,retain) IBOutlet UIView *fourContainerView;
@property (nonatomic,retain) IBOutlet UIView *fourTitleContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblFourCount;
@property (nonatomic,retain) IBOutlet UILabel *lblFourTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblFourEarning;
@property (nonatomic,retain) IBOutlet UILabel *lblFourDescription;
@property (nonatomic,retain) IBOutlet UIButton *btnFour;

@property (nonatomic,retain) IBOutlet UIView *coinChartContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblCoinChart;
@property (nonatomic,retain) IBOutlet UILabel *lblCoinChartParams;
@property (nonatomic,retain) IBOutlet UILabel *lblCoinChartValues;

@property (nonatomic,retain) IBOutlet UIView *useOfferamCoinsContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblHowToUseCoins;
@property (nonatomic,retain) IBOutlet UILabel *lblHowToUseCoinsAndwer;

//========== OTHER VARIABLES ==========//

@end

NS_ASSUME_NONNULL_END
