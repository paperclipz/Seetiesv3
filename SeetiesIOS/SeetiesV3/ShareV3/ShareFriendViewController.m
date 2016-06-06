//
//  ShareFriendViewController.m
//  SeetiesIOS
//
//  Created by Lai on 12/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ShareFriendViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ShareFriendTableViewCell.h"
#import "FriendSuggestionModel.h"

@interface ShareFriendViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendToLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *sendToView;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) FriendSuggestionModel *friendModel;
@property (strong, nonatomic) NSMutableDictionary *paramDict;
@end

@implementation ShareFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.paramDict = [NSMutableDictionary new];
    
    [self.paramDict setObject:[Utils getAppToken] forKey:@"token"];
    [self.paramDict setObject:@(30) forKey:@"list_size"];
    [self.paramDict setObject:@(1) forKey:@"page"];
    [self.paramDict setObject:@"" forKey:@"keyword"];
    
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
    self.searchTextField.inputAccessoryView = [[UIView alloc] init];
    
    //pagination handler
    [self.friendTableView addInfiniteScrollingWithActionHandler:^{
    
        [self.paramDict removeObjectForKey:@"page"];
        [self.paramDict setObject:[NSNumber numberWithInt:self.friendModel.page + 1] forKey:@"page"];
        
        [self prepareData];
    }];
    
    //registering custom cell
    [self.friendTableView registerNib:[UINib nibWithNibName:@"ShareFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShareFriendCell"];
    
    [self prepareData];
}

- (void)prepareData {
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetFriendSuggestion parameter:self.paramDict appendString:nil success:^(id object) {

        
        self.friendModel = [[ConnectionManager dataManager] friendSuggestionModel];
        
        if (self.data.count < 1) {
            self.data = [NSMutableArray arrayWithArray:self.friendModel.result];
        }
        else {
            [self.data addObjectsFromArray:self.friendModel.result];
        }
        
        [self.friendTableView.infiniteScrollingView stopAnimating];
        
        self.friendTableView.showsInfiniteScrolling = !(self.friendModel.page == self.friendModel.total_page);
        
        [self.friendTableView reloadData];
        
    } failure:^(id object) {
        
    }];

}

#pragma mark - private method

- (void)shareToFriend:(FriendSuggestionDetailModel *)friendmodel {
    
    if (!self.postData) { return; }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
                                 
    [dict setObject:[Utils getAppToken] forKey:@"token"];
    [dict setObject:friendmodel.uid forKey:@"user_ids[0]"];
    
    ServerRequestType requestType;
    
    switch (self.postData.shareType) {
        case ShareTypePost:
            requestType = ServerRequestTypePostFriendSuggestion;
            break;
        case ShareTypeCollection:
            requestType = ServerRequestTypePostCollectionFriendSuggestion;
            break;
        case ShareTypeSeetiesShop:
            requestType = ServerRequestTypePostSeetiesFriendSuggestion;
            break;
        case ShareTypeNonSeetiesShop:
            requestType = ServerRequestTypePostNonSeetiesFriendSuggestion;
            [dict setObject:self.postData.postID forKey:@"post_id"];
            break;
        case ShareTypeDeal:
            requestType = ServerRequestTypePostDealFriendSuggestion;
            break;
        default:
            break;
    }

    __weak ShareFriendViewController *weakSelf = self;
    
    NSString* appendString = [NSString stringWithFormat:@"%@/share", self.postData.shareID];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_POST serverRequestType:requestType parameter:dict appendString:appendString success:^(id object) {
        
//        [MessageManager showMessage:LocalisedString(@"Successfully share to friend") SubTitle:nil Type:TSMessageNotificationTypeSuccess];
        [MessageManager showMessage:LocalisedString(@"Successfully share to friend") Type:STAlertSuccess];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(id object) {
    
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
//        [MessageManager showMessage:LocalisedString(@"Fail to share to friend") SubTitle:nil Type:TSMessageNotificationTypeError];
        [MessageManager showMessage:LocalisedString(@"Fail to share to friend") Type:STAlertError];

    }];
    
}

#pragma mark - Button event

- (IBAction)closeButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self.data removeAllObjects];
    
    [self.paramDict removeObjectForKey:@"keyword"];
    [self.paramDict setObject:textField.text forKey:@"keyword"];
    
    //reset page number when searching
    [self.paramDict removeObjectForKey:@"page"];
    [self.paramDict setObject:[NSNumber numberWithInt:0] forKey:@"page"];

    [self prepareData];
    
    return YES;
}

#pragma mark - UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShareFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareFriendCell" forIndexPath:indexPath];

    FriendSuggestionDetailModel *friend = self.data[indexPath.row];
    
    cell.usernameLabel.text = friend.username;
    cell.nameLabel.text = [NSString stringWithFormat:@"@%@", friend.name];
    [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:friend.profile_photo] placeholderImage:[UIImage imageNamed:@"ProfileOverlay"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendSuggestionDetailModel *friendModel = self.data[indexPath.row];
    
    [self shareToFriend:friendModel];
}

@end
