//
//  TransactionTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 01/12/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 80

@implementation TransactionTableViewCell

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
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];
        
        //======= ADD INNER CONTAINER VIEW =======//
        self.innerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.innerContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        
        //======= ADD IMAGE VIEW TRANSACTION INTO MAIN CONTAINER VIEW =======//
        self.imageViewTransaction = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.imageViewTransaction.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewTransaction.layer.masksToBounds = YES;
        [self.imageViewTransaction.layer setCornerRadius:self.imageViewTransaction.frame.size.height/2];
        [self.innerContainer addSubview:self.imageViewTransaction];
        
        //======= ADD LABEL NOTIFICATION TEXT INTO MAIN CONTAINER VIEW =======//
        self.lblTransactionText = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, (self.innerContainer.frame.size.width - 70 - 90), 40)];
        self.lblTransactionText.font = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        self.lblTransactionText.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblTransactionText.textAlignment = NSTextAlignmentLeft;
        self.lblTransactionText.numberOfLines = 3;
        self.lblTransactionText.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblTransactionText];
        
        //======= ADD LABEL TRANSACTION DATE TIME INTO MAIN CONTAINER VIEW =======//
        self.lblTransactionDateTime = [[UILabel alloc] initWithFrame:CGRectMake(65, 55, (self.innerContainer.frame.size.width - 70 - 90), 15)];
        self.lblTransactionDateTime.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblTransactionDateTime.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblTransactionDateTime.textAlignment = NSTextAlignmentLeft;
        self.lblTransactionDateTime.numberOfLines = 1;
        self.lblTransactionDateTime.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblTransactionDateTime];
        
        //======= ADD LABEL TRANSACTION AMOUNT INTO MAIN CONTAINER VIEW =======//
        self.lblTransactionAmount = [[UILabel alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 90, 35, 80, 30)];
        self.lblTransactionAmount.font = [MySingleton sharedManager].themeFontFourteenSizeBold;
        self.lblTransactionAmount.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblTransactionAmount.textAlignment = NSTextAlignmentLeft;
        self.lblTransactionAmount.numberOfLines = 1;
        self.lblTransactionAmount.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblTransactionAmount];
        
        //======= ADD BOTTOM SEPARATOR INTO MAIN CONTAINER VIEW =======//
        self.bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(20, self.innerContainer.frame.size.height-1, self.innerContainer.frame.size.width - 40, 1)];
        self.bottomSeparatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
        [self.innerContainer addSubview:self.bottomSeparatorView];
        
        [self.mainContainer addSubview:self.innerContainer];
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
