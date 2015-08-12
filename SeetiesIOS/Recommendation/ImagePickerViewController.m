//
//  ImagePickerViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/12/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface ImagePickerViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *ibCVAlbumPicker;
@property (weak, nonatomic) IBOutlet UICollectionView *ibCVImagePicker;
@property (strong, nonatomic) NSArray *arrAlbum;
@property (strong, nonatomic) NSArray *arrAssets;

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    
}

-(void)initAlbumCollectionViewWithDelegate:(id)delegate
{
    self.ibCVAlbumPicker.delegate = self;
    self.ibCVAlbumPicker.dataSource = self;

}
-(void)initImageCollectionViewWithDelegate:(id)delegate
{
    self.ibCVImagePicker.delegate = self;
    self.ibCVImagePicker.dataSource = self;

}

-(NSArray*)arrAlbum
{
    if(!_arrAlbum)
    {
        
        NSMutableArray* array = [NSMutableArray new];
      //  _arrAlbum = [];
       
        // emumerate through our groups and only add groups that contain photos
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if ([group numberOfAssets] > 0)
            {
                [array addObject:group];
            }
            
        };
        _arrAlbum = array;

    }
        return _arrAlbum;
}

//-(NSArray*)arrAssets
//{
//    if(!_arrAssets)
//    {
//        NSMutableArray*
//    }
//    return _arrAssets;
//}
@end
