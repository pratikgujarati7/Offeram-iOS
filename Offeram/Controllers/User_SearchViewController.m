//
//  User_SearchViewController.m
//  Offeram
//
//  Created by Dipen Lad on 06/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_SearchViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_SearchResultViewController.h"
#import "NoDataFountTableViewCell.h"

@interface User_SearchViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_SearchViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize txtSearch;
@synthesize txtSearchBottomSeparatorView;

@synthesize mainTableView;

//========== OTHER VARIABLES ==========//

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllSuggestions;
    
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
    
    // TXT SEARCH
    txtSearch.font = txtFieldFont;
    txtSearch.delegate = self;
    txtSearch.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Search"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtSearch.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtSearch.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtSearch.floatingLabelFont = txtFieldFont;
    txtSearch.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtSearch.keepBaseline = NO;
    [txtSearch setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtSearchBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.hidden = true;
    mainTableView.hidden = false;
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

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == txtSearch)
    {
        self.dataRows = [MySingleton sharedManager].dataManager.arrayAllSuggestions;
        
        [mainTableView reloadData];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtSearch)
    {
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        [self searchSuggetionsDataWithSubstring:substring];
    }
    
    return YES;
}

- (void)searchSuggetionsDataWithSubstring:(NSString *)substring
{
    if(substring.length > 0)
    {
        //        searchImageView.hidden = true;
        self.dataRows = [[NSMutableArray alloc] init];
        
        for(NSString *str in [MySingleton sharedManager].dataManager.arrayAllSuggestions)
        {
            if ([[str lowercaseString] containsString:[substring lowercaseString]])
            {
                [self.dataRows addObject:str];
            }
        }
    }
    else
    {
        self.dataRows = [MySingleton sharedManager].dataManager.arrayAllSuggestions;
    }
    
    [mainTableView reloadData];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == mainTableView)
    {
        return 1;
    }
    return 0;
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
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            return self.dataRows.count;
        }
        else
        {
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            return 50;
        }
        else
        {
            return 220;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *lblNoDataFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblNoDataFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblNoDataFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
    }
    else
    {
        lblNoDataFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }
    
    static NSString *MyIdentifier = @"Cell";
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
            
            cell.textLabel.text = [self.dataRows objectAtIndex:indexPath.row];
            cell.textLabel.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
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
            lblNoData.text = @"No result found.";
            
            [cell.contentView addSubview:lblNoData];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            [self.view endEditing:YES];
            
            User_SearchResultViewController *viewController = [[User_SearchResultViewController alloc] init];
            viewController.strSearchString = [self.dataRows objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:viewController animated:true];
        }
    }
}

@end
