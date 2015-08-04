//
//  SelectPhotosViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SelectPhotosViewController.h"

//#import <CoreLocation/CoreLocation.h>
//@import AssetsLibrary;

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>

static NSString * const kAFAviaryAPIKey = @"b42bd0c6f4c5104f";
static NSString * const kAFAviarySecret = @"80ee1b7f54c2ed86";
@interface SelectPhotosViewController ()<UINavigationControllerDelegate, AFPhotoEditorControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation SelectPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [DoneButton setTitle:CustomLocalisedString(@"Done", nil) forState:UIControlStateNormal];
    [TapToEdit setTitle:CustomLocalisedString(@"TaptoEdit", nil) forState:UIControlStateNormal];
    ShowTitle.text = CustomLocalisedString(@"SelectPhotos", nil);
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if( screenHeight < screenWidth ){
            screenHeight = screenWidth;
        }
        
        if( screenHeight > 480 && screenHeight < 667 ){
            NSLog(@"iPhone 5/5s");
            ShowBigImage.frame = CGRectMake(10, 64, 300, 400);
            AddImageScroll.frame = CGRectMake(10, 472, 220, 88);
            AddImgButton.frame = CGRectMake(232, 475, 80, 80);
            TapToEdit.frame = CGRectMake(87, 412, 147, 32);
        } else {
            NSLog(@"iPhone 4/4s");
            ShowBigImage.frame = CGRectMake(10, 64, 300, 300);
            AddImageScroll.frame = CGRectMake(10, 372, 220, 88);
            AddImgButton.frame = CGRectMake(232, 375, 80, 80);
            TapToEdit.frame = CGRectMake(87, 312, 147, 32);
        }
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *TempImgArray = [defaults objectForKey:@"SelectImageData"];
    // NSLog(@"TempImgArray is count = %i",[TempImgArray count]);
    //NSLog(@"GetImgArray is %@",GetImgArray);
    if ([TempImgArray count] == 0) {
        ImgArray = [[NSMutableArray alloc]init];
    }else{
        ImgArray = [[NSMutableArray alloc]initWithArray:TempImgArray];
        // ShowImage.image = [GetImgArray objectAtIndex:0];
        ShowBigImage.image = [self decodeBase64ToImage:[ImgArray objectAtIndex:0]];
        
        for (int i = 0; i < [ImgArray count]; i++) {
            UIButton *ShowImgButton = [[UIButton alloc]init];
            ShowImgButton.frame = CGRectMake(5 + i * 85, 4, 80, 80);
            [ShowImgButton setBackgroundColor:[UIColor blackColor]];
            ShowImgButton.tag = i;
            [ShowImgButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [ShowImgButton setImage:[self decodeBase64ToImage:[ImgArray objectAtIndex:i]] forState:UIControlStateNormal];
            [AddImageScroll addSubview:ShowImgButton];
            [AddImageScroll setScrollEnabled:YES];
            [AddImageScroll setContentSize:CGSizeMake(85 + i * 85, 88)];
        }
    }
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)GetType:(NSString *)Type{

    GetType = Type;
    
    if ([GetType isEqualToString:@"Photo Library"]) {
        [ImgArray removeAllObjects];
        ShowBigImage.image = nil;
        for (UIView *subview in AddImageScroll.subviews) {
            [subview removeFromSuperview];
        }
        
        
//        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
//        picker.maximumNumberOfSelection = 10;
//        picker.assetsFilter = [ALAssetsFilter allPhotos];
//        picker.showEmptyGroups=NO;
//        picker.delegate=self;
//        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
//                return duration >= 5;
//            } else {
//                return YES;
//            }
//        }];
//        
//        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
        }

    }
}
-(IBAction)AddImageButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CustomLocalisedString(@"Howdoyouwanttodoaddimage",nil)
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"PhotoLibrary",nil),CustomLocalisedString(@"Camera",nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 100;
    
   // addimage++;

}
-(IBAction)ImageButtonOnClick:(id)sender{
    getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    NSString *Str_button_id = [NSString stringWithFormat:@"%ld", (long)getbuttonIDN];
    NSLog(@"Str_button_id is %@",Str_button_id);
    
    //ShowBigImage.image = [ImgArray objectAtIndex:getbuttonIDN];
    ShowBigImage.image = [self decodeBase64ToImage:[ImgArray objectAtIndex:getbuttonIDN]];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Publish Select Photos Page";
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    UIAlertView *ShowAlertView = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Your unsaved changes will be lost." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    ShowAlertView.tag = 100;
    [ShowAlertView show];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    //[self presentViewController:ListingDetail animated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:transition forKey:nil];
            //[self presentViewController:ListingDetail animated:NO completion:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
        }else{
           
        }
    }

    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        //Get the name of the current pressed button
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if  ([buttonTitle isEqualToString:CustomLocalisedString(@"PhotoLibrary",nil)]) {
            NSLog(@"Photo Library");
            //            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //            imagePicker.delegate = self;
            //            imagePicker.allowsEditing = YES;
            //            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentViewController:imagePicker animated:YES completion:nil];
            //            //  //  [self presentModalViewController:imagePicker animated:YES];
            [ImgArray removeAllObjects];
            ShowBigImage.image = nil;
            for (UIView *subview in AddImageScroll.subviews) {
                [subview removeFromSuperview];
            }
            
//
//            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
//            picker.maximumNumberOfSelection = 10;
//            picker.assetsFilter = [ALAssetsFilter allPhotos];
//            picker.showEmptyGroups=NO;
//            picker.delegate=self;
//            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
//                    return duration >= 5;
//                } else {
//                    return YES;
//                }
//            }];
//            
//            [self presentViewController:picker animated:YES completion:NULL];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Camera",nil)]) {
            NSLog(@"Camera");
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else{
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
            }
            
        }

        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel",nil)]) {
            NSLog(@"Cancel Button");
        }
    }
    
}
//-(void)imagePickerController:(UIImagePickerController *)picker
//      didFinishPickingImage : (UIImage *)image
//                 editingInfo:(NSDictionary *)editingInfo
//{
//
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//#pragma mark - ZYQAssetPickerController Delegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//  //  NSLog(@"assets is %@",assets);
//    
//    for (int i = 0; i < assets.count; i++) {
//        ALAsset *asset = assets[i];
//     //   NSLog(@"asset is %@",asset);
//        UIButton *ShowImgButton = [[UIButton alloc]init];
//        ShowImgButton.frame = CGRectMake(5 + i * 85, 4, 80, 80);
//        [ShowImgButton setBackgroundColor:[UIColor blackColor]];
//        ShowImgButton.tag = i;
//        [ShowImgButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        [ShowImgButton setImage:tempImg forState:UIControlStateNormal];
//        NSString *base64 = [self encodeToBase64String:tempImg];;
//       // NSLog(@"base64 is %@",base64);
//        
//        [ImgArray addObject:base64];
//        [AddImageScroll addSubview:ShowImgButton];
//        [AddImageScroll setScrollEnabled:YES];
//        [AddImageScroll setContentSize:CGSizeMake(85 + i * 85, 88)];
//    }
//
//    ShowBigImage.image = [self decodeBase64ToImage:[ImgArray objectAtIndex:0]];
//}
-(void)GetImgArray:(NSMutableArray *)imgarray{

    GetImgArray = [[NSMutableArray alloc]initWithArray:imgarray];
    
    ShowBigImage.image = [self decodeBase64ToImage:[GetImgArray objectAtIndex:0]];
}
-(IBAction)DoneButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ImgArray forKey:@"SelectImageData"];
    [defaults setObject:@"ChangeNewImage" forKey:@"CheckDaftsImg"];
    [defaults synchronize];
  //  NSLog(@"ImgArray is %@",ImgArray);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(IBAction)EditButton:(id)sender{
   [self launchPhotoEditorWithImage:ShowBigImage.image highResolutionImage:nil];
}
#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block SelectPhotosViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    
    NSLog(@"editor is %@",editor);
    [ShowBigImage setImage:image];
   // [[self imagePreviewView] setImage:image];
   // [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *TempImage = image;
    NSString *base64 = [self encodeToBase64String:TempImage];
    [ImgArray replaceObjectAtIndex:getbuttonIDN withObject:base64];
    
    for (UIView *subview in AddImageScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    for (int i = 0; i < [ImgArray count]; i++) {
        UIButton *ShowImgButton = [[UIButton alloc]init];
        ShowImgButton.frame = CGRectMake(5 + i * 85, 4, 80, 80);
        [ShowImgButton setBackgroundColor:[UIColor blackColor]];
        ShowImgButton.tag = i;
        [ShowImgButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [ShowImgButton setImage:[self decodeBase64ToImage:[ImgArray objectAtIndex:i]] forState:UIControlStateNormal];
        [AddImageScroll addSubview:ShowImgButton];
        [AddImageScroll setScrollEnabled:YES];
        [AddImageScroll setContentSize:CGSizeMake(85 + i * 85, 88)];
    }
    
   // [ImgArray addObject:base64];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set API Key and Secret
    [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}
@end
