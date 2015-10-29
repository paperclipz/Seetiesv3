//
//  UserProfilePageViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/11/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "UserProfilePageViewController.h"


@interface UserProfilePageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *ibScollContentView;
@property (weak, nonatomic) IBOutlet UITableView *ibTblView;

@end

@implementation UserProfilePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibTblView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200);
    self.ibTblView.delegate = self;
    self.ibTblView.dataSource = self;
    
    [self.ibTblView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    UIView* testView = [[UIView alloc]initWithFrame:CGRectMake(-50, 0, self.view.frame.size.width, 50)];
    testView.backgroundColor = [UIColor yellowColor];

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint scrollPos = scrollView.contentOffset;
    
    if(scrollPos.y >= 40 /* or CGRectGetHeight(yourToolbar.frame) */){
        // Fully hide your toolbar
    } else {
        // Slide it up incrementally, etc.
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.backgroundColor = [UIColor blueColor];
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
