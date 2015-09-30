//
//  BrightnessViewController.m
//  PhotoDemo
//
//  Created by Seeties IOS on 3/20/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import "BrightnessViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface BrightnessViewController ()

@end

@implementation BrightnessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ShowBrightnessText.text = CustomLocalisedString(@"Brightness", nil);
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    
   // CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowBrightnessText.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 60 - 15, 20, 60, 44);
    ShowBigImage.frame = CGRectMake(0, 64, screenWidth, 321);
    
    ShowIcon1.frame = CGRectMake((screenWidth/2) - 110 - 30, 448, 14, 14);
    Slider.frame = CGRectMake((screenWidth/2) - 110, 440, 220, 31);
    ShowIcon2.frame = CGRectMake((screenWidth/2) + 110 + 30, 448, 14, 14);
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetImageData:(NSArray *)ImageArray GetSelectCount:(NSInteger)SelectCount{
    
    GetSelectCount = SelectCount;
    
    GetImageArray = [[NSMutableArray alloc]initWithArray:ImageArray];
    NSLog(@"GetImageArray is %@",GetImageArray);
    
    ShowBigImage.image = [GetImageArray objectAtIndex:GetSelectCount];
    
//    UIImage *aUIImage = ShowBigImage.image;
//    CGImageRef aCGImage = aUIImage.CGImage;
//    beginImage = [CIImage imageWithCGImage:aCGImage];
//    
//    
//    context = [CIContext contextWithOptions:nil];
//    filter = [CIFilter filterWithName:@"CISepiaTone"
//                        keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity",
//              @0.8, nil];
//    filter = [CIFilter filterWithName:@"CIColorControls"];

//    UIImage *testimg = [GetImageArray objectAtIndex:0];
//    NSLog(@"testimg is %@",testimg);
//    beginImage = [[CIImage alloc] initWithCGImage:testimg.CGImage];
//    orientation = testimg.imageOrientation;
//    //beginImage = [UIImage imageWithCIImage:testimg.CIImage];
//    NSLog(@"beginImage is %@",beginImage);
//    
//    context = [CIContext contextWithOptions:nil];
//    
////    filter = [CIFilter filterWithName:@"CIColorMonochrome"
////                        keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity",
//////              @0.8, nil];
//    filter = [CIFilter filterWithName:@"CIColorControls"];
//    [filter setValue:beginImage forKey:kCIInputImageKey];
//    [filter setValue:@(1 - 2.0) forKey:@"inputBrightness"];
//    [filter setValue:@0.0 forKey:@"inputSaturation"];
//    filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues: @"inputImage", beginImage, nil];
//    
//    UIImage *newImage = [UIImage imageWithCIImage:beginImage];
//    ShowBigImage.image = newImage;
//    
//    
////    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
////                                  keysAndValues: kCIInputImageKey, beginImage,
////                        @"inputIntensity", @0.8, nil];
////    CIImage *outputImage = [filter outputImage];
////    
////    // 4
////    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
////    ShowBigImage.image = newImage;
}
- (void) CIColorControls :(float)saturation
{

    CIImage *inputImage =[[CIImage alloc]initWithImage:ShowBigImage.image];
    
    //initialize filter for brightness
    CIFilter *brightnesContrastFilter = [CIFilter filterWithName:@"CIColorControls"];
    [brightnesContrastFilter setDefaults];
    [brightnesContrastFilter setValue: inputImage forKey: @"inputImage"];
    [brightnesContrastFilter setValue: [NSNumber  numberWithFloat:0.5f]forKey:@"inputBrightness"];
    [brightnesContrastFilter setValue: [NSNumber numberWithFloat:saturation]forKey:@"inputSaturation"];
    [brightnesContrastFilter setValue: [NSNumber numberWithFloat:2.0f]forKey:@"inputContrast"];
    CIImage *outputImage = [brightnesContrastFilter valueForKey: @"outputImage"];
    CIContext *context_ = [CIContext contextWithOptions:nil];
    ShowBigImage.image = [UIImage imageWithCGImage:[context_
                                                 createCGImage:outputImage
                                                 fromRect:outputImage.extent]];
    
}
- (IBAction)amountSliderValueChanged:(UISlider *)slider {
//    float slideValue = slider.value;
////    [filter setValue:@(slideValue)
////              forKey:@"inputIntensity"];
////    CIImage *outputImage = [filter outputImage];
//    
////    [filter setValue:[NSNumber numberWithFloat:slideValue ] forKey: @"inputBrightness"];
////    CIImage *outputImage = [filter outputImage];
////    CGImageRef cgiig = [context createCGImage:outputImage fromRect:[outputImage extent]];
////    UIImage *newUIImage = [UIImage imageWithCGImage:cgiig];
////    CGImageRelease(cgiig);
////    [ShowBigImage setImage:newUIImage];
//
//    [filter setValue:[NSNumber numberWithFloat:slideValue] forKey: @"inputBrightness"];
//    CIImage *outputImage = [filter outputImage];
//    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
//    UIImage *newImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
//    ShowBigImage.image = newImage;
////
////    CGImageRelease(cgimg);
    
    float b;
    NSLog(@"%f",slider.value);
    b=(float)slider.value;
    [self CIColorControls:b];
}
-(IBAction)SaveButton:(id)sender{
    
    [GetImageArray replaceObjectAtIndex:GetSelectCount withObject:ShowBigImage.image];
    
    NSMutableArray *ImgArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [GetImageArray count]; i++) {
        UIImage *TempImg = [GetImageArray objectAtIndex:i];
        NSString *base64 = [self encodeToBase64String:TempImg];
        [ImgArray addObject:base64];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ImgArray forKey:@"selectedIndexArr_Thumbs"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
@end
