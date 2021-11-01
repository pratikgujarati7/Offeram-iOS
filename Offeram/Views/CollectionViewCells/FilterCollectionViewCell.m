//
//  FilterCollectionViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 31/08/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#import "MySingleton.h"

@implementation FilterCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        float cellWidth, cellHeight;
        cellWidth = frame.size.width;
        cellHeight = frame.size.height;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];
        
        //======= ADD BTN CHECK BOX INTO MAIN CONTAINER VIEW =======//
        self.btnCheckBox = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self.btnCheckBox setTitle:@"" forState:UIControlStateNormal];
        self.btnCheckBox.layer.masksToBounds = YES;
        [self.btnCheckBox setImage:[[UIImage imageNamed:@"checkbox_normal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.btnCheckBox setImage:[[UIImage imageNamed:@"checkbox_selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [[self.btnCheckBox imageView] setContentMode: UIViewContentModeScaleAspectFit];
        self.btnCheckBox.tintColor = [UIColor clearColor];
        self.btnCheckBox.userInteractionEnabled = false;
        
        [self.mainContainer addSubview:self.btnCheckBox];
        
        //======= ADD LBL AREA NAME INTO MAIN CONTAINER VIEW =======//
        self.lblAreaName = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, cellWidth - 45, 20)];
        self.lblAreaName.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        self.lblAreaName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblAreaName.textAlignment = NSTextAlignmentLeft;
        
        [self.mainContainer addSubview:self.lblAreaName];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
