//
//  ShopTableViewCell.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 07/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "FeaturedTableViewCell.h"

@interface ShopTableViewCell()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@end
@implementation ShopTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[FeaturedTableViewCell class] forCellReuseIdentifier:@"FeaturedTableViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeaturedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturedTableViewCell"];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeaturedTableViewCell getHeight];
}


@end
