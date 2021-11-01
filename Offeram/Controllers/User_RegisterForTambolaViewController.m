//
//  User_RegisterForTambolaViewController.m
//  Offeram
//
//  Created by Innovative Iteration on 29/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import "User_RegisterForTambolaViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_CommonWebViewViewController.h"

#import "PaymentFailedViewController.h"

#import "CommonUtility.h"

@interface User_RegisterForTambolaViewController ()

{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_RegisterForTambolaViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize txtName;
@synthesize txtNameBottomSeparatorView;

@synthesize txtMobileNumber;
@synthesize txtMobileNumberBottomSeparatorView;

@synthesize txtEmail;
@synthesize txtEmailBottomSeparatorView;

@synthesize txtArea;
@synthesize txtAreaBottomSeparatorView;

@synthesize txtCity;
@synthesize txtCityBottomSeparatorView;

@synthesize ticketChargesContainerView;
@synthesize lblTicket;

@synthesize btnRegister;

//========== OTHER VARIABLES ==========//
@synthesize cityPickerView;
@synthesize arrayAllCity;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayAllCity = [[MySingleton sharedManager].dataManager.arrayAllCity mutableCopy];
    
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_registeredForTambolaWithRegistrationDataEvent) name:@"user_registeredForTambolaWithRegistrationDataEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_generatedChecksumEvent) name:@"user_generatedChecksumEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_purchasedTambolaTicketEvent) name:@"user_purchasedTambolaTicketEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_registeredForTambolaWithRegistrationDataEvent
{
//    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
//    alertViewController.title = @"";
//    alertViewController.message = @"Registered successfully for Tambola.";
//    alertViewController.view.tintColor = [UIColor whiteColor];
//    alertViewController.backgroundTapDismissalGestureEnabled = YES;
//    alertViewController.swipeDismissalGestureEnabled = YES;
//    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
//
//    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
//    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
//    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
//    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
//
//    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
//
//        [alertViewController dismissViewControllerAnimated:YES completion:nil];
//    }]];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self presentViewController:alertViewController animated:YES completion:nil];
//    });
    
    if([self.objSelectedTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
    {
        //TambolaRequiredRegistration = 1 && TicketPrice == 0
        //redirect the user to tambola registration screen and then directly to view tambola ticket
        
//        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
//        viewController.strNavigationTitle = @"Tambola Ticket";
//        viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
//        viewController.boolIsLoadedFromRegisterForTambolaViewController = true;
//        [self.navigationController pushViewController:viewController animated:true];
        
        NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
        
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
    }
    else
    {
        //TambolaRequiredRegistration = 1 && TicketPrice != 0 (TicketPrice > 0)
        //redirect the user to tambola registration screen and then for payment and then view tambola ticket
        
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketOrderId forKey:@"ORDER_ID"];
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"TXN_AMOUNT"];
        [[MySingleton sharedManager].dataManager user_generateChecksum:dictParameters];
    }
}

-(void)user_generatedChecksumEvent
{
    [self paywithPaytm];
}

-(void)user_purchasedTambolaTicketEvent
{
//    User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
//    viewController.strNavigationTitle = @"Tambola Ticket";
//    viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
//    viewController.boolIsLoadedFromRegisterForTambolaViewController = true;
//    [self.navigationController pushViewController:viewController animated:true];
    
    NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
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
    
    UIFont *txtFieldFont, *btnFont, *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFifteenSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    // TXT NAME
    txtName.font = txtFieldFont;
    txtName.delegate = self;
    txtName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtName.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtName.floatingLabelFont = txtFieldFont;
    txtName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtName.keepBaseline = NO;
    [txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // TXT MOBILE NUMBER
    txtMobileNumber.font = txtFieldFont;
    txtMobileNumber.delegate = self;
    txtMobileNumber.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Mobile Number"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtMobileNumber.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtMobileNumber.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtMobileNumber.floatingLabelFont = txtFieldFont;
    txtMobileNumber.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMobileNumber.keepBaseline = NO;
    [txtMobileNumber setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtMobileNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    txtMobileNumberBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    NSString *strUserMobileNumber = [[NSString alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"userphonenumber"] != nil)
    {
        strUserMobileNumber = [NSString stringWithFormat:@"%@", [prefs objectForKey:@"userphonenumber"]];
    }
    else
    {
        strUserMobileNumber = @"";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");
        txtMobileNumber.text = strUserMobileNumber;
        txtMobileNumber.userInteractionEnabled = false;
    });
    
    
    
    // TXT EMAIL
    txtEmail.font = txtFieldFont;
    txtEmail.delegate = self;
    txtEmail.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Email"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtEmail.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtEmail.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtEmail.floatingLabelFont = txtFieldFont;
    txtEmail.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEmail.keepBaseline = NO;
    [txtEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
    txtEmailBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // TXT AREA
    txtArea.font = txtFieldFont;
    txtArea.delegate = self;
    txtArea.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Area"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtArea.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtArea.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtArea.floatingLabelFont = txtFieldFont;
    txtArea.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtArea.keepBaseline = NO;
    [txtArea setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtAreaBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    //CITY PICKER
    cityPickerView = [[UIPickerView alloc] init];
    cityPickerView.delegate = self;
    cityPickerView.dataSource = self;
    cityPickerView.showsSelectionIndicator = YES;
    cityPickerView.tag = 1;
    cityPickerView.backgroundColor = [UIColor whiteColor];
    
    // TXT CITY
    txtCity.font = txtFieldFont;
    txtCity.delegate = self;
    txtCity.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"City"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtCity.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtCity.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtCity.floatingLabelFont = txtFieldFont;
    txtCity.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtCity.keepBaseline = NO;
    [txtCity setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtCity setInputView:cityPickerView];
    
    txtCityBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    ticketChargesContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalOrangeColor;
    
    lblTicket.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblTicket.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    lblTicket.textAlignment = NSTextAlignmentCenter;
    lblTicket.text = [NSString stringWithFormat:@"Charges: Rs. %@ per ticket",self.objSelectedTambolaTicket.strTambolaTicketPrice];
    
    // BTN SUBMIT
    btnRegister.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnRegister.titleLabel.font = btnFont;
    [btnRegister setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnRegister.clipsToBounds = true;
    [btnRegister addTarget:self action:@selector(btnRegisterClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtCity)
    {
        if (arrayAllCity.count > 0)
        {
            if(textField.text.length <= 0)
            {
                [cityPickerView selectRow:0 inComponent:0 animated:YES];
                
                self.objSelectedCity = [self.arrayAllCity objectAtIndex:0];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:self.objSelectedCity.strCityID forKey:@"selected_city_id"];
                [prefs synchronize];
                txtCity.text = self.objSelectedCity.strCityName;
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UIPickerView Delegate Methods

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    
    if(pickerView.tag == 1)
    {
        rowsInComponent = [self.arrayAllCity count];
    }
    
    return rowsInComponent;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lblMain = (UILabel*)view;
    if (!lblMain){
        lblMain = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    
    if (pickerView.tag == 1)
    {
        City *objCity = [self.arrayAllCity objectAtIndex:row];
        lblMain.text = objCity.strCityName;
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    lblMain.textAlignment = NSTextAlignmentCenter;
    return lblMain;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [MySingleton sharedManager].screenWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        self.objSelectedCity = [self.arrayAllCity objectAtIndex:row];
        txtCity.text = self.objSelectedCity.strCityName;
    }
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
    orderDict[@"ORDER_ID"] = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketOrderId];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    orderDict[@"CUST_ID"] = [prefs objectForKey:@"userid"];
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail109";
    orderDict[@"CHANNEL_ID"] = @"WAP";
    orderDict[@"TXN_AMOUNT"] = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
      //Your main thread code goes in here
      NSLog(@"Im on the main thread");
        
        if([[jsonresponseObject objectForKey:@"RESPCODE"] isEqualToString:@"01"])
        {
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            
            [dictParameters setObject:jsonresponseObject[@"TXNID"] forKey:@"transaction_id"];
            
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"payment_amount"];
            [dictParameters setObject:@"" forKey:@"promotional_code"];
            
            [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketOrderId forKey:@"order_id"];
            
            [[MySingleton sharedManager].dataManager user_purchaseTambolaTicket:dictParameters];
        }
        else
        {
//            if([[jsonresponseObject objectForKey:@"RESPCODE"] isEqualToString:@"701"])
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [appDelegate showAlertViewWithTitle:@"" withDetails:@"Invalid Promotional Code"];
//                });
//            }
//            else
//            {
//                PaymentFailedViewController *viewController = [[PaymentFailedViewController alloc] init];
//                viewController.strAmount = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
//                viewController.strPromotionCode = @"";
//                viewController.intLoadedFor = 2;
//                [self.navigationController pushViewController:viewController animated:true];
//            }
        }
    });
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
      //Your main thread code goes in here
      NSLog(@"Im on the main thread");
        
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:response[@"TXNID"] forKey:@"transaction_id"];
        
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketPrice forKey:@"payment_amount"];
        [dictParameters setObject:@"" forKey:@"promotional_code"];
        
        [dictParameters setObject:[MySingleton sharedManager].dataManager.strTambolaTicketOrderId forKey:@"order_id"];
        
        [[MySingleton sharedManager].dataManager user_purchaseTambolaTicket:dictParameters];
    });
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, response);
    
    [self removeController:controller];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      //Your main thread code goes in here
      NSLog(@"Im on the main thread");
        
//        PaymentFailedViewController *viewController = [[PaymentFailedViewController alloc] init];
//        viewController.strAmount = [MySingleton sharedManager].dataManager.strTambolaTicketPrice;
//        viewController.strPromotionCode = @"";
//        viewController.intLoadedFor = 2;
//        [self.navigationController pushViewController:viewController animated:true];
    });
}

#pragma mark - Other Methods

-(IBAction)btnRegisterClicked:(id)sender
{
    CommonUtility *objCommonUtility = [[CommonUtility alloc] init];
    
    if (txtName.text.length > 0 && txtMobileNumber.text.length > 0 && txtEmail.text.length > 0 && ([objCommonUtility isValidEmailAddress:txtEmail.text]) && txtArea.text.length > 0 && txtCity.text.length > 0)
    {
        NSString *strCityID = self.objSelectedCity.strCityID;
        
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:self.objSelectedTambolaTicket.strTambolaTicketID forKey:@"tambola_event_id"];
        [dictParameters setObject:self.objSelectedTambolaTicket.strTambolaTicketPrice forKey:@"price"];
        
        [dictParameters setObject:txtName.text forKey:@"name"];
        [dictParameters setObject:txtMobileNumber.text forKey:@"mobile_number"];
        [dictParameters setObject:txtEmail.text forKey:@"email"];
        [dictParameters setObject:txtArea.text forKey:@"area"];
        [dictParameters setObject:txtCity.text forKey:@"city"];
        [dictParameters setObject:strCityID forKey:@"city_id"];
        
        [[MySingleton sharedManager].dataManager user_registerForTambolaWithRegistrationData:dictParameters];
    }
    else
    {
        if (txtName.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter name."];
            });
        }
        if (txtMobileNumber.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter mobile number."];
            });
        }
        if (txtEmail.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter email."];
            });
        }
        if ([objCommonUtility isValidEmailAddress:txtEmail.text] != true)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter email."];
            });
        }
        if (txtArea.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter area."];
            });
        }
        if (txtCity.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter city."];
            });
        }
    }
}

@end
