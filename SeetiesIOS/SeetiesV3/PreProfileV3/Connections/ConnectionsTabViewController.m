//
//  ConnectionsTabViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 14/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ConnectionsTabViewController.h"
#import "SeetizensTableViewCell.h"
@interface ConnectionsTabViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@end

@implementation ConnectionsTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSelfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initSelfView
{
    
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    
    [self.ibTableView registerClass:[SeetizensTableViewCell class] forCellReuseIdentifier:@"SeetizensTableViewCell"];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SeetizensTableViewCell getHeight];
}
#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeetizensTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeetizensTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
