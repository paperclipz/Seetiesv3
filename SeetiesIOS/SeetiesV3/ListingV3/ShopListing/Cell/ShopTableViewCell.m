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
        
        
        NSMutableArray* arrWord = [NSMutableArray new];
        if (![Utils isStringNull:self.ssModel.category.title]) {
            [arrWord addObject:self.ssModel.category.title];
        }
        
        if (![Utils isStringNull:self.ssModel.location.display_address]) {
            [arrWord addObject:self.ssModel.location.display_address];
        }
        
        NSMutableString* displayStr = [[NSMutableString alloc]init];
        for (int i = 0; i<arrWord.count; i++) {
            
            if (i == 0) {
                [displayStr appendString:arrWord[0]];
            }
            else
            {
                [displayStr appendString:[NSString stringWithFormat:@" \u2022 %@",arrWord[i]]];

            }
            
        }
        
        self.lblLocation.text = displayStr;
        
        
        self.lblStatus.text = self.ssModel.location.opening_hours.open_now?LocalisedString(@"OPEN"):LocalisedString(@"CLOSED");
        self.lblStatus.backgroundColor = self.ssModel.location.opening_hours.open_now?GREEN_STATUS : TWO_ZERO_FOUR_COLOR;

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
    [Utils setRoundBorder:self.ibImageView color:OUTLINE_COLOR borderRadius:5.0f];

    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealModel* model = self.ssModel.deals[indexPath.row];
    
    if (_didSelectDealBlock) {
        self.didSelectDealBlock(model);
    }    
}

@end
