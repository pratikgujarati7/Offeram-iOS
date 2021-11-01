//
//  User_TambolaTicketsListViewController.m
//  Offeram
//
//  Created by Innovative Iteration on 27/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import "User_TambolaTicketsListViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"
#import "User_FavouritesViewController.h"
#import "User_MyAccountViewController.h"
#import "User_NotificationsViewController.h"

#import "TambolaTicketTableViewCell.h"
#import "User_ViewOffersViewController.h"
#import "NoDataFountTableViewCell.h"

#import "User_CommonWebViewViewController.h"

#import "PaymentFailedViewController.h"
#import "PaymentSucceedViewController.h"

#import "User_RegisterForTambolaViewController.h"

@interface User_TambolaTicketsListViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_TambolaTicketsListViewController

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
    
    // CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_getAllTambolaTickets];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundEvent) name:@"applicationWillEnterForegroundEvent" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllTambolaTicketsEvent) name:@"user_gotAllTambolaTicketsEvent" object:nil];
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

-(void)applicationWillEnterForegroundEvent
{
    // CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_getAllTambolaTickets];
}

-(void)user_gotAllTambolaTicketsEvent
{
    self.dataRowsActiveTambolaTickets = [MySingleton sharedManager].dataManager.arrayAllActiveTambolaTickets;
    self.dataRowsCompletedTambolaTickets = [MySingleton sharedManager].dataManager.arrayAllCompletedTambolaTickets;
    mainTableView.hidden = false;
    [mainTableView reloadData];
}

-(void)user_registeredForTambolaWithRegistrationDataEvent
{
    if([[MySingleton sharedManager].dataManager.strTambolaTicketPrice isEqualToString:@"0"])
    {
//        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
//        viewController.strNavigationTitle = @"Tambola Ticket";
//        viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
//        viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
//        [self.navigationController pushViewController:viewController animated:true];
        
        NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
        
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
    }
    else
    {
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
//    viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
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
//    [[MySingleton sharedManager].dataManager user_getAllTambolaTickets];
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
        if (self.dataRowsActiveTambolaTickets.count > 0)
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
        if (self.dataRowsCompletedTambolaTickets.count > 0)
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
        lblTitle.text = @"Active Events";
    }
    else
    {
        lblTitle.text = @"Past Events";
    }
    [headerContainerView addSubview:lblTitle];
    
    
    // HEADER RETURN CONDITIONS
    if (section == 0)
    {
        if (self.dataRowsActiveTambolaTickets.count > 0)
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
        if (self.dataRowsCompletedTambolaTickets.count > 0)
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
    if(self.dataRowsActiveTambolaTickets.count > 0 || self.dataRowsCompletedTambolaTickets.count > 0)
    {
        mainTableView.userInteractionEnabled = true;
        
        if (section == 0)
        {
            if (self.dataRowsActiveTambolaTickets.count > 0)
            {
                return self.dataRowsActiveTambolaTickets.count;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            if (self.dataRowsCompletedTambolaTickets.count > 0)
            {
                return self.dataRowsCompletedTambolaTickets.count;
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
    if(self.dataRowsActiveTambolaTickets.count > 0 || self.dataRowsCompletedTambolaTickets.count > 0)
    {
        return 150;
    }
    else
    {
        return 270;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.dataRowsActiveTambolaTickets.count > 0 || self.dataRowsCompletedTambolaTickets.count > 0)
    {
        TambolaTicket *objTambolaTicket;
        
        if(indexPath.section == 0)
        {
            objTambolaTicket = [self.dataRowsActiveTambolaTickets objectAtIndex:indexPath.row];
        }
        else
        {
            objTambolaTicket = [self.dataRowsCompletedTambolaTickets objectAtIndex:indexPath.row];
        }
        
        
        TambolaTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[TambolaTicketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.imageViewTambola.imageURL = [NSURL URLWithString:objTambolaTicket.strTambolaTicketImageURL];
        cell.lblTambolaTitle.text = objTambolaTicket.strTambolaTicketTitle;
        cell.lblTambolaDescription.text = objTambolaTicket.strTambolaTicketDescription;
        
        if([objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
        {
            cell.lblPriceTag.text = [NSString stringWithFormat:@"Free"];
        }
        else
        {
            cell.lblPriceTag.text = [NSString stringWithFormat:@"₹ %@", objTambolaTicket.strTambolaTicketPrice];
        }
        
        cell.btnRegister.tag = indexPath.row;
        
        if (indexPath.section == 0)
        {
            //Active Tambola Tickets
            if(objTambolaTicket.boolIsAlreadyRegistered)
            {
                [cell.btnRegister setTitle:@"Click here to Start the Game" forState:UIControlStateNormal];
            }
            else
            {
                [cell.btnRegister setTitle:@"Click here to Register for the Game" forState:UIControlStateNormal];
            }
            
            [cell.btnRegister addTarget:self action:@selector(btnRegisterForActiveTambolaClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            //Completed Tambola Tickets
            [cell.btnRegister setTitle:@"Click here to View Success Story" forState:UIControlStateNormal];
            [cell.btnRegister addTarget:self action:@selector(btnRegisterForCompletedTambolaClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.lblNoData.text = @"No events found.";
        
        cell.btnAction.hidden = true;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRowsActiveTambolaTickets.count > 0 || self.dataRowsCompletedTambolaTickets.count > 0)
    {
        TambolaTicket *objTambolaTicket;
        
        if(indexPath.section == 0)
        {
            //Active Tambola Tickets
            objTambolaTicket = [self.dataRowsActiveTambolaTickets objectAtIndex:indexPath.row];
            
            if(objTambolaTicket.boolIsAlreadyRegistered)
            {
                [MySingleton sharedManager].dataManager.strTambolaTicketURL = objTambolaTicket.strTambolaTicketPDFURL;
                
//                User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
//                viewController.strNavigationTitle = @"Tambola Ticket";
//                viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
//                viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
//                [self.navigationController pushViewController:viewController animated:true];
                
                NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
                
                UIApplication *application = [UIApplication sharedApplication];
                [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
            }
            else
            {
                if(objTambolaTicket.boolIsTambolaRequiredRegistration && [objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
                {
                    //TambolaRequiredRegistration = 1 && TicketPrice == 0
                    //redirect the user to tambola registration screen and then directly to view tambola ticket

                    User_RegisterForTambolaViewController *viewController = [[User_RegisterForTambolaViewController alloc] init];
                    viewController.objSelectedTambolaTicket = objTambolaTicket;
                    [self.navigationController pushViewController:viewController animated:true];
                }
                else if(objTambolaTicket.boolIsTambolaRequiredRegistration && ![objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
                {
                    //TambolaRequiredRegistration = 1 && TicketPrice != 0 (TicketPrice > 0)
                    //redirect the user to tambola registration screen and then for payment and then view tambola ticket
                    
                    [MySingleton sharedManager].dataManager.strTambolaTicketPrice = objTambolaTicket.strTambolaTicketPrice;
                    
                    User_RegisterForTambolaViewController *viewController = [[User_RegisterForTambolaViewController alloc] init];
                    viewController.objSelectedTambolaTicket = objTambolaTicket;
                    [self.navigationController pushViewController:viewController animated:true];
                }
                else if(!objTambolaTicket.boolIsTambolaRequiredRegistration && ![objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
                {
                    //TambolaRequiredRegistration = 0 && TicketPrice != 0 (TicketPrice > 0)
                    //redirect the user for payment and then view tambola ticket
                    
                    [MySingleton sharedManager].dataManager.strTambolaTicketPrice = objTambolaTicket.strTambolaTicketPrice;
                    
                    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                    [dictParameters setObject:objTambolaTicket.strTambolaTicketID forKey:@"tambola_event_id"];
                    [dictParameters setObject:objTambolaTicket.strTambolaTicketPrice forKey:@"price"];
                    [dictParameters setObject:@"" forKey:@"name"];
                    [dictParameters setObject:@"" forKey:@"mobile_number"];
                    [dictParameters setObject:@"" forKey:@"email"];
                    [dictParameters setObject:@"" forKey:@"area"];
                    [dictParameters setObject:@"" forKey:@"city"];
                    [dictParameters setObject:@"" forKey:@"city_id"];
                    
                    [[MySingleton sharedManager].dataManager user_registerForTambolaWithRegistrationData:dictParameters];
                }
                else if(!objTambolaTicket.boolIsTambolaRequiredRegistration && [objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
                {
                    //TambolaRequiredRegistration = 0 && TicketPrice == 0
                    //redirect the user directly to view tambola ticket
                    
                    [MySingleton sharedManager].dataManager.strTambolaTicketPrice = objTambolaTicket.strTambolaTicketPrice;
                    
                    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
                    [dictParameters setObject:objTambolaTicket.strTambolaTicketID forKey:@"tambola_event_id"];
                    [dictParameters setObject:objTambolaTicket.strTambolaTicketPrice forKey:@"price"];
                    [dictParameters setObject:@"" forKey:@"name"];
                    [dictParameters setObject:@"" forKey:@"mobile_number"];
                    [dictParameters setObject:@"" forKey:@"email"];
                    [dictParameters setObject:@"" forKey:@"area"];
                    [dictParameters setObject:@"" forKey:@"city"];
                    [dictParameters setObject:@"" forKey:@"city_id"];
                    
                    [[MySingleton sharedManager].dataManager user_registerForTambolaWithRegistrationData:dictParameters];
                }
            }
        }
        else
        {
            //Completed Tambola Tickets
            objTambolaTicket = [self.dataRowsCompletedTambolaTickets objectAtIndex:indexPath.row];
            
            [MySingleton sharedManager].dataManager.strTambolaTicketURL = objTambolaTicket.strTambolaTicketPDFURL;
            
//            User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
//            viewController.strNavigationTitle = @"Tambola Ticket";
//            viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
//            viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
//            [self.navigationController pushViewController:viewController animated:true];
            
            NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
            
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
        }
    }
}

-(IBAction)btnRegisterForActiveTambolaClicked:(id)sender
{
    //Active Tambola Tickets
    UIButton *btnSender = (UIButton *)sender;

    TambolaTicket *objTambolaTicket = [self.dataRowsActiveTambolaTickets objectAtIndex:btnSender.tag];
    
    if(objTambolaTicket.boolIsAlreadyRegistered)
    {
        [MySingleton sharedManager].dataManager.strTambolaTicketURL = objTambolaTicket.strTambolaTicketPDFURL;
        
//        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
//        viewController.strNavigationTitle = @"Tambola Ticket";
//        viewController.strUrlToLoad = [MySingleton sharedManager].dataManager.strTambolaTicketURL;
//        viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
//        [self.navigationController pushViewController:viewController animated:true];
        
        NSString *strTambolaTicketURL = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].dataManager.strTambolaTicketURL];
        
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:strTambolaTicketURL] options:@{} completionHandler:nil];
    }
    else
    {
        if(objTambolaTicket.boolIsTambolaRequiredRegistration && [objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
        {
            //TambolaRequiredRegistration = 1 && TicketPrice == 0
            //redirect the user to tambola registration screen and then directly to view tambola ticket

            User_RegisterForTambolaViewController *viewController = [[User_RegisterForTambolaViewController alloc] init];
            viewController.objSelectedTambolaTicket = objTambolaTicket;
            [self.navigationController pushViewController:viewController animated:true];
        }
        else if(objTambolaTicket.boolIsTambolaRequiredRegistration && ![objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
        {
            //TambolaRequiredRegistration = 1 && TicketPrice != 0 (TicketPrice > 0)
            //redirect the user to tambola registration screen and then for payment and then view tambola ticket
            
            [MySingleton sharedManager].dataManager.strTambolaTicketPrice = objTambolaTicket.strTambolaTicketPrice;
            
            User_RegisterForTambolaViewController *viewController = [[User_RegisterForTambolaViewController alloc] init];
            viewController.objSelectedTambolaTicket = objTambolaTicket;
            [self.navigationController pushViewController:viewController animated:true];
        }
        else if(!objTambolaTicket.boolIsTambolaRequiredRegistration && ![objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
        {
            //TambolaRequiredRegistration = 0 && TicketPrice != 0 (TicketPrice > 0)
            //redirect the user for payment and then view tambola ticket
            
            [MySingleton sharedManager].dataManager.strTambolaTicketPrice = objTambolaTicket.strTambolaTicketPrice;
            
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            [dictParameters setObject:objTambolaTicket.strTambolaTicketID forKey:@"tambola_event_id"];
            [dictParameters setObject:objTambolaTicket.strTambolaTicketPrice forKey:@"price"];
            [dictParameters setObject:@"" forKey:@"name"];
            [dictParameters setObject:@"" forKey:@"mobile_number"];
            [dictParameters setObject:@"" forKey:@"email"];
            [dictParameters setObject:@"" forKey:@"area"];
            [dictParameters setObject:@"" forKey:@"city"];
            [dictParameters setObject:@"" forKey:@"city_id"];
            
            [[MySingleton sharedManager].dataManager user_registerForTambolaWithRegistrationData:dictParameters];
        }
        else if(!objTambolaTicket.boolIsTambolaRequiredRegistration && [objTambolaTicket.strTambolaTicketPrice isEqualToString:@"0"])
        {
            //TambolaRequiredRegistration = 0 && TicketPrice == 0
            //redirect the user directly to view tambola ticket
            
            [MySingleton sharedManager].dataManager.strTambolaTicketPrice = objTambolaTicket.strTambolaTicketPrice;
            
            NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
            [dictParameters setObject:objTambolaTicket.strTambolaTicketID forKey:@"tambola_event_id"];
            [dictParameters setObject:objTambolaTicket.strTambolaTicketPrice forKey:@"price"];
            [dictParameters setObject:@"" forKey:@"name"];
            [dictParameters setObject:@"" forKey:@"mobile_number"];
            [dictParameters setObject:@"" forKey:@"email"];
            [dictParameters setObject:@"" forKey:@"area"];
            [dictParameters setObject:@"" forKey:@"city"];
            [dictParameters setObject:@"" forKey:@"city_id"];
            
            [[MySingleton sharedManager].dataManager user_registerForTambolaWithRegistrationData:dictParameters];
        }
    }
}

-(IBAction)btnRegisterForCompletedTambolaClicked:(id)sender
{
    //Completed Tambola Tickets
    
    UIButton *btnSender = (UIButton *)sender;

    TambolaTicket *objTambolaTicket = [self.dataRowsCompletedTambolaTickets objectAtIndex:btnSender.tag];
    [MySingleton sharedManager].dataManager.strTambolaKnowMoreURL = objTambolaTicket.strTambolaTicketKnowMoreURL;
        
    NSURL *appStoreUrl = [NSURL URLWithString:[MySingleton sharedManager].dataManager.strTambolaKnowMoreURL];
    
    if ([[UIApplication sharedApplication] canOpenURL:appStoreUrl]) {
        [[UIApplication sharedApplication] openURL:appStoreUrl];
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Something went wrong!!!"];
        });
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
    
    User_NotificationsViewController *viewController = [[User_NotificationsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnMyAccountClicked:(id)sender
{
    [self.view endEditing:true];
    User_MyAccountViewController *viewController = [[User_MyAccountViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
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

@end
