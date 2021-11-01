//
//  User_FilterOutletsViewController.m
//  Offeram
//
//  Created by Dipen Lad on 06/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_FilterOutletsViewController.h"
#import "MySingleton.h"
#import "FilterCollectionViewCell.h"

@interface User_FilterOutletsViewController ()

@end

@implementation User_FilterOutletsViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize btnClose;

@synthesize innerContainerView;
@synthesize lblFilterOutlets;
@synthesize lblByLocation;

@synthesize txtCity;
@synthesize txtCityBottomSeparatorView;

@synthesize mainCollectionView;
@synthesize btnFilter;
@synthesize btnClearAll;

//========== OTHER VARIABLES ==========//

@synthesize cityPickerView;
@synthesize arrayAllCity;
@synthesize objSelectedCity;

@synthesize arrayAllAreas;
@synthesize arraySelectedArea;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupInitialView
{
    arrayAllCity = [[MySingleton sharedManager].dataManager.arrayAllCity mutableCopy];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    objSelectedCity = [[City alloc] init];
    NSString *strCityID = [prefs objectForKey:@"selected_city_id"];
    if (strCityID != nil && strCityID.length > 0)
    {
        objSelectedCity.strCityID = strCityID;
    }
    else
    {
        objSelectedCity.strCityID = @"";
    }
    
    if (![objSelectedCity.strCityID isEqualToString:@""] && [objSelectedCity.strCityID integerValue] >= 0)
    {
        for (int i = 0; i < arrayAllCity.count; i++)
        {
            City *objCity = [arrayAllCity objectAtIndex:i];
            
            if ([objSelectedCity.strCityID integerValue] == [objCity.strCityID integerValue])
            {
                objSelectedCity = objCity;
                arrayAllAreas = [objCity.arrayAllAreas mutableCopy];
            }
        }
    }
    else
    {
        for (int i = 0; i < arrayAllCity.count; i++)
        {
            City *objCity = [arrayAllCity objectAtIndex:i];
            
            if ([objCity.strCityName isEqualToString:@"Surat"])
            {
                [prefs setObject:objCity.strCityID forKey:@"selected_city_id"];
                [prefs synchronize];
                objSelectedCity = objCity;
                arrayAllAreas = [objCity.arrayAllAreas mutableCopy];
            }
        }
    }
    
    
    arraySelectedArea = [[NSMutableArray alloc] init];
    
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
    
    //CITY PICKER
    cityPickerView = [[UIPickerView alloc] init];
    cityPickerView.delegate = self;
    cityPickerView.dataSource = self;
    cityPickerView.showsSelectionIndicator = YES;
    cityPickerView.tag = 1;
    cityPickerView.backgroundColor = [UIColor whiteColor];

    // TXT SEARCH
    txtCity.font = [MySingleton sharedManager].themeFontThirteenSizeRegular;;
    txtCity.delegate = self;
    txtCity.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"BY CITY"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtCity.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtCity.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtCity.floatingLabelFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;;
    txtCity.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtCity.keepBaseline = NO;
    [txtCity setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtCity setInputView:cityPickerView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        txtCity.text = objSelectedCity.strCityName;
    });
    
    txtCityBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // LBL FILTER OUTLETS
    lblFilterOutlets.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblFilterOutlets.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
    lblFilterOutlets.textAlignment = NSTextAlignmentCenter;
    
    // LBL BY LOCATION
    lblByLocation.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
    lblByLocation.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    lblByLocation.textAlignment = NSTextAlignmentLeft;
    
    // BTN FILTER
    btnFilter.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnFilter.titleLabel.font = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    [btnFilter setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnFilter.clipsToBounds = true;
    btnFilter.layer.cornerRadius = 5;
    [btnFilter addTarget:self action:@selector(btnFilterClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // BTN CLEAR ALL
    
    NSMutableAttributedString *clearAllString = [[NSMutableAttributedString alloc] initWithString:@"CLEAR ALL"];
    [clearAllString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [clearAllString length])];
    [btnClearAll setAttributedTitle:clearAllString forState:UIControlStateNormal];
    
    btnClearAll.backgroundColor = [UIColor clearColor];
    btnClearAll.titleLabel.font = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    [btnClearAll setTitleColor:[MySingleton sharedManager].themeGlobalDarkGreyColor forState:UIControlStateNormal];
    btnClearAll.clipsToBounds = true;
    btnClearAll.layer.cornerRadius = 5;
    [btnClearAll addTarget:self action:@selector(btnClearAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // SETUP MAIN COLLECTION VIEW
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    mainCollectionView.backgroundColor = [UIColor clearColor];
    mainCollectionView.pagingEnabled = false;
//    [mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

-(void)showFilter
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
    });
}

-(IBAction)btnFilterClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.objSelectedCity.strCityID forKey:@"selected_city_id"];
    [prefs synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"filterButtonEvent" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)btnClearAllClicked:(id)sender
{
    arraySelectedArea = [[NSMutableArray alloc] init];
    [mainCollectionView reloadData];
}

-(IBAction)btnCloseClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeButtonEvent" object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UICollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayAllAreas.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if([MySingleton sharedManager].screenWidth == 320)
    {
        return 0.00;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        return 0.00;
    }
    else
    {
        return 0.00;
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell_%d-%d-%d-%d", [self.objSelectedCity.strCityID intValue],(int)indexPath.section, (int)indexPath.row, (int)indexPath.item];
    [collectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    Area *objArea = [arrayAllAreas objectAtIndex:indexPath.item];
    
    if ([arraySelectedArea containsObject:objArea.strAreaID])
    {
        cell.btnCheckBox.selected = true;
    }
    else
    {
        cell.btnCheckBox.selected = false;
    }
    
//    cell.btnCheckBox.tag = indexPath.item;
//    [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.lblAreaName.text = objArea.strAreaName;
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Area *objArea = [arrayAllAreas objectAtIndex:indexPath.item];
    if (![arraySelectedArea containsObject:objArea.strAreaID])
    {
        [arraySelectedArea addObject:objArea.strAreaID];
    }
    else
    {
        [arraySelectedArea removeObject:objArea.strAreaID];
    }
    [mainCollectionView reloadData];
}

//-(IBAction)btnCheckBoxClicked:(id)sender
//{
//    UIButton *btnSender = (UIButton *)sender;
//
//    Area *objArea = [arrayAllAreas objectAtIndex:btnSender.tag];
//    if (btnSender.selected == false)
//    {
//        [arraySelectedArea addObject:objArea.strAreaID];
//    }
//    else
//    {
//        [arraySelectedArea removeObject:objArea.strAreaID];
//    }
//    [mainCollectionView reloadData];
//}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtCity)
    {
        if(self.arrayAllCity.count > 0)
        {
            for (int i = 0; i < arrayAllCity.count; i++)
            {
                City *objCity = [arrayAllCity objectAtIndex:i];
                
                if ([objCity.strCityName isEqualToString:txtCity.text])
                {
                    NSMutableArray *tempArray = [self.arraySelectedArea copy];
                    [cityPickerView selectRow:i inComponent:0 animated:YES];
                    self.arraySelectedArea = [tempArray copy];
                    [mainCollectionView reloadData];
                }
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UIPickerView Delegate Methods

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    
    if(pickerView.tag == 1)
    {
        rowsInComponent = [self.arrayAllCity count];
    }
    
    return rowsInComponent;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lblMain = (UILabel*)view;
    if (!lblMain){
        lblMain = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    
    if (pickerView.tag == 1)
    {
        City *objCity = [self.arrayAllCity objectAtIndex:row];
        lblMain.text = objCity.strCityName;
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    lblMain.textAlignment = NSTextAlignmentCenter;
    return lblMain;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [MySingleton sharedManager].screenWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        self.objSelectedCity = [self.arrayAllCity objectAtIndex:row];
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        [prefs setObject:self.objSelectedCity.strCityID forKey:@"selected_city_id"];
//        [prefs synchronize];
        txtCity.text = self.objSelectedCity.strCityName;
        self.arrayAllAreas = [self.objSelectedCity.arrayAllAreas mutableCopy];
        self.arraySelectedArea = [[NSMutableArray alloc] init];
        [mainCollectionView reloadData];
    }
}

@end
