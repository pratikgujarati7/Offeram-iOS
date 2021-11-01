//
//  User_CommonWebViewViewController.m
//  Offeram
//
//  Created by Dipen Lad on 19/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_CommonWebViewViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_TambolaTicketsListViewController.h"

@interface User_CommonWebViewViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
    
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation User_CommonWebViewViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;
@synthesize imageViewShare;
@synthesize btnShare;
@synthesize imageViewDownload;
@synthesize btnDownload;

@synthesize mainScrollView;

@synthesize mainBackgroundImageView;

@synthesize mainWebView;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

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
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    [activityIndicatorView setColor:[UIColor blackColor]];
    activityIndicatorView.center = CGPointMake(mainWebView.bounds.size.width/2, mainWebView.bounds.size.height/2);
    
    [mainWebView addSubview:activityIndicatorView];
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    imageViewShare.layer.masksToBounds = YES;
    [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    imageViewShare.hidden = true;
    btnShare.hidden = true;
    
    imageViewDownload.layer.masksToBounds = YES;
    [btnDownload addTarget:self action:@selector(btnDownloadClicked:) forControlEvents:UIControlEventTouchUpInside];
    imageViewDownload.hidden = true;
    btnDownload.hidden = true;
    
    if ([self.strNavigationTitle isEqualToString:@"Tambola Ticket"]) {
        imageViewShare.hidden = false;
        btnShare.hidden = false;
        
        imageViewDownload.hidden = false;
        btnDownload.hidden = false;
    }
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"%@", self.strNavigationTitle];
    lblNavigationTitle.font = lblFont;
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    
    if(self.boolIsLoadedFromRegisterForTambolaViewController == true)
    {
        User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:false];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)btnShareClicked:(id)sender
{
    [self.view endEditing:true];
    
    NSString *textToShare = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaShareMessage];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:textToShare, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(IBAction)btnDownloadClicked:(id)sender
{
    [self.view endEditing:true];
    
    NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strTambolaTicketURL]];
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
    
    mainWebView.delegate = self;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.strUrlToLoad]]];
    
    [mainWebView loadRequest:request];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do your background code here
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [activityIndicatorView startAnimating];
        });
    });
}

#pragma UIWebView - Delegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad Called.");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do your background code here
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [activityIndicatorView startAnimating];
        });
    });
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad Called.");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do your background code here
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // stop the activity indicator (you are now on the main queue again)
            [activityIndicatorView stopAnimating];
        });
    });
    
    if (webView.isLoading) {
        return;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError Called.");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do your background code here
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // stop the activity indicator (you are now on the main queue again)
            [activityIndicatorView stopAnimating];
        });
    });
}

#pragma mark - Other Methods

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(void)downloadDocumentFromURLToShare
{
    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[
        NSURL URLWithString:[MySingleton sharedManager].dataManager.strTambolaTicketURL]];

    // Store the Data locally as PDF File
    NSString *resourceDocPath = [[NSString alloc] initWithString:[
        [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
            stringByAppendingPathComponent:@"Documents"
    ]];

    NSString *filePath = [resourceDocPath
        stringByAppendingPathComponent:@"TambolaTicket.pdf"];
    [pdfData writeToFile:filePath atomically:YES];

    // Now create Request for the file that was saved in your documents folder
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];

    [mainWebView setUserInteractionEnabled:YES];
    [mainWebView setDelegate:self];
    [mainWebView loadRequest:requestObj];
}

@end
