//
//  User_FriendsAndFamilyViewController.m
//  Offeram
//
//  Created by Dipen Lad on 14/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_FriendsAndFamilyViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "FriendsAndFamilyTableViewCell.h"
#import "NoDataFountTableViewCell.h"

@interface User_FriendsAndFamilyViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_FriendsAndFamilyViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize sectionContainerView;

@synthesize myContactsView;
@synthesize lblMyContacts;
@synthesize btnMyContacts;
@synthesize btnMyContactsBottomSeparatorView;

@synthesize topTenView;
@synthesize lblTopTen;
@synthesize btnTopTen;
@synthesize btnTopTenBottomSeparatorView;

@synthesize mainTableView;

//========== OTHER VARIABLES ==========//

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataRows = [MySingleton sharedManager].dataManager.arrayTopTenRedeemers;
    
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
    [self.navigationController popViewControllerAnimated:NO];
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
    
    UIFont *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFifteenSizeMedium;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
    }
    
    lblMyContacts.font = lblTitleFont;
    lblMyContacts.textAlignment = NSTextAlignmentCenter;
    lblMyContacts.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    [btnMyContacts addTarget:self action:@selector(btnMyContactsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblTopTen.font = lblTitleFont;
    lblTopTen.textAlignment = NSTextAlignmentCenter;
    lblTopTen.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    [btnTopTen addTarget:self action:@selector(btnTopTenClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    sectionContainerView.hidden = true;
    //SLECT TOP 10
    [self btnTopTenClicked:btnTopTen];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = false;
}

-(IBAction)btnMyContactsClicked:(id)sender
{
    btnMyContactsBottomSeparatorView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnTopTenBottomSeparatorView.backgroundColor = [UIColor clearColor];
    self.isMyContactSegmentSelected = true;
    
    self.dataRows = [MySingleton sharedManager].dataManager.arrayMyContactsRedeemers;
    [mainTableView reloadData];
}

-(IBAction)btnTopTenClicked:(id)sender
{
    btnMyContactsBottomSeparatorView.backgroundColor = [UIColor clearColor];
    btnTopTenBottomSeparatorView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    self.isMyContactSegmentSelected = false;
    
    self.dataRows = [MySingleton sharedManager].dataManager.arrayTopTenRedeemers;
    [mainTableView reloadData];
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
        return 60;
    }
    else
    {
        return 270;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.dataRows.count > 0)
    {
        Redeemer *objRedeemer = [self.dataRows objectAtIndex:indexPath.row];
        
        FriendsAndFamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[FriendsAndFamilyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.lblIndex.text = [NSString stringWithFormat:@"%ld.",indexPath.row + 1];
        
        if (indexPath.row %2 == 0)
            cell.imageViewProfile.image = [UIImage imageNamed:@"Icon-60@2x.png"];
        else
            cell.imageViewProfile.image = [UIImage imageNamed:@"offeram_02.png"];
        
        cell.imageViewProfile.imageURL = [NSURL URLWithString:objRedeemer.strRedeemerProfileImageURL];
        
        cell.lblName.text = [NSString stringWithFormat:@"%@", objRedeemer.strRedeemerName];
        
//        cell.lblRedeemed.text = [NSString stringWithFormat:@"₹ %@",objRedeemer.strRedeemerAmount];
        
        NSTextAttachment *icon = [[NSTextAttachment alloc] init];
        UIImage *iconImage = [self imageWithImage:[UIImage imageNamed:@"offeram_coins.png"] convertToSize:CGSizeMake(15, 15)];
        [icon setBounds:CGRectMake(0, roundf(cell.lblRedeemed.font.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [icon setImage:iconImage];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:icon];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        [myString appendAttributedString:attachmentString];
        [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",objRedeemer.strRedeemerAmount]]];
        
        cell.lblRedeemed.attributedText = myString;
        cell.lblRedeemed.textAlignment = NSTextAlignmentLeft;
        cell.lblRedeemed.adjustsFontSizeToFitWidth = true;
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.lblNoData.text = @"No data found.";
        
        cell.btnAction.hidden = true;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        [self.view endEditing:true];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
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
