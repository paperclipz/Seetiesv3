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

@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constDotHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property(nonatomic)SeShopDetailModel* ssModel;
@end
@implementation ShopTableViewCell

-(void)initData:(SeShopDetailModel*)model
{
    
    @try {
        
        self.ssModel = model;
        self.lblShopName.text = self.ssModel.name;
        self.lblLocation.text = [NSString stringWithFormat:@"%@%@",self.ssModel.location.locality,self.ssModel.location.country];
        self.lblStatus.text = self.ssModel.location.opening_hours.open_now?LocalisedString(@"OPEN"):LocalisedString(@"CLOSED");
        self.lblStatus.backgroundColor = self.ssModel.location.opening_hours.open_now?SELECTED_GREEN : SELECTED_RED;

        [self.ibImageView sd_setImageWithURL:[NSURL URLWithString:self.ssModel.profile_photo[@"picture"]]];

    }
    @catch (NSException *exception) {
        SLog(@"error initData");
    }
    
    if (self.ssModel.deals.count==0) {
        self.constDotHeight.constant = 0;
    }
    else{
        self.constDotHeight.constant = 15;

    }
    [self.ibTableView reloadData];
   
}

- (void)awakeFromNib {
    // Initialization code
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
    [self.ibTableView registerClass:[FeaturedTableViewCell class] forCellReuseIdentifier:@"FeaturedTableViewCell"];
    [Utils setRoundBorder:self.lblStatus color:[UIColor clearColor] borderRadius:self.lblStatus.frame.size.height/2];
    [Utils setRoundBorder:self.ibImageView color:[UIColor clearColor] borderRadius:5.0f];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.ssModel.deals.count>3) {
        return 3;

    }
    else{
        return self.ssModel.deals.count;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FeaturedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturedTableViewCell"];
    
    DealModel* model = self.ssModel.deals[indexPath.row];
    
    [cell initData:model];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FeaturedTableViewCell getHeight];
}

@end
