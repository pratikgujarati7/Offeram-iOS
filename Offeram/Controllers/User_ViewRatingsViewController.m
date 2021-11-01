//
//  User_ViewRatingsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 09/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_ViewRatingsViewController.h"
#import "MySingleton.h"

#import "ReviewTableViewCell.h"

@interface User_ViewRatingsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_ViewRatingsViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize btnClose;

@synthesize innerContainerView;
@synthesize lblCompanyName;
@synthesize lblReviewCount;

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
    lblCompanyName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblCompanyName.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    lblCompanyName.textAlignment = NSTextAlignmentCenter;
    
    // LBL REVIEW COUNT
    lblReviewCount.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblReviewCount.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    lblReviewCount.textAlignment = NSTextAlignmentLeft;
    
    //    [MySingleton sharedManager].floatOutletTableViewWidth = mainTableView.frame.size.width;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
}

-(void)showReview
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
    if(self.objMerchant.arrayRatings.count > 0)
    {
        mainTableView.userInteractionEnabled = true;
        
        return self.objMerchant.arrayRatings.count;
    }
    else
    {
        mainTableView.userInteractionEnabled = false;
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.objMerchant.arrayRatings.count > 0)
    {
        UILabel *lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, mainTableView.frame.size.width - 20, 15)];
        lblComment.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        lblComment.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        lblComment.textAlignment = NSTextAlignmentJustified;
        lblComment.numberOfLines = 0;
        
        Rating *objRating = [self.objMerchant.arrayRatings objectAtIndex:indexPath.row];
        lblComment.text = objRating.strComment;
        
        [lblComment sizeToFit];
        
        NSLog(@"%f", lblComment.frame.origin.y + lblComment.frame.size.height + 15);
        
        return lblComment.frame.origin.y + lblComment.frame.size.height + 15;
    }
    else
    {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.objMerchant.arrayRatings.count > 0)
    {
        Rating *objRating = [self.objMerchant.arrayRatings objectAtIndex:indexPath.row];
        
        NSLog(@"%@ %@", objRating.strName, objRating.strComment);
        
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[ReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.lblUserName.text = objRating.strName;
        
        cell.lblComment.text = objRating.strComment;
        
        cell.starRatingView.value = [objRating.strRating floatValue];
        cell.starRatingView.userInteractionEnabled = false;
        
        [cell.lblComment sizeToFit];
        
        NSLog(@"%f", cell.lblComment.frame.origin.y + cell.lblComment.frame.size.height + 45);
        
        CGRect innerContainerFrame = cell.innerContainer.frame;
        innerContainerFrame.size.height = cell.lblComment.frame.origin.y + cell.lblComment.frame.size.height + 5;
        cell.innerContainer.frame = innerContainerFrame;
        
        CGRect shadowContainerFrame = cell.shadowContainerView.frame;
        shadowContainerFrame.size.height = cell.lblComment.frame.origin.y + cell.lblComment.frame.size.height + 5;
        cell.shadowContainerView.frame = shadowContainerFrame;
    
        CGRect mainContainerFrame = cell.mainContainer.frame;
        mainContainerFrame.size.height = cell.innerContainer.frame.origin.y + cell.innerContainer.frame.size.height + 5;
        cell.mainContainer.frame = mainContainerFrame;
        
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
        lblNoData.text = @"No ratings found.";
        
        [cell.contentView addSubview:lblNoData];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

@end
