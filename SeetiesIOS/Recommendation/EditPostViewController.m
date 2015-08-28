//
//  EditPostViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPostViewController.h"
#import "AUIAutoGrowingTextView.h"
#import "UIImageViewModeScaleAspect.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FX.h"
#import "EditPhotoViewController.h"
#import "AddNewPlaceViewController.h"
#import "HMSegmentedControl.h"


@interface EditPostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet AUIAutoGrowingTextView *txtDescription;

@property(nonatomic,strong)EditPhotoViewController* editPhotoViewController;
@property(nonatomic,strong)AddNewPlaceViewController* addNewPlaceViewController;

@property(nonatomic,strong)HMSegmentedControl* segmentedControl;

@end

@implementation EditPostViewController
- (IBAction)btnEditPhotoClicked:(id)sender {
    
    //[self.navigationController pushViewController:self.editPhotoViewController animated:YES];
    
      [self presentViewController:self.editPhotoViewController animated:YES completion:nil];
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initData
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:@"http://cdn3.denofgeek.us/sites/denofgeekus/files/scarlett_johansson.jpg"]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {

                                self.ibImageView.image = [image imageCroppedAndScaledToSize:self.ibImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
                            }
                        }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    
    switch ((long)segmentedControl.selectedSegmentIndex) {
       
        default:
        case 0:
            [self presentViewController:self.editPhotoViewController animated:YES completion:nil];
            break;
        case 1:
            [self presentViewController:self.addNewPlaceViewController animated:YES completion:nil];

            break;
            
        case 2:
            [self presentViewController:self.editPhotoViewController animated:YES completion:nil];

            break;
    }
    
    segmentedControl.selectedSegmentIndex = -1;
}


-(void)initSelfView
{
    
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = -1;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Declarations
-(NSArray*)arrTabImages
{
    
    return @[[UIImage imageNamed:@"addurl_icon@2x.png"],[UIImage imageNamed:@"editplace_icon@2x.png"],[UIImage imageNamed:@"qr_icon@2x.png"],[UIImage imageNamed:@"save_icon@2x.png"]];
}

-(EditPhotoViewController*)editPhotoViewController
{
    if(!_editPhotoViewController)
    {
        _editPhotoViewController = [EditPhotoViewController new];
    }
    
    return _editPhotoViewController;
}

-(HMSegmentedControl*)segmentedControl
{
    if(!_segmentedControl)
    {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:self.arrTabImages sectionSelectedImages:self.arrTabImages];
        _segmentedControl.frame = CGRectMake(0, [Utils getDeviceScreenSize].size.height-60, [Utils getDeviceScreenSize].size.width,  60);
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
     //   _segmentedControl.selectionIndicatorHeight = 4.0f;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;

    }
    
    return _segmentedControl;
}
-(AddNewPlaceViewController*)addNewPlaceViewController
{
    
    if(!_addNewPlaceViewController)
    {
        _addNewPlaceViewController = [AddNewPlaceViewController new];
    }
    return _addNewPlaceViewController;
}
@end
