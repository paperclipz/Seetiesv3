//
//  SeetiesShopViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/30/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeetiesShopViewController.h"

#import "SeShopDetailView.h"
#import "SeDealsView.h"

@interface SeetiesShopViewController ()

@property (nonatomic,strong)SeShopDetailView* seShopDetailView;
@property (nonatomic,strong)SeDealsView* seDealsView;

@property (weak, nonatomic) IBOutlet UIScrollView *ibScrollView;
@property(nonatomic,assign)SeetiesShopType seetiesType;
@property(nonatomic, strong)NSMutableArray* arrViews;

@end

@implementation SeetiesShopViewController

#pragma mark - IBACTION
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrViews = [NSMutableArray new];

    [self setupViews];
    [self addViews];
    [self adjustView:self.arrViews[self.arrViews.count-1] :(int)(self.arrViews.count - 1)];
    UIView* lastView = [self.arrViews lastObject];
    self.ibScrollView.contentSize = CGSizeMake( self.ibScrollView.frame.size.width, lastView.frame.size.height+ lastView.frame.origin.y);

}

-(void)setupViews
{
    for (int i = 0; i<1; i++) {
        
        SeShopDetailView* temp = [SeShopDetailView initializeCustomView];
        //[temp setupViewWithData:i];
        [self.arrViews addObject:temp];
    }

}
-(void)addViews
{
    for (int i = 0; i< self.arrViews.count; i++) {
        UIView* view = self.arrViews[i];
        //[view adjustToScreenWidth];
        [self.ibScrollView addSubview:view];
        
        
    }


}
// readjust view from top to bottom
-(UIView*)adjustView:(UIView*)view :(int)count
{
    
    if (count <=0) {
        
        return view;

    }
    else{
        count--;

        UIView *previousView = [self adjustView:self.arrViews[count] :count];
        float height = previousView.frame.origin.y + previousView.frame.size.height;
        [view setY:height];

        return view;
    }
    
}

-(void)addView:(SeetiesShopType)type view:(UIView*)view
{
    [self.ibScrollView addSubview:self.seShopDetailView];
    [self.seDealsView setY:self.seShopDetailView.frame.size.height];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(SeShopDetailView*)seShopDetailView
{
    if (!_seShopDetailView)
{
        _seShopDetailView = [SeShopDetailView initializeCustomView];
        [_seShopDetailView setupViewWithData:10];
    }
    
    return _seShopDetailView;
}

-(SeDealsView*)seDealsView
{
    if (!_seDealsView) {
        _seDealsView = [SeDealsView initializeCustomView];
    }
    return _seDealsView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
