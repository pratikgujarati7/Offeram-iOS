 //
//  DataManager.m
//  Reward Cards
//
//  Created by Pratik Gujarati on 04/12/17.
//  Copyright © 2017 Innovative Iteration. All rights reserved.
//

#import "DataManager.h"
#import "MySingleton.h"
#import "NYAlertViewController.h"

//#import "User_LoginViewController.h"

@implementation DataManager

-(id)init
{
    if ((self = [super init]))
    {
        _dictionaryWebservicesUrls = [NSDictionary dictionaryWithContentsOfFile: [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: @"WebservicesUrls.plist"]];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }

    return self;
}

- (BOOL) isNetworkAvailable
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] != NotReachable)
    {
        //connection available
        isNetworkAvailable = [NSNumber numberWithBool:true];
    }
    else
    {
        //connection not available
        isNetworkAvailable = [NSNumber numberWithBool:false];
    }
    
    return [isNetworkAvailable boolValue];
}

-(void)showInternetNotConnectedError
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"No Internet Connection";
    alertViewController.message = @"Please make sure that you are connected to the internet.";
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Go to Settings" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
                                        
        if (UIApplicationOpenSettingsURLString != NULL)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }]];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}

-(void)showErrorMessage:(NSString *)errorTitle withErrorContent:(NSString *)errorDescription
{
    if([errorTitle isEqualToString:@"Server Error"] && (errorDescription == nil || errorDescription.length <= 0))
    {
        errorDescription = @"Oops! Something went wrong. Please try again later.";
    }
    else if([errorTitle isEqualToString:@"Server Error"] && (errorDescription != nil || errorDescription.length > 0))
    {
        errorTitle = @"";
        errorDescription = errorDescription;
    }
    else
    {
        errorDescription = errorDescription;
    }
    
    [appDelegate dismissGlobalHUD];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showAlertViewWithTitle:errorTitle withDetails:errorDescription];
    });
}

#pragma mark - Webservices Methods

#pragma mark USER FUNCTION TO COLLECT DATA ON SPLASH SCREEN

-(void)user_collectDataOnSplashScreen
{
    if([self isNetworkAvailable])
    {
        //        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Splash"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"userid"])
        {
            [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
            NSString *strDeviceToken = [prefs objectForKey:@"device_id"];
            if(strDeviceToken.length > 0)
            {
                [parameters setObject:[prefs objectForKey:@"device_id"] forKey:@"device_id"];
            }
            else
            {
                [parameters setObject:@"" forKey:@"device_id"];
            }
            [parameters setObject:@"1" forKey:@"device_type"];
        }
        else
        {
            [parameters setObject:@"0" forKey:@"user_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    self.strReferAndEarnText = [jsonResult objectForKey:@"ReferAndEarnText"];
                    self.strOfferamCoinsLabel1Text = [jsonResult objectForKey:@"OfferamCoinsLabel1Text"];
                    self.strOfferamCoinsLabel2Text = [jsonResult objectForKey:@"OfferamCoinsLabel2Text"];
                    self.strOfferamCoinsLabel3Text = [jsonResult objectForKey:@"OfferamCoinsLabel3Text"];
                    self.strOfferamCoinsLabel4Text = [jsonResult objectForKey:@"OfferamCoinsLabel4Text"];
                    
                    //========== FILL ALL CATEGORY ARRAY ==========//
                    NSArray *tempArrayAllCategoryList = [jsonResult objectForKey:@"categories"];
                    
                    self.arrayAllCategoryList = [[NSMutableArray alloc] init];
                    for (int i = 0; i < tempArrayAllCategoryList.count; i++)
                    {
                        NSDictionary *dictTemp = [tempArrayAllCategoryList objectAtIndex:i];
                        Category *objCategory = [[Category alloc] init];
                        objCategory.strCategoryID = [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"category_id"]];
                        objCategory.strCategoryName = [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"category_name"]];
                        objCategory.strCategoryImage = [NSString stringWithFormat:@"%@", [dictTemp objectForKey:@"category_image"]];
                        
                        [self.arrayAllCategoryList insertObject:objCategory atIndex:i];
                    }
                    
                    //========== FILL ALL SUGGESTIONS ARRAY ==========//
                    NSArray *arrayAllSuggestionsList = [jsonResult objectForKey:@"all_suggestions"];

                    self.arrayAllSuggestions = [[NSMutableArray alloc] init];

                    for(int i = 0 ; i < arrayAllSuggestionsList.count; i++)
                    {
                        NSString *strSuggestion = [NSString stringWithFormat:@"%@",[arrayAllSuggestionsList objectAtIndex:i]];
                        [self.arrayAllSuggestions addObject:strSuggestion];
                    }

                    self.strIsUpdate = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"is_update"]];
                    
                    self.strNotificationCount = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"count_for_notification"]];
                    
                    self.strPurchasePrice = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"purchase_price"]];
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:[NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"payment_id"]] forKey:@"userpaymentid"];
                    [prefs synchronize];
                    
                    //========== FILL ALL CITY ARRAY ==========//
                    NSArray *arrayAllCityList = [jsonResult objectForKey:@"all_city"];
                    
                    NSSortDescriptor * brandDescriptorCity = [[NSSortDescriptor alloc] initWithKey:@"city_name" ascending:YES];
                    NSArray * sortedArrayCity = [arrayAllCityList sortedArrayUsingDescriptors:@[brandDescriptorCity]];
                    
                    self.arrayAllCity = [[NSMutableArray alloc] init];
                    
                    for(int i = 0 ; i < sortedArrayCity.count; i++)
                    {
                        NSDictionary *currentDictionaryCity = [sortedArrayCity objectAtIndex:i];
                        
                        City *objCity = [[City alloc] init];
                        
                        objCity.strCityID = [NSString stringWithFormat:@"%@",[currentDictionaryCity objectForKey:@"city_id"]];
                        objCity.strCityName = [NSString stringWithFormat:@"%@",[currentDictionaryCity objectForKey:@"city_name"]];
                        
                        // AREAS
                        NSArray *arrayAllAreasList = [currentDictionaryCity objectForKey:@"all_areas"];
                        
                        NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"area_name" ascending:YES];
                        NSArray * sortedArray = [arrayAllAreasList sortedArrayUsingDescriptors:@[brandDescriptor]];
                        
                        objCity.arrayAllAreas = [[NSMutableArray alloc] init];
                        
                        for(int i = 0 ; i < sortedArray.count; i++)
                        {
                            NSDictionary *currentDictionary = [sortedArray objectAtIndex:i];
                            
                            Area *objArea = [[Area alloc] init];
                            objArea.strAreaID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_id"]];
                            objArea.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_name"]];
                            
                            [objCity.arrayAllAreas addObject:objArea];
                        }
                        
                        [self.arrayAllCity addObject:objCity];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_collectedDataOnSplashScreenEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO SEND OTP

-(void)user_sendOTP:(User *)objUser
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Send_OTP"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:objUser.strPhoneNumber forKey:@"mobile"];
        [parameters setObject:objUser.strCityID forKey:@"city_id"];
        [parameters setObject:objUser.strDeviceToken forKey:@"device_id"];
        [parameters setObject:@"1" forKey:@"device_type"];
        [parameters setObject:@"0" forKey:@"is_resend"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    self.objLoggedInUser.strUserID = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"user_id"]];
                    self.objLoggedInUser.strPhoneNumber = objUser.strPhoneNumber;
                    self.objLoggedInUser.strDeviceToken = objUser.strDeviceToken;
                    
                    if ([[jsonResult allKeys] containsObject:@"version_id"])
                    {
                        self.objLoggedInUser.strVersionID = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"version_id"]];
                    }
                    else
                    {
                        self.objLoggedInUser.strVersionID = @"";
                    }
                    
                    if ([[jsonResult allKeys] containsObject:@"payment_id"])
                    {
                        self.objLoggedInUser.strPaymentID = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"payment_id"]];
                    }
                    else
                    {
                        self.objLoggedInUser.strPaymentID = @"";
                    }
                    
                    self.strOTP = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"otp"]];
                    NSLog(@"OTP : %@", self.strOTP);
                    
                    if ([[jsonResult objectForKey:@"is_fresh_user"] integerValue] == 1)
                    {
                        self.isFreshUser = true;
                    }
                    else
                    {
                        self.isFreshUser = false;
//                        self.isFreshUser = true;
                    }
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:self.objLoggedInUser.strUserID forKey:@"userid"];
                    [prefs setObject:self.objLoggedInUser.strPhoneNumber forKey:@"userphonenumber"];
                    [prefs setObject:self.objLoggedInUser.strVersionID forKey:@"userversionid"];
                    [prefs setObject:[NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"version_name"]] forKey:@"userversionname"];
                    [prefs setObject:self.objLoggedInUser.strPaymentID forKey:@"userpaymentid"];
                    [prefs synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_sentOTPEvent" object:nil];
                    //                    });
                    
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO RESEND OTP

-(void)user_resendOTP:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Resend_OTP"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[dictParameters objectForKey:@"phone_number"] forKey:@"mobile"];
        [parameters setObject:[dictParameters objectForKey:@"city_id"] forKey:@"city_id"];
        [parameters setObject:[dictParameters objectForKey:@"device_id"] forKey:@"device_id"];
        [parameters setObject:@"1" forKey:@"device_type"];
        [parameters setObject:@"1" forKey:@"is_resend"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    self.strOTP = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"otp"]];
                    NSLog(@"OTP : %@", self.strOTP);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_resentOTPEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO VERIFY PHONE NUMBER

-(void)user_verifyPhoneNumber:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Verify_Phone_Number"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[dictParameters objectForKey:@"user_id"] forKey:@"user_id"];
        [parameters setObject:[dictParameters objectForKey:@"otp"] forKey:@"otp"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    //========== FILL ALL SUGGESTIONS ARRAY ==========//
                    NSArray *arrayAllSuggestionsList = [jsonResult objectForKey:@"all_suggestions"];
                    
                    self.arrayAllSuggestions = [[NSMutableArray alloc] init];
                    
                    for(int i = 0 ; i < arrayAllSuggestionsList.count; i++)
                    {
                        NSString *strSuggestion = [NSString stringWithFormat:@"%@",[arrayAllSuggestionsList objectAtIndex:i]];
                        [self.arrayAllSuggestions addObject:strSuggestion];
                    }
                    
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:@"1" forKey:@"autologin"];
                    [prefs synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_verifiedPhoneNumberEvent" object:nil];
                    //                    });
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL MERCHANTS

-(void)user_getAllMerchants:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Merchants"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        if([[dictParameters allKeys] containsObject:@"array_area_ids"])
        {
            [parameters setObject:[dictParameters objectForKey:@"array_area_ids"] forKey:@"area_ids"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"area_ids"];
        }
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        [parameters setObject:[dictParameters objectForKey:@"city_id"] forKey:@"city_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //error_message
                //code: 100 Success, 101 Message on Homescreen with a view
                
                self.intGetAllMerchantsAPIResponseCode = [[jsonResult objectForKey:@"code"] intValue];
                self.strGetAllMerchantsAPIErrorMessage = [jsonResult objectForKey:@"error_message"];
                
                self.boolIsTambolaActive = [[jsonResult objectForKey:@"is_tambola_active"] boolValue];
                self.boolIsUserRegisteredForTambola = [[jsonResult objectForKey:@"is_tambola_register"] boolValue];
                self.boolIsIPLActive = [[jsonResult objectForKey:@"is_ipl_active"] boolValue];
                self.strTambolaImageURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_image_url"]];
                self.strTambolaTitle = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_title"]];
                self.strTambolaDescription = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_desc"]];
                self.strTambolaTicketURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"ticket_url"]];
                self.strTambolaRegisteredUsersCount = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_total_registered_user"]];
                self.strTambolaKnowMoreURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_detail_url"]];
                self.strTambolaShareMessage = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_share_message"]];
                
                //========== FILL ALL MERCHANTS ARRAY ==========//
                NSArray *arrayAllMerchantsList = [jsonResult objectForKey:@"merchant_list"];
                
                self.arrayAllMerchants = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllMerchantsList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllMerchantsList objectAtIndex:i];
                    
                    Merchant *objMerchant = [[Merchant alloc] init];
                    objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                    objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                    objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                    objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                    
                    objMerchant.strCategoryID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_id"]];
                    objMerchant.strCategoryName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_name"]];
                    
                    
                    NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                    
                    NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_banner_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                    
                    objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                    objMerchant.strCuisines = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"cuisines"]];
                    
                    objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_starred"]];
                    
                    objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                    
                    objMerchant.strNumberOfRedeems = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_redeem"]];
                    objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                    
                    objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                    objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_coupons"]];
                    
                    NSArray *arrayTempOutlets = [currentDictionary objectForKey:@"outlets"];
                    objMerchant.arrayOutlets = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempOutlets.count; i++)
                    {
                        NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:i];
                        Outlet *objOutlet = [[Outlet alloc] init];
                        objOutlet.strAreaName = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"area_name"]];
                        
//                        objOutlet.strDistance = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"distance"]];
                        float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                        objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                        
                        objOutlet.strCityID = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"city_name"]];
                        objOutlet.strCityName = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"city_name"]];
                        
                        [objMerchant.arrayOutlets addObject:objOutlet];
                    }
                    
                    [self.arrayAllMerchants addObject:objMerchant];
                }
                
                //========== FILL ALL SUGGESTIONS ARRAY ==========//
                NSArray *arrayAllSuggestionsList = [jsonResult objectForKey:@"all_suggestions"];
                
                self.arrayAllSuggestions = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllSuggestionsList.count; i++)
                {
                    NSString *strSuggestion = [NSString stringWithFormat:@"%@",[arrayAllSuggestionsList objectAtIndex:i]];
                    [self.arrayAllSuggestions addObject:strSuggestion];
                }
                
                //========== FILL ALL AREAS ARRAY ==========//
                NSArray *arrayAllAreasList = [jsonResult objectForKey:@"all_areas"];
                
                NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"area_name" ascending:YES];
                NSArray * sortedArray = [arrayAllAreasList sortedArrayUsingDescriptors:@[brandDescriptor]];
                
                self.arrayAllAreas = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < sortedArray.count; i++)
                {
                    NSDictionary *currentDictionary = [sortedArray objectAtIndex:i];
                    
                    Area *objArea = [[Area alloc] init];
                    objArea.strAreaID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_id"]];
                    objArea.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_name"]];
                    
                    objArea.strCityID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"city_id"]];
                    objArea.strCityName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"city_name"]];
                    
                    [self.arrayAllAreas addObject:objArea];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllMerchantsEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL FEVORITE OFFERS

-(void)user_getAllFevoriteOffers:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Fevorite_Offers"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL MERCHANTS ARRAY ==========//
                NSArray *arrayAllFevoriteMerchantsList = [jsonResult objectForKey:@"starred_list"];
                
                self.arrayAllFevoriteOffers = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllFevoriteMerchantsList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllFevoriteMerchantsList objectAtIndex:i];
                    
                    Merchant *objMerchant = [[Merchant alloc] init];
                    objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                    objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                    objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                    objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                    
                    objMerchant.strCategoryID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_id"]];
                    objMerchant.strCategoryName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_name"]];
                    
                    
                    NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                    
                    NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                    
                    objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                    
                    objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_favorite"]];
                    
                    objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                    
                    objMerchant.strNumberOfRedeems = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_redeem"]];
                    objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                    
                    objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                    objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_offers"]];
                    
                    NSArray *arrayTempOutlets = [currentDictionary objectForKey:@"outlets"];
                    objMerchant.arrayOutlets = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempOutlets.count; i++)
                    {
                        NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:i];
                        Outlet *objOutlet = [[Outlet alloc] init];
                        objOutlet.strAreaName = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"area_name"]];
//                        objOutlet.strDistance = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"distance"]];
                        float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                        objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                        
                        objOutlet.strCityID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"city_id"]];
                        objOutlet.strCityName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"city_name"]];
                        
                        [objMerchant.arrayOutlets addObject:objOutlet];
                    }
                    
                    [self.arrayAllFevoriteOffers addObject:objMerchant];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllFevoriteOffersEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL NOTIFICATIONS

-(void)user_getAllNotifications
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Notifications"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL UNREAD NOTIFICATIONS ARRAY ==========//
                NSArray *arrayAllUnreadNotifications = [jsonResult objectForKey:@"notify_unread_list"];
                
                self.arrayAllUnreadNotifications = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllUnreadNotifications.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllUnreadNotifications objectAtIndex:i];
                    
                    Notification *objNotification = [[Notification alloc] init];
                    
                    objNotification.strNotificationID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"notification_id"]];
                    objNotification.strFromName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"from_name"]];
                    objNotification.strNotificationTitle = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"notification_title"]];
                    objNotification.strCompanyLogoImageUrl = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"company_logo"]];
                    objNotification.strNotificationDate = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"notification_date"]];
                    objNotification.strNotificationDateTime = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"time"]];
                    
                    objNotification.strMerchantID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"merchant_id"]];
                    
                    [self.arrayAllUnreadNotifications addObject:objNotification];
                }
                
                //========== FILL ALL READ NOTIFICATIONS ARRAY ==========//
                NSArray *arrayAllReadNotifications = [jsonResult objectForKey:@"notify_read_list"];
                
                self.arrayAllReadNotifications = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllReadNotifications.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllReadNotifications objectAtIndex:i];
                    
                    Notification *objNotification = [[Notification alloc] init];
                    
                    objNotification.strNotificationID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"notification_id"]];
                    objNotification.strFromName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"from_name"]];
                    objNotification.strNotificationTitle = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"notification_title"]];
                    objNotification.strCompanyLogoImageUrl = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"company_logo"]];
                    objNotification.strNotificationDate = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"notification_date"]];
                    objNotification.strNotificationDateTime = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"time"]];
                    
                    objNotification.strMerchantID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"merchant_id"]];
                    
                    [self.arrayAllReadNotifications addObject:objNotification];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllNotificationsEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO MARK NOTIFICATION AS READ

-(void)user_markNotificationsAsRead:(NSString *)strNotificationID
{
    if([self isNetworkAvailable])
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Mark_Notification_As_Read"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        // NOTIFICATION ID
        [parameters setObject:strNotificationID forKey:@"notification_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_markedNotificationsAsReadEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET MERCHANT DETAILS
-(void)user_getMerchantDetails:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_Merchant_Details"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        [parameters setObject:[dictParameters objectForKey:@"merchant_id"] forKey:@"merchant_id"];
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL MERCHANTS DETAILS ==========//
                
                self.objSelectedMerchant = [[Merchant alloc] init];
                Merchant *objMerchant = self.objSelectedMerchant;
                
                objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"merchant_id"]];
                objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"company_name"]];
                objMerchant.strUserName = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"user_name"]];
                objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"average_ratings"]];
                
                NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                
                NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"company_banner_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                
                objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"coupon_title"]];
                
                objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"mobile"]];
                
                objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"offer_text"]];
                
                objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"total_rating"]];
                objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"user_coupons"]];
                
                objMerchant.strStatus = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"status"]];
                objMerchant.strType = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"type"]];
                
                //infrastructure_photos
                NSArray *arrayRatings = [jsonResult objectForKey:@"ratings"];
                objMerchant.arrayRatings = [[NSMutableArray alloc] init];
                for (int i = 0; i < arrayRatings.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayRatings objectAtIndex:i];
                    
                    Rating *objRating = [[Rating alloc] init];
                    
                    objRating.strUserID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_id"]];
                    objRating.strName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"name"]];
                    objRating.strRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"rating"]];
                    objRating.strComment = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"comment"]];
                    objRating.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                    
                    [objMerchant.arrayRatings addObject:objRating];
                }
                
                //infrastructure_photos
                NSArray *arrayTempInfraStructurePhotos = [jsonResult objectForKey:@"infrastructure_photos"];
                objMerchant.arrayInfrastructurePhotos = [[NSMutableArray alloc] init];
                for (int i = 0; i < arrayTempInfraStructurePhotos.count; i++)
                {
                    NSDictionary *currentDictionaryInfrastructurePhoto = [arrayTempInfraStructurePhotos objectAtIndex:i];
                    
                    [objMerchant.arrayInfrastructurePhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryInfrastructurePhoto objectForKey:@"url"]]];
                }
                
                //menu_photos
                NSArray *arrayTempMenuPhotos = [jsonResult objectForKey:@"menu_photos"];
                objMerchant.arrayMenuPhotos = [[NSMutableArray alloc] init];
                for (int i = 0; i < arrayTempMenuPhotos.count; i++)
                {
                    NSDictionary *currentDictionaryMenuPhoto = [arrayTempMenuPhotos objectAtIndex:i];
                    
                    [objMerchant.arrayMenuPhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryMenuPhoto objectForKey:@"url"]]];
                }
                
                
                NSArray *arrayTempCoupons = [jsonResult objectForKey:@"coupons_list"];
                objMerchant.arrayCoupons = [[NSMutableArray alloc] init];
                for (int i = 0; i < arrayTempCoupons.count; i++)
                {
                    NSDictionary *currentDictionaryCoupon = [arrayTempCoupons objectAtIndex:i];
                    
                    Coupon *objCoupon = [[Coupon alloc] init];
                    
                    objCoupon.strCouponID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_id"]];
                    objCoupon.strCouponImageURL = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_image"]];
                    objCoupon.strCouponTitle = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_title"]];
                    objCoupon.strCouponDescription = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_description"]];
                    
                    objCoupon.strAddedDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"date_added"]];
                    objCoupon.strEndDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"end_date"]];
                    
                    objCoupon.strIsExpired = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_expired"]];
                    objCoupon.strIsPinged = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_pinged"]];
                    objCoupon.strIsStareed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_starred"]];
                    objCoupon.strIsUsed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_used"]];
                    
                    objCoupon.strNumberOfRedeem = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"num_of_redeem"]];
                    objCoupon.strTermsAndConditions = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"terms_conditions"]];
                    
                    
                    NSArray *arrayTempOutlets = [currentDictionaryCoupon objectForKey:@"coupon_at_available_outlets"];
                    objCoupon.arrayOutlets = [[NSMutableArray alloc] init];
                    
                    for (int j = 0; j < arrayTempOutlets.count; j++)
                    {
                        NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:j];
                        
                        Outlet *objOutlet = [[Outlet alloc] init];
                        
                        objOutlet.strOutletID = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"outlet_id"]];
                        objOutlet.strCouponOutletID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"coupon_outlets_id"]];
                        
                        objOutlet.strAddress = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"address"]];
                        objOutlet.strStartTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time"]];
                        objOutlet.strStartTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time2"]];
                        objOutlet.strEndTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time"]];
                        objOutlet.strEndTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time2"]];
                        
                        objOutlet.strLatitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"latitude"]];
                        objOutlet.strLongitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"longitude"]];
                        
                        objOutlet.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"area_name"]];
//                        objOutlet.strDistance = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"distance"]];
                        float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                        objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                        
                        objOutlet.strPhoneNumber = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"phone_number"]];
                        objOutlet.strPin = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"pin"]];
                        objOutlet.strStatus = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"status"]];
                        
                        objOutlet.strCityID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_id"]];
                        objOutlet.strCityName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_name"]];
                        
                        [objCoupon.arrayOutlets addObject:objOutlet];
                    }
                    
                    [objMerchant.arrayCoupons addObject:objCoupon];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotMerchantDetailsEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO ADD OR REMOVE FROM FAVORITE OFFERS
-(void)user_addRemoveFromFavoriteOffers:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Add_Remove_From_Favorite_Offers"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"coupon_id"] forKey:@"coupon_id"];
        [parameters setObject:[dictParameters objectForKey:@"is_favorite"] forKey:@"is_favorite"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_addedRemovedFromFavoriteOffersEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO PING OFFER

-(void)user_pingOffer:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Ping_Offer"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"from_user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"coupon_id"] forKey:@"coupon_id"];
        [parameters setObject:[dictParameters objectForKey:@"mobile_number"] forKey:@"mobile"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_pingOfferEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO UPDATE PINGED OFFER

-(void)user_updatePingedOffer:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"Update_pinged_Offer_Status"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"ping_id"] forKey:@"ping_id"];
        [parameters setObject:[dictParameters objectForKey:@"coupon_id"] forKey:@"coupon_id"];
        [parameters setObject:[dictParameters objectForKey:@"status"] forKey:@"status"];
        
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    //========== FILL ALL MERCHANTS ARRAY ==========//
                    NSArray *arrayAllPingedMerchantsList = [jsonResult objectForKey:@"pinged_list"];
                    
                    self.arrayAllPingedOffers = [[NSMutableArray alloc] init];
                    
                    for(int i = 0 ; i < arrayAllPingedMerchantsList.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayAllPingedMerchantsList objectAtIndex:i];
                        
                        Merchant *objMerchant = [[Merchant alloc] init];
                        
                        objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                        objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                        objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                        objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                        
                        NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                        
                        NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_banner_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                        
                        objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                        
                        objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                        
                        objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                        
                        objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                        objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_coupons"]];
                        
                        objMerchant.strStatus = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"status"]];
                        objMerchant.strType = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"type"]];
                        
                        //infrastructure_photos
                        NSArray *arrayRatings = [currentDictionary objectForKey:@"ratings"];
                        objMerchant.arrayRatings = [[NSMutableArray alloc] init];
                        for (int i = 0; i < arrayRatings.count; i++)
                        {
                            NSDictionary *currentDictionaryRatings = [arrayRatings objectAtIndex:i];
                            
                            Rating *objRating = [[Rating alloc] init];
                            
                            objRating.strUserID = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"user_id"]];
                            objRating.strName = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"name"]];
                            objRating.strRating = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"rating"]];
                            objRating.strComment = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"comment"]];
                            objRating.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"mobile"]];
                            
                            [objMerchant.arrayRatings addObject:objRating];
                        }
                        
                        //infrastructure_photos
                        NSArray *arrayTempInfraStructurePhotos = [currentDictionary objectForKey:@"infrastructure_photos"];
                        objMerchant.arrayInfrastructurePhotos = [[NSMutableArray alloc] init];
                        for (int i = 0; i < arrayTempInfraStructurePhotos.count; i++)
                        {
                            NSDictionary *currentDictionaryInfrastructurePhoto = [arrayTempInfraStructurePhotos objectAtIndex:i];
                            
                            [objMerchant.arrayInfrastructurePhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryInfrastructurePhoto objectForKey:@"url"]]];
                        }
                        
                        //menu_photos
                        NSArray *arrayTempMenuPhotos = [currentDictionary objectForKey:@"menu_photos"];
                        objMerchant.arrayMenuPhotos = [[NSMutableArray alloc] init];
                        for (int i = 0; i < arrayTempMenuPhotos.count; i++)
                        {
                            NSDictionary *currentDictionaryMenuPhoto = [arrayTempMenuPhotos objectAtIndex:i];
                            
                            [objMerchant.arrayMenuPhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryMenuPhoto objectForKey:@"url"]]];
                        }
                        
                        
                        NSArray *arrayTempCoupons = [currentDictionary objectForKey:@"coupons_list"];
                        objMerchant.arrayCoupons = [[NSMutableArray alloc] init];
                        for (int i = 0; i < arrayTempCoupons.count; i++)
                        {
                            NSDictionary *currentDictionaryCoupon = [arrayTempCoupons objectAtIndex:i];
                            
                            Coupon *objCoupon = [[Coupon alloc] init];
                            
                            objCoupon.strCouponID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_id"]];
                            objCoupon.strCouponImageURL = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_image"]];
                            objCoupon.strCouponTitle = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_title"]];
                            objCoupon.strCouponDescription = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_description"]];
                            
                            objCoupon.strAddedDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"date_added"]];
                            objCoupon.strEndDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"end_date"]];
                            
                            objCoupon.strIsExpired = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_expired"]];
                            objCoupon.strIsPinged = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_pinged"]];
                            objCoupon.strIsStareed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_starred"]];
                            objCoupon.strIsUsed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_used"]];
                            
                            objCoupon.strNumberOfRedeem = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"num_of_redeem"]];
                            objCoupon.strTermsAndConditions = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"terms_conditions"]];
                            
                            //PINGED USER DETAILS
                            objCoupon.strPingedID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"ping_id"]];
                            objCoupon.strPingedStatus = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"ping_status"]];
                            objCoupon.strPingedUserID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"pinged_user_id"]];
                            objCoupon.strPingedUserName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"pinged_user_name"]];
                            
                            
                            NSArray *arrayTempOutlets = [currentDictionaryCoupon objectForKey:@"coupon_at_available_outlets"];
                            objCoupon.arrayOutlets = [[NSMutableArray alloc] init];
                            
                            for (int j = 0; j < arrayTempOutlets.count; j++)
                            {
                                NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:j];
                                
                                Outlet *objOutlet = [[Outlet alloc] init];
                                
                                objOutlet.strOutletID = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"outlet_id"]];
                                objOutlet.strCouponOutletID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"coupon_outlets_id"]];
                                
                                objOutlet.strAddress = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"address"]];
                                objOutlet.strStartTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time"]];
                                objOutlet.strStartTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time2"]];
                                objOutlet.strEndTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time"]];
                                objOutlet.strEndTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time2"]];
                                
                                objOutlet.strLatitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"latitude"]];
                                objOutlet.strLongitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"longitude"]];
                                
                                objOutlet.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"area_name"]];
//                                objOutlet.strDistance = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"distance"]];
                                float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                                objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                                
                                objOutlet.strPhoneNumber = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"phone_number"]];
                                objOutlet.strPin = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"pin"]];
                                objOutlet.strStatus = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"status"]];
                                
                                objOutlet.strCityID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_id"]];
                                objOutlet.strCityName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_name"]];
                                
                                [objCoupon.arrayOutlets addObject:objOutlet];
                            }
                            
                            [objMerchant.arrayCoupons addObject:objCoupon];
                        }
                        
                        [self.arrayAllPingedOffers addObject:objMerchant];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_updatedPingedOfferEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL PINGED OFFER

-(void)user_getAllPingedOffer:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Pinged_Offers"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
//        [parameters setObject:@"11987" forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL MERCHANTS ARRAY ==========//
                NSArray *arrayAllPingedMerchantsList = [jsonResult objectForKey:@"pinged_list"];
                
                self.arrayAllPingedOffers = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllPingedMerchantsList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllPingedMerchantsList objectAtIndex:i];
                    
                    Merchant *objMerchant = [[Merchant alloc] init];
                    
                    objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                    objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                    objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                    objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                    
                    NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                    
                    NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_banner_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                    
                    objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                    
                    objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                    
                    objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                    
                    objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                    objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_coupons"]];
                    
                    objMerchant.strStatus = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"status"]];
                    objMerchant.strType = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"type"]];
                    
                    //infrastructure_photos
                    NSArray *arrayRatings = [currentDictionary objectForKey:@"ratings"];
                    objMerchant.arrayRatings = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayRatings.count; i++)
                    {
                        NSDictionary *currentDictionaryRatings = [arrayRatings objectAtIndex:i];
                        
                        Rating *objRating = [[Rating alloc] init];
                        
                        objRating.strUserID = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"user_id"]];
                        objRating.strName = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"name"]];
                        objRating.strRating = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"rating"]];
                        objRating.strComment = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"comment"]];
                        objRating.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"mobile"]];
                        
                        [objMerchant.arrayRatings addObject:objRating];
                    }
                    
                    //infrastructure_photos
                    NSArray *arrayTempInfraStructurePhotos = [currentDictionary objectForKey:@"infrastructure_photos"];
                    objMerchant.arrayInfrastructurePhotos = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempInfraStructurePhotos.count; i++)
                    {
                        NSDictionary *currentDictionaryInfrastructurePhoto = [arrayTempInfraStructurePhotos objectAtIndex:i];
                        
                        [objMerchant.arrayInfrastructurePhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryInfrastructurePhoto objectForKey:@"url"]]];
                    }
                    
                    //menu_photos
                    NSArray *arrayTempMenuPhotos = [currentDictionary objectForKey:@"menu_photos"];
                    objMerchant.arrayMenuPhotos = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempMenuPhotos.count; i++)
                    {
                        NSDictionary *currentDictionaryMenuPhoto = [arrayTempMenuPhotos objectAtIndex:i];
                        
                        [objMerchant.arrayMenuPhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryMenuPhoto objectForKey:@"url"]]];
                    }
                    
                    
                    NSArray *arrayTempCoupons = [currentDictionary objectForKey:@"coupons_list"];
                    objMerchant.arrayCoupons = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempCoupons.count; i++)
                    {
                        NSDictionary *currentDictionaryCoupon = [arrayTempCoupons objectAtIndex:i];
                        
                        Coupon *objCoupon = [[Coupon alloc] init];
                        
                        objCoupon.strCouponID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_id"]];
                        objCoupon.strCouponImageURL = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_image"]];
                        objCoupon.strCouponTitle = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_title"]];
                        objCoupon.strCouponDescription = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_description"]];
                        
                        objCoupon.strAddedDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"date_added"]];
                        objCoupon.strEndDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"end_date"]];
                        
                        objCoupon.strIsExpired = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_expired"]];
                        objCoupon.strIsPinged = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_pinged"]];
                        objCoupon.strIsStareed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_starred"]];
                        objCoupon.strIsUsed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_used"]];
                        
                        objCoupon.strNumberOfRedeem = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"num_of_redeem"]];
                        objCoupon.strTermsAndConditions = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"terms_conditions"]];
                        
                        //PINGED USER DETAILS
                        objCoupon.strPingedID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"ping_id"]];
                        objCoupon.strPingedStatus = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"ping_status"]];
                        objCoupon.strPingedUserID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"pinged_user_id"]];
                        objCoupon.strPingedUserName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"pinged_user_name"]];
                        
                        
                        NSArray *arrayTempOutlets = [currentDictionaryCoupon objectForKey:@"coupon_at_available_outlets"];
                        objCoupon.arrayOutlets = [[NSMutableArray alloc] init];
                        
                        for (int j = 0; j < arrayTempOutlets.count; j++)
                        {
                            NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:j];
                            
                            Outlet *objOutlet = [[Outlet alloc] init];
                            
                            objOutlet.strOutletID = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"outlet_id"]];
                            objOutlet.strCouponOutletID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"coupon_outlets_id"]];
                            
                            objOutlet.strAddress = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"address"]];
                            objOutlet.strStartTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time"]];
                            objOutlet.strStartTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time2"]];
                            objOutlet.strEndTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time"]];
                            objOutlet.strEndTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time2"]];
                            
                            objOutlet.strLatitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"latitude"]];
                            objOutlet.strLongitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"longitude"]];
                            
                            objOutlet.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"area_name"]];
//                            objOutlet.strDistance = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"distance"]];
                            float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                            objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                            
                            objOutlet.strPhoneNumber = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"phone_number"]];
                            objOutlet.strPin = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"pin"]];
                            objOutlet.strStatus = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"status"]];
                            
                            objOutlet.strCityID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_id"]];
                            objOutlet.strCityName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_name"]];
                            
                            [objCoupon.arrayOutlets addObject:objOutlet];
                        }
                        
                        [objMerchant.arrayCoupons addObject:objCoupon];
                    }
                    
                    [self.arrayAllPingedOffers addObject:objMerchant];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllPingedOffersEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL MY PINGED OFFER

-(void)user_getAllMyPingedOffer:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_My_Pinged_Offers"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        //        [parameters setObject:@"11987" forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL MERCHANTS ARRAY ==========//
                NSArray *arrayAllPingedMerchantsList = [jsonResult objectForKey:@"pinged_list"];
                
                self.arrayAllMyPingedOffers = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllPingedMerchantsList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllPingedMerchantsList objectAtIndex:i];
                    
                    Merchant *objMerchant = [[Merchant alloc] init];
                    
                    objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                    objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                    objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                    objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                    
                    NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                    
                    NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_banner_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                    
                    objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                    
                    objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                    
                    objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                    
                    objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                    objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_coupons"]];
                    
                    objMerchant.strStatus = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"status"]];
                    objMerchant.strType = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"type"]];
                    
                    //infrastructure_photos
                    NSArray *arrayRatings = [currentDictionary objectForKey:@"ratings"];
                    objMerchant.arrayRatings = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayRatings.count; i++)
                    {
                        NSDictionary *currentDictionaryRatings = [arrayRatings objectAtIndex:i];
                        
                        Rating *objRating = [[Rating alloc] init];
                        
                        objRating.strUserID = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"user_id"]];
                        objRating.strName = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"name"]];
                        objRating.strRating = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"rating"]];
                        objRating.strComment = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"comment"]];
                        objRating.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionaryRatings objectForKey:@"mobile"]];
                        
                        [objMerchant.arrayRatings addObject:objRating];
                    }
                    
                    //infrastructure_photos
                    NSArray *arrayTempInfraStructurePhotos = [currentDictionary objectForKey:@"infrastructure_photos"];
                    objMerchant.arrayInfrastructurePhotos = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempInfraStructurePhotos.count; i++)
                    {
                        NSDictionary *currentDictionaryInfrastructurePhoto = [arrayTempInfraStructurePhotos objectAtIndex:i];
                        
                        [objMerchant.arrayInfrastructurePhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryInfrastructurePhoto objectForKey:@"url"]]];
                    }
                    
                    //menu_photos
                    NSArray *arrayTempMenuPhotos = [currentDictionary objectForKey:@"menu_photos"];
                    objMerchant.arrayMenuPhotos = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempMenuPhotos.count; i++)
                    {
                        NSDictionary *currentDictionaryMenuPhoto = [arrayTempMenuPhotos objectAtIndex:i];
                        
                        [objMerchant.arrayMenuPhotos addObject:[NSString stringWithFormat:@"%@", [currentDictionaryMenuPhoto objectForKey:@"url"]]];
                    }
                    
                    
                    NSArray *arrayTempCoupons = [currentDictionary objectForKey:@"coupons_list"];
                    objMerchant.arrayCoupons = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempCoupons.count; i++)
                    {
                        NSDictionary *currentDictionaryCoupon = [arrayTempCoupons objectAtIndex:i];
                        
                        Coupon *objCoupon = [[Coupon alloc] init];
                        
                        objCoupon.strCouponID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_id"]];
                        objCoupon.strCouponImageURL = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_image"]];
                        objCoupon.strCouponTitle = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_title"]];
                        objCoupon.strCouponDescription = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"coupon_description"]];
                        
                        objCoupon.strAddedDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"date_added"]];
                        objCoupon.strEndDate = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"end_date"]];
                        
                        objCoupon.strIsExpired = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_expired"]];
                        objCoupon.strIsPinged = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_pinged"]];
                        objCoupon.strIsStareed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_starred"]];
                        objCoupon.strIsUsed = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"is_used"]];
                        
                        objCoupon.strNumberOfRedeem = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"num_of_redeem"]];
                        objCoupon.strTermsAndConditions = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"terms_conditions"]];
                        
                        //PINGED USER DETAILS
                        objCoupon.strPingedID = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"ping_id"]];
                        objCoupon.strPingedStatus = [NSString stringWithFormat:@"%@", [currentDictionaryCoupon objectForKey:@"ping_status"]];
                        objCoupon.strPingedUserID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"from_user_id"]];
                        objCoupon.strPingedUserName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"from_user_name"]];
                        
                        
                        NSArray *arrayTempOutlets = [currentDictionaryCoupon objectForKey:@"coupon_at_available_outlets"];
                        objCoupon.arrayOutlets = [[NSMutableArray alloc] init];
                        
                        for (int j = 0; j < arrayTempOutlets.count; j++)
                        {
                            NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:j];
                            
                            Outlet *objOutlet = [[Outlet alloc] init];
                            
                            objOutlet.strOutletID = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"outlet_id"]];
                            objOutlet.strCouponOutletID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"coupon_outlets_id"]];
                            
                            objOutlet.strAddress = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"address"]];
                            objOutlet.strStartTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time"]];
                            objOutlet.strStartTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"start_time2"]];
                            objOutlet.strEndTime = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time"]];
                            objOutlet.strEndTime2 = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"end_time2"]];
                            
                            objOutlet.strLatitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"latitude"]];
                            objOutlet.strLongitude = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"longitude"]];
                            
                            objOutlet.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"area_name"]];
//                            objOutlet.strDistance = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"distance"]];
                            float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                            objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                            
                            objOutlet.strPhoneNumber = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"phone_number"]];
                            objOutlet.strPin = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"pin"]];
                            objOutlet.strStatus = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"status"]];
                            
                            objOutlet.strCityID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_id"]];
                            objOutlet.strCityName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_name"]];
                            
                            [objCoupon.arrayOutlets addObject:objOutlet];
                        }
                        
                        [objMerchant.arrayCoupons addObject:objCoupon];
                    }
                    
                    [self.arrayAllMyPingedOffers addObject:objMerchant];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllMyPingedOffersEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO REDEEM OFFER

-(void)user_redeemOffer:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Redeem_Offer"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"coupon_id"] forKey:@"coupon_id"];
        [parameters setObject:[dictParameters objectForKey:@"pin"] forKey:@"pin"];
        
        [parameters setObject:[dictParameters objectForKey:@"is_pinged"] forKey:@"is_pinged"];
        [parameters setObject:[dictParameters objectForKey:@"ping_id"] forKey:@"ping_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_redeemedOfferEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET SEARCH RESULT

-(void)user_getSearchResult:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Search_Results"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        [parameters setObject:[dictParameters objectForKey:@"value"] forKey:@"value"];
        
        // LOCATION
        [parameters setObject:[dictParameters objectForKey:@"latitude"] forKey:@"latitude"];
        [parameters setObject:[dictParameters objectForKey:@"longitude"] forKey:@"longitude"];
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL MERCHANTS ARRAY ==========//
                NSArray *arrayAllSearchResult = [jsonResult objectForKey:@"coupons_list"];
                
                self.arrayAllSearchResults = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllSearchResult.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllSearchResult objectAtIndex:i];
                    
                    Merchant *objMerchant = [[Merchant alloc] init];
                    objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                    objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                    objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                    objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                    
                    objMerchant.strCategoryID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_id"]];
                    objMerchant.strCategoryName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_name"]];
                    
                    
                    NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                    
                    NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                    
                    objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                    
                    objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_favorite"]];
                    
                    objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                    
                    objMerchant.strNumberOfRedeems = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_redeem"]];
                    objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                    
                    objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                    objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_offers"]];
                    
                    NSArray *arrayTempOutlets = [currentDictionary objectForKey:@"outlets"];
                    objMerchant.arrayOutlets = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrayTempOutlets.count; i++)
                    {
                        NSDictionary *currentDictionaryOutlet = [arrayTempOutlets objectAtIndex:i];
                        Outlet *objOutlet = [[Outlet alloc] init];
                        objOutlet.strAreaName = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"area_name"]];
//                        objOutlet.strDistance = [NSString stringWithFormat:@"%@", [currentDictionaryOutlet objectForKey:@"distance"]];
                        float floatDistance = [[currentDictionaryOutlet objectForKey:@"distance"] floatValue];
                        objOutlet.strDistance = [NSString stringWithFormat:@"%.2f", floatDistance];
                        
                        objOutlet.strCityID = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_id"]];
                        objOutlet.strCityName = [NSString stringWithFormat:@"%@",[currentDictionaryOutlet objectForKey:@"city_name"]];
                        
                        [objMerchant.arrayOutlets addObject:objOutlet];
                    }
                    
                    [self.arrayAllSearchResults addObject:objMerchant];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotSearchResultEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark - MY ACCOUNT WEB SERVICE
#pragma mark USER FUNCTION TO GET PROFILE DETAILS

-(void)user_getProfileDetails
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_Profile_Deails"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    self.objLoggedInUser.strUserID = [NSString stringWithFormat:@"%@",[prefs objectForKey:@"userid"]];
                    self.objLoggedInUser.strPhoneNumber = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"user_contact"]];
                    
                    self.objLoggedInUser.strUserName = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"user_name"]];
                    self.objLoggedInUser.strProfileImageURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"user_image"]];
                    if([jsonResult objectForKey:@"valid_date"] != nil)
                    {
                        self.objLoggedInUser.strValidityDate = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"valid_date"]];
                    }
                    else
                    {
                        self.objLoggedInUser.strValidityDate = [NSString stringWithFormat:@"-"];
                    }
                    
                    if ([jsonResult objectForKey:@"userofferamcoinbalance"] != nil)
                    {
                        self.objLoggedInUser.strOfferamCoinsBalance = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"userofferamcoinbalance"]];
                    }
                    else
                    {
                        self.objLoggedInUser.strOfferamCoinsBalance = [NSString stringWithFormat:@"0"];
                    }
                    
                    self.objLoggedInUser.strReferralCode = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"referal_code"]];
                    self.objLoggedInUser.strReferralUrl = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"referal_url"]];
                    
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    [prefs setObject:self.objLoggedInUser.strUserID forKey:@"userid"];
                    [prefs setObject:self.objLoggedInUser.strPhoneNumber forKey:@"userphonenumber"];
                    
                    [prefs setObject:self.objLoggedInUser.strUserName forKey:@"username"];
                    [prefs setObject:self.objLoggedInUser.strProfileImageURL forKey:@"userimage"];
                    [prefs setObject:self.objLoggedInUser.strValidityDate forKey:@"uservaliddate"];
                    [prefs setObject:self.objLoggedInUser.strValidityDate forKey:@"userofferamcoinbalance"];
                    [prefs synchronize];
                    
                    //FILL Redeemer ARRAYS
                    //========== FILL MY CONTACT REDEEMER ARRAY ==========//
                    NSArray *arrayMyContactsRedeemers = [jsonResult objectForKey:@"my_contact_redeemers_list"];
                    
                    self.arrayMyContactsRedeemers = [[NSMutableArray alloc] init];
                    
                    for(int i = 0 ; i < arrayMyContactsRedeemers.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayMyContactsRedeemers objectAtIndex:i];
                        
                        Redeemer *objRedeemer = [[Redeemer alloc] init];
                        
                        objRedeemer.strRedeemerID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemer_id"]];
                        objRedeemer.strRedeemerProfileImageURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemer_profile_image_url"]];
                        objRedeemer.strRedeemerName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemer_name"]];
                        objRedeemer.strRedeemerAmount = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemed_amount"]];
                        
                        [self.arrayMyContactsRedeemers addObject:objRedeemer];
                    }
                    
                    //========== FILL TOP TEN REDEEMER ARRAY ==========//
                    NSArray *arrayTopTenRedeemers = [jsonResult objectForKey:@"top_ten_redeemers_list"];
                    
                    self.arrayTopTenRedeemers = [[NSMutableArray alloc] init];
                    
                    for(int i = 0 ; i < arrayTopTenRedeemers.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayTopTenRedeemers objectAtIndex:i];
                        
                        Redeemer *objRedeemer = [[Redeemer alloc] init];
                        
                        objRedeemer.strRedeemerID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemer_id"]];
                        objRedeemer.strRedeemerProfileImageURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemer_profile_image_url"]];
                        objRedeemer.strRedeemerName = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemer_name"]];
                        objRedeemer.strRedeemerAmount = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"redeemed_amount"]];
                        
                        [self.arrayTopTenRedeemers addObject:objRedeemer];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotProfileDetailsEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO UPADTE PROFILE PICTURE

-(void)user_updateProfileDetails:(NSDictionary *)dictParameters;
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Update_Profile_Details"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"user_name"] forKey:@"user_name"];
        
        if ([dictParameters objectForKey:@"referral_code"] != nil)
        {
            [parameters setObject:[dictParameters objectForKey:@"referral_code"] forKey:@"referral_code"];
        }
        
        [parameters setObject:[dictParameters objectForKey:@"is_image_uploaded"] forKey:@"is_image_uploaded"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             if ([[dictParameters objectForKey:@"is_image_uploaded"] integerValue] == 1)
             {
                 [formData appendPartWithFileData:[dictParameters objectForKey:@"profile_image"] name:@"user_image" fileName:@"1.png" mimeType:@"image/png"];
             }
            
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_updatedProfileDetailsEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO SUBMIT REVIEW

-(void)user_submitRating:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Submit_Rating"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"rating"] forKey:@"rating"];
        [parameters setObject:[dictParameters objectForKey:@"comment"] forKey:@"comment"];
        [parameters setObject:[dictParameters objectForKey:@"merchant_id"] forKey:@"merchant_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_submitRatingEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO APPLY PROMO CODE
-(void)user_applyPromoCode:(NSString *)strPromoCode
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Apply_Promo_Code"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        [parameters setObject:strPromoCode forKey:@"promotional_code"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    self.strCodeDescription = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"code_description"]];
                    self.strDiscountValue = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"discount_value"]];
                    self.strCodeType = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"discount_type"]];
                    
                    if ([[jsonResult objectForKey:@"discount_type"] integerValue] == 2)
                    {
                        [prefs setObject:[NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"payment_id"]] forKey:@"userpaymentid"];
                    }
                    
                    self.boolIsCouponApplied = true;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_appliedPromoCodeEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ORDER ID

-(void)user_getOrderId:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_Order_Id"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"promotional_code"] forKey:@"promotional_code"];
        
        [parameters setObject:[dictParameters objectForKey:@"amount"] forKey:@"amount"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    self.strGeneratedOrderId  = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"order_id"]];
                    self.strGeneratedPaymentId  = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"payment_id"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotOrderIdEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GENERATE CHECKSUM

-(void)user_generateChecksum:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Generate_Checksum"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"CUST_ID"];
        
        [parameters setObject:[dictParameters objectForKey:@"ORDER_ID"] forKey:@"ORDER_ID"];
        [parameters setObject:[dictParameters objectForKey:@"TXN_AMOUNT"] forKey:@"TXN_AMOUNT"];
        
        NSString *strUserMobileNumber = [[NSString alloc] init];
        if ([prefs objectForKey:@"userphonenumber"] != nil)
            strUserMobileNumber = [NSString stringWithFormat:@"%@", [prefs objectForKey:@"userphonenumber"]];
        else
            strUserMobileNumber = @"";
        
        [parameters setObject:strUserMobileNumber forKey:@"MERC_UNQ_REF"];
//        [parameters setObject:strUserMobileNumber forKey:@"CONTACT_NUMBER"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"payt_STATUS"] integerValue] == 1)
                {
                    self.strGeneratedChecksum = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"CHECKSUMHASH"]];
                    NSLog(@"self.strGeneratedChecksum  : %@", self.strGeneratedChecksum );
                    
                    //                    self.strGeneratedChecksum = [self.strGeneratedChecksum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    self.strGeneratedOrderId = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"ORDER_ID"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_generatedChecksumEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO PURCHASE VERSION

-(void)user_purchaseVersion:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Purchase_Version"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
        }
        
        [parameters setObject:[dictParameters objectForKey:@"promotional_code"] forKey:@"promotional_code"];
        [parameters setObject:[dictParameters objectForKey:@"transaction_id"] forKey:@"transaction_id"];
        [parameters setObject:[dictParameters objectForKey:@"payment_amount"] forKey:@"payment_amount"];
        [parameters setObject:[dictParameters objectForKey:@"order_id"] forKey:@"order_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [prefs setObject:[NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"payment_id"]] forKey:@"userpaymentid"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_purchasedVersionEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL USED OFFERS

-(void)user_getAllUsedOffers
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Used_Offers"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                self.arrayAllUsedOffers = [[NSMutableArray alloc] init];
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    if ([jsonResult objectForKey:@"offeram_coin_balance"] != nil)
                    {
                        self.objLoggedInUser.strOfferamCoinsBalance = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"offeram_coin_balance"]];
                    }
                    
                    //========== FILL ALL MERCHANTS ARRAY ==========//
                    NSArray *arrayAllUsedCouponsList = [jsonResult objectForKey:@"user_used_coupons"];
                    
                    for(int i = 0 ; i < arrayAllUsedCouponsList.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayAllUsedCouponsList objectAtIndex:i];
                        
                        Merchant *objMerchant = [[Merchant alloc] init];
                        objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                        objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                        objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                        objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                        
                        objMerchant.strCategoryID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_id"]];
                        objMerchant.strCategoryName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_name"]];
                        
                        
                        NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                        
                        NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                        
                        objMerchant.strCouponID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_id"]];
                        objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                        
                        objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_favorite"]];
                        
                        objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                        
                        objMerchant.strNumberOfRedeems = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_redeem"]];
                        objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                        
                        objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                        objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_offers"]];
                        
                        objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_starred"]];
                        
                        objMerchant.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_name"]];
                        objMerchant.strDateUsed = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"date_used"]];
                        
                        objMerchant.strIsReused = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_reused"]];
                        objMerchant.strReuseAmount = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"reuse_price"]];
                        
                        objMerchant.strRedemptionID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"redemption_id"]];
                        
                        [self.arrayAllUsedOffers addObject:objMerchant];
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllUsedOffersEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET RE ACTIVATE OFFER

-(void)user_reActivateOffer:(NSString *)strCouponID withRedemptionId:(NSString *)strRedemptionID
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Re_Activate_Coupon"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        NSString *strUserVersionId = [prefs objectForKey:@"view_userversionid"];
        if ([[[prefs dictionaryRepresentation] allKeys] containsObject:@"view_userversionid"] && strUserVersionId != nil && strUserVersionId.length > 0)
        {
            [parameters setObject:[prefs objectForKey:@"view_userversionid"] forKey:@"version_id"];
            [parameters setObject:@"" forKey:@"payment_id"];
        }
        else
        {
            [parameters setObject:[prefs objectForKey:@"userversionid"] forKey:@"version_id"];
            [parameters setObject:[prefs objectForKey:@"userpaymentid"] forKey:@"payment_id"];
        }
        
        NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
        if (strCityID != nil)
        {
            [parameters setObject:strCityID forKey:@"city_id"];
        }
        else
        {
            [parameters setObject:@"" forKey:@"city_id"];
        }
        
        [parameters setObject:strCouponID forKey:@"coupon_id"];
        [parameters setObject:strRedemptionID forKey:@"redemption_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                self.arrayAllUsedOffers = [[NSMutableArray alloc] init];
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    //========== FILL ALL MERCHANTS ARRAY ==========//
                    NSArray *arrayAllUsedCouponsList = [jsonResult objectForKey:@"user_used_coupons"];
                    
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    if ([jsonResult objectForKey:@"offeram_coin_balance"] != nil)
                    {
                        self.objLoggedInUser.strOfferamCoinsBalance = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"offeram_coin_balance"]];
                    }
                    
                    for(int i = 0 ; i < arrayAllUsedCouponsList.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayAllUsedCouponsList objectAtIndex:i];
                        
                        Merchant *objMerchant = [[Merchant alloc] init];
                        objMerchant.strMerchantID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"merchant_id"]];
                        objMerchant.strCompanyName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_name"]];
                        objMerchant.strUserName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"user_name"]];
                        objMerchant.strAverageRatings = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"average_ratings"]];
                        
                        objMerchant.strCategoryID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_id"]];
                        objMerchant.strCategoryName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"category_name"]];
                        
                        
                        NSString *strMerchantLogoImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"company_logo"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        objMerchant.strCompanyLogoImageUrl = strMerchantLogoImageUrl;
                        
                        NSString *strMerchantBannerImageUrl = [[NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_image"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        objMerchant.strCompanyBannerImageUrl = strMerchantBannerImageUrl;
                        
                        objMerchant.strCouponID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_id"]];
                        objMerchant.strCouponTitle = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"coupon_title"]];
                        
                        objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_favorite"]];
                        
                        objMerchant.strMobileNumber = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"mobile"]];
                        
                        objMerchant.strNumberOfRedeems = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_redeem"]];
                        objMerchant.strOfferText = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"offer_text"]];
                        
                        objMerchant.strTotalRating = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"total_rating"]];
                        objMerchant.strUserCoupons = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"num_of_offers"]];
                        
                        objMerchant.strIsStarred = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_starred"]];
                        
                        objMerchant.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_name"]];
                        objMerchant.strDateUsed = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"date_used"]];
                        
                        objMerchant.strIsReused = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"is_reused"]];
                        objMerchant.strReuseAmount = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"reuse_price"]];
                        
                        objMerchant.strRedemptionID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"redemption_id"]];
                        
                        [self.arrayAllUsedOffers addObject:objMerchant];
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_reActivatedOfferEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL TRANSACTIONS

-(void)user_getAllTransactions
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_transactions"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                self.arrayAllTransactions = [[NSMutableArray alloc] init];
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    
                    self.objLoggedInUser.strOfferamCoinsBalance = [NSString stringWithFormat:@"%@",[jsonResult objectForKey:@"offeram_coin_balance"]];
                    //========== FILL ALL MERCHANTS ARRAY ==========//
                    NSArray *arrayAllTransactionsList = [jsonResult objectForKey:@"transactions"];
                    
                    for(int i = 0 ; i < arrayAllTransactionsList.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayAllTransactionsList objectAtIndex:i];
                        
                        Transaction *objTransaction = [[Transaction alloc] init];
                        
                        objTransaction.strTransactionID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"transaction_id"]];
                        objTransaction.strTransactionMessage = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"transaction_reason"]];
                        objTransaction.strTransactionType = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"transaction_type"]];
                        objTransaction.strTransactionAmount = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"transaction_amount"]];
                        objTransaction.strTransactionDateTime = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"transaction_date_time"]];
                        
                        [self.arrayAllTransactions addObject:objTransaction];
                    }
                    
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllTransactionsEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO UPLOAD ALL CONTACTS

-(void)user_uploadContacts:(NSArray *)dictContactsArray
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Upload_All_Contacts"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:dictContactsArray forKey:@"contact_details"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_uploadedContactsEvent" object:nil];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user_uploadedContactsEvent" object:nil];
//            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO REGISTER FOR TAMBOLA OLD

-(void)user_registerForTambola
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Register_For_Tambola"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    self.boolIsUserRegisteredForTambola = true;
                    self.strTambolaTicketURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"ticket_url"]];
                    
                    self.strTambolaTicketOrderId = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"order_id"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_registeredForTambola" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL TAMBOLA TICKETS

-(void)user_getAllTambolaTickets
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Get_All_Tambola_Tickets"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ALL ACTIVE TAMBOLA TICKETS ARRAY ==========//
                NSArray *arrayAllActiveTambolaTicketsLocal = [jsonResult objectForKey:@"current_events"];
                
                self.arrayAllActiveTambolaTickets = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllActiveTambolaTicketsLocal.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllActiveTambolaTicketsLocal objectAtIndex:i];
                    
                    TambolaTicket *objTambolaTicket = [[TambolaTicket alloc] init];
                    
                    objTambolaTicket.strTambolaTicketID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"tambola_event_id"]];
                    objTambolaTicket.strTambolaTicketImageURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"image"]];
                    objTambolaTicket.strTambolaTicketTitle = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"title"]];
                    objTambolaTicket.strTambolaTicketDescription = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"description"]];
                    objTambolaTicket.strTambolaTicketPrice = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"price"]];
                    objTambolaTicket.boolIsTambolaRequiredRegistration = [[NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"is_registration_required"]] boolValue];
                    objTambolaTicket.strTambolaTicketPDFURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"ticket_url"]];
                    objTambolaTicket.boolIsAlreadyRegistered = [[NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"is_registered"]] boolValue];
                    objTambolaTicket.strTambolaTicketKnowMoreURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"know_more_url"]];
                                        
                    [self.arrayAllActiveTambolaTickets addObject:objTambolaTicket];
                }
                
                //========== FILL ALL COMPLETED TAMBOLA TICKETS ARRAY ==========//
                NSArray *arrayAllCompletedTambolaTicketsLocal = [jsonResult objectForKey:@"past_events"];
                
                self.arrayAllCompletedTambolaTickets = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAllCompletedTambolaTicketsLocal.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAllCompletedTambolaTicketsLocal objectAtIndex:i];
                    
                    TambolaTicket *objTambolaTicket = [[TambolaTicket alloc] init];
                    
                    objTambolaTicket.strTambolaTicketID = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"tambola_event_id"]];
                    objTambolaTicket.strTambolaTicketImageURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"image"]];
                    objTambolaTicket.strTambolaTicketTitle = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"title"]];
                    objTambolaTicket.strTambolaTicketDescription = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"description"]];
                    objTambolaTicket.strTambolaTicketPrice = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"price"]];
                    objTambolaTicket.boolIsTambolaRequiredRegistration = [[NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"is_registration_required"]] boolValue];
                    objTambolaTicket.strTambolaTicketPDFURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"ticket_url"]];
                    objTambolaTicket.boolIsAlreadyRegistered = [[NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"is_registered"]] boolValue];
                    objTambolaTicket.strTambolaTicketKnowMoreURL = [NSString stringWithFormat:@"%@", [currentDictionary objectForKey:@"know_more_url"]];
                    
                    [self.arrayAllCompletedTambolaTickets addObject:objTambolaTicket];
                }
                
                //========== FILL ALL AREAS ARRAY ==========//
                NSArray *arrayAllAreasList = [jsonResult objectForKey:@"all_areas"];
                
                NSSortDescriptor * brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"area_name" ascending:YES];
                NSArray * sortedArray = [arrayAllAreasList sortedArrayUsingDescriptors:@[brandDescriptor]];
                
                self.arrayAllAreas = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < sortedArray.count; i++)
                {
                    NSDictionary *currentDictionary = [sortedArray objectAtIndex:i];
                    
                    Area *objArea = [[Area alloc] init];
                    objArea.strAreaID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_id"]];
                    objArea.strAreaName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"area_name"]];
                    
                    objArea.strCityID = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"city_id"]];
                    objArea.strCityName = [NSString stringWithFormat:@"%@",[currentDictionary objectForKey:@"city_name"]];
                    
                    [self.arrayAllAreas addObject:objArea];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllTambolaTicketsEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO PURCHASE TAMBOLA TICKET

-(void)user_purchaseTambolaTicket:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Purchase_Tambola_Ticket"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:self.strTambolaId forKey:@"tambola_id"];
        [parameters setObject:[dictParameters objectForKey:@"transaction_id"] forKey:@"transaction_id"];
        
//        [parameters setObject:[dictParameters objectForKey:@"tambola_event_id"] forKey:@"tambola_event_id"];
        [parameters setObject:[dictParameters objectForKey:@"promotional_code"] forKey:@"promotional_code"];
        [parameters setObject:[dictParameters objectForKey:@"payment_amount"] forKey:@"payment_amount"];
        [parameters setObject:[dictParameters objectForKey:@"order_id"] forKey:@"order_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
//                    self.strTambolaTicketURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"ticket_url"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_purchasedTambolaTicketEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO REGISTER FOR TAMBOLA WITH REGISTRATION DATA

-(void)user_registerForTambolaWithRegistrationData:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Register_For_Tambola"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [parameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        
        [parameters setObject:[dictParameters objectForKey:@"tambola_event_id"] forKey:@"tambola_event_id"];
        [parameters setObject:[dictParameters objectForKey:@"price"] forKey:@"price"];
        
        [parameters setObject:[dictParameters objectForKey:@"name"] forKey:@"name"];
        [parameters setObject:[dictParameters objectForKey:@"mobile_number"] forKey:@"mobile_number"];
        [parameters setObject:[dictParameters objectForKey:@"email"] forKey:@"email_id"];
        [parameters setObject:[dictParameters objectForKey:@"area"] forKey:@"area"];
        [parameters setObject:[dictParameters objectForKey:@"city"] forKey:@"city"];
        [parameters setObject:[dictParameters objectForKey:@"city_id"] forKey:@"city_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    self.strTambolaTicketURL = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"ticket_url"]];
                    self.strTambolaTicketOrderId = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_order_id"]];
                    self.strTambolaId = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"tambola_id"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_registeredForTambolaWithRegistrationDataEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

@end
