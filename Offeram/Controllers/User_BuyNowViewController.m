//
//  User_BuyNowViewController.m
//  Offeram
//
//  Created by Dipen Lad on 11/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_BuyNowViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "PaymentFailedViewController.h"
#import "PaymentSucceedViewController.h"

@interface User_BuyNowViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_BuyNowViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize billViewWithbtnHaveCodeContainerView;
@synthesize lblMRPWithbtnHaveCodeContainerView;
@synthesize lblMRPValueWithbtnHaveCodeContainerView;
@synthesize btnHaveCode;
@synthesize lblTotalWithbtnHaveCodeContainer;
@synthesize lblTotalValueWithbtnHaveCodeContainer;

@synthesize enterCodeContainerView;
@synthesize txtEnterCode;
@synthesize txtEnterCodeBottomSeparatorView;
@synthesize btnApply;

@synthesize billViewWithoutbtnHaveCodeContainerView;
@synthesize lblMRPWithoutbtnHaveCodeContainerView;
@synthesize lblMRPValueWithoutbtnHaveCodeContainerView;
@synthesize lblTotalWithoutbtnHaveCodeContainerView;
@synthesize lblTotalValueWithoutbtnHaveCodeContainerView;

@synthesize billViewWithAppliedCodeContainerView;
@synthesize lblMRPWithAppliedCodeContainerView;
@synthesize lblMRPValueWithAppliedCodeContainerView;
@synthesize lblDiscountAmount;
@synthesize lblDiscountAmountValue;
@synthesize lblCouponDescriptin;
@synthesize lblTotalWithAppliedCodeContainerView;
@synthesize lblTotalValueWithAppliedCodeContainerView;

//========== OTHER VARIABLES ==========//

NSString *strTotal;

#pragma mark - View Controller Delegate Methods

@synthesize btnBuyNow;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MySingleton sharedManager].dataManager.boolIsCouponApplied = false;
    
    [self setupNotificationEvent];
    
    [self setNavigationBar];
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotificationEventObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_appliedPromoCodeEvent) name:@"user_appliedPromoCodeEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotOrderIdEvent) name:@"user_gotOrderIdEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_generatedChecksumEvent) name:@"user_generatedChecksumEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_purchasedVersionEvent) name:@"user_purchasedVersionEvent" object:nil];
        
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_appliedPromoCodeEvent
{
    
    if ([[MySingleton sharedManager].dataManager.strCodeType integerValue] == 2)
    {
        // FREE COUPON go to Payment Success
        
        PaymentSucceedViewController *viewController = [[PaymentSucceedViewController alloc] init];
        viewController.intLoadedFor = 1;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if ([[MySingleton sharedManager].dataManager.strCodeType integerValue] == 1)
    {
        // % DISCOUNT
        
        billViewWithoutbtnHaveCodeContainerView.hidden = true;
        
        enterCodeContainerView.hidden = false;
        billViewWithAppliedCodeContainerView.hidden = false;
        
        NSString *strDiscount = [NSString stringWithFormat:@"%.0f", [[MySingleton sharedManager].dataManager.strPurchasePrice floatValue] * ([[MySingleton sharedManager].dataManager.strDiscountValue floatValue]/ 100)];
        
        lblDiscountAmountValue.text = [NSString stringWithFormat:@"- ₹ %@", strDiscount];
        
        lblCouponDescriptin.text = [NSString stringWithFormat:@"# %@\n%@", txtEnterCode.text, [MySingleton sharedManager].dataManager.strCodeDescription];
        
        strTotal = [NSString stringWithFormat:@"%.0f", [[MySingleton sharedManager].dataManager.strPurchasePrice floatValue] - [strDiscount floatValue]];
        
        lblTotalValueWithAppliedCodeContainerView.text = [NSString stringWithFormat:@"₹ %@",strTotal];
        
        [btnBuyNow setTitle:[NSString stringWithFormat:@"Pay ₹ %@ Now", strTotal] forState:UIControlStateNormal];
    }
    else
    {
        // CASH DISCOUNT
        
        billViewWithoutbtnHaveCodeContainerView.hidden = true;
        
        enterCodeContainerView.hidden = false;
        billViewWithAppliedCodeContainerView.hidden = false;
        
        lblDiscountAmountValue.text = [NSString stringWithFormat:@"- ₹ %@", [MySingleton sharedManager].dataManager.strDiscountValue];
        
        lblCouponDescriptin.text = [NSString stringWithFormat:@"# %@\n%@", txtEnterCode.text, [MySingleton sharedManager].dataManager.strCodeDescription];
        
        strTotal = [NSString stringWithFormat:@"%.0f", [[MySingleton sharedManager].dataManager.strPurchasePrice floatValue] - [[MySingleton sharedManager].dataManager.strDiscountValue floatValue]];
        
        lblTotalValueWithAppliedCodeContainerView.text = [NSString stringWithFormat:@"₹ %@",strTotal];
        
        [btnBuyNow setTitle:[NSString stringWithFormat:@"Pay ₹ %@ Now", strTotal] forState:UIControlStateNormal];
    }
    
    billViewWithoutbtnHaveCodeContainerView.hidden = true;
    
    enterCodeContainerView.hidden = false;
    billViewWithAppliedCodeContainerView.hidden = false;
    
}

-(void)user_gotOrderIdEvent
{
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    [dictParameters setObject:[MySingleton sharedManager].dataManager.strGeneratedOrderId forKey:@"ORDER_ID"];
    if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
    {
        [dictParameters setObject:strTotal forKey:@"TXN_AMOUNT"];
    }
    else
    {
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strPurchasePrice forKey:@"TXN_AMOUNT"];
    }
    
//    // TEMP ADJUSTMENTS
//    [dictParameters setObject:@"50000" forKey:@"TXN_AMOUNT"];
    
    [[MySingleton sharedManager].dataManager user_generateChecksum:dictParameters];
}

-(void)user_purchasedVersionEvent
{
//    NSString *strAmount = [self.payTMPaymentDictionary objectForKey:@"total_amount"];
//
//    NSDictionary *parameters = @{FBSDKAppEventParameterNameDescription : [self.payTMPaymentDictionary objectForKey:@"version_id"]};
//    [FBSDKAppEvents logPurchase: [strAmount doubleValue]
//                       currency:@"INR"
//                     parameters: parameters];
    
    PaymentSucceedViewController *viewController = [[PaymentSucceedViewController alloc] init];
    viewController.intLoadedFor = 1;
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)user_generatedChecksumEvent
{
    [self paywithPaytm];
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblFont = [MySingleton sharedManager].themeFontTwentySizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
    }
    else
    {
        lblFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
    }
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.font = lblFont;
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    UIFont *txtFieldFont, *btnApplyFont, *btnFont, *lblTitleFont, *lblFont, *lblBoldFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblBoldFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnApplyFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFifteenSizeMedium;
        lblFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblBoldFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnApplyFont = [MySingleton sharedManager].themeFontFifteenSizeMedium;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        lblFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblBoldFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnApplyFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    // ========== WITH BTN HAVE CODE========//
    // border radius
    [billViewWithbtnHaveCodeContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [billViewWithbtnHaveCodeContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [billViewWithbtnHaveCodeContainerView.layer setShadowOpacity:0.6];
    [billViewWithbtnHaveCodeContainerView.layer setShadowRadius:3.0];
    [billViewWithbtnHaveCodeContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    billViewWithbtnHaveCodeContainerView.hidden = false;
    
    // LBL MRP WITH BTN HAVE CODE CONTAINER
    lblMRPWithbtnHaveCodeContainerView.font = lblFont;
    lblMRPWithbtnHaveCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMRPWithbtnHaveCodeContainerView.textAlignment = NSTextAlignmentLeft;
    
    // LBL MRP VALUE WITH BTN HAVE CODE CONTAINER
    lblMRPValueWithbtnHaveCodeContainerView.font = lblFont;
    lblMRPValueWithbtnHaveCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMRPValueWithbtnHaveCodeContainerView.textAlignment = NSTextAlignmentRight;
    
    // BTN HAVE PROMO CODE
    btnHaveCode.titleLabel.font = lblFont;
    [btnHaveCode setTitleColor:[MySingleton sharedManager].themeGlobalBlackColor forState:UIControlStateNormal];
    btnHaveCode.clipsToBounds = true;
    [btnHaveCode addTarget:self action:@selector(btnHaveCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strText = [NSString stringWithFormat: @"Wow!!! You are just one step away from Dil Kholke Discounts.\n\nGet all the amazing offers listed in the app for all the cities at just ₹ %@ with 1 year validity.\n\nApply Promocode",[MySingleton sharedManager].dataManager.strPurchasePrice];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strText];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:lblBoldFont
                       range:[strText rangeOfString:@"all the amazing offers"]];
    [attrString addAttribute:NSFontAttributeName
                       value:lblBoldFont
                       range:[strText rangeOfString:@"all the cities"]];
    [attrString addAttribute:NSFontAttributeName
                       value:lblBoldFont
                       range:[strText rangeOfString:@"Apply Promocode"]];
    [attrString endEditing];
    
    [btnHaveCode setAttributedTitle:attrString forState:UIControlStateNormal];
    
    // LBL TOTAL WITH BTN HAVE CODE CONTAINER
    lblTotalWithbtnHaveCodeContainer.font = lblFont;
    lblTotalWithbtnHaveCodeContainer.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTotalWithbtnHaveCodeContainer.textAlignment = NSTextAlignmentLeft;
    
    // LBL TOTAL VALUE WITH BTN HAVE CODE CONTAINER
    lblTotalValueWithbtnHaveCodeContainer.font = lblFont;
    lblTotalValueWithbtnHaveCodeContainer.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblTotalValueWithbtnHaveCodeContainer.textAlignment = NSTextAlignmentRight;
    
    
    // border radius
    [enterCodeContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [enterCodeContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [enterCodeContainerView.layer setShadowOpacity:0.6];
    [enterCodeContainerView.layer setShadowRadius:3.0];
    [enterCodeContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    enterCodeContainerView.hidden = true;
    
    // TXT ENTER CODE
    txtEnterCode.font = txtFieldFont;
    txtEnterCode.delegate = self;
    txtEnterCode.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter code here"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtEnterCode.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtEnterCode.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtEnterCode.floatingLabelFont = txtFieldFont;
    txtEnterCode.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEnterCode.keepBaseline = NO;
    [txtEnterCode setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtEnterCodeBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // BTN APPLY
    btnApply.titleLabel.font = btnApplyFont;
    [btnApply setTitleColor:[MySingleton sharedManager].themeGlobalBlueColor forState:UIControlStateNormal];
    btnApply.clipsToBounds = true;
    [btnApply addTarget:self action:@selector(btnApplyClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // ========== WITHOUT BTN HAVE CODE========//
    // border radius
    [billViewWithoutbtnHaveCodeContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [billViewWithoutbtnHaveCodeContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [billViewWithoutbtnHaveCodeContainerView.layer setShadowOpacity:0.6];
    [billViewWithoutbtnHaveCodeContainerView.layer setShadowRadius:3.0];
    [billViewWithoutbtnHaveCodeContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    billViewWithoutbtnHaveCodeContainerView.hidden = true;
    
    // LBL MRP WITH BTN HAVE CODE CONTAINER
    lblMRPWithoutbtnHaveCodeContainerView.font = lblFont;
    lblMRPWithoutbtnHaveCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMRPWithoutbtnHaveCodeContainerView.textAlignment = NSTextAlignmentLeft;
    
    // LBL MRP VALUE WITH BTN HAVE CODE CONTAINER
    lblMRPValueWithoutbtnHaveCodeContainerView.font = lblFont;
    lblMRPValueWithoutbtnHaveCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMRPValueWithoutbtnHaveCodeContainerView.textAlignment = NSTextAlignmentRight;
    // LBL TOTAL WITH BTN HAVE CODE CONTAINER
    lblTotalWithoutbtnHaveCodeContainerView.font = lblFont;
    lblTotalWithoutbtnHaveCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTotalWithoutbtnHaveCodeContainerView.textAlignment = NSTextAlignmentLeft;
    
    // ========== WITH APPLIED CODE========//
    // border radius
    [billViewWithAppliedCodeContainerView.layer setCornerRadius:5.0f];
    // drop shadow
    [billViewWithAppliedCodeContainerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [billViewWithAppliedCodeContainerView.layer setShadowOpacity:0.6];
    [billViewWithAppliedCodeContainerView.layer setShadowRadius:3.0];
    [billViewWithAppliedCodeContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    billViewWithAppliedCodeContainerView.hidden = true;
    
    // LBL MRP WITH APPLIED PROMOCODE
    lblMRPWithAppliedCodeContainerView.font = lblFont;
    lblMRPWithAppliedCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMRPWithAppliedCodeContainerView.textAlignment = NSTextAlignmentLeft;
    
    // LBL MRP VALUE WITH BTN HAVE CODE CONTAINER
    lblMRPValueWithAppliedCodeContainerView.font = lblFont;
    lblMRPValueWithAppliedCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblMRPValueWithAppliedCodeContainerView.textAlignment = NSTextAlignmentRight;
    
    // LBL DISCOUNT AMMOUNT
    lblDiscountAmount.font = lblFont;
    lblDiscountAmount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblDiscountAmount.textAlignment = NSTextAlignmentLeft;
    
    // LBL DISCOUNT AMOUNT VALUE
    lblDiscountAmountValue.font = lblFont;
    lblDiscountAmountValue.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblDiscountAmountValue.textAlignment = NSTextAlignmentRight;
    
    // LBL DESCRIPTION
    lblCouponDescriptin.font = lblFont;
    lblCouponDescriptin.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblCouponDescriptin.textAlignment = NSTextAlignmentLeft;
    lblCouponDescriptin.numberOfLines = 0;
    
    // LBL TOTAL WITH BTN HAVE CODE CONTAINER
    lblTotalWithAppliedCodeContainerView.font = lblFont;
    lblTotalWithAppliedCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTotalWithAppliedCodeContainerView.textAlignment = NSTextAlignmentLeft;
    
    // LBL TOTAL VALUE WITH BTN HAVE CODE CONTAINER
    lblTotalValueWithAppliedCodeContainerView.font = lblFont;
    lblTotalValueWithAppliedCodeContainerView.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblTotalValueWithAppliedCodeContainerView.textAlignment = NSTextAlignmentRight;
    
    
    
    // BTN BUY NOW
    btnBuyNow.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnBuyNow.titleLabel.font = btnFont;
    [btnBuyNow setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnBuyNow.clipsToBounds = true;
    [btnBuyNow addTarget:self action:@selector(btnBuyNowClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // SET VALUES
    lblMRPValueWithbtnHaveCodeContainerView.text = [NSString stringWithFormat:@"₹ %@", [MySingleton sharedManager].dataManager.strPurchasePrice];
    lblTotalValueWithbtnHaveCodeContainer.text = [NSString stringWithFormat:@"₹ %@", [MySingleton sharedManager].dataManager.strPurchasePrice];
    
    lblMRPValueWithoutbtnHaveCodeContainerView.text = [NSString stringWithFormat:@"₹ %@", [MySingleton sharedManager].dataManager.strPurchasePrice];
    lblTotalValueWithoutbtnHaveCodeContainerView.text = [NSString stringWithFormat:@"₹ %@", [MySingleton sharedManager].dataManager.strPurchasePrice];
    
    lblMRPValueWithAppliedCodeContainerView.text = [NSString stringWithFormat:@"₹ %@", [MySingleton sharedManager].dataManager.strPurchasePrice];
    
    [btnBuyNow setTitle:[NSString stringWithFormat:@"Pay ₹ %@ Now", [MySingleton sharedManager].dataManager.strPurchasePrice] forState:UIControlStateNormal];
    
}

-(IBAction)btnHaveCodeClicked:(id)sender
{
    billViewWithbtnHaveCodeContainerView.hidden = true;
    
    enterCodeContainerView.hidden = false;
    billViewWithoutbtnHaveCodeContainerView.hidden = false;
}

-(IBAction)btnApplyClicked:(id)sender
{
    [self.view endEditing:true];
    
    if (txtEnterCode.text.length <= 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter promotional code."];
        });
    }
    else
    {
        [MySingleton sharedManager].dataManager.boolIsCouponApplied = false;
        
        [[MySingleton sharedManager].dataManager user_applyPromoCode:txtEnterCode.text];
    }
}

-(IBAction)btnBuyNowClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
    {
        [dictParameters setObject:strTotal forKey:@"amount"];
        [dictParameters setObject:txtEnterCode.text forKey:@"promotional_code"];
    }
    else
    {
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strPurchasePrice forKey:@"amount"];
        [dictParameters setObject:@"" forKey:@"promotional_code"];
    }
    
//    // TEMP ADJUSTMENTS
//    [dictParameters setObject:@"50000" forKey:@"amount"];
    
    [[MySingleton sharedManager].dataManager user_getOrderId:dictParameters];
    
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - PAYMENT GATEWAY METHODS

- (void)paywithPaytm
{
    //Step 1: Create a default merchant config obje
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    
    //Step 2: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    
    //LIVE
    orderDict[@"MID"] = @"MAGNAD01013772099418";
    orderDict[@"ORDER_ID"] = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strGeneratedOrderId];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    orderDict[@"CUST_ID"] = [prefs objectForKey:@"userid"];
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail109";
    orderDict[@"CHANNEL_ID"] = @"WAP";
    
    if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
    {
        orderDict[@"TXN_AMOUNT"] = strTotal;
    }
    else
    {
        orderDict[@"TXN_AMOUNT"] = [MySingleton sharedManager].dataManager.strPurchasePrice;
    }
    
//    // TEMP ADJUSTMENTS
//    orderDict[@"TXN_AMOUNT"] = @"50000";
    
    orderDict[@"WEBSITE"] = @"MAGNADWAP";
    orderDict[@"CALLBACK_URL"] = [NSString stringWithFormat:@"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=%@", [MySingleton sharedManager].dataManager.strGeneratedOrderId];
    orderDict[@"CHECKSUMHASH"] = [MySingleton sharedManager].dataManager.strGeneratedChecksum;
    
    NSString *strUserMobileNumber = [[NSString alloc] init];
    if ([prefs objectForKey:@"userphonenumber"] != nil)
        strUserMobileNumber = [NSString stringWithFormat:@"%@", [prefs objectForKey:@"userphonenumber"]];
    else
        strUserMobileNumber = @"";
    
    orderDict[@"MERC_UNQ_REF"] = strUserMobileNumber;
//    orderDict[@"CONTACT_NUMBER"] = strUserMobileNumber;
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    
    //show title var
    UIView *mNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,64)];
    mNavBar.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    txnController.topBar = mNavBar;
    UILabel *mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 22, 100, 40)];
    [mTitleLabel setText:@"Payment"];
    [mTitleLabel setFont:[MySingleton sharedManager].navigationBarTitleFont];
    mTitleLabel.textColor = [MySingleton sharedManager].navigationBarTitleColor;
    mTitleLabel.textAlignment = NSTextAlignmentCenter;
    [mNavBar addSubview:mTitleLabel];
    
    txnController.serverType = eServerTypeProduction;
    txnController.merchant = mc;
    txnController.useStaging = false;
    txnController.delegate = self;
    txnController.loggingEnabled = YES;
    [self showController:txnController];
    //     }];
}

#pragma mark - PGTransactionViewController Delegate Methods

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
}

-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString
{
    DEBUGLOG(@"ViewController::didFinishedResponse:response = %@", responseString);
    
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonresponseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [self removeController:controller];
    
    if([[jsonresponseObject objectForKey:@"RESPCODE"] isEqualToString:@"01"])
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:jsonresponseObject[@"TXNID"] forKey:@"transaction_id"];
        
        if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
        {
            [dictParameters setObject:strTotal forKey:@"payment_amount"];
            [dictParameters setObject:txtEnterCode.text forKey:@"promotional_code"];
        }
        else
        {
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strPurchasePrice forKey:@"payment_amount"];
            [dictParameters setObject:@"" forKey:@"promotional_code"];
        }
        
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strGeneratedPaymentId forKey:@"order_id"];
        
        [[MySingleton sharedManager].dataManager user_purchaseVersion:dictParameters];
    }
    else
    {
        if([[jsonresponseObject objectForKey:@"RESPCODE"] isEqualToString:@"701"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Invalid Promotional Code"];
            });
        }
        else
        {
            PaymentFailedViewController *viewController = [[PaymentFailedViewController alloc] init];
            if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
            {
                viewController.strAmount = strTotal;
                viewController.strPromotionCode = txtEnterCode.text;
            }
            else
            {
                viewController.strAmount = [MySingleton sharedManager].dataManager.strPurchasePrice;
                viewController.strPromotionCode = @"";
            }
            viewController.intLoadedFor = 1;
            [self.navigationController pushViewController:viewController animated:true];
        }
    }
}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    
    NSString *msg = nil;
    if (!error) msg = [NSString stringWithFormat:@"Successful"];
    else msg = [NSString stringWithFormat:@"UnSuccessful"];
    
    ////    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [appDelegate showAlertViewWithTitle:@"" withDetails:@"Transaction Cancel"];
    
    
    [self removeController:controller];
}

//Called when Checksum HASH generation completes either by PG Server or Merchant Server.
- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}

#pragma mark - PGTransactionViewController delegate

- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didSucceedTransactionresponse= %@", response);
    
    NSString *title = [NSString stringWithFormat:@"Your order  was completed successfully. \n %@", response[@"ORDERID"]];
    
    ////    [[[UIAlertView alloc] initWithTitle:title message:[response description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //    [self showAlertViewWithTitle:title andWithMessage:[response description]];
    
    [self removeController:controller];
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:response[@"TXNID"] forKey:@"transaction_id"];
    
    if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
    {
        [dictParameters setObject:strTotal forKey:@"payment_amount"];
        [dictParameters setObject:txtEnterCode.text forKey:@"promotional_code"];
    }
    else
    {
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strPurchasePrice forKey:@"payment_amount"];
        [dictParameters setObject:@"" forKey:@"promotional_code"];
    }
    
    [dictParameters setObject:[MySingleton sharedManager].dataManager.strGeneratedPaymentId forKey:@"order_id"];
    
    [[MySingleton sharedManager].dataManager user_purchaseVersion:dictParameters];
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, response);
    
    //    if (response)
    //    {
    ////        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:[response description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //        [self showAlertViewWithTitle:error.localizedDescription andWithMessage:[response description]];
    //    }
    //    else if (error)
    //    {
    ////        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //        [self showAlertViewWithTitle:@"Error" andWithMessage:[response description]];
    //    }
    
    [self removeController:controller];
    
    PaymentFailedViewController *viewController = [[PaymentFailedViewController alloc] init];
    if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
    {
        viewController.strAmount = strTotal;
        viewController.strPromotionCode = txtEnterCode.text;
    }
    else
    {
        viewController.strAmount = [MySingleton sharedManager].dataManager.strPurchasePrice;
        viewController.strPromotionCode = @"";
    }
    viewController.intLoadedFor = 1;
    [self.navigationController pushViewController:viewController animated:true];
}

@end
