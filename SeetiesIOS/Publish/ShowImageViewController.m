//
//  ShowImageViewController.m
//  PhotoDemo
//
//  Created by Seeties IOS on 3/13/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import "ShowImageViewController.h"
#import "BrightnessViewController.h"
#import "TellaStoryViewController.h"
#import "PECropViewController.h"
#import "SelectImageViewController.h"
#import "WhereIsThisViewController.h"
#import "LLARingSpinnerView.h"

#import "LanguageManager.h"
#import "Locale.h"

//#import "MainViewController.h"
#import "ProfileV2ViewController.h"
#import "ExploreViewController.h"
#import "NotificationViewController.h"
#import "SelectImageViewController.h"

#import "FeedV2ViewController.h"
#define Duration 0.2

#import "NSMutableArray+MoveArray.h"

#import "UIIimage+Extra.h"
@import AssetsLibrary;
@interface ShowImageViewController ()<PECropViewControllerDelegate,UINavigationControllerDelegate, UIPopoverControllerDelegate>{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
    
}
@property (strong , nonatomic) NSMutableArray *itemArray;
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    [DoneButton setTitle:CustomLocalisedString(@"DoneButton", nil) forState:UIControlStateNormal];
    [AddatagButton setTitle:CustomLocalisedString(@"Addtag", nil) forState:UIControlStateNormal];
    
    ShowHoldandDragText.text = CustomLocalisedString(@"HoldNDragTheThumbnails", nil);

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [MainScroll setContentSize:CGSizeMake(screenWidth, 568)];
    
    DoneButton.frame = CGRectMake(screenWidth - 80 - 15, 20, 80, 44);
    
    DeleteButton.frame = CGRectMake((screenWidth/2) - 50, 20, 50, 44);
    //BrightnessButton.frame = CGRectMake((screenWidth/2) - 25, -50, 50, 44);
    //CropButton.frame = CGRectMake((screenWidth/2) + 25, -50, 50, 44);
    EditButton.frame = CGRectMake((screenWidth/2) , 20, 50, 44);
    BrightnessButton.hidden = YES;
    CropButton.hidden = YES;
    
    SmallImgScroll.delegate = self;
    CaptionField.delegate = self;
    CaptionField.textAlignment = NSTextAlignmentLeft;
    CaptionField.text = CustomLocalisedString(@"Writeacaptionhere", nil);
    CaptionField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    
    AddatagButton.hidden = YES;
    ShowTextCount.hidden = YES;
    ShowTextCount.frame = CGRectMake(screenWidth - 42 - 15, 400, 42, 21);
    
    SendCaptionDataArray = [[NSMutableArray alloc]init];
    TagStringArray = [[NSMutableArray alloc]init];
    TagStringDataArray = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [MainScroll addGestureRecognizer:tapGesture];
    
    CategorySelectIDArray = [[NSMutableArray alloc]init];
    
    GetHeight = (screenWidth - 4) / 5;
    
    ShowBigImage.frame = CGRectMake(0, 64, screenWidth, screenHeight - (GetHeight * 2) - 100 - 64);
    SmallArrowImage.frame = CGRectMake((screenWidth/2) - 12, screenHeight - (GetHeight * 2) - 100 - 12, 23, 12);
    CaptionField.frame = CGRectMake(20, screenHeight - (GetHeight * 2) - 90, screenWidth - 40, 90);
    CaptionBackground.frame = CGRectMake(0, screenHeight - (GetHeight * 2) - 100, screenWidth, 100);
    
    ShowMessageArrangeView.hidden = YES;
    ArrangeBackgroundImg.hidden = YES;
    
    DeletePhotoIDArray = [[NSMutableArray alloc]init];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SavePhotoChange", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"Photo_No", nil) otherButtonTitles:CustomLocalisedString(@"Photo_Yes", nil), nil];
    alert.tag = 600;
    [alert show];

}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [[event allTouches] anyObject];
//    NSLog(@"touch anyObject ????");
//    if ([CaptionField isFirstResponder] && [touch view] != CaptionField) {
//
//    }
//    [super touchesBegan:touches withEvent:event];
//
//
//}
-(void)hideKeyboard
{
    [CaptionField resignFirstResponder];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if ([CaptionField.text length] == 0) {
        CaptionField.text = CustomLocalisedString(@"Writeacaptionhere", nil);
         CaptionField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }else{
        CaptionField.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    }
    [self colorHashtag];
    //end
    ShowTextCount.hidden = YES;
    ShowBigImage.frame = CGRectMake(0, 64, screenWidth, screenHeight - (GetHeight * 2) - 100 - 64);
    SmallArrowImage.frame = CGRectMake((screenWidth/2) - 11, screenHeight - (GetHeight * 2) - 100 - 12, 23, 12);
    CaptionField.frame = CGRectMake(20, screenHeight - (GetHeight * 2) - 90, screenWidth - 40, 90);
    CaptionBackground.frame = CGRectMake(0, screenHeight - (GetHeight * 2) - 100, screenWidth, 100);
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //start
    ShowBigImage.frame = CGRectMake(0, 0, screenWidth, screenHeight - (GetHeight * 2) - 100 - 64);
    SmallArrowImage.frame = CGRectMake((screenWidth/2) - 11, screenHeight - (GetHeight * 2) - 100 - 12- 64, 23, 12);
    CaptionField.frame = CGRectMake(20, screenHeight - (GetHeight * 2) - 90 - 64, screenWidth - 40, 90);
    CaptionBackground.frame = CGRectMake(0, screenHeight - (GetHeight * 2) - 100 - 64, screenWidth, 164);
    ShowTextCount.hidden = NO;
    ShowTextCount.frame = CGRectMake(screenWidth - 42 - 15, 400, 42, 21);
    if ([CaptionField.text isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
        CaptionField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        CaptionField.text = @"";
    }else{
        CaptionField.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [self colorHashtag];
    }
    
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if ([CaptionField.text length] == 0) {
        CaptionField.text = CustomLocalisedString(@"Writeacaptionhere", nil);
        CaptionField.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }else{
        
        [CaptionArray replaceObjectAtIndex:SelctImgCount withObject:CaptionField.text];
         CaptionField.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    }
    
    //end
    ShowTextCount.hidden = YES;
    ShowBigImage.frame = CGRectMake(0, 64, screenWidth, screenHeight - (GetHeight * 2) - 100 - 64);
    SmallArrowImage.frame = CGRectMake((screenWidth/2) - 11, screenHeight - (GetHeight * 2) - 100 - 12, 23, 12);
    CaptionField.frame = CGRectMake(20, screenHeight - (GetHeight * 2) - 90, screenWidth - 40, 90);
    CaptionBackground.frame = CGRectMake(0, screenHeight - (GetHeight * 2) - 100, screenWidth, 100);
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSUInteger len = textView.text.length;
    ShowTextCount.text = [NSString stringWithFormat:@"%lu",140 - len];
    ShowTextCount.textColor = [UIColor blackColor];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ShowTextCount.frame = CGRectMake(screenWidth - 42 - 15, textView.frame.origin.y + [textView sizeThatFits:CGSizeMake(screenWidth - 42 - 15, CGFLOAT_MAX)].height, 42, 37);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }else{
        if([text length] == 0)
        {
            if([textView.text length] != 0)
            {
                return YES;
            }
        }
        else if([[textView text] length] >= 140)
        {
            ShowTextCount.text = @"0";
            ShowTextCount.textColor = [UIColor redColor];
            return NO;
        }else{
            if ([text isEqualToString:@"#"] || [text isEqualToString:@"@"]) {
                NSLog(@"get #");
                
            }else if ([text isEqualToString:@" "]) {
                NSLog(@"done ");
                [self colorHashtag];
            }
            
            
        }

    }
        return YES;
}
-(void)colorHashtag
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:CaptionField.text];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:17] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f] range:NSMakeRange(0, string.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    
    NSString *str = CaptionField.text;
    NSError *error = nil;
    
    //I Use regex to detect the pattern I want to change color
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:0];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error];
    
    NSArray *matches2 = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    for (NSTextCheckingResult *match in matches2) {
        NSRange wordRange = [match rangeAtIndex:0];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] range:wordRange];//51,181,229
    }
    [CaptionField setAttributedText:string];
}
//- (NSString *)encodeToBase64String:(UIImage *)image {
//    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//}
//- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
//    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    return [UIImage imageWithData:data];
//}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID{
    GetUpdatePost = UpdatePost;
    GetPostID = PostID;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.screenName = @"IOS Edit Photo View V2";
    
    dispatch_async (dispatch_get_main_queue(), ^{
        
        [self InitView2];
    });
}
-(void)InitView2{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
    NSData *GetImageData = [defaults objectForKey:@"selectedIndexArr_Thumbs_Data"];
    // GetImageArray = [[NSArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
    TempDictonary = [NSKeyedUnarchiver unarchiveObjectWithData:GetImageData];
    NSLog(@"TempDictonary is %@",TempDictonary);
    NSArray *aKeys = [TempDictonary keysSortedByValueUsingSelector:@selector(compare:)];
    NSLog(@"aKeys is %@",aKeys);
    
    NSString *GetPhotoID = [defaults objectForKey:@"PublishV2_PhotoID"];
    NSArray *SplitArray = [GetPhotoID componentsSeparatedByString:@","];
    GetPhotoIDArray = [[NSMutableArray alloc]initWithArray:SplitArray];
    
    GetImageDataArray = [[NSMutableArray alloc]initWithArray:aKeys];
    NSLog(@"APA GetImageDataArray is %@",GetImageDataArray);
    GetImageArray = [[NSMutableArray alloc]init];
    PhotoPositionArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [TempArray count]; i++) {
        
      //  [GetImageArray addObject:[self decodeBase64ToImage:[TempArray objectAtIndex:i]]];
        [GetImageArray addObject:[TempArray objectAtIndex:i]];
        NSString *GetCount = [[NSString alloc]initWithFormat:@"%ld",(long)i + 1];
        [PhotoPositionArray addObject:GetCount];
    }
    
    // NSLog(@"GetImageArray is %@",GetImageArray);
    CaptionArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionArray"]];
    NSLog(@"1st CaptionArray is %@",CaptionArray);
    
    if ([CaptionArray count] == 0) {
        for (NSInteger i = 0; i < [GetImageArray count]; i++) {
            [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
            [GetPhotoIDArray addObject:@""];
            
            NSString *GetCount = [[NSString alloc]initWithFormat:@"%ld",(long)i + 1];
            [PhotoPositionArray addObject:GetCount];
        }
    }else{
        for (NSInteger i = [CaptionArray count]; i < [GetImageArray count]; i++) {
            [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
            [GetPhotoIDArray addObject:@""];
            NSString *GetCount = [[NSString alloc]initWithFormat:@"%ld",(long)i + 1];
            [PhotoPositionArray addObject:GetCount];
        }
    }
    
//    if ([GetUpdatePost isEqualToString:@"YES"]) {
//        for (NSInteger i = [CaptionArray count]; i < [GetImageArray count]; i++) {
//            [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        }
//    }else{
       // [CaptionArray removeAllObjects];

//    }

    NSLog(@"after CaptionArray is %@",CaptionArray);
    
    ImgArray = [[NSMutableArray alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    for (NSInteger i = 0;i<10;i++)
    {
        
        
        InitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        InitButton.backgroundColor = [UIColor blackColor];
        InitButton.frame = CGRectMake(0+(i%5)*(GetHeight+1), (screenHeight - GetHeight - GetHeight - 1)+(i/5)*(GetHeight+1), GetHeight, GetHeight);
        InitButton.tag = i;
        //[InitBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        InitButton.clipsToBounds = YES;
        InitButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        if (i >= [GetImageArray count]) {
            //  [btn setTitle:[NSString stringWithFormat:@"NO"] forState:UIControlStateNormal];
            [InitButton setImage:[UIImage imageNamed:@"PhotoAddTile.png"] forState:UIControlStateNormal];
            
        }else{
           UIImage *TempImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
           // [InitButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]] forState:UIControlStateNormal];
            [InitButton setBackgroundImage:[TempImage imageByCroppingImage:TempImage toSize:CGSizeMake(TempImage.size.width, TempImage.size.height)] forState:UIControlStateNormal];
            [InitButton setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
        }
        InitButton.imageView.contentMode = UIViewContentModeScaleAspectFill; //this is needed for some reason, won't work without it.
        
        InitButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        InitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        if (InitButton.tag == 0) {
            InitButton.selected = YES;
        }else{
            InitButton.selected = NO;
        }
        [InitButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:InitButton];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [InitButton addGestureRecognizer:longGesture];
        [self.itemArray addObject:InitButton];
        
        
    }

    
    ShowBigImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:0]]];
    NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:0]];
    if ([TempGetStirngMessage length] == 0) {
        CaptionField.text = CustomLocalisedString(@"Writeacaptionhere", nil);
        [CaptionArray replaceObjectAtIndex:0 withObject:CaptionField.text];
    }else{
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
        CaptionField.text = TempGetStirngMessage;
        [self colorHashtag];
    }
    
    NSString *CheckArrangeMessage = [defaults objectForKey:@"ArragenMessageCheck"];
    if ([CheckArrangeMessage isEqualToString:@"Done"]) {
        ShowMessageArrangeView.hidden = YES;
        ArrangeBackgroundImg.hidden = YES;
    }else{
        ShowMessageArrangeView.hidden = NO;
        ArrangeBackgroundImg.hidden = NO;
        
        ShowMessageArrangeView.frame = CGRectMake(0, 0 , screenWidth, screenHeight);
        ArrangeBackgroundImg.frame = CGRectMake(0, screenHeight - (GetHeight * 2) - 70, 320, 63);
        
        [MainScroll addSubview:ShowMessageArrangeView];
        [MainScroll addSubview:ArrangeBackgroundImg];
    }


    
    SelctImgCount = 0;
    

}
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    // NSLog(@"1");
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) sender;
    NSInteger tag = recognizer.view.tag;
    
    NSLog(@"button %li",(long)tag);
    
    if (tag > [GetImageArray count] - 1) {
        NSLog(@"Error.");
    }else{
        UIButton *btn = (UIButton *)sender.view;
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {//NSLog(@"2");
            startPoint = [sender locationInView:sender.view];
            originPoint = btn.center;
            [UIView animateWithDuration:Duration animations:^{
                
                btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                btn.alpha = 0.7;
            }];
            
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {//NSLog(@"3");
            
            CGPoint newPoint = [sender locationInView:sender.view];
            CGFloat deltaX = newPoint.x-startPoint.x;
            CGFloat deltaY = newPoint.y-startPoint.y;
            btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
            //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
            NSInteger index = [self indexOfPoint:btn.center withButton:btn];
            // NSLog(@"index is %ld",(long)index);
            if (index<0)
            {//NSLog(@"4");
                contain = NO;
            }
            else
            {//NSLog(@"5");
                //   NSLog(@"Again TestArray is %@",TestArray);
                [UIView animateWithDuration:Duration animations:^{
                    
                    CGPoint temp = CGPointZero;
                    UIButton *button = _itemArray[index];
                    NSLog(@"button is %@",button);
                    NSLog(@"index is %ld",(long)index);
                    GetTag =  index;
                    //                for (int i = 0; i < [self.itemArray count]; i++) {
                    //                    NSString *GetString = [[NSString alloc]initWithFormat:@"%@",];
                    //                }
                    //   NSLog(@"Move GetTag is %ld",(long)GetTag);
                    temp = button.center;
                    button.center = originPoint;
                    btn.center = temp;
                    originPoint = btn.center;
                    contain = YES;
                    
                }];
            }
            
            
        }
        else if (sender.state == UIGestureRecognizerStateEnded)
        {//NSLog(@"6");
            [UIView animateWithDuration:Duration animations:^{
                
                
                btn.transform = CGAffineTransformIdentity;
                btn.alpha = 1.0;
                if (!contain)
                {
                    btn.center = originPoint;
                }
            }completion:^(BOOL finished) {
                if (finished) {
                    [self.itemArray moveObjectFromIndex:tag toIndex:GetTag];
                    [GetImageArray moveObjectFromIndex:tag toIndex:GetTag];
                    [CaptionArray moveObjectFromIndex:tag toIndex:GetTag];
                    [GetPhotoIDArray moveObjectFromIndex:tag toIndex:GetTag];
                    [PhotoPositionArray moveObjectFromIndex:tag toIndex:GetTag];
//                    [SendCaptionDataArray moveObjectFromIndex:tag toIndex:GetTag];
//                    [TagStringArray moveObjectFromIndex:tag toIndex:GetTag];
//                    [TagStringDataArray moveObjectFromIndex:tag toIndex:GetTag];

                    NSLog(@"PhotoPositionArray is %@",PhotoPositionArray);
                    

                    
                    for(UIView *view in self.view.subviews)
                    {
                        if ([view isKindOfClass:[UIButton class]])
                        {
                            [view  removeFromSuperview];
                        }
                    }
                    [self.itemArray removeAllObjects];
                    
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
                    GetHeight = (screenWidth - 4) / 5;
                    
                    for (NSInteger i = 0;i<10;i++)
                    {
                        
                        InitButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        InitButton.backgroundColor = [UIColor blackColor];
                        InitButton.frame = CGRectMake(0+(i%5)*(GetHeight+1), (screenHeight - GetHeight - GetHeight - 1)+(i/5)*(GetHeight+1), GetHeight, GetHeight);
                        InitButton.tag = i;
                        InitButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
                        InitButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                        InitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                        InitButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                        InitButton.clipsToBounds = YES;
                        if (i >= [GetImageArray count]) {
                            //  [btn setTitle:[NSString stringWithFormat:@"NO"] forState:UIControlStateNormal];
                            [InitButton setImage:[UIImage imageNamed:@"PhotoAddTile.png"] forState:UIControlStateNormal];

                        }else{
                            UIImage *TempImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
                            // [InitButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]] forState:UIControlStateNormal];
                            [InitButton setBackgroundImage:[TempImage imageByCroppingImage:TempImage toSize:CGSizeMake(TempImage.size.width, TempImage.size.height)] forState:UIControlStateNormal];
                            [InitButton setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
                        }
                        
                        if (InitButton.tag == 0) {
                            InitButton.selected = YES;
                        }else{
                            InitButton.selected = NO;
                        }
                        
                        [InitButton addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [MainScroll addSubview:InitButton];
                        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
                        [InitButton addGestureRecognizer:longGesture];
                        [self.itemArray addObject:InitButton];
                        
                        
                    }
                    //  NSLog(@"self.itemArray is %@",self.itemArray);
                    InitButton.selected = YES;
                    ShowBigImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:0]]];
                    NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:0]];
                    if ([TempGetStirngMessage length] == 0) {
                        CaptionField.text = CustomLocalisedString(@"Writeacaptionhere", nil);
                        [CaptionArray replaceObjectAtIndex:0 withObject:CaptionField.text];
                    }else{
                        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
                        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
                        CaptionField.text = TempGetStirngMessage;
                        [self colorHashtag];
                    }

                }
            }];
        }
    }
    
    
}
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{//NSLog(@"7");
    for (NSInteger i = 0;i<_itemArray.count;i++)
    {
        UIButton *button = _itemArray[i];
        if (button != btn)
        {//NSLog(@"8");
            if (CGRectContainsPoint(button.frame, point))
            {//NSLog(@"9");
                return i;
            }
        }
    }
    return -1;
}
//-(void)InitView{
//    if ([GetUpdatePost isEqualToString:@"YES"]) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
//        GetImageArray = [[NSMutableArray alloc]init];
//        for (int i = 0; i < [TempArray count]; i++) {
//            [GetImageArray addObject:[self decodeBase64ToImage:[TempArray objectAtIndex:i]]];
//        }
//        NSLog(@"GetImageArray is %@",GetImageArray);
//        CaptionArray = [[NSMutableArray alloc]init];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        
//        NSString *GetPhotoCaption = [defaults objectForKey:@"Draft_PhotoCaption"];
//        NSArray *SplitArray = [GetPhotoCaption componentsSeparatedByString:@","];
//        NSLog(@"SplitArray is %@",SplitArray);
//        
//        for (int i = 0 ; i < [SplitArray count]; i++) {
//            NSString *GetPhotoCaption = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
//            NSLog(@"GetPhotoCaption is %@",GetPhotoCaption);
//            [CaptionArray replaceObjectAtIndex:i withObject:GetPhotoCaption];
//        }
//        
//        
//        ImgArray = [[NSMutableArray alloc]init];
//        SmallImgButton_01.tag = 0;
//        SmallImgButton_02.tag = 1;
//        SmallImgButton_03.tag = 2;
//        SmallImgButton_04.tag = 3;
//        SmallImgButton_05.tag = 4;
//        SmallImgButton_06.tag = 5;
//        SmallImgButton_07.tag = 6;
//        SmallImgButton_08.tag = 7;
//        SmallImgButton_09.tag = 8;
//        SmallImgButton_10.tag = 9;
//        [SmallImgButton_01 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_02 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_03 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_04 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_05 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_06 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_07 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_08 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_09 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_10 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        for (int i = 0; i < [GetImageArray count]; i++) {
//            switch (i) {
//                case 0:
//                    NSLog(@"0 in herer???");
//                    [SmallImgButton_01 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_01 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    // SmallImgButton_01.tag = i;
//                    [SmallImgButton_01 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_01 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                    break;
//                case 1:
//                    NSLog(@"1 in herer???");
//                    [SmallImgButton_02 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_02 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //  SmallImgButton_02.tag = i;
//                    [SmallImgButton_02 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_02 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                case 2:
//                    NSLog(@"2 in herer???");
//                    [SmallImgButton_03 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_03 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_03.tag = i;
//                    [SmallImgButton_03 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_03 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 3:
//                    NSLog(@"3 in herer???");
//                    [SmallImgButton_04 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_04 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_04.tag = i;
//                    [SmallImgButton_04 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_04 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 4:
//                    [SmallImgButton_05 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_05 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_05.tag = i;
//                    [SmallImgButton_05 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_05 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 5:
//                    [SmallImgButton_06 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_06 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //  SmallImgButton_06.tag = i;
//                    [SmallImgButton_06 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_06 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 6:
//                    [SmallImgButton_07 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_07 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_07.tag = i;
//                    [SmallImgButton_07 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_07 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 7:
//                    [SmallImgButton_08 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_08 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_08.tag = i;
//                    [SmallImgButton_08 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_08 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 8:
//                    [SmallImgButton_09 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_09 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_09.tag = i;
//                    [SmallImgButton_09 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_09 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 9:
//                    [SmallImgButton_10 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_10 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_10.tag = i;
//                    [SmallImgButton_10 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_10 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 10:
//                    break;
//                default:
//                    break;
//            }
//            
//            [SmallImgScroll setScrollEnabled:YES];
//            [SmallImgScroll setContentSize:CGSizeMake(80 + i * 79, 80)];
//        }
//        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:0]];
//        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
//        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
//        CaptionField.text = TempGetStirngMessage;
//        [self colorHashtag];
//        
//        ShowBigImage.image = [GetImageArray objectAtIndex:0];
//        SelctImgCount = 0;
//        SmallImgButton_01.selected = YES;
//        SmallImgButton_02.selected = NO;
//        SmallImgButton_03.selected = NO;
//        SmallImgButton_04.selected = NO;
//        SmallImgButton_05.selected = NO;
//        SmallImgButton_06.selected = NO;
//        SmallImgButton_07.selected = NO;
//        SmallImgButton_08.selected = NO;
//        SmallImgButton_09.selected = NO;
//        SmallImgButton_10.selected = NO;
//        
//    }else{
//        
//        NSLog(@"initview in here??????");
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
//        // GetImageArray = [[NSArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
//        // NSLog(@"TempArray is %@",TempArray);
//        GetImageArray = [[NSMutableArray alloc]init];
//        for (int i = 0; i < [TempArray count]; i++) {
//            
//            [GetImageArray addObject:[self decodeBase64ToImage:[TempArray objectAtIndex:i]]];
//        }
//        // NSLog(@"GetImageArray is %@",GetImageArray);
//        CaptionArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"PublishV2_CaptionArray"]];
//       // if ([CaptionArray count] == 0) {
//        for (NSInteger i = [CaptionArray count]; i < [GetImageArray count]; i++) {
//        [CaptionArray addObject:CustomLocalisedString(@"Writeacaptionhere", nil)];
//        }
//        //}
//        NSLog(@"initview GetImageArray count is %lu",(unsigned long)[GetImageArray count]);
//        NSLog(@"initview CaptionArray count is %lu",(unsigned long)[CaptionArray count]);
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //        [CaptionArray addObject:@"Add captions & tag this photo..."];
//        //
//        //        NSString *GetPhotoCaption = [defaults objectForKey:@"PublishV2_CaptionArray"];
//        //        NSArray *SplitArray = [GetPhotoCaption componentsSeparatedByString:@","];
//        //        NSLog(@"SplitArray is %@",SplitArray);
//        //
//        //        for (int i = 0 ; i < [SplitArray count]; i++) {
//        //            NSString *GetPhotoCaption = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
//        //            NSLog(@"GetPhotoCaption is %@",GetPhotoCaption);
//        //            [CaptionArray replaceObjectAtIndex:i withObject:GetPhotoCaption];
//        //        }
//        
//        ImgArray = [[NSMutableArray alloc]init];
//        SmallImgButton_01.tag = 0;
//        SmallImgButton_02.tag = 1;
//        SmallImgButton_03.tag = 2;
//        SmallImgButton_04.tag = 3;
//        SmallImgButton_05.tag = 4;
//        SmallImgButton_06.tag = 5;
//        SmallImgButton_07.tag = 6;
//        SmallImgButton_08.tag = 7;
//        SmallImgButton_09.tag = 8;
//        SmallImgButton_10.tag = 9;
//        [SmallImgButton_01 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_02 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_03 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_04 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_05 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_06 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_07 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_08 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_09 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [SmallImgButton_10 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        for (int i = 0; i < [GetImageArray count]; i++) {
//            switch (i) {
//                case 0:
//                    [SmallImgButton_01 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_01 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    // SmallImgButton_01.tag = i;
//                    [SmallImgButton_01 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_01 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 1:
//                    [SmallImgButton_02 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_02 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //  SmallImgButton_02.tag = i;
//                    [SmallImgButton_02 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_02 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 2:
//                    [SmallImgButton_03 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_03 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_03.tag = i;
//                    [SmallImgButton_03 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_03 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 3:
//                    [SmallImgButton_04 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_04 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_04.tag = i;
//                    [SmallImgButton_04 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_04 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 4:
//                    [SmallImgButton_05 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_05 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_05.tag = i;
//                    [SmallImgButton_05 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_05 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 5:
//                    [SmallImgButton_06 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_06 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //  SmallImgButton_06.tag = i;
//                    [SmallImgButton_06 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_06 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 6:
//                    [SmallImgButton_07 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_07 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_07.tag = i;
//                    [SmallImgButton_07 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_07 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 7:
//                    [SmallImgButton_08 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_08 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_08.tag = i;
//                    [SmallImgButton_08 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_08 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 8:
//                    [SmallImgButton_09 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_09 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_09.tag = i;
//                    [SmallImgButton_09 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_09 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 9:
//                    [SmallImgButton_10 setBackgroundImage:[GetImageArray objectAtIndex:i] forState:UIControlStateNormal];
//                    [SmallImgButton_10 setImage:[UIImage imageNamed:@"EditPhotoFrame.png"] forState:UIControlStateSelected];
//                    //   SmallImgButton_10.tag = i;
//                    [SmallImgButton_10 setTitle:@"" forState:UIControlStateNormal];
//                    [SmallImgButton_10 addTarget:self action:@selector(ImageButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case 10:
//                    break;
//                default:
//                    break;
//            }
//            
//            [SmallImgScroll setScrollEnabled:YES];
//            [SmallImgScroll setContentSize:CGSizeMake(80 + i * 79, 80)];
//        }
//        
//        
//        ShowBigImage.image = [GetImageArray objectAtIndex:0];
//        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:0]];
//        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
//        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
//        CaptionField.text = TempGetStirngMessage;
//        [self colorHashtag];
////        if ([TempGetStirngMessage isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
////            
////        }else{
////            NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
////            TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
////            CaptionField.text = TempGetStirngMessage;
////            [self colorHashtag];
////        }
//
//        SelctImgCount = 0;
//        SmallImgButton_01.selected = YES;
//        SmallImgButton_02.selected = NO;
//        SmallImgButton_03.selected = NO;
//        SmallImgButton_04.selected = NO;
//        SmallImgButton_05.selected = NO;
//        SmallImgButton_06.selected = NO;
//        SmallImgButton_07.selected = NO;
//        SmallImgButton_08.selected = NO;
//        SmallImgButton_09.selected = NO;
//        SmallImgButton_10.selected = NO;
//    }
//}

//-(void)GetImageData:(NSArray *)ImageArray{
//
//    GetImageArray = [[NSArray alloc]initWithArray:ImageArray];
//    
//
//}
-(IBAction)ImageButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    SelctImgCount = getbuttonIDN;
    NSLog(@"GetImageArray count is %lu",(unsigned long)[GetImageArray count]);
    NSLog(@"getbuttonIDN + 1 is %ld",getbuttonIDN + 1);
    NSLog(@"CaptionArray count is %lu",(unsigned long)[CaptionArray count]);
    
    UIButton *button_ = sender;
    for (UIView *button in InitButton.superview.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [(UIButton *)button setSelected:NO];
        }
    }
    [button_ setSelected:YES];
    
    if ([GetImageArray count] >= getbuttonIDN + 1) {
        NSLog(@"1111");
        //ShowBigImage.image = [ImgArray objectAtIndex:getbuttonIDN];
        ShowBigImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:getbuttonIDN]]];
        
        
        NSString *TempGetStirngMessage = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:getbuttonIDN]];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]:"];
        TempGetStirngMessage = [[TempGetStirngMessage componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString:@""];
        
        if ([TempGetStirngMessage length] == 0) {
            CaptionField.text = CustomLocalisedString(@"Writeacaptionhere", nil);
        }else{
        CaptionField.text = TempGetStirngMessage;
        }
        
        NSUInteger len;

        if ([CaptionField.text isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
          //  CaptionField.textColor = [UIColor blueColor];
            CaptionField.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            len = CaptionField.text.length;
            ShowTextCount.text = [NSString stringWithFormat:@"140"];
        }else{
          //  CaptionField.textColor = [UIColor blackColor];
            len = CaptionField.text.length;
            ShowTextCount.text = [NSString stringWithFormat:@"%lu",140 - len];
            CaptionField.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
            [self colorHashtag];
        }
        [self colorHashtag];
        
        

        
        
        if (len >= 140) {
            ShowTextCount.textColor = [UIColor redColor];
        }else{
        ShowTextCount.textColor = [UIColor blackColor];
        }
        
    }else{
        CaptionField.text = @"";
        [SendCaptionDataArray removeAllObjects];
        [TagStringArray removeAllObjects];
        [TagStringDataArray removeAllObjects];
        
        for (int i = 0; i < [CaptionArray count]; i++) {
            NSString *TestString;
            NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
            if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
                TestString = @"";
            }else{
                NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
                //  NSLog(@"stringArray is %@",stringArray);
                NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
                for (int i = 0; i < [stringArray count]; i++) {
                    NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
                    if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                        //    NSLog(@"no ?");
                        //  [SendCaptionDataArray addObject:TempString];
                        //   NSLog(@"No Tag TempString is %@",TempString);
                        
                        if ([TempString rangeOfString:@"#"].location == NSNotFound) {
                            TestString = [TestArray componentsJoinedByString:@" "];
                        }else{
                            TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
                            // NSLog(@"after TempString is %@",TempString);
                            [TagStringArray addObject:TempString];
                            NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                            //   NSLog(@"TestAgain is %@",TestAgain);
                            [TagStringDataArray addObject:TestAgain];
                            [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                            //  NSLog(@"TestArray is %@",TestArray);
                            TestString = [TestArray componentsJoinedByString:@" "];
                            //   NSLog(@"TestString is %@",TestString);
                        }
                        //   NSLog(@"TestString is %@",TestString);
                    } else {
                        //    NSLog(@"with @ ?");
                        // NSLog(@"Start TempString is %@",TempString);
                        
                        TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
                        // NSLog(@"after TempString is %@",TempString);
                        [TagStringArray addObject:TempString];
                        NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                        //   NSLog(@"TestAgain is %@",TestAgain);
                        [TagStringDataArray addObject:TestAgain];
                        [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                        //  NSLog(@"TestArray is %@",TestArray);
                        TestString = [TestArray componentsJoinedByString:@" "];
                        //   NSLog(@"TestString is %@",TestString);
                        
                        // break;
                    }
                    //  NSLog(@"TempString is %@",TempString);
                }
            }
            
            
            
            [SendCaptionDataArray addObject:TestString];
        }
        
        NSString *GetPhotoCount = [[NSString alloc]initWithFormat:@"%lu",(unsigned long)[CaptionArray count]];
        NSLog(@"before GetPhotoCount is %@",GetPhotoCount);
        
        
        NSString *result = [GetPhotoIDArray componentsJoinedByString:@","];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
        [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
        [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
        [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
        [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
        [defaults setObject:result forKey:@"PublishV2_PhotoID"];
        [defaults setObject:PhotoPositionArray forKey:@"PublishV2_PhotoPosition"];
        [defaults setObject:GetPhotoCount forKey:@"CheckPhotoCount"];
        [defaults synchronize];
        
        
        
        
//        NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs_Data"]];
//        NSMutableArray *TempArray = [[NSMutableArray alloc]init];
//        SelectImageViewController *SelectImageView = [[SelectImageViewController alloc]init];
//        [self presentViewController:SelectImageView animated:YES completion:nil];
//        if ([GetUpdatePost isEqualToString:@"YES"]) {
//            NSLog(@"[SelectImageView GetBackSelectData:TempArray BackView:@Yes CheckDraft:@Yes];");
//             [SelectImageView GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"Yes"];
//        }else{
//            NSLog(@"[SelectImageView GetBackSelectData:TempArray BackView:@Yes CheckDraft:@No];");
//        [SelectImageView GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"No"];
//        }
        
        DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
        cont.delegate = self;
        cont.nResultType = DO_PICKER_RESULT_ASSET;//DO_PICKER_RESULT_UIIMAGE
        cont.nMaxCount = 10;
        cont.nColumnCount = 3;

        [self presentViewController:cont animated:YES completion:nil];
        if ([GetUpdatePost isEqualToString:@"YES"]) {
            //[cont GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"Yes"];
        }else{
         //   [cont GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"No"];
        }
    }


    

    
}
#pragma mark - DoImagePickerControllerDelegate
- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)CropButton:(id)sender{
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = ShowBigImage.image;
    
    UIImage *image = ShowBigImage.image;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
  //  self.imageView.image = croppedImage;
    
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, 1);
    NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
    [imageData writeToFile:imagePath atomically:YES];
    
    [GetImageArray replaceObjectAtIndex:SelctImgCount withObject:imagePath];
    
    
//    NSMutableArray *ImgArray_ = [[NSMutableArray alloc]init];
//    for (int i = 0; i < [GetImageArray count]; i++) {
//        UIImage *TempImg = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
//       // NSString *base64 = [self encodeToBase64String:TempImg];
//        NSData *imageData = UIImageJPEGRepresentation(TempImg, 1);
//        NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
//        [imageData writeToFile:imagePath atomically:YES];
//        [ImgArray_ addObject:TempImg];
//    }
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
    [defaults synchronize];
}
- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
-(IBAction)BrightnessButton:(id)sender{
    BrightnessViewController *CropView = [[BrightnessViewController alloc]init];
    [self presentViewController:CropView animated:YES completion:nil];
    [CropView GetImageData:GetImageArray GetSelectCount:SelctImgCount];
}
//-(IBAction)TellaStoryButton:(id)sender{
//    [SendCaptionDataArray removeAllObjects];
//    [TagStringArray removeAllObjects];
//    [TagStringDataArray removeAllObjects];
//    
//    for (int i = 0; i < [CaptionArray count]; i++) {
//        NSString *TestString;
//        NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
//        if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
//            TestString = @"";
//        }else{
//            NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
//          //  NSLog(@"stringArray is %@",stringArray);
//            NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
//            for (int i = 0; i < [stringArray count]; i++) {
//                NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
//                if ([TempString rangeOfString:@"@"].location == NSNotFound) {
//                //    NSLog(@"no ?");
//                    //  [SendCaptionDataArray addObject:TempString];
//                    //   NSLog(@"No Tag TempString is %@",TempString);
//                    
//                    if ([TempString rangeOfString:@"#"].location == NSNotFound) {
//                        TestString = [TestArray componentsJoinedByString:@" "];
//                    }else{
//                        TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
//                        // NSLog(@"after TempString is %@",TempString);
//                        [TagStringArray addObject:TempString];
//                        NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
//                        //   NSLog(@"TestAgain is %@",TestAgain);
//                        [TagStringDataArray addObject:TestAgain];
//                        [TestArray replaceObjectAtIndex:i withObject:TestAgain];
//                        //  NSLog(@"TestArray is %@",TestArray);
//                        TestString = [TestArray componentsJoinedByString:@" "];
//                     //   NSLog(@"TestString is %@",TestString);
//                    }
//                 //   NSLog(@"TestString is %@",TestString);
//                } else {
//                //    NSLog(@"with @ ?");
//                    // NSLog(@"Start TempString is %@",TempString);
//                    
//                    TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
//                    // NSLog(@"after TempString is %@",TempString);
//                    [TagStringArray addObject:TempString];
//                    NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
//                    //   NSLog(@"TestAgain is %@",TestAgain);
//                    [TagStringDataArray addObject:TestAgain];
//                    [TestArray replaceObjectAtIndex:i withObject:TestAgain];
//                    //  NSLog(@"TestArray is %@",TestArray);
//                    TestString = [TestArray componentsJoinedByString:@" "];
//                 //   NSLog(@"TestString is %@",TestString);
//                    
//                    // break;
//                }
//                //  NSLog(@"TempString is %@",TempString);
//            }
//        }
//        
//        
//        
//        [SendCaptionDataArray addObject:TestString];
//    }
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
//    [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
//    [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
//    [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
//    [defaults synchronize];
//    
//    TellaStoryViewController *TellaStoryView = [[TellaStoryViewController alloc]init];
//    [self presentViewController:TellaStoryView animated:YES completion:nil];
//    [TellaStoryView GetIsupdatePost:GetUpdatePost GetPostID:GetPostID];
//}
-(IBAction)DoneButton:(id)sender{
    [SendCaptionDataArray removeAllObjects];
    [TagStringArray removeAllObjects];
    [TagStringDataArray removeAllObjects];
    
    for (int i = 0; i < [CaptionArray count]; i++) {
        NSString *TestString;
        NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
        if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
            TestString = @"";
        }else{
            NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
            //  NSLog(@"stringArray is %@",stringArray);
            NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
            for (int i = 0; i < [stringArray count]; i++) {
                NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
                if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                    //    NSLog(@"no ?");
                    //  [SendCaptionDataArray addObject:TempString];
                    //   NSLog(@"No Tag TempString is %@",TempString);
                    
                    if ([TempString rangeOfString:@"#"].location == NSNotFound) {
                        TestString = [TestArray componentsJoinedByString:@" "];
                    }else{
                        TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        // NSLog(@"after TempString is %@",TempString);
                        [TagStringArray addObject:TempString];
                        NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                        //   NSLog(@"TestAgain is %@",TestAgain);
                        [TagStringDataArray addObject:TestAgain];
                        [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                        //  NSLog(@"TestArray is %@",TestArray);
                        TestString = [TestArray componentsJoinedByString:@" "];
                        //   NSLog(@"TestString is %@",TestString);
                    }
                    //   NSLog(@"TestString is %@",TestString);
                } else {
                    //    NSLog(@"with @ ?");
                    // NSLog(@"Start TempString is %@",TempString);
                    
                    TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    // NSLog(@"after TempString is %@",TempString);
                    [TagStringArray addObject:TempString];
                    NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                    //   NSLog(@"TestAgain is %@",TestAgain);
                    [TagStringDataArray addObject:TestAgain];
                    [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                    //  NSLog(@"TestArray is %@",TestArray);
                    TestString = [TestArray componentsJoinedByString:@" "];
                    //   NSLog(@"TestString is %@",TestString);
                    
                    // break;
                }
                //  NSLog(@"TempString is %@",TempString);
            }
        }
        
        
        
        [SendCaptionDataArray addObject:TestString];
    }
    
    NSString *result = [GetPhotoIDArray componentsJoinedByString:@","];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
    [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
    [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
    [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
    [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
    [defaults setObject:PhotoPositionArray forKey:@"PublishV2_PhotoPosition"];
    [defaults setObject:result forKey:@"PublishV2_PhotoID"];
    [defaults synchronize];
    
    NSLog(@"ShowImage SendCaptionDataArray is %@",SendCaptionDataArray);
    NSLog(@"ShowImage TagStringArray is %@",TagStringArray);
    NSLog(@"ShowImage TagStringDataArray is %@",TagStringDataArray);
    NSLog(@"ShowImage CaptionArray is %@",CaptionArray);

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)DeleteButton:(id)sender{
    NSLog(@"Delete Button Click.");
    
//    if ([GetUpdatePost isEqualToString:@"YES"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Sorry Draft Edit not support to delete photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag = 300;
//        [alert show];
//    }else{
//        NSLog(@"SelctImgCount === %li",(long)SelctImgCount);
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"DoYouWantDelete", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"Photo_No", nil) otherButtonTitles:CustomLocalisedString(@"Photo_Yes", nil), nil];
//        alert.tag = 999;
//        [alert show];
//        
//    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"DoYouWantDelete", nil) delegate:self cancelButtonTitle:CustomLocalisedString(@"Photo_No", nil) otherButtonTitles:CustomLocalisedString(@"Photo_Yes", nil), nil];
    alert.tag = 999;
    [alert show];
}
-(void)DeletePhoto{
    
    if ([GetUpdatePost isEqualToString:@"YES"]) {
        
        [DeletePhotoIDArray addObject:[GetPhotoIDArray objectAtIndex:SelctImgCount]];
        
        NSLog(@"Add DeletePhotoIDArray is %@",DeletePhotoIDArray);
        
        NSLog(@"GetImageArray is %@",GetImageArray);
        NSLog(@"CaptionArray is %@",CaptionArray);
        NSLog(@"GetImageDataArray is %@",GetImageDataArray);
        
        NSLog(@"SendCaptionDataArray is %@",SendCaptionDataArray);
        NSLog(@"TagStringArray is %@",TagStringArray);
        NSLog(@"TagStringDataArray is %@",TagStringDataArray);
        
        [GetImageArray removeObjectAtIndex:SelctImgCount];
        [CaptionArray removeObjectAtIndex:SelctImgCount];
        [GetPhotoIDArray removeObjectAtIndex:SelctImgCount];
       // [GetImageDataArray removeObjectAtIndex:SelctImgCount];
        
        [SendCaptionDataArray removeAllObjects];
        [TagStringArray removeAllObjects];
        [TagStringDataArray removeAllObjects];
        
        NSLog(@"Delete CaptionArray is %@",CaptionArray);
        
        if (![GetImageArray count]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs_Data"]];
            
            SelectImageViewController *SelectImageView = [[SelectImageViewController alloc]init];
            [self presentViewController:SelectImageView animated:YES completion:nil];
            if ([GetUpdatePost isEqualToString:@"YES"]) {
                [SelectImageView GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"Yes"];
            }else{
                [SelectImageView GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"No"];
            }
        }else{
            
            for (int i = 0; i < [CaptionArray count]; i++) {
                NSString *TestString;
                NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
                if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
                    TestString = @"";
                }else{
                    NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
                    //  NSLog(@"stringArray is %@",stringArray);
                    NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
                    for (int i = 0; i < [stringArray count]; i++) {
                        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
                        if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                            //    NSLog(@"no ?");
                            //  [SendCaptionDataArray addObject:TempString];
                            //   NSLog(@"No Tag TempString is %@",TempString);
                            
                            if ([TempString rangeOfString:@"#"].location == NSNotFound) {
                                TestString = [TestArray componentsJoinedByString:@" "];
                            }else{
                                TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
                                // NSLog(@"after TempString is %@",TempString);
                                [TagStringArray addObject:TempString];
                                NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                                //   NSLog(@"TestAgain is %@",TestAgain);
                                [TagStringDataArray addObject:TestAgain];
                                [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                                //  NSLog(@"TestArray is %@",TestArray);
                                TestString = [TestArray componentsJoinedByString:@" "];
                                //   NSLog(@"TestString is %@",TestString);
                            }
                            //   NSLog(@"TestString is %@",TestString);
                        } else {
                            //    NSLog(@"with @ ?");
                            // NSLog(@"Start TempString is %@",TempString);
                            
                            TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
                            // NSLog(@"after TempString is %@",TempString);
                            [TagStringArray addObject:TempString];
                            NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                            //   NSLog(@"TestAgain is %@",TestAgain);
                            [TagStringDataArray addObject:TestAgain];
                            [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                            //  NSLog(@"TestArray is %@",TestArray);
                            TestString = [TestArray componentsJoinedByString:@" "];
                            //   NSLog(@"TestString is %@",TestString);
                            
                            // break;
                        }
                        //  NSLog(@"TempString is %@",TempString);
                    }
                }
                
                
                
                [SendCaptionDataArray addObject:TestString];
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
            
//            NSMutableDictionary *sortedDictionary = [[NSMutableDictionary alloc] init];
//            for (NSString *key in GetImageDataArray){
//                [sortedDictionary setObject:TempDictonary[key] forKey:key];
//            }
//            NSLog(@"sortedDictionary is %@",sortedDictionary);
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sortedDictionary];
            
            NSString *result = [GetPhotoIDArray componentsJoinedByString:@","];
            NSString *Deleteresult = [DeletePhotoIDArray componentsJoinedByString:@","];
            [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
           // [defaults setObject:data forKey:@"selectedIndexArr_Thumbs_Data"];
            [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
            [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
            [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
            [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
            [defaults setObject:PhotoPositionArray forKey:@"PublishV2_PhotoPosition"];
            [defaults setObject:result forKey:@"PublishV2_PhotoID"];
            [defaults setObject:Deleteresult forKey:@"PublishV2_PhotoID_Delete"];
            [defaults synchronize];
            
            [self InitView2];
            
        }
    }else{
        [GetImageArray removeObjectAtIndex:SelctImgCount];
        [CaptionArray removeObjectAtIndex:SelctImgCount];
        [GetImageDataArray removeObjectAtIndex:SelctImgCount];
        
        [SendCaptionDataArray removeAllObjects];
        [TagStringArray removeAllObjects];
        [TagStringDataArray removeAllObjects];
        
        NSLog(@"Delete CaptionArray is %@",CaptionArray);
        
        if (![GetImageArray count]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs_Data"]];
            
            SelectImageViewController *SelectImageView = [[SelectImageViewController alloc]init];
            [self presentViewController:SelectImageView animated:YES completion:nil];
            if ([GetUpdatePost isEqualToString:@"YES"]) {
                [SelectImageView GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"Yes"];
            }else{
                [SelectImageView GetBackSelectData:TempArray BackView:@"Yes" CheckDraft:@"No"];
            }
        }else{
            
            for (int i = 0; i < [CaptionArray count]; i++) {
                NSString *TestString;
                NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
                if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
                    TestString = @"";
                }else{
                    NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
                    //  NSLog(@"stringArray is %@",stringArray);
                    NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
                    for (int i = 0; i < [stringArray count]; i++) {
                        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
                        if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                            //    NSLog(@"no ?");
                            //  [SendCaptionDataArray addObject:TempString];
                            //   NSLog(@"No Tag TempString is %@",TempString);
                            
                            if ([TempString rangeOfString:@"#"].location == NSNotFound) {
                                TestString = [TestArray componentsJoinedByString:@" "];
                            }else{
                                TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
                                // NSLog(@"after TempString is %@",TempString);
                                [TagStringArray addObject:TempString];
                                NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                                //   NSLog(@"TestAgain is %@",TestAgain);
                                [TagStringDataArray addObject:TestAgain];
                                [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                                //  NSLog(@"TestArray is %@",TestArray);
                                TestString = [TestArray componentsJoinedByString:@" "];
                                //   NSLog(@"TestString is %@",TestString);
                            }
                            //   NSLog(@"TestString is %@",TestString);
                        } else {
                            //    NSLog(@"with @ ?");
                            // NSLog(@"Start TempString is %@",TempString);
                            
                            TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
                            // NSLog(@"after TempString is %@",TempString);
                            [TagStringArray addObject:TempString];
                            NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                            //   NSLog(@"TestAgain is %@",TestAgain);
                            [TagStringDataArray addObject:TestAgain];
                            [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                            //  NSLog(@"TestArray is %@",TestArray);
                            TestString = [TestArray componentsJoinedByString:@" "];
                            //   NSLog(@"TestString is %@",TestString);
                            
                            // break;
                        }
                        //  NSLog(@"TempString is %@",TempString);
                    }
                }
                
                
                
                [SendCaptionDataArray addObject:TestString];
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //        NSMutableArray *ImgArray_ = [[NSMutableArray alloc]init];
            //        for (int i = 0; i < [GetImageArray count]; i++) {
            //            UIImage *TempImg = [UIImage imageWithData:[NSData dataWithContentsOfFile:[GetImageArray objectAtIndex:i]]];
            //           // NSString *base64 = [self encodeToBase64String:TempImg];
            //
            //            NSData *imageData = UIImageJPEGRepresentation(TempImg, 1);
            //            NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
            //            [imageData writeToFile:imagePath atomically:YES];
            //            [ImgArray_ addObject:imagePath];
            //        }
            [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
            
            NSMutableDictionary *sortedDictionary = [[NSMutableDictionary alloc] init];
            for (NSString *key in GetImageDataArray){
                [sortedDictionary setObject:TempDictonary[key] forKey:key];
            }
            NSLog(@"sortedDictionary is %@",sortedDictionary);
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sortedDictionary];
            
            NSString *result = [GetPhotoIDArray componentsJoinedByString:@","];
            [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
            [defaults setObject:data forKey:@"selectedIndexArr_Thumbs_Data"];
            [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
            [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
            [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
            [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
            [defaults setObject:PhotoPositionArray forKey:@"PublishV2_PhotoPosition"];
            [defaults setObject:result forKey:@"PublishV2_PhotoID"];
            [defaults synchronize];
            
            [self InitView2];
            
        }
    }
    
    
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500) {//delete action
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else if(buttonIndex == 1){
            NSLog(@"save draft click");
        }else{
            NSLog(@"confirm delete post");
        }
    }
    if (alertView.tag == 300) {//handle error
        
    }
    if (alertView.tag == 999) {//handle error
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else if(buttonIndex == 1){
            NSLog(@"Delete Photo Click");
            [self DeletePhoto];
        }
    }
    if (alertView.tag == 600) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetPhotoCount = [[NSString alloc]initWithFormat:@"%@",[defaults valueForKey:@"CheckPhotoCount"]];
            NSLog(@"Check Back GetPhotoCount is %@",GetPhotoCount);
            if ([GetPhotoCount length] == 0 || [GetPhotoCount isEqualToString:@"(null)"]) {
                NSLog(@"in herer??????");
            }else{
                NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
                NSLog(@"TempArray count is %lu",(unsigned long)[TempArray count]);
                int PhotoCountData = [GetPhotoCount intValue];
                if (PhotoCountData == [TempArray count]) {
                    NSLog(@"same data");
                }else{
                    NSLog(@"do delete photo");
                    NSMutableArray *TempArray2 = [[NSMutableArray alloc]init];
                    for (int i = 0; i < PhotoCountData; i++) {
                        [TempArray2 addObject:[TempArray objectAtIndex:i]];
                    }
                    
                    [defaults setObject:TempArray2 forKey:@"selectedIndexArr_Thumbs"];// image data
                    [defaults synchronize];
                }

            }

            [self dismissViewControllerAnimated:YES completion:nil];
        }else if(buttonIndex == 1){
            NSLog(@"OK click");
            [SendCaptionDataArray removeAllObjects];
            [TagStringArray removeAllObjects];
            [TagStringDataArray removeAllObjects];
            
            for (int i = 0; i < [CaptionArray count]; i++) {
                NSString *TestString;
                NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
                if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
                    TestString = @"";
                }else{
                    NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
                    //  NSLog(@"stringArray is %@",stringArray);
                    NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
                    for (int i = 0; i < [stringArray count]; i++) {
                        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
                        if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                            //    NSLog(@"no ?");
                            //  [SendCaptionDataArray addObject:TempString];
                            //   NSLog(@"No Tag TempString is %@",TempString);
                            
                            if ([TempString rangeOfString:@"#"].location == NSNotFound) {
                                TestString = [TestArray componentsJoinedByString:@" "];
                            }else{
                                TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
                                // NSLog(@"after TempString is %@",TempString);
                                [TagStringArray addObject:TempString];
                                NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                                //   NSLog(@"TestAgain is %@",TestAgain);
                                [TagStringDataArray addObject:TestAgain];
                                [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                                //  NSLog(@"TestArray is %@",TestArray);
                                TestString = [TestArray componentsJoinedByString:@" "];
                                //   NSLog(@"TestString is %@",TestString);
                            }
                            //   NSLog(@"TestString is %@",TestString);
                        } else {
                            //    NSLog(@"with @ ?");
                            // NSLog(@"Start TempString is %@",TempString);
                            
                            TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
                            // NSLog(@"after TempString is %@",TempString);
                            [TagStringArray addObject:TempString];
                            NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                            //   NSLog(@"TestAgain is %@",TestAgain);
                            [TagStringDataArray addObject:TestAgain];
                            [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                            //  NSLog(@"TestArray is %@",TestArray);
                            TestString = [TestArray componentsJoinedByString:@" "];
                            //   NSLog(@"TestString is %@",TestString);
                            
                            // break;
                        }
                        //  NSLog(@"TempString is %@",TempString);
                    }
                }
                
                
                
                [SendCaptionDataArray addObject:TestString];
            }
            
            NSString *result = [GetPhotoIDArray componentsJoinedByString:@","];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
            [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
            [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
            [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
            [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
            [defaults setObject:result forKey:@"PublishV2_PhotoID"];
            [defaults setObject:PhotoPositionArray forKey:@"PublishV2_PhotoPosition"];
            [defaults synchronize];
            
            NSLog(@"ShowImage SendCaptionDataArray is %@",SendCaptionDataArray);
            NSLog(@"ShowImage TagStringArray is %@",TagStringArray);
            NSLog(@"ShowImage TagStringDataArray is %@",TagStringDataArray);
            NSLog(@"ShowImage CaptionArray is %@",CaptionArray);
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}
-(IBAction)EditButton:(id)sender{
    
    [SendCaptionDataArray removeAllObjects];
    [TagStringArray removeAllObjects];
    [TagStringDataArray removeAllObjects];
    
    for (int i = 0; i < [CaptionArray count]; i++) {
        NSString *TestString;
        NSString *GetString = [[NSString alloc]initWithFormat:@"%@",[CaptionArray objectAtIndex:i]];
        if ([GetString isEqualToString:CustomLocalisedString(@"Writeacaptionhere", nil)]) {
            TestString = @"";
        }else{
            NSArray *stringArray = [GetString componentsSeparatedByString:@" "];
            //  NSLog(@"stringArray is %@",stringArray);
            NSMutableArray *TestArray = [[NSMutableArray alloc]initWithArray:stringArray];
            for (int i = 0; i < [stringArray count]; i++) {
                NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[stringArray objectAtIndex:i]];
                if ([TempString rangeOfString:@"@"].location == NSNotFound) {
                    //    NSLog(@"no ?");
                    //  [SendCaptionDataArray addObject:TempString];
                    //   NSLog(@"No Tag TempString is %@",TempString);
                    
                    if ([TempString rangeOfString:@"#"].location == NSNotFound) {
                        TestString = [TestArray componentsJoinedByString:@" "];
                    }else{
                        TempString = [TempString stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        // NSLog(@"after TempString is %@",TempString);
                        [TagStringArray addObject:TempString];
                        NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                        //   NSLog(@"TestAgain is %@",TestAgain);
                        [TagStringDataArray addObject:TestAgain];
                        [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                        //  NSLog(@"TestArray is %@",TestArray);
                        TestString = [TestArray componentsJoinedByString:@" "];
                        //   NSLog(@"TestString is %@",TestString);
                    }
                    //   NSLog(@"TestString is %@",TestString);
                } else {
                    //    NSLog(@"with @ ?");
                    // NSLog(@"Start TempString is %@",TempString);
                    
                    TempString = [TempString stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    // NSLog(@"after TempString is %@",TempString);
                    [TagStringArray addObject:TempString];
                    NSString *TestAgain = [[NSString alloc]initWithFormat:@"#[tag:%@]",TempString];
                    //   NSLog(@"TestAgain is %@",TestAgain);
                    [TagStringDataArray addObject:TestAgain];
                    [TestArray replaceObjectAtIndex:i withObject:TestAgain];
                    //  NSLog(@"TestArray is %@",TestArray);
                    TestString = [TestArray componentsJoinedByString:@" "];
                    //   NSLog(@"TestString is %@",TestString);
                    
                    // break;
                }
                //  NSLog(@"TempString is %@",TempString);
            }
        }
        
        
        
        [SendCaptionDataArray addObject:TestString];
    }
    
    NSString *result = [GetPhotoIDArray componentsJoinedByString:@","];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetImageArray forKey:@"selectedIndexArr_Thumbs"];
    [defaults setObject:SendCaptionDataArray forKey:@"PublishV2_CaptionDataArray"];
    [defaults setObject:TagStringArray forKey:@"PublishV2_TagStringArray"];
    [defaults setObject:TagStringDataArray forKey:@"PublishV2_TagStringDataArray"];
    [defaults setObject:CaptionArray forKey:@"PublishV2_CaptionArray"];
    [defaults setObject:PhotoPositionArray forKey:@"PublishV2_PhotoPosition"];
    [defaults setObject:result forKey:@"PublishV2_PhotoID"];
    [defaults synchronize];
    
}

-(IBAction)OKButton:(id)sender{
    ShowMessageArrangeView.hidden = YES;
    ArrangeBackgroundImg.hidden = YES;
    
    NSString *GetCheckDone = @"Done";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetCheckDone forKey:@"ArragenMessageCheck"];
    [defaults synchronize];
}
@end
