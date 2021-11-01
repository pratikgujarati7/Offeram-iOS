//
//  User_OfferamCoinsTransactionViewController.m
//  Offeram
//
//  Created by Dipen Lad on 01/12/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_OfferamCoinsTransactionViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "TransactionTableViewCell.h"
#import "NoDataFountTableViewCell.h"

@interface User_OfferamCoinsTransactionViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_OfferamCoinsTransactionViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;
@synthesize mainTableView;

@synthesize balanceContainerView;
@synthesize lblTransactions;
@synthesize lblCurrentBalance;
@synthesize lblCurrentBalanceValue;

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
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, mainTableView.frame.origin.y + mainTableView.frame.size.height);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllTransactionsEvent) name:@"user_gotAllTransactionsEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotAllTransactionsEvent
{
    NSTextAttachment *icon = [[NSTextAttachment alloc] init];
    UIImage *iconImage = [self imageWithImage:[UIImage imageNamed:@"offeram_coins.png"] convertToSize:CGSizeMake(40, 40)];
    [icon setBounds:CGRectMake(0, roundf(lblCurrentBalanceValue.font.capHeight - (iconImage.size.height/2))/2.f, (iconImage.size.width/2), (iconImage.size.height/2))];
    [icon setImage:iconImage];
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:icon];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
    [myString appendAttributedString:attachmentString];
    [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[MySingleton sharedManager].dataManager.objLoggedInUser.strOfferamCoinsBalance]]];
    
    lblCurrentBalanceValue.attributedText = myString;
    lblCurrentBalanceValue.textAlignment = NSTextAlignmentLeft;
    lblCurrentBalanceValue.adjustsFontSizeToFitWidth = true;
    
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllTransactions;
    mainTableView.hidden = false;
    [mainTableView reloadData];
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
    
    UIFont *lblTitleFont, *lblValueFont, *lblCoinValueFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        lblValueFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentySizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSeventeenSizeMedium;
        lblValueFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontEighteenSizeMedium;
        lblValueFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        lblCoinValueFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
    }
    
    //CURRENT BALANCE CONTAINER
    balanceContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    lblTransactions.font = lblTitleFont;
    lblTransactions.textAlignment = NSTextAlignmentLeft;
    lblTransactions.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblTransactions.text = @"Transactions";
    
    lblCurrentBalance.font = lblValueFont;
    lblCurrentBalance.textAlignment = NSTextAlignmentRight;
    lblCurrentBalance.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCurrentBalance.text = @"Current Balance:";
    
    lblCurrentBalanceValue.font = lblCoinValueFont;
    lblCurrentBalanceValue.textAlignment = NSTextAlignmentLeft;
    lblCurrentBalanceValue.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCurrentBalanceValue.text = @"-";
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = false;
    
    //CALL WEBSERVICE
    [[MySingleton sharedManager].dataManager user_getAllTransactions];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return balanceContainerView.frame.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return balanceContainerView;
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
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        return 80;
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
        Transaction *objTransaction = [self.dataRows objectAtIndex:indexPath.row];
        
        TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[TransactionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        if (indexPath.row %2 == 0)
            cell.imageViewTransaction.image = [UIImage imageNamed:@"Icon-60@2x.png"];
        else
            cell.imageViewTransaction.image = [UIImage imageNamed:@"offeram_02.png"];
        
        cell.lblTransactionText.text = objTransaction.strTransactionMessage;
        cell.lblTransactionDateTime.text = objTransaction.strTransactionDateTime;
        
        
        NSTextAttachment *icon = [[NSTextAttachment alloc] init];
        UIImage *iconImage = [self imageWithImage:[UIImage imageNamed:@"offeram_coins.png"] convertToSize:CGSizeMake(15, 15)];
        [icon setBounds:CGRectMake(0, roundf(cell.lblTransactionAmount.font.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [icon setImage:iconImage];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:icon];
        
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        [myString appendAttributedString:attachmentString];
        
        if ([objTransaction.strTransactionType integerValue] == 1)
        {
            [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" + %@", objTransaction.strTransactionAmount]]];
            cell.lblTransactionAmount.textColor = [MySingleton sharedManager].themeGlobalGreenColor;
        }
        else
        {
            [myString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" - %@",objTransaction.strTransactionAmount]]];
            cell.lblTransactionAmount.textColor = [MySingleton sharedManager].themeGlobalRedColor;
        }
        
        cell.lblTransactionAmount.attributedText = myString;
        cell.lblTransactionAmount.textAlignment = NSTextAlignmentLeft;
        cell.lblTransactionAmount.adjustsFontSizeToFitWidth = true;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NoDataFountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

        cell = [[NoDataFountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        cell.lblNoData.text = @"No transactions found.";

        cell.btnAction.hidden = true;

        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
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
