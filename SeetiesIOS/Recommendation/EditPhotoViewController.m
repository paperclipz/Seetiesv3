//
//  EditPhotoViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/20/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditPhotoViewController.h"


#import "BMXSwipableCell+ConfigureCell.h"
#import "UITableViewCell+ConfigureCell.h"
#import "UITableViewController+BMXSwipableCellSupport.h"
#import "BMXDataItem.h"
#import "EditPhotoModel.h"

@interface EditPhotoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@property (nonatomic, strong) NSMutableArray *arrEditPhotoList;


@end

@implementation EditPhotoViewController
{
    NSString *_cellIdentifier;

}
- (IBAction)btnBackClicked:(id)sender {
    
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(NSMutableArray*)arrEditPhotoList
{
    
    if(!_arrEditPhotoList)
    {
        _arrEditPhotoList = [NSMutableArray new];

        for (int i = 0; i<50; i++) {
            EditPhotoModel* model = [EditPhotoModel new];
            model.imageURL = [NSString stringWithFormat:@"profile_%d.png",i%3];
            model.photoDescription = [NSString stringWithFormat:@"description %d",i];

            [_arrEditPhotoList addObject:model];
        }
    
    }
    
    return _arrEditPhotoList;
}

// hints the user showing the basement for a little time
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BMXSwipableCell* cell = (BMXSwipableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell showBasement: YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cell hideBasement: YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    self.cellsCurrentlyEditing = [NSMutableArray array];
    [self.tableView registerClass:[CustomEditPhotoTableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    self.tableView.longPressReorderEnabled = YES;
}

-(void)initData
{
    
    _cellIdentifier = @"SwipeCell";

}


#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrEditPhotoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomEditPhotoTableViewCell *cell = (CustomEditPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier: _cellIdentifier
                                                                               forIndexPath: indexPath];
    
    [cell configureCellForItem:nil];
    
    if ([cell isKindOfClass:[BMXSwipableCell class]]) {
        ((BMXSwipableCell*)cell).delegate = self;
    }
    
    
    EditPhotoModel* model = self.arrEditPhotoList[indexPath.row];
    [cell initData:[UIImage imageNamed:model.imageURL] description:model.photoDescription];

    
    cell.deleteBlock = ^(id block)
    {
        [self.arrEditPhotoList removeObject:self.arrEditPhotoList[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    };
    
    cell.moreBlock = ^(id block)
    {
        [TSMessage showNotificationInViewController:self title:@"more" subtitle:@"here is more message" type:TSMessageNotificationTypeSuccess];
    };
    
   
    
    return cell;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.arrEditPhotoList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    cell.accessoryView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"cell %@ highlighted", [self cellDescriptionForRow: indexPath.row]);
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell %@ unhighlighted", [self cellDescriptionForRow: indexPath.row]);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    cell.accessoryView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"cell %@ selected", [self cellDescriptionForRow: indexPath.row]);
}

- (NSString*)cellDescriptionForRow:(NSUInteger)row
{
    return [[self.arrEditPhotoList objectAtIndex: row] description];
}


#pragma mark - BMXSwipableCellDelegate

- (void)cell:(BMXSwipableCell *)cell basementVisibilityChanged:(BOOL)showing
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
    NSUInteger row = indexPath.row;
    NSLog(@"cell %@ basement now %@",
          [self cellDescriptionForRow: row],
          (showing ? @"visible" : @"not visible"));
}


@end
