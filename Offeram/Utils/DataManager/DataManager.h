//
//  DataManager.h
//  Reward Cards
//
//  Created by Pratik Gujarati on 04/12/17.
//  Copyright © 2017 Innovative Iteration. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "CommonUtility.h"

//IMPORTING MODELS
#import "Area.h"
#import "City.h"
#import "Category.h"
#import "Merchant.h"
#import "User.h"

#import "Rating.h"
#import "Outlet.h"
#import "Coupon.h"

#import "Notification.h"
#import "Redeemer.h"
#import "Transaction.h"

#import "TambolaTicket.h"


@interface DataManager : NSObject
{
    NSNumber  *isNetworkAvailable;
    AppDelegate *appDelegate;
    
    User *objLoggedInUser;
}

//==================== OTHER VARIABLES ====================//

@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) NSDictionary *dictionaryWebservicesUrls;

@property(nonatomic,retain) User *objLoggedInUser;

@property(nonatomic,retain) NSMutableArray *arrayAllSuggestions;
@property (nonatomic,retain) NSMutableArray *arrayAllCategoryList;
@property(nonatomic,retain) NSMutableArray *arrayAllCity;
@property(nonatomic,retain) NSMutableArray *arrayAllAreas;
@property(nonatomic,retain) NSMutableArray *arrayAllMerchants;
@property(nonatomic,retain) NSMutableArray *arrayAllFevoriteOffers;
@property(nonatomic,retain) NSMutableArray *arrayAllUnreadNotifications;
@property(nonatomic,retain) NSMutableArray *arrayAllReadNotifications;
@property(nonatomic,retain) NSMutableArray *arrayAllSearchResults;
@property(nonatomic,retain) NSMutableArray *arrayAllUsedOffers;

@property(nonatomic,retain) NSMutableArray *arrayMyContactsRedeemers;
@property(nonatomic,retain) NSMutableArray *arrayTopTenRedeemers;

@property(nonatomic,retain) NSMutableArray *arrayAllPingedOffers;
@property(nonatomic,retain) NSMutableArray *arrayAllMyPingedOffers;

@property(nonatomic,retain) NSMutableArray *arrayAllTransactions;

@property(nonatomic,retain) NSMutableArray *arrayAllActiveTambolaTickets;
@property(nonatomic,retain) NSMutableArray *arrayAllCompletedTambolaTickets;

@property(nonatomic,retain) Merchant *objSelectedMerchant;

// LOCATION VARIABLES
@property(nonatomic,assign) BOOL boolIsLocationAvailable;
@property(nonatomic,retain) NSString *strUserLocationLatitude;
@property(nonatomic,retain) NSString *strUserLocationLongitude;

// ACCESS TOKEN REGISTRE
@property(nonatomic, assign) BOOL isInvalidAccessTokenRegistered;
// NOTIFICATION ADJUSTMENTS
@property(nonatomic, assign) BOOL isSplashScreenOpen;

// VARIABLES
@property(nonatomic,retain) NSString *strIsUpdate;
@property(nonatomic,retain) NSString *strNotificationCount;
@property(nonatomic,retain) NSString *strPurchasePrice;

@property(nonatomic,retain) NSString *strOTP;
@property(nonatomic, assign) BOOL isFreshUser;

@property(nonatomic,assign) BOOL boolIsCouponApplied;
@property(nonatomic,retain) NSString *strCodeType;
@property(nonatomic,retain) NSString *strCodeDescription;
@property(nonatomic,retain) NSString *strDiscountValue;

@property(nonatomic,retain) NSString *strGeneratedChecksum;
@property(nonatomic,retain) NSString *strGeneratedOrderId;
@property(nonatomic,retain) NSString *strGeneratedPaymentId;

@property(nonatomic,assign) BOOL boolIsAppOpenedFromNotification;
@property(nonatomic,assign) BOOL boolIsNotificationScreenOpened;
@property(nonatomic,retain) NSString *strNotificationMerchantId;

@property(nonatomic,retain) NSString *strReferAndEarnText;
@property(nonatomic,retain) NSString *strOfferamCoinsLabel1Text;
@property(nonatomic,retain) NSString *strOfferamCoinsLabel2Text;
@property(nonatomic,retain) NSString *strOfferamCoinsLabel3Text;
@property(nonatomic,retain) NSString *strOfferamCoinsLabel4Text;

// TAMBOLA VARIABLES
@property(nonatomic, assign) BOOL boolIsTambolaActive;
@property(nonatomic, assign) BOOL boolIsUserRegisteredForTambola;
@property(nonatomic, assign) BOOL boolIsIPLActive;
@property(nonatomic,retain) NSString *strTambolaImageURL;
@property(nonatomic,retain) NSString *strTambolaTitle;
@property(nonatomic,retain) NSString *strTambolaDescription;
@property(nonatomic,retain) NSString *strTambolaTicketURL;
@property(nonatomic,retain) NSString *strTambolaRegisteredUsersCount;
@property(nonatomic,retain) NSString *strTambolaKnowMoreURL;
@property(nonatomic,retain) NSString *strTambolaShareMessage;

@property(nonatomic,retain) NSString *strTambolaTicketOrderId;
@property(nonatomic,retain) NSString *strTambolaId;
@property(nonatomic,retain) NSString *strTambolaTicketPrice;

@property(nonatomic,assign) int intGetAllMerchantsAPIResponseCode;
@property(nonatomic,retain) NSString *strGetAllMerchantsAPIErrorMessage;

#pragma mark - Server communication

//FUNCTION TO CHECK IF INTERNET CONNECTION IS AVAILABLE OR NOT
-(BOOL)isNetworkAvailable;

//FUNCTION TO SHOW ERROR ALERT
-(void)showErrorMessage:(NSString *)errorTitle withErrorContent:(NSString *)errorDescription;

#pragma mark - Webservices Methods

//==================== USER APP WEBSERVICES ====================//

//USER FUNCTION TO COLLECT DATA ON SPLASH SCREEN
-(void)user_collectDataOnSplashScreen;

// USER FUNCTION TO SEND OTP
-(void)user_sendOTP:(User *)objUser;

//USER FUNCTION TO RESEND OTP
-(void)user_resendOTP:(NSDictionary *)dictParameters;

//USER FUNCTION TO VERIFY PHONE NUMBER
-(void)user_verifyPhoneNumber:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET ALL MERCHANTS
-(void)user_getAllMerchants:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET ALL FEVORITE OFFERS
-(void)user_getAllFevoriteOffers:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET ALL NOTIFICATIONS
-(void)user_getAllNotifications;

//USER FUNCTION TO MARK NOTIFICATION AS READ
-(void)user_markNotificationsAsRead:(NSString *)strNotificationID;

//USER FUNCTION TO GET MERCHANT DETAILS
-(void)user_getMerchantDetails:(NSDictionary *)dictParameters;

//USER FUNCTION TO ADD OR REMOVE FROM FAVORITE OFFERS
-(void)user_addRemoveFromFavoriteOffers:(NSDictionary *)dictParameters;

//USER FUNCTION TO PING OFFER
-(void)user_pingOffer:(NSDictionary *)dictParameters;

//USER FUNCTION TO UPDATE PINGED OFFER
-(void)user_updatePingedOffer:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET ALL PINGED OFFER
-(void)user_getAllPingedOffer:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET ALL MY PINGED OFFER
-(void)user_getAllMyPingedOffer:(NSDictionary *)dictParameters;

//USER FUNCTION TO REDEEM OFFER
-(void)user_redeemOffer:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET SEARCH RESULT
-(void)user_getSearchResult:(NSDictionary *)dictParameters;

// MY ACCOUNT
//USER FUNCTION TO GET PROFILE DETAILS
-(void)user_getProfileDetails;

//USER FUNCTION TO UPADTE PROFILE PICTURE
-(void)user_updateProfileDetails:(NSDictionary *)dictParameters;

//USER FUNCTION TO SUBMIT REVIEW
-(void)user_submitRating:(NSDictionary *)dictParameters;

//USER FUNCTION TO APPLY PROMO CODE
-(void)user_applyPromoCode:(NSString *)strPromoCode;

//USER FUNCTION TO GET ORDER ID
-(void)user_getOrderId:(NSDictionary *)dictParameters;

//USER FUNCTION TO GENERATE CHECKSUM
-(void)user_generateChecksum:(NSDictionary *)dictParameters;

//USER FUNCTION TO PURCHASE VERSION
-(void)user_purchaseVersion:(NSDictionary *)dictParameters;

//USER FUNCTION TO GET ALL USED OFFERS
-(void)user_getAllUsedOffers;

//USER FUNCTION TO GET RE ACTIVATE OFFER
-(void)user_reActivateOffer:(NSString *)strCouponID withRedemptionId:(NSString *)strRedemptionID;

//USER FUNCTION TO GET ALL TRANSACTIONS
-(void)user_getAllTransactions;

//USER FUNCTION TO UPLOAD ALL CONTACTS
-(void)user_uploadContacts:(NSArray *)dictContactsArray;

//USER FUNCTION TO REGISTER FOR TAMBOLA
-(void)user_registerForTambola;

//USER FUNCTION TO GET ALL TAMBOLA TICKETS
-(void)user_getAllTambolaTickets;

//USER FUNCTION TO PURCHASE TAMBOLA TICKET
-(void)user_purchaseTambolaTicket:(NSDictionary *)dictParameters;

//USER FUNCTION TO REGISTER FOR TAMBOLA  WITH REGISTRATION DATA
-(void)user_registerForTambolaWithRegistrationData:(NSDictionary *)dictParameters;

@end
