//
//  MySingleton.m
//  Coupon Bouquet
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton

@synthesize dataManager;

+(MySingleton *)sharedManager
{
    static MySingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
        dataManager = [[DataManager alloc]init];
        
        _screenRect = [[UIScreen mainScreen] bounds];
        _screenWidth = _screenRect.size.width;
        _screenHeight = _screenRect.size.height;
        
        //========================= APPLICATION SPECIFIC SETTINGS ================//
        _strSocialMediaShareSubject = @"Share This App Subject";
        _striOSAppUrlForUsers = @"http://itunes.apple.com/app/id1313764616";
        _intiOSAppstoreId = 1313764616;
        _strAndroidAppUrlForUsers = @"http://";
        _strSocialMediaShareMessage = [NSString stringWithFormat:@"Dil Kholke Discounts at 100+ places in Surat.\n\n Offeram Coupon Bouquet Download Now for apple : %@\nDownload for android : %@", _striOSAppUrlForUsers, _strAndroidAppUrlForUsers];
        
        //========================= SIDE MENU SETTINGS ================//
        if(_screenWidth == 320)
        {
            _floatLeftSideMenuWidth = 260.0f;
            _floatRightSideMenuWidth = 260.0f;
            
            _themeFontWorthTitle = [UIFont fontWithName:@"Lato-Regular" size:16.0f];
            _themeFontWorthValue = [UIFont fontWithName:@"Lato-Bold" size:30.0f];
        }
        else if(_screenWidth == 375)
        {
            _floatLeftSideMenuWidth = 305.0f;
            _floatRightSideMenuWidth = 305.0f;
            
            _themeFontWorthTitle = [UIFont fontWithName:@"Lato-Regular" size:18.0f];
            _themeFontWorthValue = [UIFont fontWithName:@"Lato-Bold" size:32.0f];
        }
        else
        {
            _floatLeftSideMenuWidth = 336.0f;
            _floatRightSideMenuWidth = 336.0f;
            
            _themeFontWorthTitle = [UIFont fontWithName:@"Lato-Regular" size:20.0f];
            _themeFontWorthValue = [UIFont fontWithName:@"Lato-Bold" size:34.0f];
        }
        
//        _leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
//        _rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
        
        //========================= NAVIGATION BAR SETTINGS ================//
        _navigationBarBackgroundColor = UIColorFromRGB(0xE7A529);
        _navigationBarTitleColor = UIColorFromRGB(0xFFFFFF);
        if(_screenWidth == 320)
        {
            _navigationBarTitleFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f];
            _navigationBarTitleSmallFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f];
        }
        else if(_screenWidth == 375)
        {
            _navigationBarTitleFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:17.0f];
            _navigationBarTitleSmallFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f];
        }
        else
        {
            _navigationBarTitleFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:18.0f];
            _navigationBarTitleSmallFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f];
        }
        
        //========================= THEME GLOBAL COLORS SETTINGS ================//
        _themeGlobalBackgroundColor = UIColorFromRGB(0xF3F3F3);
        _themeGlobalTransperentBlackBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _themeGlobalBlueColor = UIColorFromRGB(0x00025f);
        _themeGlobalOrangeColor = UIColorFromRGB(0xE7A529);
        _themeGlobalGreenColor = UIColorFromRGB(0x5EA030);
        _themeGlobalRedColor = UIColorFromRGB(0xff0000);
        _themeGlobalWhiteColor = UIColorFromRGB(0xFFFFFF);
        _themeGlobalBlackColor = UIColorFromRGB(0x000000);
        _themeGlobalDarkGreyColor = UIColorFromRGB(0x545454);
        _themeGlobalLightGreyColor = UIColorFromRGB(0x8A8A8A);
        _themeGlobalSeperatorGreyColor = UIColorFromRGB(0xDCDCDC);
        _themeGlobalSideMenuSeperatorColor = UIColorFromRGB(0xFFFFFF);
        _themeGlobalCouponListGreyColor = UIColorFromRGB(0xE1DFDA);
        
        _textfieldPlaceholderColor = UIColorFromRGB(0xC0C0C0);
        _textfieldPlaceholderGreyColor = UIColorFromRGB(0x9FA0A1);
        _textfieldTextColor = UIColorFromRGB(0x000000);
        _textfieldTintColor = UIColorFromRGB(0x00025f);
        _textfieldDisabledTextColor = UIColorFromRGB(0x9FA0A1);
        _textfieldBorderColor = UIColorFromRGB(0xE7A529);
        _floatTextfieldBorderWidth = 3.0f;
        _textfieldFloatingLabelTextColor = UIColorFromRGB(0x00025f);
        _textfieldBottomSeparatorColor = UIColorFromRGB(0xDCDCDC);
        
        _themeGlobalButtonDisabledBackgroundGreyColor = UIColorFromRGB(0x8A8A8A);
        _themeGlobalButtonDisabledTextColor = UIColorFromRGB(0xA9A9A9);
        
        _themeGlobalUsedCouponsInnerContainerBackgroundColor = UIColorFromRGB(0xF6F3F0);
        _themeGlobalUsedCouponsSerialNumberBackgroundColor = UIColorFromRGB(0x525252);
        
        _pageIndicatorTintColor = UIColorFromRGB(0xbfc0d7);
        _currentPageIndicatorTintColorPage1 = UIColorFromRGB(0xFFFFFF);
        _currentPageIndicatorTintColor = UIColorFromRGB(0x00025f);
                
        //========================= FLOAT VALUES SETTINGS ================//
        if(_screenWidth == 320)
        {
            _floatButtonCornerRadius = 5.0f;
        }
        else if(_screenWidth == 375)
        {
            _floatButtonCornerRadius = 8.0f;
        }
        else
        {
            _floatButtonCornerRadius = 8.0f;
        }
        
        //========================= THEME REGULAR FONTS SETTING ================//
        _themeFontFourSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:4.0f];
        _themeFontFiveSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:5.0f];
        _themeFontSixSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:6.0f];
        _themeFontSevenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:7.0f];
        _themeFontEightSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:8.0f];
        _themeFontNineSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:9.0f];
        _themeFontTenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:10.0f];
        _themeFontElevenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:11.0f];
        _themeFontTwelveSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:12.0f];
        _themeFontThirteenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:13.0f];
        _themeFontFourteenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f];
        _themeFontFifteenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:15.0f];
        _themeFontSixteenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f];
        _themeFontSeventeenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:17.0f];
        _themeFontEighteenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:18.0f];
        _themeFontNineteenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:19.0f];
        _themeFontTwentySizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:20.0f];
        _themeFontTwentyOneSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:21.0f];
        _themeFontTwentyTwoSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:22.0f];
        _themeFontTwentyThreeSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:23.0f];
        _themeFontTwentyFourSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:24.0f];
        _themeFontTwentyFiveSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:25.0f];
        _themeFontTwentySixSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:26.0f];
        _themeFontTwentySevenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:27.0f];
        _themeFontTwentyEightSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:28.0f];
        _themeFontTwentyNineSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:29.0f];
        _themeFontThirtySizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:30.0f];
        _themeFontThirtyOneSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:31.0f];
        _themeFontThirtyTwoSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:32.0f];
        _themeFontThirtyThreeSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:33.0f];
        _themeFontThirtyFourSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:34.0f];
        _themeFontThirtyFiveSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:35.0f];
        _themeFontThirtySixSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:36.0f];
        _themeFontThirtySevenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:37.0f];
        _themeFontThirtyEightSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:38.0f];
        _themeFontThirtyNineSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:39.0f];
        _themeFontFourtySizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:40.0f];
        _themeFontFourtyOneSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:41.0f];
        _themeFontFourtyTwoSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:42.0f];
        _themeFontFourtyThreeSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:43.0f];
        _themeFontFourtyFourSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:44.0f];
        _themeFontFourtyFiveSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:45.0f];
        _themeFontFourtySixSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:46.0f];
        _themeFontFourtySevenSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:47.0f];
        _themeFontFourtyEightSizeRegular = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:48.0f];
        
        //========================= THEME LIGHT FONTS SETTINGS ================//
        _themeFontFourSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:4.0f];
        _themeFontFiveSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:5.0f];
        _themeFontSixSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:6.0f];
        _themeFontSevenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:7.0f];
        _themeFontEightSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:8.0f];
        _themeFontNineSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:9.0f];
        _themeFontTenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:10.0f];
        _themeFontElevenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:11.0f];
        _themeFontTwelveSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:12.0f];
        _themeFontThirteenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:13.0f];
        _themeFontFourteenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14.0f];
        _themeFontFifteenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:15.0f];
        _themeFontSixteenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:16.0f];
        _themeFontSeventeenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:17.0f];
        _themeFontEighteenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:18.0f];
        _themeFontNineteenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:19.0f];
        _themeFontTwentySizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:20.0f];
        _themeFontTwentyOneSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:21.0f];
        _themeFontTwentyTwoSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:22.0f];
        _themeFontTwentyThreeSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:23.0f];
        _themeFontTwentyFourSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:24.0f];
        _themeFontTwentyFiveSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:25.0f];
        _themeFontTwentySixSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:26.0f];
        _themeFontTwentySevenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:27.0f];
        _themeFontTwentyEightSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:28.0f];
        _themeFontTwentyNineSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:29.0f];
        _themeFontThirtySizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:30.0f];
        _themeFontThirtyOneSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:31.0f];
        _themeFontThirtyTwoSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:32.0f];
        _themeFontThirtyThreeSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:33.0f];
        _themeFontThirtyFourSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:34.0f];
        _themeFontThirtyFiveSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:35.0f];
        _themeFontThirtySixSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:36.0f];
        _themeFontThirtySevenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:37.0f];
        _themeFontThirtyEightSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:38.0f];
        _themeFontThirtyNineSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:39.0f];
        _themeFontFourtySizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:40.0f];
        _themeFontFourtyOneSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:41.0f];
        _themeFontFourtyTwoSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:42.0f];
        _themeFontFourtyThreeSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:43.0f];
        _themeFontFourtyFourSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:44.0f];
        _themeFontFourtyFiveSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:45.0f];
        _themeFontFourtySixSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:46.0f];
        _themeFontFourtySevenSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:47.0f];
        _themeFontFourtyEightSizeLight = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:48.0f];
        
        //========================= THEME MEDIUM FONTS SETTING ================//
        _themeFontFourSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:4.0f];
        _themeFontFiveSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:5.0f];
        _themeFontSixSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:6.0f];
        _themeFontSevenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:7.0f];
        _themeFontEightSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:8.0f];
        _themeFontNineSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:9.0f];
        _themeFontTenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:10.0f];
        _themeFontElevenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:11.0f];
        _themeFontTwelveSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:12.0f];
        _themeFontThirteenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:13.0f];
        _themeFontFourteenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:14.0f];
        _themeFontFifteenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:15.0f];
        _themeFontSixteenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.0f];
        _themeFontSeventeenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:17.0f];
        _themeFontEighteenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:18.0f];
        _themeFontNineteenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:19.0f];
        _themeFontTwentySizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:20.0f];
        _themeFontTwentyOneSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:21.0f];
        _themeFontTwentyTwoSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:22.0f];
        _themeFontTwentyThreeSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:23.0f];
        _themeFontTwentyFourSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:24.0f];
        _themeFontTwentyFiveSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:25.0f];
        _themeFontTwentySixSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:26.0f];
        _themeFontTwentySevenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:27.0f];
        _themeFontTwentyEightSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:28.0f];
        _themeFontTwentyNineSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:29.0f];
        _themeFontThirtySizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:30.0f];
        _themeFontThirtyOneSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:31.0f];
        _themeFontThirtyTwoSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:32.0f];
        _themeFontThirtyThreeSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:33.0f];
        _themeFontThirtyFourSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:34.0f];
        _themeFontThirtyFiveSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:35.0f];
        _themeFontThirtySixSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:36.0f];
        _themeFontThirtySevenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:37.0f];
        _themeFontThirtyEightSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:38.0f];
        _themeFontThirtyNineSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:39.0f];
        _themeFontFourtySizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:40.0f];
        _themeFontFourtyOneSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:41.0f];
        _themeFontFourtyTwoSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:42.0f];
        _themeFontFourtyThreeSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:43.0f];
        _themeFontFourtyFourSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:44.0f];
        _themeFontFourtyFiveSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:45.0f];
        _themeFontFourtySixSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:46.0f];
        _themeFontFourtySevenSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:47.0f];
        _themeFontFourtyEightSizeMedium = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:48.0f];
        
        //========================= THEME BOLD FONTS SETTINGS ================//
        _themeFontFourSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:4.0f];
        _themeFontFiveSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:5.0f];
        _themeFontSixSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:6.0f];
        _themeFontSevenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:7.0f];
        _themeFontEightSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:8.0f];
        _themeFontNineSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:9.0f];
        _themeFontTenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:10.0f];
        _themeFontElevenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:11.0f];
        _themeFontTwelveSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12.0f];
        _themeFontThirteenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:13.0f];
        _themeFontFourteenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:14.0f];
        _themeFontFifteenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:15.0f];
        _themeFontSixteenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:16.0f];
        _themeFontSeventeenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:17.0f];
        _themeFontEighteenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f];
        _themeFontNineteenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:19.0f];
        _themeFontTwentySizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:20.0f];
        _themeFontTwentyOneSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21.0f];
        _themeFontTwentyTwoSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:22.0f];
        _themeFontTwentyThreeSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:23.0f];
        _themeFontTwentyFourSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:24.0f];
        _themeFontTwentyFiveSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:25.0f];
        _themeFontTwentySixSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:26.0f];
        _themeFontTwentySevenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:27.0f];
        _themeFontTwentyEightSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:28.0f];
        _themeFontTwentyNineSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:29.0f];
        _themeFontThirtySizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:30.0f];
        _themeFontThirtyOneSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:31.0f];
        _themeFontThirtyTwoSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:32.0f];
        _themeFontThirtyThreeSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:33.0f];
        _themeFontThirtyFourSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:34.0f];
        _themeFontThirtyFiveSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:35.0f];
        _themeFontThirtySixSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:36.0f];
        _themeFontThirtySevenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:37.0f];
        _themeFontThirtyEightSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:38.0f];
        _themeFontThirtyNineSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:39.0f];
        _themeFontFourtySizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:40.0f];
        _themeFontFourtyOneSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:41.0f];
        _themeFontFourtyTwoSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:42.0f];
        _themeFontFourtyThreeSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:43.0f];
        _themeFontFourtyFourSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:44.0f];
        _themeFontFourtyFiveSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:45.0f];
        _themeFontFourtySixSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:46.0f];
        _themeFontFourtySevenSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:47.0f];
        _themeFontFourtyEightSizeBold = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:48.0f];
        
        //========================= ALERT VIEW SETTING ================//
        _alertViewTitleFont = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0];
        _alertViewMessageFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0];
        _alertViewButtonTitleFont = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0];
        _alertViewCancelButtonTitleFont = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16.0];
        _alertViewTitleColor = UIColorFromRGB(0x0092DD);
        _alertViewContentColor = UIColorFromRGB(0x000000);
        _alertViewLeftButtonFontColor = UIColorFromRGB(0xFFFFFF);
        _alertViewBackGroundColor = UIColorFromRGB(0xFFFFFF);
        _alertViewLeftButtonBackgroundColor = UIColorFromRGB(0x005A9C);
        _alertViewRightButtonBackgroundColor = UIColorFromRGB(0x0092DD);

    }
    
    return self;
}

//========================= OTHER CUSTOM METHODS ================//

-(NSMutableAttributedString *)getAttributedStringForString:(NSString *)strString withSubString:(NSString *)strSubString withFontColorForSubString:(UIColor *)fontColorForSubString withFontForSubString:(UIFont *)fontForSubString withFontColorForOtherString:(UIColor *)fontColorForOtherString withFontForOtherString:(UIFont *)fontForOtherString
{
    NSMutableAttributedString *strAttrString = [[NSMutableAttributedString alloc] initWithString:strString attributes: nil];
    
    if(fontColorForOtherString != nil)
    {
        [strAttrString addAttribute:NSForegroundColorAttributeName value:fontColorForOtherString range:NSMakeRange(0, strString.length)];
    }
    
    if(fontForOtherString != nil)
    {
        [strAttrString addAttribute:NSFontAttributeName value:fontForOtherString range:NSMakeRange(0, strString.length)];
    }
    
    
    NSRange rangeOfSubString = [strString rangeOfString:strSubString];
    
    if(fontColorForSubString != nil)
    {
        [strAttrString addAttribute:NSForegroundColorAttributeName value:fontColorForSubString range:rangeOfSubString];
    }
    
    if(fontForSubString != nil)
    {
        [strAttrString addAttribute:NSFontAttributeName value:fontForSubString range:rangeOfSubString];
    }
    
    return strAttrString;
}

@end
