//
//  SeShopDetailView.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopDetailView.h"
#import "SeShopDetailTableViewCell.h"

@interface SeShopDetailView()<UITableViewDataSource,UITableViewDelegate>
{
}
@property(nonatomic,strong)NSArray* arrayList;
@property(nonatomic,assign)int counter;
@property(nonatomic,strong)NSMutableArray* arrayCell;

@end

@implementation SeShopDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initSelfView
{
    //[self initTableViewDelegate];
    
}

-(void)setupViewWithData:(int)counter
{

    self.counter = counter;
    
    self.arrayCell = [NSMutableArray new];
    for (int i = 0; i<counter; i++) {
        SeShopDetailTableViewCell* cell = [[SeShopDetailTableViewCell alloc]init];
        [cell setY:i* [SeShopDetailTableViewCell getHeight]];
        [self.arrayCell addObject:cell];
    }
    
    
    for (int i = 0; i<self.arrayCell.count; i++) {
        
        [self addSubview:self.arrayCell[i]];
    }
    
    if (self.arrayCell) {
        
        CGRect rect = [[self.arrayCell lastObject] frame];
        [self setHeight:rect.size.height + rect.origin.y + 20];
    }

    
}

-(BOOL)isAvailable
{

    if (self.arrayCell) {
        return YES;
    }
    
    return NO;
}

//-(void)initTableViewDelegate
//{
//    self.ibTableView.delegate = self;
//    self.ibTableView.dataSource = self;
//    [self.ibTableView registerClass:[SeShopDetailTableViewCell class] forCellReuseIdentifier:@"SeShopDetailTableViewCell"];
//    self.ibTableView.frame = CGRectMake(0, 0, self.ibTableView.frame.size.width, [SeShopDetailTableViewCell getHeight]*10);
//    self.frame = self.ibTableView.frame;
//}

#pragma mark - UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeShopDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SeShopDetailTableViewCell"];
    
    return cell;
}


@end
