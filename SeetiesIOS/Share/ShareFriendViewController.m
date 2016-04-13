//
//  ShareFriendViewController.m
//  SeetiesIOS
//
//  Created by Lai on 12/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ShareFriendViewController.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface ShareFriendViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendToLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *sendToView;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@end

@implementation ShareFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialize method

- (void)initializeView {
    
    //layout setting
    self.sendToView.layer.borderWidth = 1;
    self.sendToView.layer.borderColor = UIColorFromRGB(238, 238, 238, 1.0).CGColor;
    
    self.searchTextField.layer.borderWidth = 1.5;
    self.searchTextField.layer.borderColor = UIColorFromRGB(247, 247, 247, 1.0).CGColor;
    self.searchTextField.layer.cornerRadius = 15;
    
    //localization
    self.titleLabel.text = LocalisedString(@"Share with your buddies!");
    self.sendToLabel.text = LocalisedString(@"Send to...");
    self.searchTextField.placeholder = LocalisedString(@"Username or name");
    
//    [self.friendTableView addPullToRefreshWithActionHandler:^{
//        
//    } position:SVPullToRefreshPositionBottom];
}

- (void)prepareData {
    
    NSDictionary *dict = @{@"token":[Utils getAppToken],
                           @"list_size":@(30),
                           @"page":@(1)};
    
    [[ConnectionManager Instance] requestServerWithGet:ServerRequestTypeGetFriendSuggestion param:dict appendString:@"" completeHandler:^(id object) {
        
        
    } errorBlock:^(id object) {
        
    }];

}

#pragma mark - Button event

- (IBAction)closeButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
