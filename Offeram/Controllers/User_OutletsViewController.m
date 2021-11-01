//
//  User_OutletsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 07/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_OutletsViewController.h"
#import "MySingleton.h"

#import "OutletTableViewCell.h"
#import "User_OutletDetailsViewController.h"

@interface User_OutletsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_OutletsViewController
//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize btnClose;

@synthesize innerContainerView;
@synthesize lblCompanName;
@synthesize lblOutletsCount;

@synthesize mainTableView;

//========== OTHER VARIABLES ==========//


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [MySingleton sharedManager].floatOutletTableViewWidth = mainTableView.frame.size.width;
    [mainTableView reloadData];
}
    

-(void)setupInitialView
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.5];
    
    [btnClose setImage:[[UIImage imageNamed:@"close_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [[btnClose imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btnClose.tintColor = [UIColor clearColor];
    CGFloat spacing = btnClose.frame.size.height/5;
    [btnClose setImageEdgeInsets:UIEdgeInsetsMake(spacing, spacing, spacing, spacing)];
    [btnClose addTarget:self action:@selector(btnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    innerContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    innerContainerView.clipsToBounds = true;
    innerContainerView.layer.cornerRadius = 10;
    
    // LBL COMPANY NAME
    lblCompanName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCompanName.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    lblCompanName.textAlignment = NSTextAlignmentCenter;
    
    // LBL OUTLETS COUNT
    lblOutletsCount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblOutletsCount.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    lblOutletsCount.textAlignment = NSTextAlignmentLeft;
    
//    [MySingleton sharedManager].floatOutletTableViewWidth = mainTableView.frame.size.width;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
}

-(void)showOutlets
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
    });
}

-(IBAction)btnCloseClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeButtonEvent" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataRows.count > 0)
    {
        mainTableView.userInteractionEnabled = true;
        
        return self.dataRows.count;
    }
    else
    {
        mainTableView.userInteractionEnabled = false;
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        return 100;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.dataRows.count > 0)
    {
        Outlet *objOutlet = [self.dataRows objectAtIndex:indexPath.row];
        
        OutletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[OutletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.lblAreaName.text = objOutlet.strAreaName;
        
        cell.lblAddress.text = objOutlet.strAddress;
        
        cell.lblTimings.text = [NSString stringWithFormat:@"TIMINGS: %@ - %@", objOutlet.strStartTime, objOutlet.strEndTime];
        
        cell.btnCall.tag = indexPath.row;
        [cell.btnCall addTarget:self action:@selector(btnCallClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnMap.tag = indexPath.row;
        [cell.btnMap addTarget:self action:@selector(btnMapClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        UIFont *lblNoDataFont;
        
        if([MySingleton sharedManager].screenWidth == 320)
        {
            lblNoDataFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        }
        else if([MySingleton sharedManager].screenWidth == 375)
        {
            lblNoDataFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
        }
        else
        {
            lblNoDataFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        }
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        
        UILabel *lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mainTableView.frame.size.width, cell.frame.size.height)];
        lblNoData.textAlignment = NSTextAlignmentCenter;
        lblNoData.font = lblNoDataFont;
        lblNoData.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        lblNoData.text = @"No outlets found.";
        
        [cell.contentView addSubview:lblNoData];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(IBAction)btnCallClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    self.objSelectedOutlet = [self.dataRows objectAtIndex:btnSender.tag];
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    // CUSTOMER CARE
    NSString *phNo = self.objSelectedOutlet.strPhoneNumber;
    
    
    NSString *phoneNumber = self.objSelectedOutlet.strPhoneNumber;
    NSString *strphoneUrl = [@"telprompt://" stringByAppendingString:phoneNumber];
    NSString *strphoneFallbackUrl = [@"tel://" stringByAppendingString:phoneNumber];
    NSURL *phoneUrl = [NSURL URLWithString:[strphoneUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *phoneFallbackUrl = [NSURL URLWithString:[strphoneFallbackUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
        [UIApplication.sharedApplication openURL:phoneUrl];
    } else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
        [UIApplication.sharedApplication openURL:phoneFallbackUrl];
    } else {
        [appDelegate showAlertViewWithTitle:@"" withDetails:@"Call facility is not available!!!"];
    }
}

-(IBAction)btnMapClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    self.objSelectedOutlet = [self.dataRows objectAtIndex:btnSender.tag];
    
    
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mapButtonEvent" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
