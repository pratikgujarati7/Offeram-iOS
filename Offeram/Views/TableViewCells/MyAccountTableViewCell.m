//
//  MyAccountTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 14/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "MyAccountTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 50

@implementation MyAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [self setSelectedBackgroundView:bgColorView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float cellHeight = CellHeight;
        float cellWidth = [MySingleton sharedManager].screenWidth;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth-20, cellHeight)];
        self.mainContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        
        //======= ADD LABEL IMAGE VIEW ITEM INTO MAIN CONTAINER VIEW =======//
        self.imageViewItem = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.imageViewItem.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewItem.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.imageViewItem];
        
        //======= ADD LABEL ITEM NAME INTO MAIN CONTAINER VIEW =======//
        self.lblItemName = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, (self.mainContainer.frame.size.width - 90), 40)];
        self.lblItemName.font = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        self.lblItemName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblItemName.textAlignment = NSTextAlignmentLeft;
        self.lblItemName.numberOfLines = 1;
        self.lblItemName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblItemName];
        
        //======= ADD IMAGE VIEW RIGHT ARROW INTO MAIN CONTAINER VIEW =======//
        self.imageViewRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake((self.mainContainer.frame.size.width - 30), 15, 20, 20)];
        self.imageViewRightArrow.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewRightArrow.layer.masksToBounds = YES;
        self.imageViewRightArrow.image = [UIImage imageNamed:@"right_arrow_grey.png"];
        [self.mainContainer addSubview:self.imageViewRightArrow];
        
        //======== ADD SEPERATOR INTO MAIN CONTAINER VIEW ========//
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mainContainer.frame.size.height-1, self.mainContainer.frame.size.width, 1)];
        self.separatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
        self.separatorView.alpha = 0.5f;
        [self.mainContainer addSubview:self.separatorView];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
