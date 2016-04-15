//
//  NotificationTableViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "NotificationTableViewCell.h"
#import "YLImageView.h"
#import "YLGIFImage.h"

@interface NotificationTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int viewType;//1 or 2
    BOOL isMiddleOfRequestServer;
}
@property (strong, nonatomic) IBOutlet UIView *ibFooterView;
@property(nonatomic)NSMutableArray* arrNotifications;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ibActivityIndicator;
@property (strong, nonatomic) IBOutlet UIView *ibEmptyStateView;
@property (weak, nonatomic) IBOutlet YLImageView *ibLoadingImg;

@property(nonatomic)NotificationModels* notificationModels;

@end

@implementation NotificationTableViewController
-(void)initFooterView
{
    self.ibActivityIndicator.tag = 10;
    self.ibActivityIndicator.hidesWhenStopped = YES;
    self.tableView.tableFooterView = self.ibFooterView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibLoadingImg.image = [YLGIFImage imageNamed:@"Loading.gif"];
    self.tableView.backgroundView = self.ibEmptyStateView;

    
    [self initFooterView];

    isMiddleOfRequestServer = false;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestServer:(int)type
{
    viewType = type;
    if (viewType == 1) {
        [self requestServerForFollowingNotifications];

    }
    else{
        [self requestServerForNotifications];

    }
}


#pragma mark - Declaration

-(NSMutableArray*)arrNotifications
{
    if (!_arrNotifications) {
        _arrNotifications = [NSMutableArray new];
    }
    
    return _arrNotifications;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrNotifications.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *CellIdentifier = @"NotificationTableViewCell";
        NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    
    NotificationModel* model = self.arrNotifications[indexPath.row];

    [cell initData:model Type:viewType];
    cell.didSelectPostAtIndexBlock = self.didSelectPostBlock;
    cell.didSelectProfileBlock = self.didSelectProfileBlock;
    
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (viewType == 2) {
        return 101;
    }

    else
    {
        NotificationModel* model = self.notificationModels.arrNotifications[indexPath.row];
        if (model.arrPosts.count == 0) {
            return 101;
        }
        else{
            return 176;

        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (self.didSelectNotificationBlock) {
        NotificationModel* model = self.arrNotifications[indexPath.row];
        self.didSelectNotificationBlock(model);
    }
}


-(void)requestServerForNotifications
{
    
    if (!isMiddleOfRequestServer) {

        isMiddleOfRequestServer = YES;

        NSDictionary* dict = @{@"offset" : @(self.notificationModels.offset + self.notificationModels.limit),
                               @"limit" : @(LIKES_LIST_SIZE),
                               @"token" : [Utils getAppToken],
                               @"type" : @"all"
                               };
        
        
        [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetNotifications param:dict appendString:nil completeHandler:^(id object) {
            
            NotificationModels* model = [[ConnectionManager dataManager]notificationModels];
            
            [self.arrNotifications addObjectsFromArray:model.arrNotifications];
            self.notificationModels = model;
            isMiddleOfRequestServer = NO;
            
            [self.tableView reloadData];
            self.ibLoadingImg.hidden = YES;
            //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            @autoreleasepool {
            //
            //
            //
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                });
            //            }
            //        });
            //
        } errorBlock:^(id object) {
            isMiddleOfRequestServer = NO;
            self.ibLoadingImg.hidden = YES;

        }];
    }
}

#pragma mark - Server Request

-(void)requestServerForFollowingNotifications
{
    
    if (!isMiddleOfRequestServer) {

        NSDictionary* dict = @{@"token" : [Utils getAppToken],
                               @"latest_timestamp" :self.notificationModels.latest_timestamp?self.notificationModels.latest_timestamp:@""};
        
        isMiddleOfRequestServer = YES;
        [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetFollowingNotifictions param:dict appendString:nil completeHandler:^(id object) {
            
            NotificationModels * model = [[ConnectionManager dataManager]followingNotificationModels];
            self.notificationModels = model;
            [self.arrNotifications addObjectsFromArray:model.arrNotifications];
            isMiddleOfRequestServer = NO;
            //[(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] stopAnimating];
            [self.tableView reloadData];
            self.ibLoadingImg.hidden = YES;

        } errorBlock:^(id object) {
            isMiddleOfRequestServer = NO;
           // [(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] stopAnimating];
            self.ibLoadingImg.hidden = YES;

        }];
    }
    
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView {
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= self.view.frame.size.height/2) {
        
        if(![Utils isStringNull:self.notificationModels.paging.next])
        {
           // [(UIActivityIndicatorView *)[self.ibFooterView viewWithTag:10] startAnimating];
            
            if (viewType == 1) {
                
                [self requestServerForFollowingNotifications];
            }
            else{
                [self requestServerForNotifications];

            }
        }
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
