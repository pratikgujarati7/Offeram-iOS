//
//  User_MyAccountViewController.m
//  Offeram
//
//  Created by Dipen Lad on 14/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_MyAccountViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_AboutUsViewController.h"
#import "User_CommonWebViewViewController.h"
#import "User_HomeViewController.h"
#import "User_TambolaTicketsListViewController.h"
#import "User_FavouritesViewController.h"
#import "User_NotificationsViewController.h"
#import "MyAccountTableViewCell.h"
#import "User_LoginViewController.h"

#import "User_EditProfileViewController.h"

#import "User_OfferamCoinsViewController.h"
#import "User_ReferAndEarnViewController.h"
#import "User_FriendsAndFamilyViewController.h"
#import "User_OfferamCoinsTransactionViewController.h"

@interface User_MyAccountViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_MyAccountViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize navigationTitle;

@synthesize mainScrollView;

@synthesize imageViewProfilePicture;
@synthesize btnEditProfile;
@synthesize lblUserName;
@synthesize lblMobileNumber;
@synthesize lblValidity;

@synthesize sectionHeaderContainerView;
@synthesize btnOfferamCoinsContainerView;
@synthesize imageViewOfferamCoins;
@synthesize btnOfferamCoins;
@synthesize btnOfferamCoinsBottomBorderView;
//OFFERAM COINS CONTAINER
@synthesize offeramCoinsContainerView;
@synthesize lblOfferamCoins;
@synthesize lblOfferamCoinsBalance;
@synthesize lblEarned;
@synthesize btnKnowMoreAboutOfferamCoins;
@synthesize btnTransactionHistoryContainerView;
@synthesize imageViewTransactionHistory;
@synthesize btnTransactionHistory;

@synthesize btnFemilyAndFriendsContainerView;
@synthesize imageViewFemilyAndFriends;
@synthesize btnFemilyAndFriends;
@synthesize btnFemilyAndFriendsBottomBorderView;
//FAMILY AND FRIENDS CONTAINER
@synthesize femilyAndFriendsContainerView;
@synthesize lblFemilyAndFriends;
@synthesize btnSeeTopRedeemers;
@synthesize lblIndex;
@synthesize imageViewIndexProfile;
@synthesize lblIndexName;
@synthesize lblIndexRedeemed;

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
    
    mainTableView.frame = CGRectMake(mainTableView.frame.origin.x, mainTableView.frame.origin.y, mainTableView.frame.size.width, 50 + (50 * 9));
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, mainTableView.frame.origin.y + mainTableView.frame.size.height);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotProfileDetailsEvent) name:@"user_gotProfileDetailsEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotProfileDetailsEvent
{
    // ST VALUES
    imageViewProfilePicture.imageURL = [NSURL URLWithString:[MySingleton sharedManager].dataManager.objLoggedInUser.strProfileImageURL];
    lblUserName.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strUserName;
    lblMobileNumber.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strPhoneNumber;
    lblValidity.text = [NSString stringWithFormat:@"Valid Till : %@", [MySingleton sharedManager].dataManager.objLoggedInUser.strValidityDate];
    
    NSTextAttachment *icon2 = [[NSTextAttachment alloc] init];
    UIImage *iconImage2 = [self imageWithImage:[UIImage imageNamed:@"offeram_coins.png"] convertToSize:CGSizeMake(15, 15)];
    [icon2 setBounds:CGRectMake(0, roundf(lblIndexRedeemed.font.capHeight - iconImage2.size.height)/2.f, iconImage2.size.width, iconImage2.size.height)];
    [icon2 setImage:iconImage2];
    
    NSAttributedString *attachmentString2 = [NSAttributedString attributedStringWithAttachment:icon2];
    
    NSMutableAttributedString *myString2= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
    [myString2 appendAttributedString:attachmentString2];
    [myString2 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[MySingleton sharedManager].dataManager.objLoggedInUser.strOfferamCoinsBalance]]];
    
    lblOfferamCoinsBalance.attributedText = myString2;
    lblOfferamCoinsBalance.textAlignment = NSTextAlignmentLeft;
    lblOfferamCoinsBalance.adjustsFontSizeToFitWidth = true;
    
    imageViewIndexProfile.image = [UIImage imageNamed:@"Icon-60@2x.png"];
    
    if ([MySingleton sharedManager].dataManager.arrayTopTenRedeemers.count > 0)
    {
        lblIndex.hidden = false;
        imageViewIndexProfile.hidden = false;
        lblIndexName.hidden = false;
        lblIndexRedeemed.hidden = false;
        
        Redeemer *objRedeemer = [[MySingleton sharedManager].dataManager.arrayTopTenRedeemers objectAtIndex:0];
        
        imageViewIndexProfile.imageURL = [NSURL URLWithString:objRedeemer.strRedeemerProfileImageURL];
        lblIndexName.text = [NSString stringWithFormat:@"%@", objRedeemer.strRedeemerName];
//        lblIndexRedeemed.text = [NSString stringWithFormat:@"₹ %@",objRedeemer.strRedeemerAmount];
        
        NSTextAttachment *icon = [[NSTextAttachment alloc] init];
        UIImage *iconImage = [self imageWithImage:[UIImage imageNamed:@"offeram_coins.png"] convertToSize:CGSizeMake(15, 15)];
        [icon setBounds:CGRectMake(0, roundf(lblIndexRedeemed.font.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [icon setImage:iconImage];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:icon];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        [myString appendAttributedString:attachmentString];
        [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",objRedeemer.strRedeemerAmount]]];
        
        lblIndexRedeemed.attributedText = myString;
        lblIndexRedeemed.textAlignment = NSTextAlignmentLeft;
        lblIndexRedeemed.adjustsFontSizeToFitWidth = true;
    }
    else
    {
        lblIndex.hidden = true;
        imageViewIndexProfile.hidden = true;
        lblIndexName.hidden = true;
        lblIndexRedeemed.hidden = true;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
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
    
    navigationTitle.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    navigationTitle.font = lblFont;
    navigationTitle.textAlignment = NSTextAlignmentCenter;
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
    
    UIFont *lblUserNameFont, *lblMobileNumberFont, *lblValidityFont, *lblTitleFont, *lblOfferamCoinsBalanceFont, *lblEarnedFont, *lblIndexNameFont, *lblIndexRedeemedFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblUserNameFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        lblMobileNumberFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblValidityFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        
        lblTitleFont = [MySingleton sharedManager].themeFontEighteenSizeRegular;
        lblOfferamCoinsBalanceFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        lblEarnedFont = [MySingleton sharedManager].themeFontTenSizeRegular;
        lblIndexNameFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblIndexRedeemedFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblUserNameFont = [MySingleton sharedManager].themeFontSeventeenSizeMedium;
        lblMobileNumberFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
        lblValidityFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        
        lblTitleFont = [MySingleton sharedManager].themeFontNineteenSizeRegular;
        lblOfferamCoinsBalanceFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
        lblEarnedFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
        lblIndexNameFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblIndexRedeemedFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
    }
    else
    {
        lblUserNameFont = [MySingleton sharedManager].themeFontEighteenSizeMedium;
        lblMobileNumberFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        lblValidityFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        
        lblTitleFont = [MySingleton sharedManager].themeFontTwentySizeRegular;
        lblOfferamCoinsBalanceFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
        lblEarnedFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblIndexNameFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblIndexRedeemedFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    
    imageViewProfilePicture.layer.borderColor = [MySingleton sharedManager].themeGlobalWhiteColor.CGColor;
    imageViewProfilePicture.layer.borderWidth = 1.0f;
    // border radius
    [imageViewProfilePicture.layer setCornerRadius:imageViewProfilePicture.frame.size.height/2];
    imageViewProfilePicture.clipsToBounds = true;
    
    // border radius
    [btnEditProfile.layer setCornerRadius:btnEditProfile.frame.size.height/2];
    [btnEditProfile addTarget:self action:@selector(btnEditProfileClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // LBL USER NAME
    lblUserName.font = lblUserNameFont;
    lblUserName.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblUserName.textAlignment = NSTextAlignmentCenter;
    lblUserName.numberOfLines = 1;
    lblUserName.text = @"-";
    
    // LBL MOBILE NUMBER
    lblMobileNumber.font = lblMobileNumberFont;
    lblMobileNumber.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblMobileNumber.textAlignment = NSTextAlignmentCenter;
    lblMobileNumber.numberOfLines = 1;
    lblMobileNumber.text = @"-";
    
    // LBL USER NAME
    lblValidity.font = lblValidityFont;
    lblValidity.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblValidity.textAlignment = NSTextAlignmentCenter;
    lblValidity.numberOfLines = 1;
    lblValidity.text = [NSString stringWithFormat:@"Valid Till : -"];
    
    //SECTION HEADER CONTAINER
    sectionHeaderContainerView.layer.cornerRadius = 5.0f;
    sectionHeaderContainerView.clipsToBounds = true;
    
    imageViewOfferamCoins.image = [UIImage imageNamed:@"offeram_coins.png"];
    imageViewOfferamCoins.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnOfferamCoins addTarget:self action:@selector(btnOfferamCoinsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewFemilyAndFriends.image = [UIImage imageNamed:@"friends_and_family.png"];
    imageViewFemilyAndFriends.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnFemilyAndFriends addTarget:self action:@selector(btnFemilyAndFriendsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //OFFERAM COINS CONTAINER
    lblOfferamCoins.font = lblTitleFont;
    lblOfferamCoins.textAlignment = NSTextAlignmentCenter;
    lblOfferamCoins.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    lblOfferamCoinsBalance.font = lblOfferamCoinsBalanceFont;
    lblOfferamCoinsBalance.textAlignment = NSTextAlignmentCenter;
    lblOfferamCoinsBalance.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    lblEarned.font = lblEarnedFont;
    lblEarned.textAlignment = NSTextAlignmentLeft;
    lblEarned.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        
    NSMutableAttributedString *btnKnowMoreAboutOfferamCoinsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Know more About Offeram coins"]];
    [btnKnowMoreAboutOfferamCoinsString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnKnowMoreAboutOfferamCoinsString length])];
    [btnKnowMoreAboutOfferamCoinsString addAttribute:NSFontAttributeName value:lblEarnedFont range:NSMakeRange(0, [btnKnowMoreAboutOfferamCoinsString length])];
    [btnKnowMoreAboutOfferamCoinsString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlackColor range:NSMakeRange(0, [btnKnowMoreAboutOfferamCoinsString length])];
    [btnKnowMoreAboutOfferamCoins setAttributedTitle:btnKnowMoreAboutOfferamCoinsString forState:UIControlStateNormal];
    [btnKnowMoreAboutOfferamCoins addTarget:self action:@selector(btnKnowMoreAboutOfferamCoinsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewTransactionHistory.contentMode = UIViewContentModeScaleAspectFit;
    [btnTransactionHistory addTarget:self action:@selector(btnTransactionHistoryClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //FAMILY AND FRIENDS CONTAINER
    lblFemilyAndFriends.font = lblTitleFont;
    lblFemilyAndFriends.textAlignment = NSTextAlignmentCenter;
    lblFemilyAndFriends.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    //SELECT OFFERAM COINS
    offeramCoinsContainerView.hidden = false;
    femilyAndFriendsContainerView.hidden = true;
    btnOfferamCoinsBottomBorderView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnFemilyAndFriendsBottomBorderView.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString *btnSeeTopRedeemersString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"see who is Top Redeemer amongst you"]];
    [btnSeeTopRedeemersString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnSeeTopRedeemersString length])];
    [btnSeeTopRedeemersString addAttribute:NSFontAttributeName value:lblEarnedFont range:NSMakeRange(0, [btnSeeTopRedeemersString length])];
    [btnSeeTopRedeemersString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalBlackColor range:NSMakeRange(0, [btnSeeTopRedeemersString length])];
    [btnSeeTopRedeemers setAttributedTitle:btnSeeTopRedeemersString forState:UIControlStateNormal];
    [btnSeeTopRedeemers addTarget:self action:@selector(btnSeeTopRedeemersClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblIndex.font = lblEarnedFont;
    lblIndex.textAlignment = NSTextAlignmentCenter;
    lblIndex.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    imageViewIndexProfile.layer.cornerRadius = imageViewIndexProfile.frame.size.height/2;
    imageViewIndexProfile.clipsToBounds = true;
    imageViewIndexProfile.contentMode = kCAGravityResizeAspectFill;
    imageViewIndexProfile.image = [UIImage imageNamed:@"splash_3.png"];
    
    lblIndexName.font = lblIndexNameFont;
    lblIndexName.textAlignment = NSTextAlignmentLeft;
    lblIndexName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    lblIndexRedeemed.font = lblIndexRedeemedFont;
    lblIndexRedeemed.textAlignment = NSTextAlignmentLeft;
    lblIndexRedeemed.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
//    mainTableView.hidden = true;
    mainTableView.layer.cornerRadius = 5.0f;
    mainTableView.hidden = false;
    
    // CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_getProfileDetails];
}

-(IBAction)btnEditProfileClicked:(id)sender
{
    User_EditProfileViewController *viewController = [[User_EditProfileViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnOfferamCoinsClicked:(id)sender
{
    offeramCoinsContainerView.hidden = false;
    femilyAndFriendsContainerView.hidden = true;
    btnOfferamCoinsBottomBorderView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnFemilyAndFriendsBottomBorderView.backgroundColor = [UIColor clearColor];
}

-(IBAction)btnFemilyAndFriendsClicked:(id)sender
{
    offeramCoinsContainerView.hidden = true;
    femilyAndFriendsContainerView.hidden = false;
    btnOfferamCoinsBottomBorderView.backgroundColor = [UIColor clearColor];
    btnFemilyAndFriendsBottomBorderView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
}

-(IBAction)btnKnowMoreAboutOfferamCoinsClicked:(id)sender
{
    User_OfferamCoinsViewController *viewController = [[User_OfferamCoinsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnTransactionHistoryClicked:(id)sender
{
    User_OfferamCoinsTransactionViewController *viewController = [[User_OfferamCoinsTransactionViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

-(IBAction)btnSeeTopRedeemersClicked:(id)sender
{
    User_FriendsAndFamilyViewController *viewController = [[User_FriendsAndFamilyViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainTableView.frame.size.width, 50)];
    headerContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, mainTableView.frame.size.width-40, 20)];
    lblTitle.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    lblTitle.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = @"Offeram's Corner";
    [headerContainerView addSubview:lblTitle];
    
    UIView *bottomSaperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, mainTableView.frame.size.width, 1)];
    bottomSaperatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
    [headerContainerView addSubview:bottomSaperatorView];
    
    return headerContainerView;
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
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    //        Request *objRequest = [self.dataRows objectAtIndex:indexPath.row];
    
    MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    cell = [[MyAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        // REFER & EARN
        cell.imageViewItem.image = [UIImage imageNamed:@"reffer_earn.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Refer & Earn"];
    }
    else if (indexPath.row == 1)
    {
        // ABOUT US
        cell.imageViewItem.image = [UIImage imageNamed:@"about_us.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"About Us"];
    }
    else if (indexPath.row == 2)
    {
        // TERMS AND CONDITIONS
        cell.imageViewItem.image = [UIImage imageNamed:@"terms_conditions.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Terms & Conditions"];
    }
    else if (indexPath.row == 3)
    {
        // RATE US
        cell.imageViewItem.image = [UIImage imageNamed:@"rate_us.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Rate Us"];
    }
    else if (indexPath.row == 4)
    {
        // CUSTOMER CARE
        cell.imageViewItem.image = [UIImage imageNamed:@"customer_care.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Customer Care"];
    }
    else if (indexPath.row == 5)
    {
        // PRIVACY POLICY
        cell.imageViewItem.image = [UIImage imageNamed:@"terms_conditions.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Privacy Policy"];
    }
    else if (indexPath.row == 6)
    {
        // DESCLAIMER
        cell.imageViewItem.image = [UIImage imageNamed:@"terms_conditions.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Disclaimer"];
    }
    else if (indexPath.row == 7)
    {
        // REFUND AND CANCELLATION
        cell.imageViewItem.image = [UIImage imageNamed:@"terms_conditions.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Refund & Cancellation"];
    }
    else
    {
        // LOGOUT
        cell.imageViewItem.image = [UIImage imageNamed:@"logout.png"];
        cell.lblItemName.text = [NSString stringWithFormat:@"Logout"];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // REFER AND EARN
        User_ReferAndEarnViewController *viewController = [[User_ReferAndEarnViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if (indexPath.row == 1)
    {
        // ABOUT US
        User_AboutUsViewController *viewController = [[User_AboutUsViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if (indexPath.row == 2)
    {
        // TERMS AND CONDITIONS
        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
        viewController.strNavigationTitle = @"Terms & Conditions";
        viewController.strUrlToLoad = @"http://offeram.com/Offeram_Terms_and_Conditions.html";
        viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if (indexPath.row == 3)
    {
        // RATE US // id1313764616
        //apps://itunes.apple.com/app/twitter/id1313764616?mt=8&action=write-review
        NSURL *appStoreUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"https://itunes.apple.com/app/id1313764616?mt=8&action=write-review"]];
        
        if ([[UIApplication sharedApplication] canOpenURL:appStoreUrl]) {
            [[UIApplication sharedApplication] openURL:appStoreUrl];
        } else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Rating facility is not available!!!"];
            });
        }
    }
    else if (indexPath.row == 4)
    {
        // CUSTOMER CARE
        NSString *phNo = @"+917055540333";
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showAlertViewWithTitle:@"" withDetails:@"Call facility is not available!!!"];
            });
        }
    }
    else if (indexPath.row == 5)
    {
        // PRIVACY POLICY
        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
        viewController.strNavigationTitle = @"Privacy Policy";
        viewController.strUrlToLoad = @"http://offeram.com/Offeram_Privacy_Policy.html";
        viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if (indexPath.row == 6)
    {
        // DESCLAIMER
        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
        viewController.strNavigationTitle = @"Desclaimer";
        viewController.strUrlToLoad = @"http://offeram.com/Offeram_Disclaimer.html";
        viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else if (indexPath.row == 7)
    {
        // REFUND AND CANCELLATION
        User_CommonWebViewViewController *viewController = [[User_CommonWebViewViewController alloc] init];
        viewController.strNavigationTitle = @"Refund & Cancellation";
        viewController.strUrlToLoad = @"http://offeram.com/Offeram_Refund_and_Cancellation.html";
        viewController.boolIsLoadedFromRegisterForTambolaViewController = false;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else
    {
        // LOGOUT
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = @"";
        alertViewController.message = @"Are you sure you want to logout?";
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs removeObjectForKey:@"userid"];
            [prefs removeObjectForKey:@"userphonenumber"];
            [prefs removeObjectForKey:@"userversionid"];
            [prefs removeObjectForKey:@"userversionname"];
            [prefs removeObjectForKey:@"userpaymentid"];
            [prefs removeObjectForKey:@"autologin"];
            [prefs synchronize];
            
            User_LoginViewController *viewController = [[User_LoginViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:true];
            
        }]];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertViewController animated:YES completion:nil];
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
    
    if ([[MySingleton sharedManager].dataManager.strNotificationCount integerValue] > 0)
    {
        imageViewNotifications.image = [UIImage imageNamed:@"notifications_unread.png"];
    }
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
    User_NotificationsViewController *viewController = [[User_NotificationsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:false];
}

-(IBAction)btnMyAccountClicked:(id)sender
{
    [self.view endEditing:true];
}

@end
