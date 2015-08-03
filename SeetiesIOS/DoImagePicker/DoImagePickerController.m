//
//  DoImagePickerController.m
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//

#import "DoImagePickerController.h"
#import "AssetHelper.h"
#import "WhereIsThisViewController.h"
#import "DoAlbumCell.h"
#import "DoPhotoCell.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@implementation DoImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    NSLog(@"come here init ????");
    [super viewDidLoad];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
   
    ShowSelectText.frame = CGRectMake(0, -64, screenWidth, 28);
    ShowSelectText.hidden = YES;
    ShowChooseUpText.frame = CGRectMake(0, 0, screenWidth, 28);
    _lbSelectCount.frame = CGRectMake(screenWidth - 50 - 15, 0, 50, 28);
    //ShowChooseUpText.backgroundColor = [UIColor redColor];
    ShowChooseUpText.text = CustomLocalisedString(@"Chooseuptp10photo", nil);
    DoneText.text = CustomLocalisedString(@"DoneButton", nil);
    _tvAlbumList.alpha = 0.0;
    TblviewBackImg.alpha = 0.0;
    _vBottomMenu.alpha = 0.0;
    
    [self initBottomMenu];
    [self initControls];
    
    UINib *nib = [UINib nibWithNibName:@"DoPhotoCell" bundle:nil];
    [_cvPhotoList registerNib:nib forCellWithReuseIdentifier:@"DoPhotoCell"];

   // _lbSelectCount.frame = CGRectMake(screenWidth - 200, 20, 42, 44);

    [self readAlbumList:YES];

    // new photo is located at the first of array
    ASSETHELPER.bReverse = YES;
	
	if (_nMaxCount != 1)
	{
		// init gesture for multiple selection with panning
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanForSelection:)];
		[self.view addGestureRecognizer:pan];
	}

    // init gesture for preview
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongTapForPreview:)];
    longTap.minimumPressDuration = 0.3;
    [self.view addGestureRecognizer:longTap];
    
    // add observer for refresh asset data
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnterForeground:)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
    
    //[self.view addSubview:ShowChooseUpText];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _vBottomMenu.frame = CGRectMake(0, 0, screenWidth, 64);
    _tvAlbumList.frame = CGRectMake((screenWidth/2) - 160,  0, 320, 245);
    TblviewBackImg.frame = CGRectMake((screenWidth/2) - 160,0, 320, 264);
    _tvAlbumList.alpha = 0.0;
    TblviewBackImg.alpha = 0.0;
    
    _btCancel.frame = CGRectMake(0, 0, 64, 64);
    _btSelectAlbum.frame = CGRectMake((screenWidth / 2) - 75, 20, 150, 44);
    _ivShowMark.frame = CGRectMake((screenWidth / 2) - 65, 38, 13, 8);
    
    _lbDone.frame = CGRectMake(screenWidth - 64, 20, 64, 44);
    _btOK.frame = CGRectMake(screenWidth - 64, 0, 64, 64);
    
    _vBottomMenu.alpha = 1.0;
}
-(void)GetBackSelectData:(NSMutableArray *)SelectedIndexArr BackView:(NSString *)CheckView CheckDraft:(NSString *)DraftCheck{
    
    CheckViewData = CheckView;
    CheckDraft = DraftCheck;
    if ([CheckDraft isEqualToString:@"Yes"]) {

    }else{

    }
    // NSLog(@"selectedIndexArr_Thumbs is %@",selectedIndexArr_Thumbs);
    // NSLog(@"CheckViewData is %@",CheckViewData);
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (_nResultType == DO_PICKER_RESULT_UIIMAGE)
        [ASSETHELPER clearData];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)handleEnterForeground:(NSNotification*)notification
{
    [self readAlbumList:NO];
}

#pragma mark - for init
- (void)initControls
{
    // side buttons
    _btUp.backgroundColor = DO_SIDE_BUTTON_COLOR;
    _btDown.backgroundColor = DO_SIDE_BUTTON_COLOR;
    
    CALayer *layer1 = [_btDown layer];
	[layer1 setMasksToBounds:YES];
	[layer1 setCornerRadius:_btDown.frame.size.height / 2.0 - 1];
    
    CALayer *layer2 = [_btUp layer];
	[layer2 setMasksToBounds:YES];
	[layer2 setCornerRadius:_btUp.frame.size.height / 2.0 - 1];
    
//    // table view
//    UIImageView *ivHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tvAlbumList.frame.size.width, 0.5)];
//    ivHeader.backgroundColor = DO_ALBUM_NAME_TEXT_COLOR;
//    _tvAlbumList.tableHeaderView = ivHeader;
//    
//    UIImageView *ivFooter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tvAlbumList.frame.size.width, 0.5)];
//    ivFooter.backgroundColor = DO_ALBUM_NAME_TEXT_COLOR;
//    _tvAlbumList.tableFooterView = ivFooter;
    
    // dimmed view
    _vDimmed.alpha = 0.0;
    _vDimmed.frame = self.view.frame;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOnDimmedView:)];
    [_vDimmed addGestureRecognizer:tap];
}

- (void)readAlbumList:(BOOL)bFirst
{
    [ASSETHELPER getGroupList:^(NSArray *aGroups) {
        
        [_tvAlbumList reloadData];

        NSInteger nIndex = 0;
#ifdef DO_SAVE_SELECTED_ALBUM
        nIndex = [self getSelectedGroupIndex:aGroups];
        if (nIndex < 0)
            nIndex = 0;
#endif
        [_tvAlbumList selectRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [_btSelectAlbum setTitle:[ASSETHELPER getGroupInfo:nIndex][@"name"] forState:UIControlStateNormal];
        
        [self showPhotosInGroup:nIndex];
        
        if (aGroups.count == 1)
            _btSelectAlbum.enabled = NO;
        
        // calculate tableview's height
        _tvAlbumList.frame = CGRectMake(_tvAlbumList.frame.origin.x, _tvAlbumList.frame.origin.y, _tvAlbumList.frame.size.width, 245);
    }];
}

#pragma mark - for bottom menu
- (void)initBottomMenu
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    _vBottomMenu.backgroundColor = [UIColor blackColor];
    _vBottomMenu.frame = CGRectMake(0, 0, screenWidth, 64);
    [_btSelectAlbum setTitleColor:DO_BOTTOM_TEXT_COLOR forState:UIControlStateNormal];
    [_btSelectAlbum setTitleColor:DO_BOTTOM_TEXT_COLOR forState:UIControlStateDisabled];
    
    _ivLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    _ivLine2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    
    if (_nMaxCount == DO_NO_LIMIT_SELECT)
    {
        _lbSelectCount.text = @"(0)";
        _lbSelectCount.textColor = DO_BOTTOM_TEXT_COLOR;
    }
    else if (_nMaxCount <= 1)
    {
        // hide ok button
        _btOK.hidden = YES;
        _ivLine1.hidden = YES;
        
        CGRect rect = _btSelectAlbum.frame;
        rect.size.width = rect.size.width + 60;
        _btSelectAlbum.frame = rect;
        
        _lbSelectCount.hidden = YES;
    }
    else
    {
        _lbSelectCount.text = [NSString stringWithFormat:@"(0/%d)", (int)_nMaxCount];
        _lbSelectCount.textColor = DO_BOTTOM_TEXT_COLOR;
    }
    
    NSLog(@"_vBottomMenu is %@",_vBottomMenu);
}

- (IBAction)onSelectPhoto:(id)sender
{
    if ([_dSelected count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SelectPhoto", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        if ([CheckDraft isEqualToString:@"Yes"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *TempArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"selectedIndexArr_Thumbs"]];
            NSArray *aKeys = [_dSelected keysSortedByValueUsingSelector:@selector(compare:)];
            for (int i = 0; i < _dSelected.count; i++){
                UIImage *iSelected_Img = [ASSETHELPER getImageAtIndex:[aKeys[i] integerValue] type:ASSET_PHOTO_SCREEN_SIZE];
                // NSString *base64 = [self encodeToBase64String:iSelected_Img];
                // [aResult addObject:base64];
                
                NSData *imageData = UIImageJPEGRepresentation(iSelected_Img, 1);
                NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
                [imageData writeToFile:imagePath atomically:YES];
                
                [TempArray addObject:imagePath];
            }
            
            [defaults setObject:TempArray forKey:@"selectedIndexArr_Thumbs"];// image data
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dSelected];
            [defaults setObject:data forKey:@"selectedIndexArr_Thumbs_Data"];// select data
            [defaults synchronize];
        }else{
         //   NSLog(@"_dSelected is %@",_dSelected);
            NSMutableArray *aResult = [[NSMutableArray alloc] initWithCapacity:_dSelected.count];
            
            NSArray *aKeys = [_dSelected keysSortedByValueUsingSelector:@selector(compare:)];
          //  NSLog(@"aKeys is %@",aKeys);
            for (int i = 0; i < _dSelected.count; i++){
                UIImage *iSelected_Img = [ASSETHELPER getImageAtIndex:[aKeys[i] integerValue] type:ASSET_PHOTO_SCREEN_SIZE];
               // NSString *base64 = [self encodeToBase64String:iSelected_Img];
               // [aResult addObject:base64];
                
                NSData *imageData = UIImageJPEGRepresentation(iSelected_Img, 1);
                NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_%f.jpg", [NSDate timeIntervalSinceReferenceDate]]];
                [imageData writeToFile:imagePath atomically:YES];
                
                [aResult addObject:imagePath];
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:aResult forKey:@"selectedIndexArr_Thumbs"];// image data
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dSelected];
            [defaults setObject:data forKey:@"selectedIndexArr_Thumbs_Data"];// select data
            [defaults synchronize];
        }

        
        if ([CheckViewData isEqualToString:@"Yes"]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            WhereIsThisViewController *ShowImageView = [[WhereIsThisViewController alloc]init];
            [self presentViewController:ShowImageView animated:YES completion:nil];
            // [ShowImageView GetImageData:selectedIndexArr_Thumbs];
        }
        
      //  [_delegate didSelectPhotosFromDoImagePickerController:self result:aResult];
    }

}
- (NSString *)documentsPathForFileName:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
- (IBAction)onCancel:(id)sender
{
    if ([CheckViewData isEqualToString:@"Yes"]) {
        [_delegate didCancelDoImagePickerController];
    }else{
        [_delegate didCancelDoImagePickerController];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs_Data"];
    }

}

- (IBAction)onSelectAlbum:(id)sender
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    NSLog(@"_vBottomMenu == %f",_vBottomMenu.frame.size.height);
//    NSLog(@"_tvAlbumList == %f",_tvAlbumList.frame.origin.y);
    if (_vBottomMenu.frame.origin.y == _tvAlbumList.frame.origin.y)
    {
        // show tableview
        [UIView animateWithDuration:0.2 animations:^(void) {

            _vDimmed.alpha = 0.7;

//            _tvAlbumList.frame = CGRectMake(0,64,
//                                            _tvAlbumList.frame.size.width, 245);
            _tvAlbumList.frame = CGRectMake((screenWidth/2) - 160,  64, 320, 245);
            _tvAlbumList.alpha = 1.0;
            TblviewBackImg.frame = CGRectMake((screenWidth/2) - 160, 64, 320, 264);
            TblviewBackImg.alpha = 1.0;
            
            _ivShowMark.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else
    {
        // hide tableview
        [self hideBottomMenu];
    }
}

#pragma mark - for side buttons
- (void)onTapOnDimmedView:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [self hideBottomMenu];
        
        if (_ivPreview != nil)
            [self hidePreview];
    }
}

- (IBAction)onUp:(id)sender
{
    [_cvPhotoList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (IBAction)onDown:(id)sender
{
    [_cvPhotoList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[ASSETHELPER getPhotoCountOfCurrentGroup] - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - UITableViewDelegate for selecting album
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ASSETHELPER getGroupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoAlbumCell *cell = (DoAlbumCell*)[tableView dequeueReusableCellWithIdentifier:@"DoAlbumCell"];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoAlbumCell" owner:nil options:nil] lastObject];
    }

    NSDictionary *d = [ASSETHELPER getGroupInfo:indexPath.row];
    //NSLog(@"d == %@",d);
    cell.lbAlbumName.text   = d[@"name"];
    cell.lbCount.text       = [NSString stringWithFormat:@"%@", d[@"count"]];
    cell.ImageShow.image = d[@"image"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPhotosInGroup:indexPath.row];
    [_btSelectAlbum setTitle:[ASSETHELPER getGroupInfo:indexPath.row][@"name"] forState:UIControlStateNormal];

    [self hideBottomMenu];
}

- (void)hideBottomMenu
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.2 animations:^(void) {
        
        _vDimmed.alpha = 0.0;
        _tvAlbumList.frame = CGRectMake((screenWidth/2) - 160,  0, 320, 245);
        TblviewBackImg.frame = CGRectMake((screenWidth/2) - 160, 0, 320, 264);
       // _tvAlbumList.frame = CGRectMake(0, 0, _tvAlbumList.frame.size.width, 245);
        _ivShowMark.transform = CGAffineTransformMakeRotation(0);
        
        [UIView setAnimationDelay:0.1];

        _tvAlbumList.alpha = 0.0;
        TblviewBackImg.alpha = 0.0;
    }];
}

#pragma mark - UICollectionViewDelegates for photos
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ASSETHELPER getPhotoCountOfCurrentGroup];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoPhotoCell *cell = (DoPhotoCell *)[_cvPhotoList dequeueReusableCellWithReuseIdentifier:@"DoPhotoCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.ivPhoto.image = [UIImage imageNamed:@"TakePhoto.png"];
        [cell setSelectMode:NO];
    }else{
        if (_nColumnCount == 4)
            cell.ivPhoto.image = [ASSETHELPER getImageAtIndex:indexPath.row  type:ASSET_PHOTO_THUMBNAIL];
        else
            cell.ivPhoto.image = [ASSETHELPER getImageAtIndex:indexPath.row  type:ASSET_PHOTO_ASPECT_THUMBNAIL];
        
        
        if (_dSelected[@(indexPath.row)] == nil)
            [cell setSelectMode:NO];
        else
            [cell setSelectMode:YES];
    }

	
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"Open Camera");
        [self OpenCamera];
    }else{
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             ShowSelectText.hidden = NO;
             ShowSelectText.frame = CGRectMake(0, 64, screenWidth, 28);
         }completion:^(BOOL finished){}];
        
        if (_nMaxCount > 1 || _nMaxCount == DO_NO_LIMIT_SELECT)
        {
            DoPhotoCell *cell = (DoPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            if ((_dSelected[@(indexPath.row)] == nil) && (_nMaxCount > _dSelected.count))
            {
                // select
                _dSelected[@(indexPath.row)] = @(_dSelected.count);
                [cell setSelectMode:YES];
            }
            else
            {
                // unselect
                [_dSelected removeObjectForKey:@(indexPath.row)];
                [cell setSelectMode:NO];
                if ([_dSelected count] == 0) {
                    [UIView animateWithDuration:0.2 animations:
                     ^(void){
                         ShowSelectText.frame = CGRectMake(0, -64, screenWidth, 28);
                     }completion:^(BOOL finished){
                         ShowSelectText.hidden = YES;
                     }];
                }
                

            }
            
            if (_nMaxCount == DO_NO_LIMIT_SELECT)
                _lbSelectCount.text = [NSString stringWithFormat:@"(%d)", (int)_dSelected.count];
            else
                _lbSelectCount.text = [NSString stringWithFormat:@"(%d/%d)", (int)_dSelected.count, (int)_nMaxCount];
        }
        else
        {
            if (_nResultType == DO_PICKER_RESULT_UIIMAGE)
                [_delegate didSelectPhotosFromDoImagePickerController:self result:@[[ASSETHELPER getImageAtIndex:indexPath.row type:ASSET_PHOTO_SCREEN_SIZE]]];
            else
                [_delegate didSelectPhotosFromDoImagePickerController:self result:@[[ASSETHELPER getAssetAtIndex:indexPath.row]]];
        }
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int TestWidth = screenWidth - 12;
    int FinalWidth = TestWidth / 3;
    return CGSizeMake(FinalWidth, FinalWidth);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _cvPhotoList)
    {
        [UIView animateWithDuration:0.2 animations:^(void) {
            if (scrollView.contentOffset.y <= 50)
                _btUp.alpha = 0.0;
            else
                _btUp.alpha = 1.0;
            
            if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height)
                _btDown.alpha = 0.0;
            else
                _btDown.alpha = 1.0;
        }];
    }
}

// for multiple selection with panning
- (void)onPanForSelection:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (_ivPreview != nil)
        return;
    
    double fX = [gestureRecognizer locationInView:_cvPhotoList].x;
    double fY = [gestureRecognizer locationInView:_cvPhotoList].y;
	
    for (UICollectionViewCell *cell in _cvPhotoList.visibleCells)
	{
        float fSX = cell.frame.origin.x;
        float fEX = cell.frame.origin.x + cell.frame.size.width;
        float fSY = cell.frame.origin.y;
        float fEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (fX >= fSX && fX <= fEX && fY >= fSY && fY <= fEY)
        {
            NSIndexPath *indexPath = [_cvPhotoList indexPathForCell:cell];
            
            if (_lastAccessed != indexPath)
            {
				[self collectionView:_cvPhotoList didSelectItemAtIndexPath:indexPath];
            }
            
            _lastAccessed = indexPath;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        _lastAccessed = nil;
        _cvPhotoList.scrollEnabled = YES;
    }
}

// for preview
- (void)onLongTapForPreview:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (_ivPreview != nil)
        return;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        double fX = [gestureRecognizer locationInView:_cvPhotoList].x;
        double fY = [gestureRecognizer locationInView:_cvPhotoList].y;

        // check boundary of controls
        CGPoint pt = [gestureRecognizer locationInView:self.view];
        if (CGRectContainsPoint(_vBottomMenu.frame, pt))
            return;
        if (_btDown.alpha == 1.0 && CGRectContainsPoint(_btDown.frame, pt))
            return;
        if (_btUp.alpha == 1.0 && CGRectContainsPoint(_btUp.frame, pt))
            return;
        
        NSIndexPath *indexPath = nil;
        for (UICollectionViewCell *cell in _cvPhotoList.visibleCells)
        {
            float fSX = cell.frame.origin.x;
            float fEX = cell.frame.origin.x + cell.frame.size.width;
            float fSY = cell.frame.origin.y;
            float fEY = cell.frame.origin.y + cell.frame.size.height;
            
            if (fX >= fSX && fX <= fEX && fY >= fSY && fY <= fEY)
            {
                indexPath = [_cvPhotoList indexPathForCell:cell];
                break;
            }
        }
        
        if (indexPath != nil)
            [self showPreview:indexPath.row];
    }
}



#pragma mark - for photos
- (void)showPhotosInGroup:(NSInteger)nIndex
{
    if (_nMaxCount == DO_NO_LIMIT_SELECT)
    {
        _dSelected = [[NSMutableDictionary alloc] init];
        _lbSelectCount.text = @"(0)";
    }
    else if (_nMaxCount > 1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"selectedIndexArr_Thumbs_Data"];
        NSLog(@"apa data is === %@",data);
        NSMutableDictionary *TempDictonary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([CheckDraft isEqualToString:@"Yes"]) {
            _dSelected = [[NSMutableDictionary alloc] initWithCapacity:_nMaxCount];
            _lbSelectCount.text = [NSString stringWithFormat:@"(0/%d)", (int)_nMaxCount];
        }else{
            if ([ TempDictonary count ] == 0 ) {
                _dSelected = [[NSMutableDictionary alloc] initWithCapacity:_nMaxCount];
                _lbSelectCount.text = [NSString stringWithFormat:@"(0/%d)", (int)_nMaxCount];
            }else{
                _dSelected = TempDictonary;
                _lbSelectCount.text = [NSString stringWithFormat:@"(%lu/%d)",(unsigned long)[TempDictonary count], (int)_nMaxCount];
            }
        }
        
        


    }
    
    [ASSETHELPER getPhotoListOfGroupByIndex:nIndex result:^(NSArray *aPhotos) {
        
        [_cvPhotoList reloadData];
        
        _cvPhotoList.alpha = 0.3;
        [UIView animateWithDuration:0.2 animations:^(void) {
            [UIView setAnimationDelay:0.1];
            _cvPhotoList.alpha = 1.0;
        }];
        
		if (aPhotos.count > 0)
		{
			[_cvPhotoList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }

        _btUp.alpha = 0.0;

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (_cvPhotoList.contentSize.height < _cvPhotoList.frame.size.height)
                _btDown.alpha = 0.0;
            else
                _btDown.alpha = 1.0;
        });
    }];
    
#ifdef DO_SAVE_SELECTED_ALBUM
    // save selected album
    [self saveSelectedGroup:nIndex];
#endif
    
}

- (void)showPreview:(NSInteger)nIndex
{
    [self.view bringSubviewToFront:_vDimmed];
    
    _ivPreview = [[UIImageView alloc] initWithFrame:_vDimmed.frame];
    _ivPreview.contentMode = UIViewContentModeScaleAspectFit;
    _ivPreview.autoresizingMask = _vDimmed.autoresizingMask;
    [_vDimmed addSubview:_ivPreview];
    
    _ivPreview.image = [ASSETHELPER getImageAtIndex:nIndex type:ASSET_PHOTO_SCREEN_SIZE];
    
    // add gesture for close preview
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanToClosePreview:)];
    [_vDimmed addGestureRecognizer:pan];
    
    [UIView animateWithDuration:0.2 animations:^(void) {
        _vDimmed.alpha = 1.0;
    }];
}

- (void)hidePreview
{
    [self.view bringSubviewToFront:_tvAlbumList];
    [self.view bringSubviewToFront:_vBottomMenu];
    
    [_ivPreview removeFromSuperview];
    _ivPreview = nil;

    _vDimmed.alpha = 0.0;
    [_vDimmed removeGestureRecognizer:[_vDimmed.gestureRecognizers lastObject]];
}

- (void)onPanToClosePreview:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.view];

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^(void) {
            
            if (_vDimmed.alpha < 0.7)   // close preview
            {
                CGPoint pt = _ivPreview.center;
                if (_ivPreview.center.y > _vDimmed.center.y)
                    pt.y = self.view.frame.size.height * 1.5;
                else if (_ivPreview.center.y < _vDimmed.center.y)
                    pt.y = -self.view.frame.size.height * 1.5;

                _ivPreview.center = pt;

                [self hidePreview];
            }
            else
            {
                _vDimmed.alpha = 1.0;
                _ivPreview.center = _vDimmed.center;
            }
            
        }];
    }
    else
    {
		_ivPreview.center = CGPointMake(_ivPreview.center.x, _ivPreview.center.y + translation.y);
		[gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        
        _vDimmed.alpha = 1 - ABS(_ivPreview.center.y - _vDimmed.center.y) / (self.view.frame.size.height / 2.0);
    }
}

#pragma mark - save selected album
- (void)saveSelectedGroup:(NSInteger)nIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:[[ASSETHELPER getGroupAtIndex:nIndex] valueForProperty:ALAssetsGroupPropertyName] forKey:@"DO_SELECTED_ALBUM"];
	[defaults synchronize];
    
    NSLog(@"[[ASSETHELPER getGroupAtIndex:nIndex] valueForProperty:ALAssetsGroupPropertyName] : %@", [[ASSETHELPER getGroupAtIndex:nIndex] valueForProperty:ALAssetsGroupPropertyName]);
}

- (NSString *)loadSelectedGroup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    NSLog(@"---------> %@", [defaults objectForKey:@"DO_SELECTED_ALBUM"]);
    
    return [defaults objectForKey:@"DO_SELECTED_ALBUM"];
}

- (NSInteger)getSelectedGroupIndex:(NSArray *)aGroups
{
    NSString *strOldAlbumName = [self loadSelectedGroup];
    for (int i = 0; i < aGroups.count; i++)
    {
        NSDictionary *d = [ASSETHELPER getGroupInfo:i];
        if ([d[@"name"] isEqualToString:strOldAlbumName])
            return i;
    }
    
    return -1;
}

#pragma mark - Others
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
-(void)OpenCamera{
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
           [self readAlbumList:YES];
        }
    }];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
