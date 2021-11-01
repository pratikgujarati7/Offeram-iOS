//
//  User_RedeemOfferViewController.m
//  Offeram
//
//  Created by Dipen Lad on 05/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_RedeemOfferViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_RedeemOfferSuccessViewController.h"

@interface User_RedeemOfferViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_RedeemOfferViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize lblUsingPin;

@synthesize enterPinContainerView;
@synthesize txtEnterPin;
@synthesize txtEnterPinBottomSeparatorView;

@synthesize lblOr;

@synthesize viewBarcodeScanner;
@synthesize btnReScan;
@synthesize lblScanUserCode;

@synthesize btnProceed;

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
    
    // START SCANNER
    [self btnReScanClicked:btnReScan];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_redeemedOfferEvent) name:@"user_redeemedOfferEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_redeemedOfferEvent
{
    User_RedeemOfferSuccessViewController *viewController = [[User_RedeemOfferSuccessViewController alloc] init];
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
    
    UIFont *lblOrFont, *txtFieldFont, *btnFont, *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblOrFont = [MySingleton sharedManager].themeFontEighteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblOrFont = [MySingleton sharedManager].themeFontNineteenSizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontFifteenSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblOrFont = [MySingleton sharedManager].themeFontTwentySizeRegular;
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    lblUsingPin.font = lblTitleFont;
    lblUsingPin.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblUsingPin.textAlignment = NSTextAlignmentLeft;
    
    // TXT ENTER PIN
    txtEnterPin.font = txtFieldFont;
    txtEnterPin.delegate = self;
    txtEnterPin.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter Pin"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtEnterPin.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtEnterPin.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtEnterPin.floatingLabelFont = txtFieldFont;
    txtEnterPin.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEnterPin.keepBaseline = NO;
    [txtEnterPin setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtEnterPin.keyboardType = UIKeyboardTypeNumberPad;
    
    txtEnterPinBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // BTN RESCAN
    [btnReScan setTitle:@"" forState:UIControlStateNormal];
    [btnReScan setImage:[[UIImage imageNamed:@"rescan.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [[btnReScan imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btnReScan.hidden = YES;
    [btnReScan addTarget:self action:@selector(btnReScanClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //lbl OR
    lblOr.font = lblOrFont;
    lblOr.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblOr.backgroundColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
    lblOr.textAlignment = NSTextAlignmentCenter;
    lblOr.clipsToBounds = true;
    lblOr.layer.cornerRadius = lblOr.frame.size.width/2;
    
    // SCAN CODE
    lblScanUserCode.font = lblTitleFont;
    lblScanUserCode.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblScanUserCode.textAlignment = NSTextAlignmentCenter;
    
    // BTN PROCEED
    btnProceed.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnProceed.titleLabel.font = btnFont;
    [btnProceed setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnProceed.clipsToBounds = true;
    [btnProceed addTarget:self action:@selector(btnProceedClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnProceedClicked:(id)sender
{
    if (txtEnterPin.text.length <= 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter Pin."];
        });
    }
    else
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        if (self.isPingedOffer)
        {
            [dictParameters setObject:@"1" forKey:@"is_pinged"];
            [dictParameters setObject:self.objSelectedCoupon.strPingedID forKey:@"ping_id"];
        }
        else
        {
            [dictParameters setObject:@"0" forKey:@"is_pinged"];
            [dictParameters setObject:@"" forKey:@"ping_id"];
        }
        
        [dictParameters setObject:self.objSelectedCoupon.strCouponID forKey:@"coupon_id"];
        [dictParameters setObject:txtEnterPin.text forKey:@"pin"];
        
        [[MySingleton sharedManager].dataManager user_redeemOffer:dictParameters];
    }
}

-(IBAction)btnReScanClicked:(id)sender
{
    btnReScan.hidden = YES;
    
    self.scanner = [[MTBBarcodeScanner alloc] initWithMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode] previewView:viewBarcodeScanner];
    self.scanner.torchMode = MTBTorchModeOff;
    self.boolIsTorchOn = false;
    
    txtEnterPin.text = @"";
    self.strScannedBarCode = @"";
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                
                if(code.type == CIFeatureTypeQRCode || code.type == CIDetectorTypeQRCode || code.type == AVMetadataObjectTypeQRCode)
                {
                    NSLog(@"QR Code");
                    
                    self.boolScannedCodeIsBarCode = false;
                }
                else
                {
                    NSLog(@"Bar Code");
                    
                    self.boolScannedCodeIsBarCode = true;
                }
                
                self.strScannedBarCode = code.stringValue;
                //                    btnSave.hidden = false;
                
                txtEnterPin.text = [NSString stringWithFormat:@"%@", self.strScannedBarCode];
                //                    btnScanAgain.hidden = false;
                
                btnReScan.hidden = NO;
                [self.scanner stopScanning];
            } error:&error];
            
        } else {
            // The user denied access to the camera
            btnReScan.hidden = NO;
        }
    }];
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

@end
