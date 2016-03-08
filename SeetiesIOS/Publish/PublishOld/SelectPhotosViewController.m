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

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@interface SelectPhotosViewController ()<UINavigationControllerDelegate, UIPopoverControllerDelegate>
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
}

@end
