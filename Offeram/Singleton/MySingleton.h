//
//  MySingleton.h
//  Coupon Bouquet
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataManager.h"
//
//#import "LGSideMenuController.h"
//#import "UIViewController+LGSideMenuController.h"
//
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MySingleton : NSObject

+(MySingleton *)sharedManager;

@property (nonatomic, retain) DataManager *dataManager;

@property (nonatomic, assign) CGRect screenRect;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, assign) CGSize keyboardSize;

//========================= APPLICATION SPECIFIC SETTINGS ================//
@property (nonatomic, assign) float floatAreaPickerTableViewWidth;

@property (nonatomic, retain) NSString *strSocialMediaShareSubject;
@property (nonatomic, retain) NSString *striOSAppUrlForUsers;
@property (nonatomic, assign) int intiOSAppstoreId;
@property (nonatomic, retain) NSString *strAndroidAppUrlForUsers;
@property (nonatomic, retain) NSString *strSocialMediaShareMessage;

//========================= SIDE MENU SETTINGS ================//
@property (nonatomic, assign) float floatLeftSideMenuWidth;
@property (nonatomic, assign) float floatRightSideMenuWidth;

//@property (nonatomic, assign) LGSideMenuPresentationStyle leftViewPresentationStyle;
//@property (nonatomic, assign) LGSideMenuPresentationStyle rightViewPresentationStyle;

@property (nonatomic, retain) UIFont  *themeFontWorthTitle;
@property (nonatomic, retain) UIFont  *themeFontWorthValue;

//========================= NAVIGATION BAR SETTINGS ================//
@property (nonatomic, retain) UIColor *navigationBarBackgroundColor;
@property (nonatomic, retain) UIColor *navigationBarTitleColor;
@property (nonatomic, retain) UIFont *navigationBarTitleFont;
@property (nonatomic, retain) UIFont *navigationBarTitleSmallFont;

//========================= THEME GLOBAL COLORS SETTINGS ================//
@property (nonatomic, retain) UIColor *themeGlobalBackgroundColor;
@property (nonatomic, retain) UIColor *themeGlobalTransperentBlackBackgroundColor;
@property (nonatomic, retain) UIColor *themeGlobalBlueColor;
@property (nonatomic, retain) UIColor *themeGlobalOrangeColor;
@property (nonatomic, retain) UIColor *themeGlobalGreenColor;
@property (nonatomic, retain) UIColor *themeGlobalRedColor;
@property (nonatomic, retain) UIColor *themeGlobalWhiteColor;
@property (nonatomic, retain) UIColor *themeGlobalBlackColor;
@property (nonatomic, retain) UIColor *themeGlobalDarkGreyColor;
@property (nonatomic, retain) UIColor *themeGlobalLightGreyColor;
@property (nonatomic, retain) UIColor *themeGlobalSeperatorGreyColor;
@property (nonatomic, retain) UIColor *themeGlobalSideMenuSeperatorColor;
@property (nonatomic, retain) UIColor *themeGlobalCouponListGreyColor;

@property (nonatomic, retain) UIColor *textfieldPlaceholderColor;
@property (nonatomic, retain) UIColor *textfieldPlaceholderGreyColor;
@property (nonatomic, retain) UIColor *textfieldTextColor;
@property (nonatomic, retain) UIColor *textfieldTintColor;
@property (nonatomic, retain) UIColor *textfieldDisabledTextColor;
@property (nonatomic, retain) UIColor *textfieldBorderColor;
@property (nonatomic, assign) float floatTextfieldBorderWidth;
@property (nonatomic, retain) UIColor *textfieldFloatingLabelTextColor;
@property (nonatomic, retain) UIColor *textfieldBottomSeparatorColor;

@property (nonatomic, retain) UIColor *themeGlobalButtonDisabledBackgroundGreyColor;
@property (nonatomic, retain) UIColor *themeGlobalButtonDisabledTextColor;

@property (nonatomic, retain) UIColor *themeGlobalUsedCouponsInnerContainerBackgroundColor;
@property (nonatomic, retain) UIColor *themeGlobalUsedCouponsSerialNumberBackgroundColor;

@property (nonatomic, retain) UIColor *pageIndicatorTintColor;
@property (nonatomic, retain) UIColor *currentPageIndicatorTintColorPage1;
@property (nonatomic, retain) UIColor *currentPageIndicatorTintColor;

// NEW VERIABLES BY DIPEN
@property (nonatomic, assign) float floatOutletTableViewWidth;


//========================= FLOAT VALUES SETTINGS ================//
@property (nonatomic, assign) float floatButtonCornerRadius;

//========================= THEME REGULAR FONTS SETTING ================//
@property (nonatomic, retain) UIFont  *themeFontFourSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFiveSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontSixSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontSevenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontEightSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontNineSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontElevenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwelveSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirteenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourteenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFifteenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontSixteenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontSeventeenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontEighteenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontNineteenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentySizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyOneSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyTwoSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyThreeSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyFourSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyFiveSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentySixSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentySevenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyEightSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontTwentyNineSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtySizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyOneSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyTwoSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyThreeSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyFourSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyFiveSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtySixSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtySevenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyEightSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontThirtyNineSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtySizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtyOneSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtyTwoSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtyThreeSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtyFourSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtyFiveSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtySixSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtySevenSizeRegular;
@property (nonatomic, retain) UIFont  *themeFontFourtyEightSizeRegular;

//========================= THEME LIGHT FONTS SETTINGS ================//
@property (nonatomic, retain) UIFont  *themeFontFourSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFiveSizeLight;
@property (nonatomic, retain) UIFont  *themeFontSixSizeLight;
@property (nonatomic, retain) UIFont  *themeFontSevenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontEightSizeLight;
@property (nonatomic, retain) UIFont  *themeFontNineSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontElevenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwelveSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirteenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourteenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFifteenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontSixteenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontSeventeenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontEighteenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontNineteenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentySizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyOneSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyTwoSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyThreeSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyFourSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyFiveSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentySixSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentySevenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyEightSizeLight;
@property (nonatomic, retain) UIFont  *themeFontTwentyNineSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtySizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyOneSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyTwoSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyThreeSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyFourSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyFiveSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtySixSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtySevenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyEightSizeLight;
@property (nonatomic, retain) UIFont  *themeFontThirtyNineSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtySizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtyOneSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtyTwoSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtyThreeSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtyFourSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtyFiveSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtySixSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtySevenSizeLight;
@property (nonatomic, retain) UIFont  *themeFontFourtyEightSizeLight;

//========================= THEME MEDIUM FONTS SETTING ================//
@property (nonatomic, retain) UIFont  *themeFontFourSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFiveSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontSixSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontSevenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontEightSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontNineSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontElevenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwelveSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirteenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourteenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFifteenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontSixteenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontSeventeenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontEighteenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontNineteenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentySizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyOneSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyTwoSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyThreeSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyFourSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyFiveSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentySixSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentySevenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyEightSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontTwentyNineSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtySizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyOneSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyTwoSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyThreeSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyFourSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyFiveSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtySixSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtySevenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyEightSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontThirtyNineSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtySizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtyOneSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtyTwoSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtyThreeSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtyFourSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtyFiveSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtySixSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtySevenSizeMedium;
@property (nonatomic, retain) UIFont  *themeFontFourtyEightSizeMedium;

//========================= THEME BOLD FONTS SETTINGS ================//
@property (nonatomic, retain) UIFont  *themeFontFourSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFiveSizeBold;
@property (nonatomic, retain) UIFont  *themeFontSixSizeBold;
@property (nonatomic, retain) UIFont  *themeFontSevenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontEightSizeBold;
@property (nonatomic, retain) UIFont  *themeFontNineSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontElevenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwelveSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirteenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourteenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFifteenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontSixteenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontSeventeenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontEighteenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontNineteenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentySizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyOneSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyTwoSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyThreeSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyFourSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyFiveSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentySixSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentySevenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyEightSizeBold;
@property (nonatomic, retain) UIFont  *themeFontTwentyNineSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtySizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyOneSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyTwoSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyThreeSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyFourSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyFiveSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtySixSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtySevenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyEightSizeBold;
@property (nonatomic, retain) UIFont  *themeFontThirtyNineSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtySizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtyOneSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtyTwoSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtyThreeSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtyFourSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtyFiveSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtySixSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtySevenSizeBold;
@property (nonatomic, retain) UIFont  *themeFontFourtyEightSizeBold;

//========================= ALERT VIEW SETTINGS ================//
@property (nonatomic, retain) UIFont *alertViewTitleFont;
@property (nonatomic, retain) UIFont *alertViewMessageFont;
@property (nonatomic, retain) UIFont *alertViewButtonTitleFont;
@property (nonatomic, retain) UIFont *alertViewCancelButtonTitleFont;

@property (nonatomic, retain) UIColor *alertViewTitleColor;
@property (nonatomic, retain) UIColor *alertViewContentColor;
@property (nonatomic, retain) UIColor *alertViewLeftButtonFontColor;
@property (nonatomic, retain) UIColor *alertViewBackGroundColor;
@property (nonatomic, retain) UIColor *alertViewLeftButtonBackgroundColor;
@property (nonatomic, retain) UIColor *alertViewRightButtonBackgroundColor;

//========================= OTHER CUSTOM METHODS ================//
-(NSMutableAttributedString *)getAttributedStringForString:(NSString *)strString withSubString:(NSString *)strSubString withFontColorForSubString:(UIColor *)fontColorForSubString withFontForSubString:(UIFont *)fontForSubString withFontColorForOtherString:(UIColor *)fontColorForOtherString withFontForOtherString:(UIFont *)fontForOtherString;

@end
