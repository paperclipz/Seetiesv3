//
//  SelectImageViewController.m
//  PhotoDemo
//
//  Created by Seeties IOS on 3/19/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import "SelectImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

#import "ShowImageViewController.h"
#import "WhereIsThisViewController.h"

#import "LanguageManager.h"
#import "Locale.h"
@interface SelectImageViewController ()
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@end

@implementation SelectImageViewController
-(id)init{
    self = [super init];
    if (self) {
        
        thumbsArr = [[NSMutableArray alloc] init];
        FullArr = [[NSMutableArray alloc] init];
        urlArray = [[NSMutableArray alloc] init];
        LocationArray = [[NSMutableArray alloc] init];
        DateArray = [[NSMutableArray alloc] init];
        selectedIndexArr_Thumbs = [[NSMutableArray alloc] init];
        selectedIndexArr_Location = [[NSMutableArray alloc] init];
        selectedIndexArr_Date = [[NSMutableArray alloc] init];
        
        //  [thumbsArr addObject:@"DefaultProfilePic.png"];
        //  [FullArr addObject:@"DefaultProfilePic.png"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ChoosePhotoText.text = CustomLocalisedString(@"Chooseuptp10photo", nil);
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    AlbumView.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    AlbumView.hidden = YES;
    AlbumBackImg.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    AlbumWhiteBack.frame = CGRectMake((screenWidth/2) - 160, 8, 320, 264);
    AlbumTblView.frame = CGRectMake((screenWidth/2) - 160, 22, 320, 245);
    [self.view addSubview:AlbumView];
    
    MainScroll.delegate = self;
    [MainScroll setScrollEnabled:YES];
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    
    ShowChooseUpText.frame = CGRectMake(0, -28, screenWidth, 28);
    
    DoneText.frame = CGRectMake(screenWidth - 64, 20, 64, 44);
    DoneButton.frame = CGRectMake(screenWidth - 64, 0, 64, 64);
    SelectAlbumButton.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ArrowImg.frame = CGRectMake((screenWidth/2) + 60, 38, 13, 8);
    
    //  PhotoCount = 3;
    CheckDone = NO;
    
    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    spinnerView.lineWidth = 1.0f;
    [self.view addSubview:spinnerView];
    [spinnerView startAnimating];
    dispatch_async (dispatch_get_main_queue(), ^{
        
        [self InitAlbumData];
    });
    //[NSThread detachNewThreadSelector:@selector(InitAlbumData) toTarget:self withObject:nil];
    // [self InitPhotoData];
    
}
-(void)GetBackSelectData:(NSMutableArray *)SelectedIndexArr BackView:(NSString *)CheckView CheckDraft:(NSString *)DraftCheck{
    
    CheckViewData = CheckView;
    CheckDraft = DraftCheck;
    if ([CheckDraft isEqualToString:@"Yes"]) {
        selectedIndexArr_Thumbs = [[NSMutableArray alloc]init];
    }else{
        selectedIndexArr_Thumbs = [[NSMutableArray alloc]initWithArray:SelectedIndexArr];
    }
    // NSLog(@"selectedIndexArr_Thumbs is %@",selectedIndexArr_Thumbs);
    // NSLog(@"CheckViewData is %@",CheckViewData);
}
-(void)viewDidAppear:(BOOL)animated
{
    self.screenName = @"IOS Select Photo View V2";
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)InitAlbumData{
    // [ShowActivity startAnimating];
    // NSLog(@"InitAlbumData");
    if (self.assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (self.groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        //        AssetsDataIsInaccessibleViewController *assetsDataInaccessibleViewController =
        //        [self.storyboard instantiateViewControllerWithIdentifier:@"inaccessibleViewController"];
        //
        //        NSString *errorMessage = nil;
        //        switch ([error code]) {
        //            case ALAssetsLibraryAccessUserDeniedError:
        //            case ALAssetsLibraryAccessGloballyDeniedError:
        //                errorMessage = @"The user has declined access to it.";
        //                break;
        //            default:
        //                errorMessage = @"Reason unknown.";
        //                break;
        //        }
        //
        //        assetsDataInaccessibleViewController.explanation = errorMessage;
        //        [self presentViewController:assetsDataInaccessibleViewController animated:NO completion:nil];
    };
    
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            [self.groups addObject:group];
        }
        else
        {
            // [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [AlbumTblView reloadData];
            //NSLog(@"self.groups is %@",self.groups);
            //  NSLog(@"self.assetsLibrary is %@",self.assetsLibrary);
            self.assetsGroup = [self.groups lastObject];
            [self InitPhotoData];
        }
    };
    
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAssetChangedNotifiation:) name:ALAssetsLibraryChangedNotification object:self.assetsLibrary];
    //    NSLog(@"self.groups is %@",self.groups);
    //    NSLog(@"self.assetsLibrary is %@",self.assetsLibrary);
    
    //  self.assets = self.groups[0];
    
    
    
    //  [self InitPhotoData];
}
- (void) handleAssetChangedNotifiation:(NSNotification *)notification
{
    NSLog(@"notification: %@", notification);
}
-(void)InitPhotoData{
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
            
            ALAssetRepresentation *representation = [result defaultRepresentation];
            UIImage *latestPhotoThumbnail = [UIImage imageWithCGImage:[result thumbnail]];
            //  UIImage *FullPhoto = [UIImage imageWithCGImage:[representation fullResolutionImage]];
            CLLocation *location = [result valueForProperty:ALAssetPropertyLocation];
            NSDate *date = [result valueForProperty:ALAssetPropertyDate];
            
            if (location == nil) {
                [LocationArray addObject:@"nil"];
            }else{
                [LocationArray addObject:location];
            }
            
            [urlArray addObject:representation.url];
            NSData* data = UIImagePNGRepresentation(latestPhotoThumbnail);
            [thumbsArr addObject:data];
            //   NSData* data1 = UIImagePNGRepresentation(FullPhoto);
            //   [FullArr addObject:data1];
            
            [DateArray addObject:date];
            
            
            representation = nil;
            latestPhotoThumbnail = nil;
            // NSLog(@"thumbsArr is %@",thumbsArr);
            
        }
        // [self InitView];
    };
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    //    [thumbsArr addObject:@"DefaultProfilePic.png"];
    NSArray* reversedArray = [[self.assets reverseObjectEnumerator] allObjects];
    self.assets = nil;
    self.assets = [[NSMutableArray alloc]initWithArray:reversedArray];
    
    // thumbsArr = [[NSMutableArray alloc]initWithArray:reversedArray];
    //  [self InitView];
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    [self InitView];
   // [NSThread detachNewThreadSelector:@selector(InitView) toTarget:self withObject:nil];
}
-(void)InitView{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        int TestWidth = screenWidth - 12;
        //    NSLog(@"TestWidth is %i",TestWidth);
        int FinalWidth = TestWidth / 3;
        //    NSLog(@"FinalWidth is %i",FinalWidth);
        int SpaceWidth = FinalWidth + 3;
        
        NSLog(@"PhotoCount is %ld",(long)PhotoCount);
        NSLog(@"[self.assets count] is %lu",(unsigned long)[self.assets count]);
        
        PhotoCount += 20;
        if ([self.assets count]  < PhotoCount) {
            PhotoCount = [self.assets count];
            CheckDone = YES;
        }else{
            // PhotoCount += 3;
        }
        
        NSInteger tempcountdata;
        if (PhotoCount <= 20) {
            tempcountdata = 0;
        }else{
            tempcountdata = PhotoCount - 20;
        }
        NSLog(@"tempcountdata is %ld",(long)tempcountdata);
        //    for (UIView *subview in MainScroll.subviews) {
        //        [subview removeFromSuperview];
        //    }
        // NSLog(@"3 [thumbsArr count] is %lu",(unsigned long)[thumbsArr count]);
        for (NSInteger i = tempcountdata; i < PhotoCount; i++) {
            ALAsset *asset = self.assets[i];
            CGImageRef thumbnailImageRef = [asset thumbnail];
            UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
            
            AsyncImageView *ShowImage = [[AsyncImageView alloc]init];
            ShowImage.frame = CGRectMake(3 +((i + 1) % 3)* SpaceWidth, 5 + (SpaceWidth * (CGFloat)((i + 1) /3)), FinalWidth, FinalWidth);
            ShowImage.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
            //   if (i == 0) {
            //      ShowImage.image = [UIImage imageNamed:[thumbsArr objectAtIndex:i]];
            //   }else{
            // NSData *data = [thumbsArr objectAtIndex:i];
            ShowImage.image = thumbnail;
            //  }
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowImage];
            
            
            SelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
            SelectButton.frame = CGRectMake(3 +((i + 1) % 3)* SpaceWidth, 5 + (SpaceWidth * (CGFloat)((i + 1) /3)), FinalWidth, FinalWidth);
            SelectButton.tag = i;
            [SelectButton setTitle:@"" forState:UIControlStateNormal];
            //   [SelectButton setImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
            [SelectButton setBackgroundImage:[UIImage imageNamed:@"SelectPhotoFrame.png"] forState:UIControlStateSelected];
            [SelectButton setBackgroundColor:[UIColor clearColor]];
            [SelectButton addTarget:self action:@selector(SelectImgClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([CheckViewData isEqualToString:@"Yes"]) {
                CountSelectImg = 0;
                for (int i = 0; i < [selectedIndexArr_Thumbs count]; i++) {
                    CountSelectImg++;
                    NSString *TempIDN = [[NSString alloc]initWithFormat:@"%@",[selectedIndexArr_Thumbs objectAtIndex:i]];
                    //  NSLog(@"TempIDN is %@",TempIDN);
                    //   NSLog(@"1 SelectButton.tag is %ld",(long)SelectButton.tag);
                    if ([SelectButton viewWithTag:[TempIDN intValue]]) {
                        //       NSLog(@"2 SelectButton.tag is %ld",(long)SelectButton.tag);
                        SelectButton.selected = YES;
                        NSString *TempString = [[NSString alloc]initWithFormat:@"%li",CountSelectImg];
                        [SelectButton setTitle:TempString forState:UIControlStateNormal];
                    }else{
                        //        NSLog(@"3 SelectButton.tag is %ld",(long)SelectButton.tag);
                    }
                    // SelectButton.selected = YES;
                }
            }else{
                CountSelectImg = 0;
            }
            
            [MainScroll addSubview:ShowImage];
            [MainScroll addSubview:SelectButton];
            
            //[MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
            [MainScroll setContentSize:CGSizeMake(screenWidth, SpaceWidth + (SpaceWidth * (CGFloat)((i + 1) /3)) + 5)];
        }
        UIButton *SelectButton_ = [UIButton buttonWithType:UIButtonTypeCustom];
        SelectButton_.frame = CGRectMake(3, 5, FinalWidth, FinalWidth);
        [SelectButton_ setTitle:@"" forState:UIControlStateNormal];
        [SelectButton_ setBackgroundColor:[UIColor blackColor]];
        [SelectButton_ setBackgroundImage:[UIImage imageNamed:@"TakePhoto.png"] forState:UIControlStateNormal];
        [SelectButton_ addTarget:self action:@selector(OpenCameraButton:) forControlEvents:UIControlEventTouchUpInside];
        SelectButton_.contentMode = UIViewContentModeScaleToFill;
        [MainScroll addSubview:SelectButton_];
        
        [MainScroll addSubview:ShowChooseUpText];
        
        // ShowLoadingText.hidden = YES;
        [spinnerView stopAnimating];
        [spinnerView removeFromSuperview];
    });
    
}
-(IBAction)OpenCameraButton:(id)sender{
    // NSLog(@"Open Camera");
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
-(IBAction)SelectImgClick:(id)sender{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    // NSLog(@"button %li",(long)getbuttonIDN);
    
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         //  ShowChooseUpText.hidden = NO;
         ShowChooseUpText.frame = CGRectMake(0, 0, screenWidth, 28);
     }completion:^(BOOL finished){}];
    
    
    
    UIButton *buttonWithTag1 = (UIButton *)[sender viewWithTag:getbuttonIDN];
    buttonWithTag1.selected = !buttonWithTag1.selected;
    
    if (buttonWithTag1.selected) {
        if ([selectedIndexArr_Thumbs count] >= 10) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CustomLocalisedString(@"LimitExceed", nil) message:CustomLocalisedString(@"MaximumPhoto", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            buttonWithTag1.selected = NO;
        }else{
            CountSelectImg++;
            //   [buttonWithTag1 setBackgroundColor:[UIColor redColor]];
            NSString *TempString = [[NSString alloc]initWithFormat:@"%li",CountSelectImg];
            NSString *TempIDN = [[NSString alloc]initWithFormat:@"%li",getbuttonIDN];
            [buttonWithTag1 setTitle:TempString forState:UIControlStateNormal];
            [selectedIndexArr_Thumbs addObject:TempIDN];
            //        [selectedIndexArr_Location addObject:[LocationArray objectAtIndex:getbuttonIDN]];
            //        [selectedIndexArr_Date addObject:[DateArray objectAtIndex:getbuttonIDN]];
        }
        
    }else{
        CountSelectImg--;
        //   NSString *TempString = [[NSString alloc]initWithFormat:@"%li",CountSelectImg];
        [buttonWithTag1 setTitle:@"" forState:UIControlStateNormal];
        //  [buttonWithTag1 setBackgroundColor:[UIColor clearColor]];
        NSString *TempIDN = [[NSString alloc]initWithFormat:@"%li",getbuttonIDN];
        [selectedIndexArr_Thumbs removeObject:TempIDN];
        //        [selectedIndexArr_Location removeObject:[LocationArray objectAtIndex:getbuttonIDN]];
        //        [selectedIndexArr_Date removeObject:[DateArray objectAtIndex:getbuttonIDN]];
        
        if ([selectedIndexArr_Thumbs count] == 0) {
            
            [UIView animateWithDuration:0.2 animations:
             ^(void){
                 ShowChooseUpText.frame = CGRectMake(0, -28, screenWidth, 28);
             }completion:^(BOOL finished){}];
        }
    }
    //   }
    
    
    
    
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)DoneButton:(id)sender{
    //    NSLog(@"selectedIndexArr_Thumbs is %@",selectedIndexArr_Thumbs);
    //    NSLog(@"selectedIndexArr_Location is %@",selectedIndexArr_Location);
    //    NSLog(@"selectedIndexArr_Date is %@",selectedIndexArr_Date);
    
    if ([selectedIndexArr_Thumbs count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SelectPhoto", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([CheckDraft isEqualToString:@"Yes"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
            for (int i = 0; i < [selectedIndexArr_Thumbs count]; i++) {
                
                NSString *TempIdn = [[NSString alloc]initWithFormat:@"%@",[selectedIndexArr_Thumbs objectAtIndex:i]];
                //  NSLog(@"TempIdn is %@",TempIdn);
                int x = [TempIdn intValue];
                //  NSLog(@"x is %i",x);
                ALAsset *photoAsset = self.assets[x];
                //  NSLog(@"photoAsset is %@",photoAsset);
                ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
                UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
                //        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                //                                                       scale:[assetRepresentation scale]dd
                //                                                 orientation:ALAssetOrientationUp];
                
                
                
                //     UIImage *TempImg = [UIImage imageWithData:[selectedIndexArr_Thumbs objectAtIndex:i]];
                //NSString *base64 = [self encodeToBase64String:fullScreenImage];
                //[TempArray addObject:base64];
                 [TempArray addObject:fullScreenImage];
            }
            
            //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:TempArray forKey:@"selectedIndexArr_Thumbs"];// image data
            [defaults setObject:selectedIndexArr_Thumbs forKey:@"selectedIndexArr_Thumbs_Data"];// select data
            [defaults synchronize];
            
        }else{
            // [self GetSelectedImage];
            [NSThread detachNewThreadSelector:@selector(GetSelectedImage) toTarget:self withObject:nil];
        }
        
        
        
        
        
        if ([CheckViewData isEqualToString:@"Yes"]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            WhereIsThisViewController *ShowImageView = [[WhereIsThisViewController alloc]init];
            [self presentViewController:ShowImageView animated:YES completion:nil];
            // [ShowImageView GetImageData:selectedIndexArr_Thumbs];
        }
        
    }
    
}
-(void)GetSelectedImage{
    NSMutableArray *ImgArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [selectedIndexArr_Thumbs count]; i++) {
        
        NSString *TempIdn = [[NSString alloc]initWithFormat:@"%@",[selectedIndexArr_Thumbs objectAtIndex:i]];
        //  NSLog(@"TempIdn is %@",TempIdn);
        int x = [TempIdn intValue];
        //   NSLog(@"x is %i",x);
        ALAsset *photoAsset = self.assets[x];
        //  NSLog(@"photoAsset is %@",photoAsset);
        ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
        //        UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
        //                                                       scale:[assetRepresentation scale]dd
        //                                                 orientation:ALAssetOrientationUp];
        
        
        
        //     UIImage *TempImg = [UIImage imageWithData:[selectedIndexArr_Thumbs objectAtIndex:i]];
        NSString *base64 = [self encodeToBase64String:fullScreenImage];
        [ImgArray addObject:base64];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ImgArray forKey:@"selectedIndexArr_Thumbs"];// image data
    [defaults setObject:selectedIndexArr_Thumbs forKey:@"selectedIndexArr_Thumbs_Data"];// select data
    [defaults synchronize];
}
-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    //  UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling
        } else {
            // TODO: success handling
            [self InitPhotoData];
        }
    }];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
-(IBAction)SelectAlbumButton:(id)sender{
    AlbumView.hidden = NO;
}




#pragma mark - UITableViewDataSource

// determine the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groups.count;
}

// determine the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake(20, 14, 72, 72);
        ShowImage.tag = 100;
        [cell addSubview:ShowImage];
        
        UILabel *ShowTitle = [[UILabel alloc]init];
        ShowTitle.frame = CGRectMake(116, 24, 200, 40);
        ShowTitle.tag = 200;
        ShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        ShowTitle.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        // ShowTitle.backgroundColor = [UIColor redColor];
        [cell addSubview:ShowTitle];
        
        UILabel *ShowCountTitle = [[UILabel alloc]init];
        ShowCountTitle.frame = CGRectMake(116, 49, 200, 40);
        ShowCountTitle.tag = 300;
        ShowCountTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        ShowCountTitle.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        //ShowCountTitle.backgroundColor = [UIColor yellowColor];
        [cell addSubview:ShowCountTitle];
    }
    
    //    static NSString *CellIdentifier = @"Cell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    ALAssetsGroup *groupForCell = self.groups[indexPath.row];
    CGImageRef posterImageRef = [groupForCell posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    
    UIImageView *ShowImage = (UIImageView *)[cell viewWithTag:100];
    ShowImage.image = posterImage;
    
    UILabel *ShowTitle = (UILabel *)[cell viewWithTag:200];
    ShowTitle.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    
    NSString *TempString = [[NSString alloc]initWithFormat:@"%@ photos",[@(groupForCell.numberOfAssets) stringValue]];
    
    UILabel *ShowCountTitle = (UILabel *)[cell viewWithTag:300];
    ShowCountTitle.text = TempString;
    //  cell.imageView.image = posterImage;
    //    cell.textLabel.text = [groupForCell valueForProperty:ALAssetsGroupPropertyName];
    //    cell.detailTextLabel.text = [@(groupForCell.numberOfAssets) stringValue];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //  NSLog(@"Click...");
    self.assetsGroup = nil;
    [self.assets removeAllObjects];
    [thumbsArr removeAllObjects];
    [FullArr removeAllObjects];
    [urlArray removeAllObjects];
    [LocationArray removeAllObjects];
    [DateArray removeAllObjects];
    [selectedIndexArr_Thumbs removeAllObjects];
    [selectedIndexArr_Location removeAllObjects];
    [selectedIndexArr_Date removeAllObjects];
    PhotoCount = 0;
    
    self.assetsGroup = self.groups[indexPath.row];
    NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    [SelectAlbumButton setTitle:TempString forState:UIControlStateNormal];
    [self InitPhotoData];
    AlbumView.hidden = YES;
    
}
-(IBAction)CloseAlbumButton:(id)sender{
    AlbumView.hidden = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height)
    {
        // we are at the end
        NSLog(@"we are at the end");
        
        if (CheckDone == NO) {
            [self InitView];
        }else{
            
        }
        
    }
    
}
@end
