//
//  TambolaTicketTableViewCell.h
//  Offeram
//
//  Created by Innovative Iteration on 27/04/20.
//  Copyright © 2020 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface TambolaTicketTableViewCell : UITableViewCell

@property (nonatomic,retain) UIView *mainContainer;
@property (nonatomic,retain) UIView *innerContainer;

@property (nonatomic,retain) AsyncImageView *imageViewTambola;

@property (nonatomic,retain) UILabel *lblTambolaTitle;
@property (nonatomic,retain) UILabel *lblTambolaDescription;

@property (nonatomic,retain) UILabel *lblPriceTag;

@property (nonatomic,retain) UIButton *btnRegister;

@end


