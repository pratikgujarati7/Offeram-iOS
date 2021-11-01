//
//  NotificationTableViewCell.m
//  Offeram
//
//  Created by Dipen Lad on 12/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 100

@implementation NotificationTableViewCell

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
        self.innerContainer = [[UIView alloc]initWithFrame:CGRectMake(5, 5, cellWidth-10, cellHeight-10)];
        self.innerContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalWhiteColor;
        // border radius
        [self.innerContainer.layer setCornerRadius:5.0f];
        // drop shadow
        [self.innerContainer.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.innerContainer.layer setShadowOpacity:0.6];
        [self.innerContainer.layer setShadowRadius:2.0];
        [self.innerContainer.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        //======= ADD IMAGE VIEW BRAND INTO MAIN CONTAINER VIEW =======//
        self.imageViewNotification = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, self.innerContainer.frame.size.height - 20, self.innerContainer.frame.size.height - 20)];
        self.imageViewNotification.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewNotification.layer.masksToBounds = YES;
        [self.imageViewNotification.layer setCornerRadius:self.imageViewNotification.frame.size.height/2];
        [self.innerContainer addSubview:self.imageViewNotification];
        
        //======= ADD LABEL NOTIFICATION TEXT INTO MAIN CONTAINER VIEW =======//
        self.lblNotificationText = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewNotification.frame.origin.x + self.imageViewNotification.frame.size.width + 5), 5, (self.innerContainer.frame.size.width - (self.imageViewNotification.frame.origin.x + self.imageViewNotification.frame.size.width + 10)-5), 60)];
        self.lblNotificationText.font = [MySingleton sharedManager].themeFontFourteenSizeMedium;
        self.lblNotificationText.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblNotificationText.textAlignment = NSTextAlignmentJustified;
        self.lblNotificationText.numberOfLines = 0;
        self.lblNotificationText.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblNotificationText];
        
        //======= ADD LABEL NOTIFICATION TEXT BOTTOM SEPARATOR VIEW INTO MAIN CONTAINER VIEW =======//
        self.lblNotificationTextBottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake((self.imageViewNotification.frame.origin.x + self.imageViewNotification.frame.size.width + 5), 65, (self.innerContainer.frame.size.width - (self.imageViewNotification.frame.origin.x + self.imageViewNotification.frame.size.width + 10)-5), 1)];
        self.lblNotificationTextBottomSeparatorView.backgroundColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        [self.innerContainer addSubview:self.lblNotificationTextBottomSeparatorView];
        
        //======= ADD LABEL NOTIFICATION FROM INTO MAIN CONTAINER VIEW =======//
        self.lblNotificationFrom = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewNotification.frame.origin.x + self.imageViewNotification.frame.size.width + 5), 70, (self.innerContainer.frame.size.width - (self.imageViewNotification.frame.origin.x + self.imageViewNotification.frame.size.width + 10)-120), 10)];
        self.lblNotificationFrom.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblNotificationFrom.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblNotificationFrom.textAlignment = NSTextAlignmentLeft;
        self.lblNotificationFrom.numberOfLines = 1;
        self.lblNotificationFrom.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblNotificationFrom];
        
        //======= ADD LABEL NOTIFICATION DATE TIME INTO MAIN CONTAINER VIEW =======//
        self.lblNotificationDateTime = [[UILabel alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 120, 70, 110, 10)];
        self.lblNotificationDateTime.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblNotificationDateTime.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
        self.lblNotificationDateTime.textAlignment = NSTextAlignmentRight;
        self.lblNotificationDateTime.numberOfLines = 1;
        self.lblNotificationDateTime.layer.masksToBounds = YES;
        [self.innerContainer addSubview:self.lblNotificationDateTime];
        
        [self.mainContainer addSubview:self.innerContainer];
        
        //======= ADD NEW NOTIFICATION INDICATOR INTO MAIN CONTAINER VIEW =======//
        self.unreadNotificationIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.innerContainer.frame.size.width - 30, 0, 10, 10)];
        self.unreadNotificationIndicator.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
        [self.unreadNotificationIndicator.layer setCornerRadius:self.unreadNotificationIndicator.frame.size.height/2];
        [self.mainContainer addSubview:self.unreadNotificationIndicator];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
