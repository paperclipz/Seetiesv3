//
//  PECropViewController.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropViewController.h"
#import "PECropView.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface PECropViewController () <UIActionSheetDelegate>

@property (nonatomic) PECropView *cropView;
@property (nonatomic) UIActionSheet *actionSheet;

- (void)commonInit;

@end

@implementation PECropViewController
@synthesize rotationEnabled = _rotationEnabled;

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"PEPhotoCropEditor" withExtension:@"bundle"];
        bundle = [[NSBundle alloc] initWithURL:bundleURL];
    });
    
    return bundle;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
static inline NSString *PELocalizedString(NSString *key, NSString *comment)
{
    return [[PECropViewController bundle] localizedStringForKey:key value:nil table:@"Localizable"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.rotationEnabled = YES;
}

#pragma mark -

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    //contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.backgroundColor = [UIColor blackColor];
    self.view = contentView;
    
    self.cropView = [[PECropView alloc] initWithFrame:contentView.bounds];
    [contentView addSubview:self.cropView];
}

- (void)viewDidLoad
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.toolbar.translucent = YES;
    
    UIImageView *BackImage = [[UIImageView alloc]init];
    BackImage.frame = CGRectMake(13, 33, 17, 17);
    BackImage.image = [UIImage imageNamed:@"buttonClose.png"];
    [self.view addSubview:BackImage];
    
    UIButton *BackgroundButton = [[UIButton alloc]init];
    BackgroundButton.frame = CGRectMake(0, 0, screenWidth, 64);
    [BackgroundButton setTitle:@"" forState:UIControlStateNormal];
    BackgroundButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:BackgroundButton];
    
    UIButton *BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.frame = CGRectMake(0, 20, 56,44);
    [BackButton setTitle:@"" forState:UIControlStateNormal];
    [BackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BackButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [BackButton setBackgroundColor:[UIColor clearColor]];
    [BackButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BackButton];
    
    
    
    UIButton *DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    DoneButton.frame = CGRectMake(screenWidth - 60 - 15, 20, 60,44);
    [DoneButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    [DoneButton setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:183.0f/255.0f blue:41.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [DoneButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [DoneButton setBackgroundColor:[UIColor clearColor]];
    DoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [DoneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DoneButton];
    
    UILabel *ShowTitle = [[UILabel alloc]init];
    ShowTitle.text = CustomLocalisedString(@"Crop", nil);
    ShowTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowTitle.textColor = [UIColor whiteColor];
    ShowTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ShowTitle];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                          target:self
//                                                                                          action:@selector(cancel:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                           target:self
//                                                                                           action:@selector(done:)];

//    if (!self.toolbarItems) {
//        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                       target:nil
//                                                                                       action:nil];
//        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:PELocalizedString(@"Constrain", nil)
//                                                                            style:UIBarButtonItemStyleBordered
//                                                                           target:self
//                                                                           action:@selector(constrain:)];
//        self.toolbarItems = @[flexibleSpace, constrainButton, flexibleSpace];
//    }
//    self.navigationController.toolbarHidden = self.toolbarHidden;
    
    self.cropView.image = self.image;
    
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
    
    UIButton *LineButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    LineButton1.frame = CGRectMake((screenWidth/2) - 41, [UIScreen mainScreen].bounds.size.height - 135, 82,82);
    [LineButton1 setImage:[UIImage imageNamed:@"BtnRotate.png"] forState:UIControlStateNormal];
   // [LineButton1 setTitle:@"Rotate" forState:UIControlStateNormal];
    [LineButton1 setBackgroundColor:[UIColor clearColor]];
    [LineButton1 addTarget:self action:@selector(RotateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LineButton1];
    
    
    UIButton *LineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LineButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, screenWidth,50);
    [LineButton setTitle:CustomLocalisedString(@"Reset", nil) forState:UIControlStateNormal];
    [LineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LineButton setBackgroundColor:[UIColor clearColor]];
    [LineButton addTarget:self action:@selector(ResetButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LineButton];
    
    test = 0;
}
-(IBAction)ResetButton:(id)sender{
    CGRect cropRect = self.cropView.cropRect;
    CGSize size = self.cropView.image.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat ratio;
    if (width < height) {
        ratio = width / height;
        cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect));
    } else {
        ratio = height / width;
        cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio);
    }
    self.cropView.cropRect = cropRect;
}
-(IBAction)RotateButton:(id)sender{
  //  [self.cropView setRotationAngle:M_PI / 2];
    
    switch (test) {
        case 0:
            test = 1;
            [self.cropView setRotationAngle:90 snap:YES];
            break;
        case 1:
            test = 2;
            [self.cropView setRotationAngle:129 snap:YES];
            break;
        case 2:
            test = 3;
            [self.cropView setRotationAngle:180 snap:YES];
            break;
        case 3:
            test = 0;
            [self.cropView setRotationAngle:220 snap:YES];
            break;
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.cropAspectRatio != 0) {
        self.cropAspectRatio = self.cropAspectRatio;
    }
    if (!CGRectEqualToRect(self.cropRect, CGRectZero)) {
        self.cropRect = self.cropRect;
    }
    if (!CGRectEqualToRect(self.imageCropRect, CGRectZero)) {
        self.imageCropRect = self.imageCropRect;
    }
    
    self.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.cropView.image = image;
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropView.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)cropAspectRatio
{
    _cropAspectRatio = cropAspectRatio;
    self.cropView.cropAspectRatio = self.cropAspectRatio;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    _imageCropRect = CGRectZero;
    
    CGRect cropViewCropRect = self.cropView.cropRect;
    cropViewCropRect.origin.x += cropRect.origin.x;
    cropViewCropRect.origin.y += cropRect.origin.y;
    
    CGSize size = CGSizeMake(fminf(CGRectGetMaxX(cropViewCropRect) - CGRectGetMinX(cropViewCropRect), CGRectGetWidth(cropRect)),
                             fminf(CGRectGetMaxY(cropViewCropRect) - CGRectGetMinY(cropViewCropRect), CGRectGetHeight(cropRect)));
    cropViewCropRect.size = size;
    self.cropView.cropRect = cropViewCropRect;
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    _imageCropRect = imageCropRect;
    _cropRect = CGRectZero;
    
    self.cropView.imageCropRect = imageCropRect;
}

- (BOOL)isRotationEnabled
{
    return _rotationEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled = rotationEnabled;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (CGAffineTransform)rotationTransform
{
    return self.cropView.rotation;
}

- (CGRect)zoomedCropRect
{
    return self.cropView.zoomedCropRect;
}

- (void)resetCropRect
{
    [self.cropView resetCropRect];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    [self.cropView resetCropRectAnimated:animated];
}

#pragma mark -

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [self.delegate cropViewControllerDidCancel:self];
    }
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:transform:cropRect:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage transform: self.cropView.rotation cropRect: self.cropView.zoomedCropRect];
    } else if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}

- (void)constrain:(id)sender
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:PELocalizedString(@"Cancel", nil)
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:
                        PELocalizedString(@"Original", nil),
                        PELocalizedString(@"Square", nil),
                        PELocalizedString(@"3 x 2", nil),
                        PELocalizedString(@"3 x 5", nil),
                        PELocalizedString(@"4 x 3", nil),
                        PELocalizedString(@"4 x 6", nil),
                        PELocalizedString(@"5 x 7", nil),
                        PELocalizedString(@"8 x 10", nil),
                        PELocalizedString(@"16 x 9", nil), nil];
    [self.actionSheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CGRect cropRect = self.cropView.cropRect;
        CGSize size = self.cropView.image.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat ratio;
        if (width < height) {
            ratio = width / height;
            cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect));
        } else {
            ratio = height / width;
            cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio);
        }
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 1) {
        self.cropView.cropAspectRatio = 1.0f;
    } else if (buttonIndex == 2) {
        self.cropView.cropAspectRatio = 2.0f / 3.0f;
    } else if (buttonIndex == 3) {
        self.cropView.cropAspectRatio = 3.0f / 5.0f;
    } else if (buttonIndex == 4) {
        CGFloat ratio = 3.0f / 4.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    } else if (buttonIndex == 5) {
        self.cropView.cropAspectRatio = 4.0f / 6.0f;
    } else if (buttonIndex == 6) {
        self.cropView.cropAspectRatio = 5.0f / 7.0f;
    } else if (buttonIndex == 7) {
        self.cropView.cropAspectRatio = 8.0f / 10.0f;
    } else if (buttonIndex == 8) {
        CGFloat ratio = 9.0f / 16.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    }
}

@end
