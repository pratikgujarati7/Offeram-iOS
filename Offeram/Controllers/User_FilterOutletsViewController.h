//
//  User_FilterOutletsViewController.h
//  Offeram
//
//  Created by Dipen Lad on 06/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"
#import "City.h"

@interface User_FilterOutletsViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIButton *btnClose;

@property (nonatomic,retain) IBOutlet UIView *innerContainerView;
@property (nonatomic,retain) IBOutlet UILabel *lblFilterOutlets;
@property (nonatomic,retain) IBOutlet UILabel *lblByLocation;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtCity;
@property (nonatomic,retain) IBOutlet UIView *txtCityBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic,retain) IBOutlet UIButton *btnFilter;
@property (nonatomic,retain) IBOutlet UIButton *btnClearAll;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) UIPickerView *cityPickerView;
@property (nonatomic,retain) NSMutableArray *arrayAllCity;
@property (nonatomic,retain) City *objSelectedCity;

@property (nonatomic,retain) NSMutableArray *arrayAllAreas;
@property (nonatomic,retain) NSMutableArray *arraySelectedArea;

// METHODS
-(void)setupInitialView;
-(void)showFilter;

@end
