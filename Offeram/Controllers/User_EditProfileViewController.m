//
//  User_EditProfileViewController.m
//  Offeram
//
//  Created by Dipen Lad on 06/06/18.
//  Copyright © 2018 Accrete. All rights reserved.
//

#import "User_EditProfileViewController.h"
#import "MySingleton.h"
#import "IQKeyboardManager.h"

#import "User_MyAccountViewController.h"

@interface User_EditProfileViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}
@end

@implementation User_EditProfileViewController

//========== IBOUTLETS ==========//

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainScrollView;

@synthesize imageViewProfilePicture;

@synthesize ProfileDetilsContainerView;
@synthesize txtUserName;
@synthesize txtUserNameBottomSeparatorView;
@synthesize btnSubmit;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    
    [self setNavigationBar];
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotificationEventObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_updatedProfileDetailsEvent) name:@"user_updatedProfileDetailsEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_updatedProfileDetailsEvent
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"Profile updated successfully.";
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
        User_MyAccountViewController *viewController = [[User_MyAccountViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:false];
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    
    UIFont *lblFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblFont = [MySingleton sharedManager].themeFontTwentySizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
    }
    else
    {
        lblFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
    }
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.font = lblFont;
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalBackgroundColor;
    
    UIFont *txtFieldFont, *btnFont, *lblTitleFont;
    
    if([MySingleton sharedManager].screenWidth == 320)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
    }
    else if([MySingleton sharedManager].screenWidth == 375)
    {
        lblTitleFont = [MySingleton sharedManager].themeFontFifteenSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
    }
    else
    {
        lblTitleFont = [MySingleton sharedManager].themeFontSixteenSizeMedium;
        txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    
    // PROFILE PICTURE
    // border radius
    [imageViewProfilePicture.layer setCornerRadius:imageViewProfilePicture.frame.size.height/2];
    imageViewProfilePicture.clipsToBounds = true;
    imageViewProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
    imageViewProfilePicture.userInteractionEnabled = true;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTapOnProfileImage:)];
    [imageViewProfilePicture addGestureRecognizer:singleFingerTap];
    
    // TXT USER NAME
    txtUserName.font = txtFieldFont;
    txtUserName.delegate = self;
    txtUserName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"User Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtUserName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtUserName.tintColor = [MySingleton sharedManager].textfieldTintColor;
    txtUserName.floatingLabelFont = txtFieldFont;
    txtUserName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtUserName.keepBaseline = NO;
    [txtUserName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtUserNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    // BTN SUBMIT
    btnSubmit.backgroundColor = [MySingleton sharedManager].themeGlobalBlueColor;
    btnSubmit.titleLabel.font = btnFont;
    [btnSubmit setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = true;
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // SET DATA
    imageViewProfilePicture.imageURL = [NSURL URLWithString:[MySingleton sharedManager].dataManager.objLoggedInUser.strProfileImageURL];
    txtUserName.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strUserName;
    
}

-(IBAction)btnSubmitClicked:(id)sender
{
    if (txtUserName.text.length <= 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showAlertViewWithTitle:@"" withDetails:@"Please enter user name."];
        });
    }
    else
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        
        [dictParameters setObject:txtUserName.text forKey:@"user_name"];
        
        if (self.isImageChanged == true)
        {
            [dictParameters setObject:@"1" forKey:@"is_image_uploaded"];
            [dictParameters setObject:self.imageSelectedPictureData forKey:@"profile_image"];
        }
        else
        {
            [dictParameters setObject:@"0" forKey:@"is_image_uploaded"];
        }
        
        [[MySingleton sharedManager].dataManager user_updateProfileDetails:dictParameters];
    }
}

#pragma mark - MENU IMAGES

- (void)handleSingleTapOnProfileImage:(UITapGestureRecognizer *)recognizer
{
    [self showActionsheetForImagePicker];
}

#pragma mark - UIImagePickerController Delegate Method

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try
    {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        
        UIImage* smaller = [self imageWithImage:image scaledToWidth:320];
        
        self.imageSelectedPicture = smaller;
        self.imageSelectedPictureData = UIImagePNGRepresentation(smaller);
        
        imageViewProfilePicture.image = smaller;
        
        self.isImageChanged = true;
        
        UIGraphicsEndImageContext();
        
        [picker dismissViewControllerAnimated:NO completion:NULL];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in imagePickerController's didFinishPickingMediaWithInfo Method, %@",exception);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Custom Methods

-(void)showActionsheetForImagePicker
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Take a Photo
        [self dismissViewControllerAnimated:YES completion:nil];
        [self takeAPhoto];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Choose from Gallery
        [self dismissViewControllerAnimated:YES completion:nil];
        [self chooseFromGallery];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:actionSheet animated:YES completion:nil];
    });
}

-(void)takeAPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
        }
        else
        {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable" message:@"Unable to find a camera on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

-(void)chooseFromGallery
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
        }
        else
        {
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Photo library Unavailable" message:@"Unable to find photo library on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

@end
