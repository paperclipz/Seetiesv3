//
//  CT3_InviteFriendViewController.m
//  Seeties
//
//  Created by Evan Beh on 28/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_InviteFriendViewController.h"

@interface CT3_InviteFriendViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibMainTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibMainDesc;
@property (weak, nonatomic) IBOutlet UIButton *ibInviteBtn;

@end

@implementation CT3_InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Utils setRoundBorder:self.ibInviteBtn color:[UIColor clearColor] borderRadius:self.ibInviteBtn.frame.size.height/2];
}

-(void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)changeLanguage{
    self.ibHeaderTitle.text = LocalisedString(@"Invite Your Buddies");
    self.ibMainTitle.text = LocalisedString(@"The More, The Merrier");
    self.ibMainDesc.text = LocalisedString(@"Invite your buddies to join Seeties to enjoy exciting deals!");
    [self.ibInviteBtn setTitle:LocalisedString(@"Invite Friends") forState:UIControlStateNormal];
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

- (IBAction)btnInviteClicked:(id)sender {
    CustomItemSource *dataToPost = [[CustomItemSource alloc] init];
    dataToPost.shareType = ShareTypeInvite;
    [self presentViewController:[UIActivityViewController ShowShareViewControllerOnTopOf:self WithDataToPost:dataToPost] animated:YES completion:nil];
}

@end
