//
//  CT3_SearchListingViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 11/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_SearchListingViewController.h"
@interface CT3_SearchListingViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *ibSegmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@end

@implementation CT3_SearchListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self InitSelfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)InitSelfView{
    //self.ibScrollView.contentSize = CGSizeMake(850, 50);
    
    CGRect frame = [Utils getDeviceScreenSize];
    [self.ibScrollView setWidth:frame.size.width];
    [self.shopListingTableViewController.view setWidth:frame.size.width];
    [self.shopListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.shopListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width, self.ibScrollView.frame.size.height);
    
    [self.collectionListingTableViewController.view setWidth:frame.size.width];
    [self.collectionListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.collectionListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*2, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.collectionListingTableViewController.view setX:self.shopListingTableViewController.view.frame.size.width];

    [self.PostsListingTableViewController.view setWidth:frame.size.width];
    [self.PostsListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.PostsListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*3, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.PostsListingTableViewController.view setX:self.collectionListingTableViewController.view.frame.size.width*2];
    
    [self.SeetizensListingTableViewController.view setWidth:frame.size.width];
    [self.SeetizensListingTableViewController.view setHeight:self.ibScrollView.frame.size.height];
    [self.ibScrollView addSubview:self.SeetizensListingTableViewController.view];
    self.ibScrollView.contentSize = CGSizeMake(frame.size.width*4, self.ibScrollView.frame.size.height);
    self.ibScrollView.pagingEnabled = YES;
    [self.SeetizensListingTableViewController.view setX:self.PostsListingTableViewController.view.frame.size.width*3];
    
}
- (IBAction)searchSegmentedControl:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"Shops was selected");
            [self.ibScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            NSLog(@"Collection was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
            break;
        case 2:
            NSLog(@"Posts was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
            break;
        case 3:
            NSLog(@"Seetizens was selected");
            [self.ibScrollView setContentOffset:CGPointMake(self.view.frame.size.width * 3, 0) animated:YES];
            break;
        default:
            break;
    }
}
-(SearchLTabViewController*)shopListingTableViewController{
    if(!_shopListingTableViewController)
    {
        _shopListingTableViewController = [SearchLTabViewController new];
        _shopListingTableViewController.TabType = @"Shops";
    }
    return _shopListingTableViewController;
}
-(SearchLTabViewController*)collectionListingTableViewController{
    if(!_collectionListingTableViewController)
    {
        _collectionListingTableViewController = [SearchLTabViewController new];
        _collectionListingTableViewController.TabType = @"Collection";
    }
    return _collectionListingTableViewController;
}
-(SearchLTabViewController*)PostsListingTableViewController{
    if(!_PostsListingTableViewController)
    {
        _PostsListingTableViewController = [SearchLTabViewController new];
        _PostsListingTableViewController.TabType = @"Posts";
    }
    return _PostsListingTableViewController;
}
-(SearchLTabViewController*)SeetizensListingTableViewController{
    if(!_SeetizensListingTableViewController)
    {
        _SeetizensListingTableViewController = [SearchLTabViewController new];
        _SeetizensListingTableViewController.TabType = @"Seetizens";
    }
    return _SeetizensListingTableViewController;
}
@end
