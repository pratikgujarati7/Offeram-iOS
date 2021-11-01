//
//  NotificationTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 12/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface NotificationTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) AsyncImageView *imageViewNotification;

@property (nonatomic,retain) UILabel *lblNotificationText;
@property (nonatomic,retain) UIView *lblNotificationTextBottomSeparatorView;

@property (nonatomic,retain) UIView *unreadNotificationIndicator;

@property (nonatomic,retain) UILabel *lblNotificationFrom;
@property (nonatomic,retain) UILabel *lblNotificationDateTime;

@end
