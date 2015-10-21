//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImage+FX.h"
#import "UIScrollView+APParallaxHeader.h"
//cell
#import "ProfilePageCollectionTableViewCell.h"
#import "ProfilePagePostTableViewCell.h"
#import "ProfilePageCollectionHeaderView.h"
#import "ProfilePageCollectionFooterTableViewCell.h"
#import "ProfileNoItemTableViewCell.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* arrayTag;
    NSMutableArray* arrCollection;
    NSMutableArray* arrPost;
    NSMutableArray* arrLikes;

}

// =======  OUTLET   =======
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgProfilePic;
@property (strong, nonatomic) IBOutlet UIView *ibTopContentView;
@property (strong, nonatomic) IBOutlet UIView *ibContentView;
@property (strong, nonatomic) IBOutlet TLTagsControl *ibTagControlView;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
//profile page table view
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;
@property (weak, nonatomic) ProfilePageCollectionHeaderView *profilePageCollectionHeaderView1;
// =======  OUTLET   =======
// =======  MODEL   =======

@property(nonatomic,strong)ProfileModel* userProfileModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)ProfilePostModel* userProfileLikeModel;

// =======  MODEL   =======

@end

@implementation ProfileViewController
- (IBAction)btnSegmentedControlClicked:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initSelfView];
    [self requestServerForUserCollection];
  //  [self requestServerForUserPost];
  //  [self requestServerForUserLikes];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    
    [self initTagView];
    [self initProfilePageCell];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [Utils setRoundBorder:self.ibImgProfilePic color:[UIColor whiteColor] borderRadius:self.ibImgProfilePic.frame.size.width/2 borderWidth:6.0f];

    
    //set image from url
    [self.ibImgProfilePic sd_setImageWithURL:[NSURL URLWithString:@"http://www.ambwallpapers.com/wp-content/uploads/2015/02/scarlett-johansson-wallpapers-2.jpg"] placeholderImage:[UIImage imageNamed:@"DefaultProfilePic.png"]];

    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://i.ytimg.com/vi/tjW1mKwNUSo/maxresdefault.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.backgroundImageView.image = [image imageCroppedAndScaledToSize:self.backgroundImageView.bounds.size contentMode:UIViewContentModeScaleAspectFill padToFit:NO];
        
    }];
    
    // add parallax view with top content and content
    [self.ibScrollView addParallaxWithView:self.backgroundImageView andHeight:200];
    self.ibScrollView.parallaxView.shadowView.hidden = YES;
    self.ibScrollView.contentSize = CGSizeMake(self.ibScrollView.frame.size.width, self.ibContentView.frame.size.height);
    [self.ibScrollView addSubview:self.ibContentView];
  //  self.ibContentView.frame = CGRectMake(self.ibContentView.frame.origin.x, self.ibContentView.frame.origin.y - self.ibImgProfilePic.frame.size.height/2, self.ibContentView.frame.size.width, self.ibContentView.frame.size.height);

//    self.ibImgProfilePic.frame = CGRectMake(self.ibImgProfilePic.frame.origin.x, self.ibImgProfilePic.frame.origin.y - self.ibImgProfilePic.frame.size.height/2, self.ibImgProfilePic.frame.size.width, self.ibImgProfilePic.frame.size.height);
    [self adjustTableView];
}

-(void)adjustTableView
{
    
    int collectionHeight = arrCollection.count>0?(int)([ProfilePageCollectionTableViewCell getHeight]*arrCollection.count):[ProfileNoItemTableViewCell getHeight];
  //  int postAndLikesHeight = (int)([ProfilePagePostTableViewCell getHeight]*((arrPost.count>0?1:0) + (arrLikes.count>0?1:0)));
    int postAndLikesHeight = (arrPost.count>0?[ProfilePagePostTableViewCell getHeight]:[ProfileNoItemTableViewCell getHeight]) + (arrLikes.count>0?[ProfilePagePostTableViewCell getHeight]:[ProfileNoItemTableViewCell getHeight]);

    int cellHeaderHeight = 3*[ProfilePageCollectionHeaderView getHeight];
    int count = (arrCollection.count>0?1:0) + (arrPost.count>0?1:0) + (arrLikes.count>0?1:0);
    int cellFooterHeight = [ProfilePageCollectionFooterTableViewCell getHeight]*(count);
    
    self.ibTableView.frame = CGRectMake(self.ibTableView.frame.origin.x, self.ibTableView.frame.origin.y, self.ibTableView.frame.size.width, collectionHeight + postAndLikesHeight + cellHeaderHeight + cellFooterHeight + 5);
    
    self.ibContentView.frame = CGRectMake(self.ibContentView.frame.origin.x, self.ibContentView.frame.origin.y, self.ibContentView.frame.size.width, self.ibTableView.frame.origin.y +self.ibTableView.frame.size.height);
    
    self.ibScrollView.contentSize = CGSizeMake(self.ibScrollView.frame.size.width, self.ibContentView.frame.size.height);

}

-(UIImageView*)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 212)];
        [_backgroundImageView adjustToScreenWidth];
    }
    
    return _backgroundImageView;
}
#pragma mark - Cell
-(void)initProfilePageCell
{
    self.ibTableView.delegate = self;
    self.ibTableView.dataSource = self;
}
#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return arrCollection.count+1;
    }
    else if(section == 1)
    {
        
        if (arrPost.count>0) {
            return 1+1;
        }
        return 0+1;
    }
    else if (section == 2)
    {
        if (arrLikes.count>0) {
            return 1+1;

        }
        return 0+1;

    }
    else
        return 1;

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        
        if (!arrCollection.count>0) {
            return [ProfileNoItemTableViewCell getHeight];
        }
        else if (indexPath.row == arrCollection.count) {
            return [ProfilePageCollectionFooterTableViewCell getHeight];
        }
        
        return [ProfilePageCollectionTableViewCell getHeight];
    }
    else if (indexPath.section == 1){
        if (!arrPost.count>0) {
            return [ProfileNoItemTableViewCell getHeight];
        }
        else if (indexPath.row == 1) {
            return [ProfilePageCollectionFooterTableViewCell getHeight];
        }

        return [ProfilePagePostTableViewCell getHeight];

    }
    else if (indexPath.section == 2){
       
        if (!arrLikes.count>0) {
            return [ProfileNoItemTableViewCell getHeight];
        }
        else if (indexPath.row == 1) {
            return [ProfilePageCollectionFooterTableViewCell getHeight];
        }
        
        return [ProfilePagePostTableViewCell getHeight];
        

    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    return [ProfilePageCollectionHeaderView getHeight];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    ProfilePageCollectionHeaderView* headerView = [ProfilePageCollectionHeaderView initializeCustomView];
    [headerView adjustRoundedEdge:self.ibTableView.frame];
   
    if (section == 0) {
        headerView.lblTitle.text = @"Collections";
    }else if(section == 1)
        headerView.lblTitle.text = @"Posts";
    else
    headerView.lblTitle.text = @"Likes";
    
    return headerView;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
       
        if (!arrCollection.count>0) {
            
            static NSString* cellIndenfierShowNone = @"ProfileNoItemTableViewCell";
            ProfileNoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierShowNone];
            
            if (!cell) {
                cell = [[ProfileNoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierShowNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];

            return cell;
        }
       else if (indexPath.row==arrCollection.count) {
            
            static NSString* cellIndenfierNone = @"ProfilePageCollectionFooterTableViewCell";
            ProfilePageCollectionFooterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierNone];
            
            if (!cell) {
                cell = [[ProfilePageCollectionFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierNone];
            }
            
            [cell adjustRoundedEdge:self.ibTableView.frame];
            return cell;
        }
        else{
            
            static NSString* cellIndenfier1 = @"ProfilePageCollectionTableViewCell";
            ProfilePageCollectionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier1];
            
            if (!cell) {
                cell = [[ProfilePageCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier1];
            }
            
            [cell initData:arrCollection[indexPath.row]];
            
            return cell;
        }
       
    }
    
    else if(indexPath.section == 1)
    {
        
        if (!arrPost.count>0) {
            
            static NSString* cellIndenfierShowNone = @"ProfileNoItemTableViewCell";
            ProfileNoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierShowNone];
            
            if (!cell) {
                cell = [[ProfileNoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierShowNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];

            return cell;
        }
        else if (indexPath.row == 1) {
            
            static NSString* cellIndenfierNone = @"ProfilePageCollectionFooterTableViewCell";
            ProfilePageCollectionFooterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierNone];
            
            if (!cell) {
                cell = [[ProfilePageCollectionFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];

            return cell;
        }
        else{
        static NSString* cellIndenfier2 = @"ProfilePagePostTableViewCell";
        ProfilePagePostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier2];
        
        if (!cell) {
            cell = [[ProfilePagePostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier2];
        }
            DraftModel* model = arrPost[0];
            [cell initData:model.arrPhotos];
            return cell;

        }
    }
    
    else if (indexPath.section == 2)
    {
        
        if (!arrLikes.count>0) {
            
            static NSString* cellIndenfierShowNone = @"ProfileNoItemTableViewCell";
            ProfileNoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierShowNone];
            
            if (!cell) {
                cell = [[ProfileNoItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierShowNone];
            }
            [cell adjustRoundedEdge:self.ibTableView.frame];

            return cell;
        }

        else if (indexPath.row== 1) {
                
                static NSString* cellIndenfierNone = @"ProfilePageCollectionFooterTableViewCell";
                ProfilePageCollectionFooterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfierNone];
                
                if (!cell) {
                    cell = [[ProfilePageCollectionFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfierNone];
                }
                [cell adjustRoundedEdge:self.ibTableView.frame];

                return cell;
            }
        
        else{
                static NSString* cellIndenfier2 = @"ProfilePagePostTableViewCell";
                ProfilePagePostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier2];
                
                if (!cell) {
                    cell = [[ProfilePagePostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier2];
                }
                DraftModel* model = arrLikes[0];
                [cell initData:model.arrPhotos];
                return cell;
           
        }
    }
        
    
    return nil;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:self.collectionListingViewController animated:YES];
    }
}


#pragma mark - Tag
-(void)initTagView
{
    arrayTag = [[NSMutableArray alloc]initWithArray:@[@"111",@"222",@"333",@"111",@"222",@"333",@"111",@"222",@"333"]];
    _ibTagControlView.tags = arrayTag;
    _ibTagControlView.mode = TLTagsControlModeEdit;
    _ibTagControlView.tagPlaceholder = @"Tag";
    [_ibTagControlView setTapDelegate:self];
    UIColor *whiteTextColor = [UIColor whiteColor];
    
    _ibTagControlView.tagsBackgroundColor = DEVICE_COLOR;
    _ibTagControlView.tagsTextColor = whiteTextColor;
    [_ibTagControlView reloadTagSubviewsCustom];
}

- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index
{
    NSLog(@"Tag \"%@\" was tapped", tagsControl.tags[index]);
}

#pragma mark - Declaration

-(CollectionListingViewController*)collectionListingViewController
{
    if (!_collectionListingViewController) {
        _collectionListingViewController = [CollectionListingViewController new];
    }
    
    return _collectionListingViewController;
}
-(CollectionViewController*)collectionViewController
{
    if(!_collectionViewController)
    {
        _collectionViewController = [CollectionViewController new];
    }
    
    return _collectionViewController;
}
-(void)initData
{
   // arrCollection = [[NSMutableArray alloc]initWithArray:@[@"123",@"222"]];
    //arrLikes = [[NSMutableArray alloc]initWithArray:@[@"123",@"222",@"333"]];
    //arrPost = [[NSMutableArray alloc]initWithArray:@[@"123",@"222",@"333"]];

}

-(ProfilePageCollectionHeaderView*)profilePageCollectionHeaderView1
{
    if (!_profilePageCollectionHeaderView1) {
        _profilePageCollectionHeaderView1 = [ProfilePageCollectionHeaderView initializeCustomView];
        
    }
    return _profilePageCollectionHeaderView1;
}

#pragma mark - Request Server
-(void)requestServerForUserLikes
{
    NSString* appendString = [NSString stringWithFormat:@"%@/likes",[Utils getUserID]];
    NSDictionary* dict = @{@"page":@1,
                           @"list_size":@5,
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserLikes param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userProfileLikeModel = [[ConnectionManager dataManager]userProfileLikeModel];
        [self assignLikesData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserPost
{
    NSString* appendString = [NSString stringWithFormat:@"%@/posts",[Utils getUserID]];
    NSDictionary* dict = @{@"page":@1,
                           @"list_size":@5,
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserPosts param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userProfilePostModel = [[ConnectionManager dataManager]userProfilePostModel];
        [self assignPostData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserCollection
{
    //need to input token for own profile private collection, no token is get other people public collection
    NSString* appendString = [NSString stringWithFormat:@"%@/collections",[Utils getUserID]];
    NSDictionary* dict = @{@"page":@1,
                           @"list_size":@5,
                           @"token":[Utils getAppToken]
                           };
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserCollections param:dict appendString:appendString completeHandler:^(id object) {
        
        self.userCollectionsModel = [[ConnectionManager dataManager]userCollectionsModel];
        [self assignCollectionData];
        
    } errorBlock:^(id object) {
        
    }];
}

-(void)requestServerForUserInfo
{
    NSString* appendString = [NSString stringWithFormat:@"%@",[Utils getUserID]];
   
    [[ConnectionManager Instance]requestServerWithGet:ServerRequestTypeGetUserInfo param:nil appendString:appendString completeHandler:^(id object) {
        
        self.userProfileModel = [[ConnectionManager dataManager]userProfileModel];
        [self assignData];
        
    } errorBlock:^(id object) {
        
    }];
}


-(void)assignData
{
    
    [self assignUserData];
}

-(void)assignUserData
{
    self.lblUserName.text = self.userProfileModel.name;
    [self setFollowing:self.userProfileModel.follower_count Following:self.userProfileModel.following_count];
    self.lblLocation.text = self.userProfileModel.location;

}

-(void)assignCollectionData
{
    arrCollection = [[NSMutableArray alloc]initWithArray:self.userCollectionsModel.arrCollections];
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.ibTableView reloadData];
    [self.ibTableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
    [self adjustTableView];
}

-(void)assignPostData
{
    arrPost = [[NSMutableArray alloc]initWithArray:self.userProfilePostModel.userPostData.posts];
    NSRange range = NSMakeRange(1, 2);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.ibTableView reloadData];
    [self.ibTableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
    [self adjustTableView];
}

-(void)assignLikesData
{
    arrLikes = [[NSMutableArray alloc]initWithArray:self.userProfileLikeModel.userPostData.posts];
   
    [self.ibTableView reloadData];
    
    [self.ibTableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self adjustTableView];

}

-(void)setFollowing:(int)followers Following:(int)followings
{
    self.lblFollowing.text = [NSString stringWithFormat:@"%d Followers     %d Followings",followers,followings];
    
}
@end
