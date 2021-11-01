//
//  Common_IntroductionViewController.h
//  Offeram
//
//  Created by Dipen Lad on 07/05/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Common_IntroductionViewController : UIViewController<UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, retain) IBOutlet UIButton *btnSkip;
@property (nonatomic, retain) IBOutlet UIButton *btnNext;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControlCount;

// PAGE 1
@property (nonatomic, retain) IBOutlet UIView *page1ContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage1Background;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage1Logo;

// PAGE 2
@property (nonatomic, retain) IBOutlet UIView *page2ContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage2Background;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage2Logo;
@property (nonatomic, retain) IBOutlet UILabel *lblPage2Title;
@property (nonatomic, retain) IBOutlet UILabel *lblPage2Description;

// PAGE 3
@property (nonatomic, retain) IBOutlet UIView *page3ContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage3Background;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage3Logo;
@property (nonatomic, retain) IBOutlet UILabel *lblPage3Title;
@property (nonatomic, retain) IBOutlet UILabel *lblPage3Description;

// PAGE 4
@property (nonatomic, retain) IBOutlet UIView *page4ContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage4Background;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage4Logo;
@property (nonatomic, retain) IBOutlet UILabel *lblPage4Title;
@property (nonatomic, retain) IBOutlet UILabel *lblPage4Description;

// PAGE 5
@property (nonatomic, retain) IBOutlet UIView *page5ContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage5Background;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewPage5Logo;
@property (nonatomic, retain) IBOutlet UILabel *lblPage5Title;
@property (nonatomic, retain) IBOutlet UILabel *lblPage5Description;

//========== OTHER VARIABLES ==========//

@end
