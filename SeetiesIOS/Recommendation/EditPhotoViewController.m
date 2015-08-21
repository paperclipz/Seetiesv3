//
//  EditPhotoViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPhotoViewController.h"

@interface EditPhotoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemList;

@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;

@end

@implementation EditPhotoViewController
static NSString *sCellIdentifier;

#define kIndexNameOfMovie		0
#define kIndexYearOfMovie		1
#define kIndexRowHeightOfMovie  2


-(NSArray*)itemList
{
    if(!_itemList)
    {
        _itemList = [NSMutableArray arrayWithArray:[DataManager getSampleObject]];
    }
    return _itemList;
}
+ (void)initialize
{
    sCellIdentifier = @"EditPhotoTableViewCell";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellsCurrentlyEditing = [NSMutableArray array];
    [self.tableView registerClass:[CustomEditPhotoTableViewCell class] forCellReuseIdentifier:sCellIdentifier];
    self.tableView.longPressReorderEnabled = YES;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomEditPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier forIndexPath:indexPath];
   // cell.textLabel.text = self.itemList[indexPath.row];
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.itemList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}@end
