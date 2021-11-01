//
//  NoDataFountTableViewCell.h
//  Offeram
//
//  Created by Dipen Lad on 23/11/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoDataFountTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;
@property (nonatomic,retain) UIImageView *imageViewOfferam;
@property (nonatomic,retain) UILabel *lblNoData;
@property (nonatomic,retain) UIButton *btnAction;

@end

NS_ASSUME_NONNULL_END
