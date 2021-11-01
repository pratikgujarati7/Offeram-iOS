//
//  User_NotificationsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 12/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_NotificationsViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"
#import "User_TambolaTicketsListViewController.h"
#import "User_FavouritesViewController.h"
#import "User_MyAccountViewController.h"
#import "NotificationTableViewCell.h"
#import "User_ViewOffersViewController.h"
#import "NoDataFountTableViewCell.h"

@interface User_NotificationsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_NotificationsViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize navigationTitle;

@synthesize mainScrollView;

@synthesize mainTableView;

// BOTTOM BAR VIEW
@synthesize bottomBarView;

@synthesize offersContainerView;
@synthesize imageViewOffers;
@synthesize lblOffers;
@synthesize btnOffers;

@synthesize tambolaContainerView;
@synthesize imageViewTambola;
@synthesize lblTambola;
@synthesize btnTambola;

@synthesize favouritesContainerView;
@synthesize imageViewFavourites;
@synthesize lblFavourites;
@synthesize btnFavourites;

@synthesize notificationsContainerView;
@synthesize imageViewNotifications;
@synthesize lblNotifications;
@synthesize btnNotifications;

@synthesize myAccountContainerView;
@synthesize imageViewMyAccount;
@synthesize lblMyAccount;
@synthesize btnMyAccount;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    [self setupInitialView];
    
    [self setNavigationBar];
    [self setupBottomBar];    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MySingleton sharedManager].dataManager.boolIsNotificationScreenOpened = true;
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    
    [self.view endEditing:YES];
    
    [MySingleton sharedManager].dataManager.boolIsNotificationScreenOpened = false;
    
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
    
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height)];
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllNotificationsEvent) name:@"user_gotAllNotificationsEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotAllNotificationsEvent
{
    [MySingleton sharedManager].dataManager.strNotificationCount = @"0";
    
    self.dataRowsUnreadNotifications = [MySingleton sharedManager].dataManager.arrayAllUnreadNotifications;
    self.dataRowsReadNotifications = [MySingleton sharedManager].dataManager.arrayAllReadNotifications;
    mainTableView.hidden = false;
    [mainTableView reloadData];
    
    for (int i = 0; i < self.dataRowsUnreadNotifications.count; i++)
    {
        Notification *objNotification = [self.dataRowsUnreadNotifications objectAtIndex:i];
        [[MySingleton sharedManager].dataManager user_markNotificationsAsRead:objNotification.strNotificationID];
    }
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 375)
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
    
    navigationTitle.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    navigationTitle.font = lblFont;
    navigationTitle.textAlignment = NSTextAlignmentCenter;
}

-(IBAction)btnFilterClicked:(id)sender
{
    [self.view endEditing:YES];
    
}

-(IBAction)btnSearchClicked:(id)sender
{
    [self.view endEditing:YES];
    
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = true;
    
    // CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_getAllNotifications];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.dataRowsUnreadNotifications.count > 0)
        {
            return 50;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (self.dataRowsReadNotifications.count > 0)
        {
            return 50;
        }
        else
        {
            return 1;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [MySingleton sharedManager].screenWidth, 50)];
    headerContainerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, [MySingleton sharedManager].screenWidth-10, 20)];
    lblTitle.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    lblTitle.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblTitle.textAlignment = NSTextAlignmentLeft;
    
    if (section == 0)
    {
        lblTitle.text = @"Unread Notifications";
    }
    else
    {
        lblTitle.text = @"Read Notifications";
    }
    [headerContainerView addSubview:lblTitle];
    
    
    // HEADER RETURN CONDITIONS
    if (section == 0)
    {
        if (self.dataRowsUnreadNotifications.count > 0)
        {
            return headerContainerView;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if (self.dataRowsReadNotifications.count > 0)
        {
            return headerContainerView;
        }
        else
        {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataRowsUnreadNotifications.count > 0 || self.dataRowsReadNotifications.count > 0)
    {
        mainTableView.userInteractionEnabled = true;
        
        if (section == 0)
        {
            if (self.dataRowsUnreadNotifications.count > 0)
            {
                return self.dataRowsUnreadNotifications.count;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            if (self.dataRowsReadNotifications.count > 0)
            {
                return self.dataRowsReadNotifications.count;
            }
            else
            {
                return 0;
            }
        }
    }
    else
    {
        mainTableView.userInteractionEnabled = false;
        
        if (section == 1)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRowsUnreadNotifications.count > 0 || self.dataRowsReadNotifications.count > 0)
    {
        return 100;
    }
    else
    {
        return 270;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.dataRowsUnreadNotifications.count > 0 || self.dataRowsReadNotifications.count > 0)
    {
        
        Notification *objNotification;
        
        if(indexPath.section == 0)
        {
            objNotification = [self.dataRowsUnreadNotifications objectAtIndex:indexPath.row];
        }
        else
        {
            objNotification = [self.dataRowsReadNotifications objectAtIndex:indexPath.row];
        }
        
        
        NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        if (indexPath.section == 0)
        {
            cell.unreadNotificationIndicator.hidden = false;
        }
        else
        {
            cell.unreadNotificationIndicator.hidden = true;
        }
        
        cell.imageViewNotification.imageURL = [NSURL URLWithString:objNotification.strCompanyLogoImageUrl];
        cell.lblNotificationText.text = objNotification.strNotificationTitle;

        cell.lblNotificationFrom.text = [NSString stringWithFormat:@"From: %@", objNotification.strFromName];
        cell.lblNotificationDateTime.text = objNotification.strNotificationDateTime;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.lblNoData.text = @"No notification found.";
        
        cell.btnAction.hidden = true;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRowsUnreadNotifications.count > 0 || self.dataRowsReadNotifications.count > 0)
    {
        //        Request *objRequest = [self.dataRows objectAtIndex:indexPath.row];
        //        [[MySingleton sharedManager].dataManager user_getRequestDetails:objRequest.strRequestID];
        
        Notification *objNotification;
        
        if(indexPath.section == 0)
        {
            objNotification = [self.dataRowsUnreadNotifications objectAtIndex:indexPath.row];
        }
        else
        {
            objNotification = [self.dataRowsReadNotifications objectAtIndex:indexPath.row];
        }
        
        if (objNotification.strMerchantID != nil && [objNotification.strMerchantID integerValue] > 0)
        {
            User_ViewOffersViewController *viewController = [[User_ViewOffersViewController alloc] init];
            viewController.strMerchantID = objNotification.strMerchantID;
            [self.navigationController pushViewController:viewController animated:true];
        }
    }
}

#pragma mark - Bottom Bar Methods

-(void)setupBottomBar
{
    bottomBarView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblFont = [MySingleton sharedManager].themeFontTenSizeMedium;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblFont = [MySingleton sharedManager].themeFontElevenSizeMedium;
    }
    else
    {
        lblFont = [MySingleton sharedManager].themeFontTwelveSizeMedium;
    }
    
    imageViewOffers.layer.masksToBounds = true;
    
    lblOffers.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblOffers.font = lblFont;
    lblOffers.textAlignment = NSTextAlignmentCenter;
    
    [btnOffers addTarget:self action:@selector(btnOffersClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewTambola.layer.masksToBounds = true;
    
    lblTambola.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblTambola.font = lblFont;
    lblTambola.textAlignment = NSTextAlignmentCenter;
    
    [btnTambola addTarget:self action:@selector(btnTambolaClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewFavourites.layer.masksToBounds = true;
    
    lblFavourites.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblFavourites.font = lblFont;
    lblFavourites.textAlignment = NSTextAlignmentCenter;
    
    [btnFavourites addTarget:self action:@selector(btnFavouritesClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewNotifications.layer.masksToBounds = true;
    
    lblNotifications.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblNotifications.font = lblFont;
    lblNotifications.textAlignment = NSTextAlignmentCenter;
    
    [btnNotifications addTarget:self action:@selector(btnNotificationsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewMyAccount.layer.masksToBounds = true;
    
    lblMyAccount.textColor = [MySingleton sharedManager].themeGlobalBlueColor;
    lblMyAccount.font = lblFont;
    lblMyAccount.textAlignment = NSTextAlignmentCenter;
    
    [btnMyAccount addTarget:self action:@selector(btnMyAccountClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnOffersClicked:(id)sender
{
    [self.view endEditing:true];
    User_HomeViewController *viewController = [[User_HomeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnTambolaClicked:(id)sender
{
    [self.view endEditing:true];
    
    User_TambolaTicketsListViewController *viewController = [[User_TambolaTicketsListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnFavouritesClicked:(id)sender
{
    [self.view endEditing:true];
    User_FavouritesViewController *viewController = [[User_FavouritesViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnNotificationsClicked:(id)sender
{
    [self.view endEditing:true];
}

-(IBAction)btnMyAccountClicked:(id)sender
{
    [self.view endEditing:true];
    User_MyAccountViewController *viewController = [[User_MyAccountViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

@end
