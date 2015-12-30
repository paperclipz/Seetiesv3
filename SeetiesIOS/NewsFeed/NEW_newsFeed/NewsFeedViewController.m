//
//  NewsFeedViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedTableViewCell.h"
@interface NewsFeedViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ibTableView;

@end

@implementation NewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSelfView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSelfView
{
    [self initFeedTableViewWithDelegate:self];

}

-(void)initFeedTableViewWithDelegate:(id)delegate
{
    self.ibTableView.delegate = delegate;
    self.ibTableView.dataSource = delegate;
 
    [self.ibTableView registerClass:[NewsFeedTableViewCell class] forCellReuseIdentifier:@"NewsFeedTableViewCell"];
}


#pragma mark - Table View DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsFeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedTableViewCell"];
   
    return cell;
}



@end
