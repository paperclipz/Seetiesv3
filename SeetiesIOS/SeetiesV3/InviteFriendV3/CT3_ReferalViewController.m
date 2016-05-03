//
//  CT3_ReferalViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 20/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CT3_ReferalViewController.h"

@interface CT3_ReferalViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@end

@implementation CT3_ReferalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"key1"];
    NSMutableArray* array;


    NSData * asd = [defaults objectForKey:@"key1"];
    
    array = [NSKeyedUnarchiver unarchiveObjectWithData:asd];

    if ([Utils isArrayNull:array]) {
        
        array = [NSMutableArray new];
        for (int i = 0; i<10; i++) {
            
            DealModel * temp = [DealModel new];
            temp.dID = [NSString stringWithFormat:@"id_%d",i];
            temp.title = [NSString stringWithFormat:@"title_%d",i];
            temp.voucher_info = [VoucherInfoModel new];
            temp.voucher_info.voucher_id = @"ggwp";
            [array addObject:temp];
        }
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:array];
        [defaults setObject:encodedObject forKey:@"key1"];
        [defaults synchronize];

        NSData * abc = [defaults objectForKey:@"key1"];

        array = [NSKeyedUnarchiver unarchiveObjectWithData:abc];

    }
    else{
    
        
        SLog(@"%@",array);
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}
/*
}
*/

@end
