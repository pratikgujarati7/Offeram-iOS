//
//  User_CommonWebViewViewController.h
//  Offeram
//
//  Created by Dipen Lad on 19/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User_CommonWebViewViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewShare;
@property (nonatomic,retain) IBOutlet UIButton *btnShare;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewDownload;
@property (nonatomic,retain) IBOutlet UIButton *btnDownload;

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIImageView *mainBackgroundImageView;

@property (nonatomic,retain) IBOutlet UIWebView *mainWebView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSString *strNavigationTitle;
@property (nonatomic,retain) NSString *strUrlToLoad;

@property (nonatomic,assign) BOOL boolIsLoadedFromRegisterForTambolaViewController;

@end
