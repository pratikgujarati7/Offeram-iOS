//
//  PaymentFailedViewController.m
//  Offeram
//
//  Created by Dipen Lad on 11/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "PaymentFailedViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "PaymentSucceedViewController.h"

@interface PaymentFailedViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation PaymentFailedViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;

@synthesize mainScrollView;

@synthesize imageViewMain;

@synthesize lblTitle;
@synthesize lblDescription;

@synthesize btnTryAgain;

//========== OTHER VARIABLES ==========//

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_generatedChecksumEvent) name:@"user_generatedChecksumEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_purchasedVersionEvent) name:@"user_purchasedVersionEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_purchasedTambolaTicketEvent) name:@"user_purchasedTambolaTicketEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_generatedChecksumEvent
{
    [self paywithPaytm];
}

-(void)user_purchasedVersionEvent
{
    PaymentSucceedViewController *viewController = [[PaymentSucceedViewController alloc] init];
    viewController.intLoadedFor = self.intLoadedFor;
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)user_purchasedTambolaTicketEvent
{
    PaymentSucceedViewController *viewController = [[PaymentSucceedViewController alloc] init];
    viewController.intLoadedFor = self.intLoadedFor;
    [self.navigationController pushViewController:viewController animated:true];
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
    
    UIFont *lblTitleFont, *btnTitleFont;
    
    if([MySingleton sharedManager].screenHeight == 480)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeMedium;
        btnTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenHeight == 568)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeMedium;
        btnTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenHeight == 667)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        btnTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        btnTitleFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
    }
    
    lblTitle.font = lblTitleFont;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    lblDescription.font = lblTitleFont;
    lblDescription.textAlignment = NSTextAlignmentCenter;
    lblDescription.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    
    // BTN TRY AGAIN
    btnTryAgain.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnTryAgain.titleLabel.font = btnTitleFont;
    [btnTryAgain setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnTryAgain.clipsToBounds = true;
    [btnTryAgain addTarget:self action:@selector(btnTryAgainClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnTryAgainClicked:(id)sender
{
    if(self.intLoadedFor == 1)
    {
        //========== BUY NOW/PACKAGE PURCHASED REDIRECTION ==========//
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strGeneratedOrderId forKey:@"ORDER_ID"];
        if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
        {
            [dictParameters setObject:self.strAmount forKey:@"TXN_AMOUNT"];
        }
        else
        {
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strPurchasePrice forKey:@"TXN_AMOUNT"];
        }
        
        [[MySingleton sharedManager].dataManager user_generateChecksum:dictParameters];
    }
    else if(self.intLoadedFor == 2)
    {
        //========== TAMBOLA TICKET PURCHASED REDIRECTION ==========//
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketOrderId forKey:@"ORDER_ID"];
        if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
        {
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"TXN_AMOUNT"];
        }
        else
        {
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"TXN_AMOUNT"];
        }
        
        [[MySingleton sharedManager].dataManager user_generateChecksum:dictParameters];
    }
}

#pragma mark PAYMENT GATEWAY METHODS

- (void)paywithPaytm
{
    //Step 1: Create a default merchant config obje
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    
    //Step 2: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    
    //LIVE
    orderDict[@"MID"] = @"MAGNAD01013772099418";
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    orderDict[@"CUST_ID"] = [prefs objectForKey:@"userid"];
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail109";
    orderDict[@"CHANNEL_ID"] = @"WAP";
    
    if(self.intLoadedFor == 1)
    {
        //========== BUY NOW/PACKAGE PURCHASE ==========//
        
        orderDict[@"ORDER_ID"] = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strGeneratedOrderId];
        
        if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
        {
            orderDict[@"TXN_AMOUNT"] = self.strAmount;
        }
        else
        {
            orderDict[@"TXN_AMOUNT"] = [MySingleton sharedManager].dataManager.strPurchasePrice;
        }
    }
    else if(self.intLoadedFor == 2)
    {
        //========== TAMBOLA TICKET PURCHASE ==========//
        
        orderDict[@"ORDER_ID"] = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketOrderId];
        
        if ([MySingleton sharedManager].dataManager.boolIsCouponApplied == true)
        {
            orderDict[@"TXN_AMOUNT"] = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
        }
        else
        {
            orderDict[@"TXN_AMOUNT"] = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
        }
    }
    
    
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
    
    if(self.intLoadedFor == 1)
    {
        //========== BUY NOW/PACKAGE PURCHASED REDIRECTION ==========//
        if([[jsonresponseObject objectForKey:@"RESPCODE"] isEqualToString:@"01"])
        {
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            
            [dictParameters setObject:jsonresponseObject[@"TXNID"] forKey:@"transaction_id"];
            
            [dictParameters setObject:self.strAmount forKey:@"payment_amount"];
            [dictParameters setObject:self.strPromotionCode forKey:@"promotional_code"];
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
                viewController.strAmount = self.strAmount;
                viewController.strPromotionCode = self.strPromotionCode;
                viewController.intLoadedFor = self.intLoadedFor;
                [self.navigationController pushViewController:viewController animated:true];
            }
        }
    }
    else if(self.intLoadedFor == 2)
    {
        //========== TAMBOLA TICKET PURCHASED REDIRECTION ==========//
        if([[jsonresponseObject objectForKey:@"RESPCODE"] isEqualToString:@"01"])
        {
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            
            [dictParameters setObject:jsonresponseObject[@"TXNID"] forKey:@"transaction_id"];
            
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"payment_amount"];
            [dictParameters setObject:self.strPromotionCode forKey:@"promotional_code"];
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketOrderId forKey:@"order_id"];
            
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
                viewController.strAmount = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
                viewController.strPromotionCode = self.strPromotionCode;
                viewController.intLoadedFor = self.intLoadedFor;
                [self.navigationController pushViewController:viewController animated:true];
            }
        }
    }
    
}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    
    NSString *msg = nil;
    if (!error) msg = [NSString stringWithFormat:@"Successful"];
    else msg = [NSString stringWithFormat:@"UnSuccessful"];
    
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
        
    [self removeController:controller];
    
    if(self.intLoadedFor == 1)
    {
        //========== BUY NOW/PACKAGE PURCHASED REDIRECTION ==========//
        
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:response[@"TXNID"] forKey:@"transaction_id"];
        
        [dictParameters setObject:self.strAmount forKey:@"payment_amount"];
        [dictParameters setObject:self.strPromotionCode forKey:@"promotional_code"];
        
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strGeneratedPaymentId forKey:@"order_id"];
        
        [[MySingleton sharedManager].dataManager user_purchaseVersion:dictParameters];
    }
    else if(self.intLoadedFor == 2)
    {
        //========== TAMBOLA TICKET PURCHASED REDIRECTION ==========//
        
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:response[@"TXNID"] forKey:@"transaction_id"];
        
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"payment_amount"];
        [dictParameters setObject:self.strPromotionCode forKey:@"promotional_code"];
        
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketOrderId forKey:@"order_id"];
        
        [[MySingleton sharedManager].dataManager user_purchaseVersion:dictParameters];
    }
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, response);
    
    [self removeController:controller];
    
    if(self.intLoadedFor == 1)
    {
        //========== BUY NOW/PACKAGE PURCHASED REDIRECTION ==========//
        PaymentFailedViewController *viewController = [[PaymentFailedViewController alloc] init];
        viewController.strAmount = self.strAmount;
        viewController.strPromotionCode = self.strPromotionCode;
        viewController.intLoadedFor = self.intLoadedFor;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if(self.intLoadedFor == 2)
    {
        //========== TAMBOLA TICKET PURCHASED REDIRECTION ==========//
        PaymentFailedViewController *viewController = [[PaymentFailedViewController alloc] init];
        viewController.strAmount = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
        viewController.strPromotionCode = self.strPromotionCode;
        viewController.intLoadedFor = self.intLoadedFor;
        [self.navigationController pushViewController:viewController animated:true];
    }
}

@end
