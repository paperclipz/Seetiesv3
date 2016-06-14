//
//  CT3_CollectionViewController.m
//  Seeties
//
//  Created by ZackTvZ on 6/10/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_CollectionViewController.h"
#import "CollectionType_HeaderCell.h"

@interface CT3_CollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bottomToolbarView;
@property (nonatomic, strong)NSString *collectionID;
@property (nonatomic, assign)int currentPage;
@property (strong, nonatomic)CollectionModel* collectionModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
- (IBAction)back:(id)sender;
@end

@implementation CT3_CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    2
    
    self.tableView.estimatedRowHeight = 44.0;
    [self styleUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Style

- (void)styleUI{
    //bottom bar
    
    self.bottomToolbarView.layer.borderWidth = 1;
    self.bottomToolbarView.layer.borderColor = [UIColorFromRGB(238, 238, 238, 1) CGColor];
    self.shareBtn.layer.borderWidth = 1;
    self.shareBtn.layer.cornerRadius = self.shareBtn.frame.size.height/2;
    self.shareBtn.layer.borderColor = [UIColorFromRGB(3, 155, 229, 1) CGColor];
    
}

#pragma mark - Request

-(void)getCollectionByID:(NSString *)collectionID{
    self.collectionID = collectionID;
    [self getCollectionData];
}

-(void)getCollectionData{
//    [ShowActivity startAnimating];
//    if (CurrentPage == TotalPage) {
//    }else{
//        CurrentPage += 1;
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        CLLocation* location = [[SearchManager Instance]getAppLocation];
//        
//        
//        if ([GetPermisionUser isEqualToString:@"Self"] || [GetPermisionUser isEqualToString:@"self"]) {
//            GetMainUserID = [defaults objectForKey:@"Useruid"];
//        }else{
//            
//            
//        }
//        
//        
//        
//        NSString *FullString;
//        if ([SearchManager isDeviceGPSTurnedOn]) {
//            
//            if ([Utils isGuestMode]) {
//                FullString = [[NSString alloc]initWithFormat:@"%@collections/%@?page=%li",DataUrl.UserWallpaper_Url,GetID,CurrentPage];
//                
//            }
//            else{
//                FullString = [[NSString alloc]initWithFormat:@"%@collections/%@?page=%li&token=%@",DataUrl.UserWallpaper_Url,GetID,CurrentPage,[Utils getAppToken]];
//                
//            }
//            
//        }else{
//            
//            if ([Utils isGuestMode]) {
//                FullString = [[NSString alloc]initWithFormat:@"%@collections/%@?page=%li&lat=%f&lng=%f",DataUrl.UserWallpaper_Url,GetID,CurrentPage,location.coordinate.latitude,location.coordinate.longitude];
//                
//            }
//            else{
//                FullString = [[NSString alloc]initWithFormat:@"%@collections/%@?page=%li&lat=%f&lng=%f&token=%@",DataUrl.UserWallpaper_Url,GetID,CurrentPage,location.coordinate.latitude,location.coordinate.longitude,[Utils getAppToken]];
//                
//            }
//        }
//        
//        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
//        NSLog(@"GetCollectionData check postBack URL ==== %@",postBack);
//        NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        // NSURL *url = [NSURL URLWithString:postBack];
//        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
//        NSLog(@"theRequest === %@",theRequest);
//        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
//        
//        theConnection_CollectionData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//        [theConnection_CollectionData start];
//        if( theConnection_CollectionData ){
//            webData = [NSMutableData data];
//        }
//    }
    
    NSDictionary* dict = @{@"collection_id":self.collectionID,
//                           @"list_size":@(ARRAY_LIST_SIZE),
                           @"page":@(self.currentPage+1),
                           @"token":[Utils getAppToken]
                           };
    
    NSString* appendString = [NSString stringWithFormat:@"collections/%@",self.collectionID];
    
    [LoadingManager show];
    
    [[ConnectionManager Instance] requestServerWith:AFNETWORK_GET serverRequestType:ServerRequestTypeGetCollectionInfo parameter:dict appendString:appendString success:^(id object) {
        self.collectionModel = [[ConnectionManager dataManager] collectionModels];
        [self.tableView reloadData];
//        if (successBlock) {
//            successBlock(nil);
//        }
        [LoadingManager hide];
//        isMiddleOfRequesting = NO;
        
        
    } failure:^(id object) {
        [LoadingManager hide];
//        isMiddleOfRequesting = NO;
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(!self.collectionModel)
        return 0;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *cellIdentifier;
//    switch (indexPath.section) {
//        case 0:{
//            cellIdentifier = @"HeaderCell";
//            CollectionType_HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if(cell == nil) {
//                cell = [[CollectionType_HeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            }
//            [cell process:self.collectionModel];
//        }
//            break;
//            
//        default:
//            break;
//    }
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    switch (indexPath.section) {
        case 0:{
            cellIdentifier = @"HeaderCell";
            CollectionType_HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell == nil) {
                cell = [[CollectionType_HeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell process:self.collectionModel];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
