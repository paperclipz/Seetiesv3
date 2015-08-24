//
//  EditPostViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPostViewController.h"
#import "AUIAutoGrowingTextView.h"

@interface EditPostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet AUIAutoGrowingTextView *txtDescription;

@end

@implementation EditPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:@"http://images.boomsbeat.com/data/images/full/2048/scarlett-johansson-jpg.jpg"]];
    // Do any additional setup after loading the view from its nib.
    self.txtDescription.maxHeight = 170.0f;//size taken is from iphone 4 , smallest screen size.
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

@end
