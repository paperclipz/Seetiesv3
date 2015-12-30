//
//  EditPhotoViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPhotoViewController.h"
#import "EditPhotoModel.h"
#import "AssetHelper.h"

#define MAX_PHOTO_SELECTION 10
@interface EditPhotoViewController ()
{
    NSMutableArray* arrayDeletedImages;
    __weak IBOutlet UILabel *lbltitle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrEditPhotoList;
@property (nonatomic, strong) RecommendationModel *recModel;
@property (nonatomic, strong) RecommendationModel *tempRecModel;

@property(nonatomic,strong)NSMutableArray* sessions;
@property (nonatomic, copy) ImageBlock processImageBlock;


@end

@implementation EditPhotoViewController
{
    NSString *_cellIdentifier;

}

-(void)addRow:(NSArray*)arrayOfModels
{
    
    
    [self.tableView beginUpdates];
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                           NSMakeRange(0,[arrayOfModels count])];
    
    if(self.arrEditPhotoList.count == 0)
    {
        [self.arrEditPhotoList addObjectsFromArray:arrayOfModels];
    }
    else{
        [self.arrEditPhotoList insertObjects:arrayOfModels atIndexes:indexes];

    }
    [self.tableView insertRowsAtIndexPaths:[self getIndexPaths:arrayOfModels.count] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];

}

-(NSArray*)getIndexPaths:(NSInteger)count
{
    NSMutableArray* tempArray = [NSMutableArray new];
    for (int i = 0; i<count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [tempArray addObject:indexPath];
    }
    return tempArray;
}

- (IBAction)btnDoneClicked:(id)sender {
    
    if (_doneBlock) {
        self.doneBlock(self.arrEditPhotoList,arrayDeletedImages);
    }
    [self dismissView];

}
- (IBAction)btnAddNewClicked:(id)sender {
    
    [self presentViewController:self.imagePickerViewController animated:YES completion:^{
        
    }];
}

-(void)dismissView
{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
- (IBAction)btnBackClicked:(id)sender {
    
    
    if (self.editPhotoBackClickedBlock) {
        self.editPhotoBackClickedBlock(nil);
    }
    [self dismissView];
}



// hints the user showing the basement for a little time
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    arrayDeletedImages= [NSMutableArray new];
  }

-(void)initData:(RecommendationModel*)model
{
    self.recModel = [model copy];
    
    NSString* apple = [self.recModel.arrPostImagesList[0] photo_id];
    self.arrEditPhotoList = [self.recModel.arrPostImagesList mutableCopy];

}
-(void)initSelfView
{
    [self configureTableView];
    

}

-(void)configureTableView
{
    _cellIdentifier = @"SwipeCell";
    [self.tableView registerClass:[CustomEditPhotoTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    self.tableView.longPressReorderEnabled = YES;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrEditPhotoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomEditPhotoTableViewCell *cell = (CustomEditPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier: _cellIdentifier
                                                                               forIndexPath: indexPath];
    
    
    PhotoModel* model = self.arrEditPhotoList[indexPath.row];
    [cell initData:model];

    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    
    return cell;
}

-(void)configureCell:(CustomEditPhotoTableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{

    cell.deleteBlock = ^(CustomEditPhotoTableViewCell* customCell)
    {
        NSIndexPath* indexPth = [self.tableView indexPathForCell:customCell];
        
        [self.tableView beginUpdates];
        PhotoModel* tempModel = self.arrEditPhotoList[indexPth.row];
        if (tempModel.photo_id) {
            [arrayDeletedImages addObject:tempModel.photo_id];
        }
        [self.arrEditPhotoList removeObject:tempModel];
        [self.tableView deleteRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];

    };
    
    cell.editBlock = ^(CustomEditPhotoTableViewCell* customCell)
    {
        
        [self launchPhotoEditorWithImage:customCell.model.image highResolutionImage:nil completion:^(UIImage *image) {
            
            NSIndexPath* indexPth = [self.tableView indexPathForCell:customCell];

            customCell.model.image = image;
            [self.arrEditPhotoList replaceObjectAtIndex:indexPth.row withObject:customCell.model];
            [self.tableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.arrEditPhotoList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - image picker
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    
    NSMutableArray* tempArray = [NSMutableArray new];
    for (int i = 0; i<aSelected.count; i++) {
        PhotoModel* model = [PhotoModel new];
        model.image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];

        [tempArray addObject:model];
    }

    [self addRow:tempArray];
    
    [self.imagePickerViewController dismissViewControllerAnimated:YES completion:^{
        
        _imagePickerViewController = nil;
    }];
    
}


- (void)didCancelDoImagePickerController
{
    [self.imagePickerViewController dismissViewControllerAnimated:YES completion:^{
        _imagePickerViewController = nil;
    }];
}


#pragma mark - Declaration


-(DoImagePickerController*)imagePickerViewController
{
    
    if(!_imagePickerViewController)
    {
        _imagePickerViewController = [DoImagePickerController new];
        _imagePickerViewController.delegate = self;
        _imagePickerViewController.nColumnCount = 3;  // 2, 3, or 4
        _imagePickerViewController.nMaxCount = MAX_PHOTO_SELECTION - self.arrEditPhotoList.count;     // larger than 1
        _imagePickerViewController.nResultType = DO_PICKER_RESULT_ASSET; // get UIImage object array : common case
    }
    

    SLog(@"count : %ld",(long)_imagePickerViewController.nMaxCount);
    return _imagePickerViewController;
}

-(NSMutableArray*)arrEditPhotoList
{
    if (!_arrEditPhotoList) {
        _arrEditPhotoList = [NSMutableArray new];
    }
    return _arrEditPhotoList;
}

#pragma mark Aviary Photo editor method
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage completion:(ImageBlock)completionBlock
{
    
    self.processImageBlock = completionBlock;
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
    
    __block typeof (self) weakSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[weakSelf sessions] removeObject:session];
        
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    
    NSLog(@"editor is %@",editor);
    // [[self imagePreviewView] setImage:image];
    // [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
    if(_processImageBlock)
    {
        self.processImageBlock(image);

    }
  
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

#pragma mark - change language
-(void)changeLanguage
{
    lbltitle.text = LocalisedString(@"Edit Photos");
}

@end
