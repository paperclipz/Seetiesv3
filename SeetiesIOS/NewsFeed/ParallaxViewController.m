//
//  ParallaxViewController.m
//  Seeties
//
//  Created by Lai on 05/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ParallaxViewController.h"
#import "UIScrollView+APParallaxHeader.h"
#import "iCarousel.h"
#import "AsyncImageView.h"

@interface ParallaxViewController () <iCarouselDelegate, iCarouselDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet iCarousel *carouselView;

@property (strong, nonatomic) iCarousel *carousel;

@end

@implementation ParallaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
//    self.carousel.backgroundColor = [UIColor blueColor];
    self.carousel.type = iCarouselTypeLinear;
    //    self.carousel.contentOffset.width = -20;
    self.carousel.pagingEnabled = YES;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.bounceDistance = 0.01;
//    self.carousel.contentMode = UIViewContentModeScaleAspectFill;

    self.scrollView.delegate = self;
    
//    [self.scrollView addParallaxWithImage:<#(UIImage *)#> andHeight:<#(CGFloat)#>]
    [self.scrollView addParallaxWithView:self.carousel andHeight:300];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - carousel delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //generate 100 buttons
    //normally we'd use a backing array
    //as shown in the basic iOS example
    //but for this example we haven't bothered
    return 5;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //    UIButton *button = (UIButton *)view;
    //    if (button == nil)
    //    {
    //        //no button available to recycle, so create new one
    //        UIImage *image = [UIImage imageNamed:@"page.png"];
    //        button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    //        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [button setBackgroundImage:image forState:UIControlStateNormal];
    //        button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
    //        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    //
    //    //set button label
    //    [button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
    //
    //    return button;
    
    
    if (!view) {
        view = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(carousel.frame), CGRectGetHeight(carousel.frame))];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        
        //        view.translatesAutoresizingMaskIntoConstraints = NO;
        //        view.autoresizingMask = YES;
        [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
    }
    
    //cancel any previously loading images for this view
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:view];
    
    //set image URL. AsyncImageView class will then dynamically load the image
    ((AsyncImageView *)view).imageURL = [[NSURL alloc] initWithString:@"http://pre15.deviantart.net/c351/th/pre/f/2014/276/b/b/foggy_forest_by_danimatie-d81g488.jpg"];
    
//    [self.scrollView addParallaxWithView:view andHeight:300];
    
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return CGRectGetWidth(self.carousel.frame);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"selected %d", index);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIView *view = [self.carousel currentItemView];
    
    UIView *superView = [view superview];
    
    [superView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
//    [superView setFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.carousel.frame), CGRectGetHeight(self.carousel.frame))];
    
    //    [view setHeight:CGRectGetHeight(self.carousel.frame)];
    
//    if (scrollView.contentOffset.y == 350) {
//        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 350)];
//        newView.backgroundColor = [UIColor purpleColor];
//        
//        [self.carousel addSubview:newView];
//    }
    
    NSLog(@"carousel x:%f y:%f w:%f h:%f", self.carousel.frame.origin.x, self.carousel.frame.origin.y, self.carousel.frame.size.width,self.carousel.frame.size.height);
    
    NSLog(@"view x:%f y:%f w:%f h:%f", superView.frame.origin.x, superView.frame.origin.y, superView.frame.size.width, superView.frame.size.height);
    
    NSLog(@"scrollview y:%f", scrollView.contentOffset.y);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
 
//    UIView *view = [self.carousel currentItemView];
//    UIView *superView = [view superview];
//
//    if (superView.frame.origin.y != 0.0) {
//        [superView setFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.carousel.frame), CGRectGetHeight(self.carousel.frame))];
//    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
